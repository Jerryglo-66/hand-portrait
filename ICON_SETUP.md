# App Icon Setup Guide

## 🎨 Icon Created

L'icona dell'app **Hand Portrait** è stata creata con:
- ✅ Volto stilizzato (occhi, naso, bocca)
- ✅ Griglia (linee grigie)
- ✅ Sezione aurea (linee dorate)
- ✅ Colori: Viola, Oro, Pelle

## 📱 Come generare le icone per iOS e Android

### 1. Installa il package flutter_launcher_icons
```bash
flutter pub add flutter_launcher_icons
```

### 2. La configurazione è già in pubspec.yaml
Le seguenti linee sono già configurate:
```yaml
flutter_launcher_icons:
  image_path: "assets/icon/app_icon.svg"
  android:
    notification_icon: "ic_notification"
  ios: true
```

### 3. Genera le icone
```bash
flutter pub run flutter_launcher_icons:main
```

### 4. Verifica il risultato
- **Android**: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- **iOS**: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## 🚀 Build e Test

Dopo la generazione, puoi buildare l'app:

```bash
# Test su Android
flutter run -d android

# Test su iOS
flutter run -d ios
```

## 📦 File Icon

- **SVG Source**: `assets/icon/app_icon.svg`
- **Scalabile**: Può essere convertito a qualsiasi dimensione
- **Responsive**: Si adatta perfettamente su tutti i dispositivi

---

**✨ L'icona è pronta per il tuo app!**