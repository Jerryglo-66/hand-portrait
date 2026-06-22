import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class DrawPoint {
  final Offset offset;
  final Paint paint;

  DrawPoint({required this.offset, required this.paint});
}

class DrawingProvider extends ChangeNotifier {
  List<DrawPoint> points = [];
  Paint currentPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  img.Image? referenceImage;
  bool showGrid = true;
  bool showGoldenRatio = true;
  double gridSize = 20;
  double gridOpacity = 0.3;

  // Golden ratio
  static const double goldenRatio = 1.618;

  void addPoint(Offset offset) {
    points.add(DrawPoint(offset: offset, paint: Paint.from(currentPaint)));
    notifyListeners();
  }

  void setColor(Color color) {
    currentPaint.color = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    currentPaint.strokeWidth = width;
    notifyListeners();
  }

  void undo() {
    if (points.isNotEmpty) {
      points.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    points.clear();
    notifyListeners();
  }

  void setReferenceImage(img.Image image) {
    referenceImage = image;
    notifyListeners();
  }

  void removeReferenceImage() {
    referenceImage = null;
    notifyListeners();
  }

  void toggleGrid() {
    showGrid = !showGrid;
    notifyListeners();
  }

  void toggleGoldenRatio() {
    showGoldenRatio = !showGoldenRatio;
    notifyListeners();
  }

  void setGridSize(double size) {
    gridSize = size;
    notifyListeners();
  }

  void setGridOpacity(double opacity) {
    gridOpacity = opacity;
    notifyListeners();
  }
}