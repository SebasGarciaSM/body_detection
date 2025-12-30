# AI Squat Counter - Flutter

A modern, real-time exercise tracking application built with Flutter. This project uses AI-powered pose detection to count squats and provide visual feedback to the user.

## ✨ Features

- **Real-time Pose Detection**: Tracks 33 body landmarks using Google ML Kit.
- **Smart Squat Logic**: Calculates knee angles using bilateral leg tracking (checks both legs for better accuracy).
- **Confidence Filtering**: Only registers movements when the AI is confident about the body part visibility.
- **Premium UI**: Uses a modern Glassmorphism design with real-time visual feedback:
  - Header shows total repetitions.
  - Footer provides dynamic guidance ("GO LOWER", "PUSH UP") with color-coded glows.
- **Audio Feedback (TTS)**: Provides real-time voice cues for repetition counting and encouragement ("Good, now up").
- **Full-Screen Preview**: Immersive camera experience using `BoxFit.cover`.

## 🛠️ Tools & Technologies

- **[Flutter](https://flutter.dev/)**: The core framework for the cross-platform mobile application.
- **[Google ML Kit Pose Detection](https://pub.dev/packages/google_mlkit_pose_detection)**: High-performance, on-device pose estimation.
- **[Camera Plugin](https://pub.dev/packages/camera)**: Handles the live camera stream and frame-by-frame image processing.
- **Dart Math**: Used for vector-based angle calculation between Hip, Knee, and Ankle landmarks.
- **[Flutter TTS](https://pub.dev/packages/flutter_tts)**: Provides the text-to-speech functionality for audio guidance.
- **Glassmorphism/BackdropFilter**: Advanced UI techniques for a premium look and feel.

## 🚀 How it works

The application captures frames from the camera and converts them into an `InputImage` format for ML Kit. The `SquatCounter` class then:
1. Identifies the Hip, Knee, and Ankle landmarks for both legs.
2. Calculates the internal angle of the knee using the Law of Cosines (via `atan2`).
3. Uses a state machine to track the transition from "Down" (Angle < 110°) to "Up" (Angle > 150°).
4. Increments the counter and **announces the rep count** via TTS when a full repetition is completed.
5. Provides **audio encouragement** when the user successfully reaches the "down" position.

## 📱 Getting Started

1. Ensure you have the Flutter SDK installed.
2. Add the following dependencies to your `pubspec.yaml`:
   ```yaml
   dependencies:
     camera: ^0.11.0
     google_mlkit_pose_detection: ^0.10.0
     flutter_tts: ^4.0.0
   ```
3. Run the app on a **physical device** (iOS or Android). Pose detection is not supported on most standard emulators.

---
*Created as part of a Flutter Body Tracking Exploration.*
