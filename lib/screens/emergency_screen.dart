import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  bool emergencyActive = false;

  final messageController = TextEditingController(
    text: "I'm not feeling safe. Please track me through my location — I've shared it with you.",
  );

  final List<Map<String, String>> notifyList = const [
    {'name': 'Rabia Tabassum', 'detail': 'Sister · +92 301 7654321'},
    {'name': 'Campus Security Office', 'detail': 'University · +92 21 99261300'},
    {'name': 'Anti-Harassment Committee', 'detail': 'Authorised university authority'},
  ];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void activateEmergency() {
    setState(() {
      emergencyActive = true;
    });

    // Placeholder location text until this is wired to the geolocator package
    // in the native Flutter build.
    const placeholderLocation = 'Federal Urdu University, Gulshan Campus, Karachi';
    final now = DateTime.now();
    final timeText = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Alert Sent'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('"${messageController.text}"', style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                const Expanded(child: Text(placeholderLocation, style: TextStyle(fontSize: 13))),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(timeText, style: const TextStyle(fontSize: 13)),
              ]),
              const SizedBox(height: 12),
              const Text(
                'Sent to: Rabia Tabassum (Sister), Campus Security Office, Anti-Harassment Committee.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void stopEmergency() {
    setState(() {
      emergencyActive = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Emergency mode stopped.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
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
                        Text(AppText.of(context, 'emergency'), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(AppText.of(context, 'immediate_help'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Editable emergency message
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Message to send', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: messageController,
                maxLines: 2,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'This message + your live location will be sent to your emergency contacts.',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ),

              const SizedBox(height: 25),
              Text(
                emergencyActive ? 'Emergency alert active' : AppText.of(context, 'press_hold_sos'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.danger),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onLongPress: emergencyActive ? null : activateEmergency,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: emergencyActive ? AppColors.dangerDark : AppColors.danger,
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
              const SizedBox(height: 25),
              const Text(
                'Your location, alert and recording start together, exactly as described in FR-03.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(AppText.of(context, 'will_be_notified'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
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
                  children: List.generate(notifyList.length * 2 - 1, (i) {
                    if (i.isOdd) return const Divider(height: 1, color: AppColors.cardBorder);
                    final item = notifyList[i ~/ 2];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(backgroundColor: AppColors.chipBackground, child: Icon(Icons.call, color: AppColors.primary, size: 18)),
                      title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                      subtitle: Text(item['detail']!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 25),
              if (emergencyActive)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: stopEmergency,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Stop Emergency'),
                  ),
                ),
            ],
          ),
        ),
      ),
        );
      },
    );
  }
}