import 'dart:math' as math;

import 'package:body_detection/domain/models/point.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class SquatCounter {
  int counter = 0;
  bool isDown = false;

  // Thresholds for detecting the squat (Adjusted for better sensitivity)
  static const double angleThresholdDown =
      110.0; // Before 90, now it detects shallower squats
  static const double angleThresholdUp = 150.0;

  /// Processes a pose and updates the counter if a repetition is completed.
  void checkSquat(Pose pose) {
    // Calculate the angles for both legs
    double? leftAngle = _getLegAngle(pose, isLeft: true);
    double? rightAngle = _getLegAngle(pose, isLeft: false);

    // If we don't detect any leg with enough confidence, we exit
    if (leftAngle == null && rightAngle == null) return;

    // Choose the angle of the leg that is most "extreme" or simply the one available
    // Generally, if one leg goes lower than the other, it defines the squat
    double angle = 0;
    if (leftAngle != null && rightAngle != null) {
      angle = (leftAngle + rightAngle) / 2; // Average for greater stability
    } else {
      angle = leftAngle ?? rightAngle!;
    }

    // State logic to count the repetition
    if (angle < angleThresholdDown && !isDown) {
      isDown = true;
    } else if (angle > angleThresholdUp && isDown) {
      isDown = false;
      counter++;
    }
  }

  /// Calculates the angle of a specific leg if the points have good confidence.
  double? _getLegAngle(Pose pose, {required bool isLeft}) {
    final hip =
        pose.landmarks[isLeft
            ? PoseLandmarkType.leftHip
            : PoseLandmarkType.rightHip];
    final knee =
        pose.landmarks[isLeft
            ? PoseLandmarkType.leftKnee
            : PoseLandmarkType.rightKnee];
    final ankle =
        pose.landmarks[isLeft
            ? PoseLandmarkType.leftAnkle
            : PoseLandmarkType.rightAnkle];

    if (hip == null || knee == null || ankle == null) return null;

    // ML Kit provides a presence/confidence score (0.0 to 1.0)
    // If the confidence is very low (e.g. < 0.5), we ignore that leg
    if (hip.likelihood < 0.5 ||
        knee.likelihood < 0.5 ||
        ankle.likelihood < 0.5) {
      return null;
    }

    return _calculateAngle(
      Point(hip.x, hip.y),
      Point(knee.x, knee.y),
      Point(ankle.x, ankle.y),
    );
  }

  // Calculate the angle between three points (A-B-C) being B the vertex
  double _calculateAngle(Point a, Point b, Point c) {
    double radians =
        math.atan2(c.y - b.y, c.x - b.x) - math.atan2(a.y - b.y, a.x - b.x);
    double angle = (radians * 180.0 / math.pi).abs();

    if (angle > 180.0) {
      angle = 360.0 - angle;
    }
    return angle;
  }
}
