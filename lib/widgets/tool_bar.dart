import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/drawing_provider.dart';

class ToolBar extends StatefulWidget {
  final VoidCallback onPickImage;

  const ToolBar({
    Key? key,
    required this.onPickImage,
  }) : super(key: key);

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingProvider>(
      builder: (context, drawingProvider, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Color and Brush Size Controls
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _ColorButton(
                            color: Colors.black,
                            isSelected:
                                drawingProvider.currentPaint.color == Colors.black,
                            onPressed: () {
                              drawingProvider.setColor(Colors.black);
                            },
                          ),
                          const SizedBox(width: 8),
                          _ColorButton(
                            color: Colors.grey,
                            isSelected:
                                drawingProvider.currentPaint.color == Colors.grey,
                            onPressed: () {
                              drawingProvider.setColor(Colors.grey);
                            },
                          ),
                          const SizedBox(width: 8),
                          _ColorButton(
                            color: Colors.red,
                            isSelected:
                                drawingProvider.currentPaint.color == Colors.red,
                            onPressed: () {
                              drawingProvider.setColor(Colors.red);
                            },
                          ),
                          const SizedBox(width: 8),
                          _ColorButton(
                            color: Colors.blue,
                            isSelected:
                                drawingProvider.currentPaint.color == Colors.blue,
                            onPressed: () {
                              drawingProvider.setColor(Colors.blue);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Brush Size Slider
              Row(
                children: [
                  const Icon(Icons.brush, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: drawingProvider.currentPaint.strokeWidth,
                      min: 1,
                      max: 20,
                      onChanged: (value) {
                        drawingProvider.setStrokeWidth(value);
                      },
                    ),
                  ),
                  Text(
                    drawingProvider.currentPaint.strokeWidth.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Grid and Golden Ratio Toggles
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Grid'),
                          selected: drawingProvider.showGrid,
                          onSelected: (value) {
                            drawingProvider.toggleGrid();
                          },
                        ),
                        FilterChip(
                          label: const Text('Golden Ratio'),
                          selected: drawingProvider.showGoldenRatio,
                          onSelected: (value) {
                            drawingProvider.toggleGoldenRatio();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Grid Size Control
              Row(
                children: [
                  const Text(
                    'Grid Size:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: drawingProvider.gridSize,
                      min: 5,
                      max: 50,
                      divisions: 9,
                      label: drawingProvider.gridSize.toStringAsFixed(0),
                      onChanged: (value) {
                        drawingProvider.setGridSize(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Grid Opacity Control
              Row(
                children: [
                  const Text(
                    'Grid Opacity:',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Slider(
                      value: drawingProvider.gridOpacity,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      label: (drawingProvider.gridOpacity * 100)
                          .toStringAsFixed(0),
                      onChanged: (value) {
                        drawingProvider.setGridOpacity(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onPressed;

  const _ColorButton({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.black, width: 3)
              : Border.all(color: Colors.grey, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
      ),
    );
  }
}