import 'package:flutter/material.dart';
import '../models/drawing_model.dart';
import '../services/storage_service.dart';

class GalleryProvider extends ChangeNotifier {
  List<DrawingModel> drawings = [];
  bool isLoading = false;

  /// Load all drawings from storage
  Future<void> loadDrawings() async {
    isLoading = true;
    notifyListeners();

    try {
      drawings = await StorageService.getAllDrawings();
    } catch (e) {
      print('Failed to load drawings: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  /// Add a new drawing to the gallery
  Future<void> addDrawing(DrawingModel drawing) async {
    drawings.insert(0, drawing); // Add to top
    notifyListeners();
  }

  /// Delete a drawing
  Future<void> deleteDrawing(String drawingId) async {
    try {
      await StorageService.deleteDrawing(drawingId);
      drawings.removeWhere((d) => d.id == drawingId);
      notifyListeners();
    } catch (e) {
      print('Failed to delete drawing: $e');
      rethrow;
    }
  }

  /// Rename a drawing
  Future<void> renameDrawing(String drawingId, String newTitle) async {
    try {
      await StorageService.renameDrawing(drawingId, newTitle);
      final index = drawings.indexWhere((d) => d.id == drawingId);
      if (index != -1) {
        drawings[index] = DrawingModel(
          id: drawings[index].id,
          title: newTitle,
          createdAt: drawings[index].createdAt,
          thumbnail: drawings[index].thumbnail,
          filePath: drawings[index].filePath,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Failed to rename drawing: $e');
      rethrow;
    }
  }

  /// Clear all drawings
  Future<void> clearAll() async {
    for (var drawing in drawings) {
      await StorageService.deleteDrawing(drawing.id);
    }
    drawings.clear();
    notifyListeners();
  }
}