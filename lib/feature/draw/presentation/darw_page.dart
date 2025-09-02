import 'package:drawing_app/feature/draw/model/drawing.dart';
import 'package:drawing_app/feature/draw/model/stroke.dart';
import 'package:drawing_app/feature/draw/utils/thumbnail_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;
  late Box<Drawing> _drawingBox;

  Drawing? _currentDrawing; // full object for editing

  @override
  void initState() {
    super.initState();
    _drawingBox = Hive.box<Drawing>('drawing');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final drawing = ModalRoute.of(context)?.settings.arguments as Drawing?;
      if (drawing != null) {
        _currentDrawing = drawing;
        _strokes = List<Stroke>.from(drawing.strokes);
        if (mounted) setState(() {});
      }
    });
  }

  void _flushCurrentPointsIntoStrokeIfAny() {
    if (_currentPoints.isNotEmpty) {
      _strokes.add(
        Stroke.fromOffsetList(
          points: List<Offset>.from(_currentPoints),
          color: _selectedColor,
          brushSize: _brushSize,
        ),
      );
      _currentPoints.clear();
      _redoStokes.clear();
    }
  }

  Future<void> _saveDrawingWithName(String newName) async {
    _flushCurrentPointsIntoStrokeIfAny();
    final thumbnail = await generateThumbnail(_strokes, 200, 200);

    // Check if editing existing drawing
    if (_currentDrawing != null) {
      // rename logic
      if (_currentDrawing!.name != newName &&
          _drawingBox.containsKey(newName)) {
        final overwrite = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Overwrite drawing?'),
            content:
                Text('A drawing named "$newName" already exists. Overwrite?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes')),
            ],
          ),
        );
        if (overwrite != true) return;
      }

      // update Hive object
      _currentDrawing!
        ..name = newName
        ..strokes = _strokes
        ..thumbnail = thumbnail;

      await _currentDrawing!.save();
      if (mounted) setState(() {});
      Navigator.of(context).pop(true);
      return;
    }

    // New drawing
    final drawing =
        Drawing(name: newName, strokes: _strokes, thumbnail: thumbnail);
    await _drawingBox.put(newName, drawing);
    _currentDrawing = drawing;
    if (mounted) setState(() {});
    Navigator.of(context).pop(true);
  }

  void _showSaveDialog() {
    final controller = TextEditingController(text: _currentDrawing?.name ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Save Drawing'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter a name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;
                Navigator.of(context).pop();
                _saveDrawingWithName(name);
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(_currentDrawing?.name ?? 'Draw Your Dream')),
        body: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() => _currentPoints.add(details.localPosition));
                },
                onPanUpdate: (details) {
                  setState(() => _currentPoints.add(details.localPosition));
                },
                onPanEnd: (_) {
                  _flushCurrentPointsIntoStrokeIfAny();
                  setState(() {});
                },
                child: CustomPaint(
                  painter: DrawPainter(
                    strokes: _strokes,
                    currentPoints: _currentPoints,
                    currentColor: _selectedColor,
                    selectedBrushSize: _brushSize,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
            _buildToolBar(),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: FloatingActionButton(
            onPressed: _showSaveDialog,
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _strokes.isNotEmpty
                ? () {
                    setState(() => _redoStokes.add(_strokes.removeLast()));
                  }
                : null,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _redoStokes.isNotEmpty
                ? () {
                    setState(() => _strokes.add(_redoStokes.removeLast()));
                  }
                : null,
            icon: const Icon(Icons.redo),
          ),
          DropdownButton<double>(
            value: _brushSize,
            items: const [
              DropdownMenuItem(value: 2.0, child: Text('Small')),
              DropdownMenuItem(value: 4.0, child: Text('Medium')),
              DropdownMenuItem(value: 8.0, child: Text('Large')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _brushSize = value);
            },
          ),
          Row(children: [_buildColorButton()]),
        ],
      ),
    );
  }

  Widget _buildColorButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Select Color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _selectedColor,
                onColorChanged: (color) {
                  setState(() => _selectedColor = color);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _selectedColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double selectedBrushSize;

  DrawPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.selectedBrushSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.strokeColor
        ..strokeWidth = stroke.brushSize
        ..strokeCap = StrokeCap.round;

      final points = stroke.offsetPoints;
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }

    final paint = Paint()
      ..color = currentColor
      ..strokeWidth = selectedBrushSize
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < currentPoints.length - 1; i++) {
      if (currentPoints[i] != Offset.zero &&
          currentPoints[i + 1] != Offset.zero) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
