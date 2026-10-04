import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../data_store.dart';

/// Service to handle automated and manual emergency audio evidence recording (FR-06).
class AudioRecordingService {
  static final AudioRecorder _recorder = AudioRecorder();
  static final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  static final ValueNotifier<int> recordingSeconds = ValueNotifier<int>(0);

  static Timer? _timer;
  static String? _currentFilePath;

  /// Starts emergency audio recording
  static Future<bool> startEmergencyRecording({String caseId = 'EMERGENCY-SOS'}) async {
    try {
      if (isRecording.value) return true;

      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        debugPrint('Microphone permission not granted for emergency recording.');
        return false;
      }

      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'emergency_audio_$timestamp.m4a';
      _currentFilePath = '${dir.path}${Platform.pathSeparator}$fileName';

      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _currentFilePath!,
      );

      isRecording.value = true;
      recordingSeconds.value = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        recordingSeconds.value = t.tick;
      });

      return true;
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
      isRecording.value = false;
      return false;
    }
  }

  /// Stops emergency audio recording and saves file to Evidence Vault
  static Future<String?> stopEmergencyRecording({String caseId = 'EMERGENCY-SOS'}) async {
    try {
      if (!isRecording.value) return null;

      _timer?.cancel();
      _timer = null;
      final recordedPath = await _recorder.stop();
      isRecording.value = false;

      final finalPath = recordedPath ?? _currentFilePath;
      if (finalPath != null && finalPath.isNotEmpty) {
        final file = File(finalPath);
        int sizeBytes = 0;
        if (await file.exists()) {
          sizeBytes = await file.length();
        }
        final sizeText = sizeBytes > 1024 * 1024
            ? '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
            : '${(sizeBytes / 1024).toStringAsFixed(1)} KB';

        final fileName = finalPath.split(Platform.pathSeparator).last;

        // Automatically store in Evidence Vault
        DataStore.addEvidenceFile(
          name: fileName,
          size: sizeText.isEmpty ? '150 KB' : sizeText,
          caseId: caseId,
          type: 'Audio',
          path: finalPath,
        );

        DataStore.addNotification(
          title: 'Evidence Audio Recorded',
          message: 'Emergency audio file ($fileName) was secured in your Evidence Vault.',
          type: 'system',
        );

        return finalPath;
      }
      return null;
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
      isRecording.value = false;
      return null;
    }
  }

  static void dispose() {
    _timer?.cancel();
    _recorder.dispose();
  }
}