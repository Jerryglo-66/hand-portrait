import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import '../providers/drawing_provider.dart';

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({Key? key}) : super(key: key);

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  late GlobalKey<CustomPainterState> _customPainterKey;

  @override
  void initState() {
    super.initState();
    _customPainterKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        context.read<DrawingProvider>().addPoint(details.localPosition);
      },
      onPanUpdate: (details) {
        context.read<DrawingProvider>().addPoint(details.localPosition);
      },
      child: Consumer<DrawingProvider>(
        builder: (context, drawingProvider, _) {
          return CustomPaint(
            key: _customPainterKey,
            painter: CanvasPainter(
              points: drawingProvider.points,
              referenceImage: drawingProvider.referenceImage,
              showGrid: drawingProvider.showGrid,
              showGoldenRatio: drawingProvider.showGoldenRatio,
              gridSize: drawingProvider.gridSize,
              gridOpacity: drawingProvider.gridOpacity,
            ),
            isComplex: true,
            willChange: true,
            child: Container(
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<DrawPoint> points;
  final img.Image? referenceImage;
  final bool showGrid;
  final bool showGoldenRatio;
  final double gridSize;
  final double gridOpacity;

  CanvasPainter({
    required this.points,
    required this.referenceImage,
    required this.showGrid,
    required this.showGoldenRatio,
    required this.gridSize,
    required this.gridOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw reference image if available
    if (referenceImage != null) {
      _drawReferenceImage(canvas, size);
    }

    // Draw grid
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    // Draw golden ratio
    if (showGoldenRatio) {
      _drawGoldenRatio(canvas, size);
    }

    // Draw points
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        canvas.drawPoints(
          ui.PointMode.points,
          [points[i].offset],
          points[i].paint,
        );
      } else {
        canvas.drawLine(
          points[i - 1].offset,
          points[i].offset,
          points[i].paint,
        );
      }
    }
  }

  void _drawReferenceImage(Canvas canvas, Size size) {
    if (referenceImage == null) return;

    final image = referenceImage!;
    final ratio = image.width / image.height;
    final canvasRatio = size.width / size.height;

    late Rect rect;
    if (ratio > canvasRatio) {
      final height = size.width / ratio;
      rect = Rect.fromLTWH(0, (size.height - height) / 2, size.width, height);
    } else {
      final width = size.height * ratio;
      rect = Rect.fromLTWH((size.width - width) / 2, 0, width, size.height);
    }

    // Convert image to ui.Image for drawing
    final completer = Future.sync(() async {
      // For now, we'll skip drawing the image and just use overlays
      // In a production app, you'd convert the image properly
    });
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(gridOpacity)
      ..strokeWidth = 0.5;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawGoldenRatio(Canvas canvas, Size size) {
    const goldenRatio = 1.618;
    final paint = Paint()
      ..color = Colors.amber.withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Golden spiral divisions
    final goldenWidth = size.width / goldenRatio;
    final goldenHeight = size.height / goldenRatio;

    // Vertical golden ratio line
    canvas.drawLine(
      Offset(goldenWidth, 0),
      Offset(goldenWidth, size.height),
      paint,
    );

    // Horizontal golden ratio line
    canvas.drawLine(
      Offset(0, goldenHeight),
      Offset(size.width, goldenHeight),
      paint,
    );

    // Draw golden rectangles
    canvas.drawRect(
      Rect.fromLTWH(0, 0, goldenWidth, goldenHeight),
      paint,
    );

    // Additional golden ratio guides
    final rightSection = size.width - goldenWidth;
    final goldenRightWidth = rightSection / goldenRatio;

    canvas.drawLine(
      Offset(goldenWidth + goldenRightWidth, 0),
      Offset(goldenWidth + goldenRightWidth, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) {
    return oldDelegate.points.length != points.length ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showGoldenRatio != showGoldenRatio ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.gridOpacity != gridOpacity;
  }
}

class DrawPoint {
  final Offset offset;
  final Paint paint;

  DrawPoint({required this.offset, required this.paint});
}