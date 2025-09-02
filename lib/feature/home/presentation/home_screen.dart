import 'package:drawing_app/feature/draw/model/drawing.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Drawing> _drawingBox;

  @override
  void initState() {
    super.initState();
    _drawingBox = Hive.box<Drawing>('drawing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Drawings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: _drawingBox.listenable(),
        builder: (context, Box<Drawing> box, _) {
          final drawings = box.values.toList();

          if (drawings.isEmpty) {
            return const Center(child: Text("No Drawing saved yet ...."));
          }

          return GridView.builder(
            itemCount: drawings.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final drawing = drawings[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/draw', arguments: drawing);
                    },
                    child: Card(
                      child: Center(
                        child: Text(
                          drawing.name.isEmpty ? 'Untitled' : drawing.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Drawing?"),
                            content: Text(
                                "Are you sure you want to delete '${drawing.name}'?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _drawingBox.delete(drawing.key);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/draw');
        },
        child: const Icon(Icons.draw),
      ),
    );
  }
}

