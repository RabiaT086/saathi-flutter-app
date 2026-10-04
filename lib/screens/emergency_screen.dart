import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';
import '../services/location_service.dart';
import '../services/supabase_service.dart';
import '../services/audio_recording_service.dart';

class EmergencyScreen extends StatefulWidget {
  final bool autoTriggerFromShake;

  const EmergencyScreen({super.key, this.autoTriggerFromShake = false});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool emergencyActive = false;
  String currentMapsUrl = '';
  String currentLocationText = '';

  final messageController = TextEditingController(
    text: "I'm not feeling safe. Please track me through my location - I've shared it with you.",
  );

  @override
  void initState() {
    super.initState();
    if (widget.autoTriggerFromShake) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        activateEmergency(triggeredByShake: true);
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> activateEmergency({bool triggeredByShake = false}) async {
    setState(() {
      emergencyActive = true;
    });

    final loc = await LocationService.getCurrentLocation();
    currentLocationText = loc.readableLocation;
    currentMapsUrl = loc.mapsUrl;

    final user = DataStore.currentUser.value;
    final studentName = user['name'] ?? 'Student';
    final primaryContact = (user['contacts'] as List?)?.isNotEmpty == true
        ? user['contacts'][0]['phone'] ?? '+92 301 7654321'
        : '+92 301 7654321';

    // 1. Supabase / Local DataStore alert trigger
    await SupabaseService.triggerEmergencyAlert(
      student: '$studentName${triggeredByShake ? " (Shake Triggered)" : ""}',
      location: loc.readableLocation,
      phone: primaryContact,
      mapsUrl: loc.mapsUrl,
    );

    // 2. Start automated audio evidence recording if enabled (FR-06)
    final autoRecordEnabled = user['autoRecord'] ?? true;
    if (autoRecordEnabled) {
      await AudioRecordingService.startEmergencyRecording(caseId: 'SOS-ALERT');
    }

    if (!mounted) return;
    final now = DateTime.now();
    final timeText = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 28),
            const SizedBox(width: 8),
            Text(triggeredByShake ? 'Shake SOS Alert Sent!' : 'Emergency Alert Sent'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('"${messageController.text}"', style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(loc.readableLocation, style: const TextStyle(fontSize: 13))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(timeText, style: const TextStyle(fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              if (autoRecordEnabled)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.mic, color: AppColors.danger, size: 18),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Evidence audio recording is active in background.',
                          style: TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              const Text(
                'Dispatched to campus security and your emergency contacts.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _shareViaSmsOrWhatsApp(primaryContact),
            icon: const Icon(Icons.share, size: 18),
            label: const Text('Share SMS / WhatsApp'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareViaSmsOrWhatsApp(String phone) async {
    final text = Uri.encodeComponent(
      '${messageController.text}\nMy Live Location: ${currentMapsUrl.isNotEmpty ? currentMapsUrl : "Federal Urdu University"}',
    );
    final smsUri = Uri.parse('sms:$phone?body=$text');
    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        final waUri = Uri.parse('https://wa.me/?text=$text');
        await launchUrl(waUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Launch URL note: $e');
    }
  }

  Future<void> stopEmergency() async {
    // Stop audio recording and save to Evidence Vault
    if (AudioRecordingService.isRecording.value) {
      await AudioRecordingService.stopEmergencyRecording(caseId: 'SOS-ALERT');
    }

    setState(() {
      emergencyActive = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Emergency mode stopped. Audio evidence secured in Evidence Vault.'),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return ValueListenableBuilder<Map<String, dynamic>>(
          valueListenable: DataStore.currentUser,
          builder: (context, user, _) {
            final contacts = (user['contacts'] as List?)?.cast<Map<String, String>>() ?? [];

            return Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.of(context, 'emergency'),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  AppText.of(context, 'immediate_help'),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    user['shakeDetection'] == true ? Icons.vibration : Icons.sensors_off,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    user['shakeDetection'] == true ? 'Shake Active' : 'Shake Off',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Editable emergency message
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Message to send',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: messageController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.cardBackground,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'This message + live GPS location + audio recording will be saved and sent.',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Live Audio Recording Status Indicator
                      ValueListenableBuilder<bool>(
                        valueListenable: AudioRecordingService.isRecording,
                        builder: (context, recording, _) {
                          if (!recording) return const SizedBox.shrink();
                          return ValueListenableBuilder<int>(
                            valueListenable: AudioRecordingService.recordingSeconds,
                            builder: (context, sec, _) {
                              final min = (sec ~/ 60).toString().padLeft(2, '0');
                              final s = (sec % 60).toString().padLeft(2, '0');
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.red.shade300),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.fiber_manual_record, color: Colors.red, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Recording Audio Evidence ($min:$s)',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const Text('Saving to Vault', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),

                      Text(
                        emergencyActive ? 'Emergency alert active' : AppText.of(context, 'press_hold_sos'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.danger),
                      ),
                      const SizedBox(height: 20),

                      // Large SOS Panic Button
                      GestureDetector(
                        onLongPress: emergencyActive ? null : () => activateEmergency(),
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: emergencyActive ? AppColors.dangerDark : AppColors.danger,
                            boxShadow: [
                              BoxShadow(
                                color: (emergencyActive ? AppColors.dangerDark : AppColors.danger).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.notifications_active, color: Colors.white, size: 46),
                              const SizedBox(height: 6),
                              Text(
                                emergencyActive ? 'ACTIVE' : 'SOS',
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your location, alert, and recording start together, exactly as described in FR-03 & FR-06.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 25),

                      // Will Be Notified Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppText.of(context, 'will_be_notified'),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          children: [
                            ...contacts.map((c) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: AppColors.chipBackground,
                                    child: Icon(Icons.person, color: AppColors.primary, size: 18),
                                  ),
                                  title: Text(
                                    c['name'] ?? 'Emergency Contact',
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                  ),
                                  subtitle: Text(
                                    '${c['relation'] ?? "Contact"} · ${c['phone'] ?? ""}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                )),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.chipBackground,
                                child: Icon(Icons.shield_outlined, color: AppColors.primary, size: 18),
                              ),
                              title: Text(
                                'Campus Security Office',
                                style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                              ),
                              subtitle: Text(
                                'FUUAST Main Campus · +92 21 99261300',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Stop Emergency Button
                      if (emergencyActive)
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: stopEmergency,
                            icon: const Icon(Icons.stop_circle_outlined),
                            label: const Text('Stop Emergency & Save Audio'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}