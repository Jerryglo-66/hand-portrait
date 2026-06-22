import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../providers/drawing_provider.dart';
import '../widgets/drawing_canvas.dart';
import '../widgets/tool_bar.dart';

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
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showClearDialog(context);
            },
            tooltip: 'Clear Canvas',
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