# 🎨 Flutter Drawing App

A simple and efficient Flutter drawing app that allows users to **draw**, **save**, and **edit** their creations. Built using **Flutter**, with **Hive** for fast local storage and **hive_generator** for automatic adapter generation.

---

## ✨ Features

- 🖌️ Freehand drawing on a canvas  
- 💾 Save your drawings locally using Hive  
- ♻️ Reopen and update saved drawings anytime  
- ⚡ Fast, persistent, and offline-first storage  
- 🛠️ Auto-generated Hive type adapters using `hive_generator` and `build_runner`

---

## 🛠️ Tech Stack

- **Flutter** – Cross-platform UI toolkit  
- **Hive** – Lightweight, fast NoSQL database  
- **hive_flutter** – Flutter bindings for Hive  
- **hive_generator** – Code generation for Hive type adapters  
- **build_runner** – To generate code automatically

---

## 📦 Dependencies

Add these in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^latest
  hive_flutter: ^latest
  path_provider: ^latest

dev_dependencies:
  hive_generator: ^latest
  build_runner: ^latest

