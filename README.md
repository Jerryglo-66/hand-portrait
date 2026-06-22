# Hand Portrait 🎨

A Flutter mobile/tablet application for portrait sketching with advanced drawing tools, grid overlay, and golden ratio guides.

## Features

✨ **Core Features:**
- 📱 **Mobile & Tablet Support** - Optimized for touch and stylus input
- 🎨 **Freehand Drawing** - Smooth, responsive canvas for sketching
- 📷 **Reference Photo Loading** - Load images from gallery as reference
- 📐 **Grid Overlay** - Adjustable grid for accurate proportions
- ✨ **Golden Ratio Guides** - Professional composition guides based on the golden ratio (1.618)
- 🎯 **Drawing Tools**:
  - Multiple brush sizes (1-20px)
  - Multiple colors (Black, Grey, Red, Blue)
  - Undo functionality
  - Clear canvas

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Android SDK (for Android development)
- Xcode (for iOS development)
- Dart 3.0+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Jerryglo-66/hand-portrait.git
cd hand-portrait
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### For Specific Platforms

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Tablet:**
```bash
flutter run -d your_tablet_device
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   └── home_screen.dart      # Main drawing screen
├── widgets/
│   ├── drawing_canvas.dart   # Canvas with grid & golden ratio
│   └── tool_bar.dart         # Tool controls and settings
└── providers/
    └── drawing_provider.dart # State management with Provider
```

## How to Use

1. **Start Drawing**: Tap or use stylus on the canvas to draw
2. **Load Reference Photo**: Tap the image icon to load a photo from your gallery
3. **Adjust Grid**: Use the toolbar to:
   - Change grid size (5-50px)
   - Adjust grid opacity (10-100%)
4. **Toggle Overlays**: Use the Filter Chips to show/hide:
   - Grid overlay
   - Golden ratio guides
5. **Drawing Tools**:
   - Select colors by tapping color buttons
   - Adjust brush size with the slider
   - Undo recent strokes
   - Clear canvas to start over

## Golden Ratio

The golden ratio (φ ≈ 1.618) is used in professional portrait composition:
- Creates aesthetically pleasing proportions
- Helps with face placement and feature alignment
- Divides the canvas into harmonious sections
- Perfect for portrait artists

## Technologies Used

- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **image_picker** - Photo selection
- **image** - Image processing
- **permission_handler** - Permission management

## Future Enhancements

- [ ] Save drawings to gallery
- [ ] Layer support (sketch, reference, guides)
- [ ] Stylus pressure sensitivity
- [ ] Color picker with custom colors
- [ ] Drawing history with timeline
- [ ] Export to PDF/SVG
- [ ] Built-in reference templates
- [ ] Symmetry guides
- [ ] Custom grid patterns (isometric, perspective)
- [ ] Dark mode

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.

## Author

Created with ❤️ by Jerryglo-66

---

**Happy Drawing!** 🎨✨