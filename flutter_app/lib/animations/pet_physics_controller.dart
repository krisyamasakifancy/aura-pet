import 'package:flutter/material.dart';
import 'dart:math' as math;

class PetPhysicsController {
  // Spring physics for bounce effects
  static const double springStiffness = 500.0;
  static const double springDamping = 15.0;
  static const double springMass = 1.0;

  // Pet mood animations
  static const Map<String, Duration> moodDurations = {
    'happy': Duration(seconds: 2),
    'sad': Duration(seconds: 3),
    'hungry': Duration(seconds: 1),
    'sleepy': Duration(seconds: 4),
    'excited': Duration(milliseconds: 500),
    'diving': Duration(seconds: 2),
    'eating': Duration(milliseconds: 800),
    'celebrating': Duration(milliseconds: 300),
  };

  // Breathing animation parameters
  static double calculateBreathScale(double phase, String mood) {
    double baseScale = 1.0;
    double amplitude = 0.02;

    switch (mood) {
      case 'excited':
        amplitude = 0.05;
        break;
      case 'sleepy':
        amplitude = 0.01;
        break;
      case 'celebrating':
        amplitude = 0.08;
        break;
    }

    return baseScale + amplitude * math.sin(phase);
  }

  // Glow intensity based on mood and nutrition
  static double calculateGlowIntensity(String mood, int auraScore) {
    double base = 0.3;
    double auraBonus = auraScore / 100 * 0.4;

    switch (mood) {
      case 'excited':
        return 0.6 + auraBonus;
      case 'celebrating':
        return 0.8 + auraBonus;
      case 'sad':
        return 0.2;
      case 'sleepy':
        return 0.1;
      default:
        return base + auraBonus;
    }
  }

  // Haptic feedback patterns
  static String getHapticPattern(String action) {
    switch (action) {
      case 'tap':
        return 'light';
      case 'success':
        return 'medium';
      case 'achievement':
        return 'heavy';
      case 'warning':
        return 'selection';
      default:
        return 'light';
    }
  }

  // Spring animation for interactions
  static double springInterpolation(double t) {
    // Critically damped spring
    double omega = math.sqrt(springStiffness / springMass);
    double zeta = springDamping / (2 * math.sqrt(springStiffness * springMass));

    if (zeta < 1) {
      // Underdamped
      double omegaD = omega * math.sqrt(1 - zeta * zeta);
      return 1 - math.exp(-zeta * omega * t) *
          (math.cos(omegaD * t) + (zeta * omega / omegaD) * math.sin(omegaD * t));
    } else {
      // Overdamped
      return 1 - math.exp(-omega * t) * (1 + omega * t);
    }
  }

  // Scale animation on tap (like giving head pats)
  static double headPatScale(double time, double intensity) {
    return 1.0 + 0.1 * intensity * math.sin(time * 10) * math.exp(-time * 3);
  }

  // Heart eyes animation (loves food)
  static double heartEyesPulse(double phase) {
    return 0.8 + 0.2 * math.sin(phase * 2);
  }

  // Dizzy animation (overeating)
  static double dizzyWobble(double time) {
    return 0.1 * math.sin(time * 5) * math.exp(-time * 2);
  }

  // Eating animation sequence
  static List<double> eatingSequence(double t) {
    // Open mouth, chew, close
    if (t < 0.3) {
      return [0.0, t / 0.3, 0.0]; // mouth opening
    } else if (t < 0.7) {
      return [0.0, 1.0, (t - 0.3) / 0.2]; // chewing
    } else {
      return [0.0, 1.0 - (t - 0.5) / 0.5, 1.0]; // closing
    }
  }

  // Water splash effect
  static double waterSplash(double time, double intensity) {
    return intensity * math.sin(time * 8) * math.exp(-time * 2);
  }

  // XP gain sparkle
  static List<double> sparklePositions(int count, double time) {
    return List.generate(count, (i) {
      double angle = (2 * math.pi * i / count) + time;
      double radius = 0.5 + 0.3 * math.sin(time * 3 + i);
      return radius * math.cos(angle);
    });
  }

  // Sleep animation (Z's floating up)
  static double sleepFloat(double time, double baseY) {
    return baseY - 0.5 * math.sin(time) * math.exp(-time * 0.5);
  }
}

// Animation state machine
class PetAnimationState {
  final String currentAnimation;
  final double progress;
  final Map<String, dynamic> parameters;

  const PetAnimationState({
    required this.currentAnimation,
    required this.progress,
    this.parameters = const {},
  });

  static const PetAnimationState idle = PetAnimationState(
    currentAnimation: 'idle',
    progress: 0.0,
  );

  static PetAnimationState fromMood(String mood) {
    switch (mood) {
      case 'happy':
        return const PetAnimationState(
          currentAnimation: 'breathe',
          progress: 0.0,
          parameters: {'amplitude': 0.02},
        );
      case 'excited':
        return const PetAnimationState(
          currentAnimation: 'bounce',
          progress: 0.0,
          parameters: {'amplitude': 0.08},
        );
      case 'sleepy':
        return const PetAnimationState(
          currentAnimation: 'droopy',
          progress: 0.0,
          parameters: {'blinkRate': 4.0},
        );
      case 'eating':
        return const PetAnimationState(
          currentAnimation: 'chew',
          progress: 0.0,
          parameters: {'mouthOpen': 0.0},
        );
      case 'celebrating':
        return const PetAnimationState(
          currentAnimation: 'sparkle',
          progress: 0.0,
          parameters: {'particleCount': 8},
        );
      default:
        return idle;
    }
  }
}

// Gesture recognizer for pet interactions
enum PetGesture {
  tap,        // Quick tap - respond
  doubleTap,  // Double tap - excited reaction
  longPress,  // Long press - pet/head pat
  swipeUp,    // Swipe up - praise
  swipeDown,  // Swipe down - discourage
  pan,        // Drag - move pet
}

class PetGestureResult {
  final PetGesture gesture;
  final Offset position;
  final Duration duration;

  const PetGestureResult({
    required this.gesture,
    required this.position,
    required this.duration,
  });
}
