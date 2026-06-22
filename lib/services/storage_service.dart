import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/drawing_model.dart';

class StorageService {
  static const uuid = Uuid();

  /// Get the application documents directory
  static Future<Directory> _getApplicationDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  /// Get drawings directory
  static Future<Directory> _getDrawingsDirectory() async {
    final appDir = await _getApplicationDocumentsDirectory();
    final drawingsDir = Directory('${appDir.path}/drawings');
    
    if (!await drawingsDir.exists()) {
      await drawingsDir.create(recursive: true);
    }
    
    return drawingsDir;
  }

  /// Save drawing image
  static Future<DrawingModel> saveDrawing({
    required Uint8List imageData,
    required String title,
  }) async {
    try {
      final drawingsDir = await _getDrawingsDirectory();
      final drawingId = uuid.v4();
      final fileName = '${drawingId}.png';
      final filePath = '${drawingsDir.path}/$fileName';

      // Save the image file
      final file = File(filePath);
      await file.writeAsBytes(imageData);

      // Create drawing model
      final drawing = DrawingModel(
        id: drawingId,
        title: title.isNotEmpty ? title : 'Drawing - ${DateTime.now().toString()}',
        createdAt: DateTime.now(),
        thumbnail: imageData.length > 10000 
          ? Uint8List.fromList(imageData.sublist(0, 10000))
          : imageData,
        filePath: filePath,
      );

      // Save metadata
      await _saveDrawingMetadata(drawing);

      return drawing;
    } catch (e) {
      throw Exception('Failed to save drawing: $e');
    }
  }

  /// Save drawing metadata to a JSON file
  static Future<void> _saveDrawingMetadata(DrawingModel drawing) async {
    try {
      final appDir = await _getApplicationDocumentsDirectory();
      final metadataFile = File('${appDir.path}/drawings_metadata.json');
      
      List<DrawingModel> allDrawings = await getAllDrawings();
      allDrawings.add(drawing);

      // Save as JSON (simplified version)
      final jsonData = allDrawings.map((d) => d.toJson()).toList();
      await metadataFile.writeAsString(jsonData.toString());
    } catch (e) {
      print('Failed to save metadata: $e');
    }
  }

  /// Get all saved drawings
  static Future<List<DrawingModel>> getAllDrawings() async {
    try {
      final drawingsDir = await _getDrawingsDirectory();
      final files = drawingsDir.listSync();

      List<DrawingModel> drawings = [];

      for (var file in files) {
        if (file is File && (file.path.endsWith('.png') || file.path.endsWith('.jpg'))) {
          final bytes = await file.readAsBytes();
          final fileName = file.path.split('/').last;
          final id = fileName.replaceAll('.png', '').replaceAll('.jpg', '');

          drawings.add(DrawingModel(
            id: id,
            title: 'Drawing - $id',
            createdAt: file.statSync().modified,
            thumbnail: bytes,
            filePath: file.path,
          ));
        }
      }

      // Sort by creation date (newest first)
      drawings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return drawings;
    } catch (e) {
      print('Failed to load drawings: $e');
      return [];
    }
  }

  /// Delete a drawing
  static Future<void> deleteDrawing(String drawingId) async {
    try {
      final drawingsDir = await _getDrawingsDirectory();
      final file = File('${drawingsDir.path}/$drawingId.png');

      if (await file.exists()) {
        await file.delete();
      }

      // Remove from metadata
      List<DrawingModel> allDrawings = await getAllDrawings();
      allDrawings.removeWhere((d) => d.id == drawingId);

      final appDir = await _getApplicationDocumentsDirectory();
      final metadataFile = File('${appDir.path}/drawings_metadata.json');
      if (await metadataFile.exists()) {
        await metadataFile.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete drawing: $e');
    }
  }

  /// Get a single drawing file
  static Future<File?> getDrawingFile(String drawingId) async {
    try {
      final drawingsDir = await _getDrawingsDirectory();
      final file = File('${drawingsDir.path}/$drawingId.png');

      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Failed to get drawing file: $e');
      return null;
    }
  }

  /// Rename a drawing
  static Future<void> renameDrawing(String drawingId, String newTitle) async {
    try {
      List<DrawingModel> allDrawings = await getAllDrawings();
      final index = allDrawings.indexWhere((d) => d.id == drawingId);

      if (index != -1) {
        allDrawings[index] = DrawingModel(
          id: allDrawings[index].id,
          title: newTitle,
          createdAt: allDrawings[index].createdAt,
          thumbnail: allDrawings[index].thumbnail,
          filePath: allDrawings[index].filePath,
        );

        // Update metadata
        final appDir = await _getApplicationDocumentsDirectory();
        final metadataFile = File('${appDir.path}/drawings_metadata.json');
        final jsonData = allDrawings.map((d) => d.toJson()).toList();
        await metadataFile.writeAsString(jsonData.toString());
      }
    } catch (e) {
      throw Exception('Failed to rename drawing: $e');
    }
  }
}