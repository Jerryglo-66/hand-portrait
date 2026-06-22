import 'dart:typed_data';

class DrawingModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final Uint8List thumbnail;
  final String filePath;

  DrawingModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.thumbnail,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'filePath': filePath,
    };
  }

  factory DrawingModel.fromJson(Map<String, dynamic> json) {
    return DrawingModel(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      thumbnail: Uint8List.fromList([]),
      filePath: json['filePath'],
    );
  }
}