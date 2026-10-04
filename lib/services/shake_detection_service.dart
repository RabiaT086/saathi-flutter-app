import 'package:flutter/foundation.dart';
import 'package:shake/shake.dart';
import '../data_store.dart';

/// Service to handle phone shake emergency detection (FR-04).
class ShakeDetectionService {
  static ShakeDetector? _detector;
  static bool _isListening = false;
  static DateTime? _lastShakeTime;

  /// Starts listening for shake events with a callback
  static void startListening({required VoidCallback onShakeTriggered}) {
    if (_isListening) return;

    try {
      _detector = ShakeDetector.autoStart(
        shakeThresholdGravity: 2.7,
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        minimumShakeCount: 2, // 2 firm shakes to prevent accidental triggers
        onPhoneShake: (ShakeEvent event) {
          // Check if user has shake detection enabled in profile settings
          final bool isEnabled = DataStore.currentUser.value['shakeDetection'] ?? true;
          if (!isEnabled) {
            debugPrint('Shake detected but disabled in settings.');
            return;
          }

          // Debounce: prevent multiple triggers within 4 seconds
          final now = DateTime.now();
          if (_lastShakeTime != null && now.difference(_lastShakeTime!).inSeconds < 4) {
            return;
          }
          _lastShakeTime = now;

          debugPrint('Shake detected! Triggering emergency response.');
          onShakeTriggered();
        },
      );
      _isListening = true;
      debugPrint('Shake detection service started.');
    } catch (e) {
      debugPrint('Shake detection initialization error: $e');
    }
  }

  /// Stops listening for phone shakes
  static void stopListening() {
    _detector?.stopListening();
    _isListening = false;
  }
}