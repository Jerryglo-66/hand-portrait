import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../providers/drawing_provider.dart';
import '../providers/gallery_provider.dart';
import '../services/storage_service.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_bar.dart';
import 'gallery_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hand Portrait'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _pickImage,
            tooltip: 'Load Reference Photo',
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              context.read<DrawingProvider>().undo();
            },
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDrawing,
            tooltip: 'Save Drawing',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showClearDialog(context);
            },
            tooltip: 'Clear Canvas',
          ),
          IconButton(
            icon: const Icon(Icons.collections),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GalleryScreen(),
                ),
              );
            },
            tooltip: 'Gallery',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: DrawingCanvas(),
          ),
          ToolBar(
            onPickImage: _pickImage,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        final image = img.decodeImage(imageBytes);

        if (image != null && mounted) {
          context.read<DrawingProvider>().setReferenceImage(image);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading image: $e')),
        );
      }
    }
  }

  Future<void> _saveDrawing() async {
    try {
      // Show save dialog
      final title = await _showSaveDialog();
      if (title == null) return;

      // Capture canvas as image
      final drawing = context.read<DrawingProvider>();
      final size = MediaQuery.of(context).size;

      // Create a picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder,
          Rect.fromLTWH(0, 0, size.width, size.height - 200));

      // Draw white background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height - 200),
        Paint()..color = Colors.white,
      );

      // Draw all points
      for (int i = 0; i < drawing.points.length; i++) {
        if (i == 0) {
          canvas.drawPoints(
            ui.PointMode.points,
            [drawing.points[i].offset],
            drawing.points[i].paint,
          );
        } else {
          canvas.drawLine(
            drawing.points[i - 1].offset,
            drawing.points[i].offset,
            drawing.points[i].paint,
          );
        }
      }

      // Convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        (size.height - 200).toInt(),
      );

      // Convert to bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to storage
      final drawingModel = await StorageService.saveDrawing(
        imageData: pngBytes,
        title: title,
      );

      // Add to gallery
      await context.read<GalleryProvider>().addDrawing(drawingModel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Drawing saved successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving drawing: $e')),
        );
      }
    }
  }

  Future<String?> _showSaveDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Drawing'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter drawing name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Canvas?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<DrawingProvider>().clear();
                Navigator.pop(context);
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}