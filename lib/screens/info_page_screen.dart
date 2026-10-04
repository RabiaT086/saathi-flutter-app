import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Generic content page used for Privacy Policy, Help/FAQs, and About Us.
class InfoPageScreen extends StatelessWidget {
  final String title;
  final String content;

  const InfoPageScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title, style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.6),
        ),
      ),
    );
  }
}

const String privacyPolicyContent =
    'Saathi collects only the information needed to process your safety reports: your account details, '
    'the complaints you submit, evidence you attach, and your emergency contacts.\n\n'
    'Your identity is never shown to other students. Reports and evidence are visible only to you and the '
    'Anti-Harassment Committee handling your case.\n\n'
    'Location is only shared during an active emergency alert or if you choose to share it with the committee. '
    'You can review or delete your data at any time from your Profile.';

const String helpFaqsContent =
    'How do I report harassment?\n'
    'Go to Home > Report Harassment, fill in the details and attach any evidence, then submit.\n\n'
    'How does the Emergency SOS work?\n'
    'Press and hold the SOS button on the Emergency screen. Your location is shared and your emergency '
    'contacts and campus security are notified.\n\n'
    'Who can see my case?\n'
    'Only you and the authorised Anti-Harassment Committee members reviewing your case.\n\n'
    'Can I remain anonymous to other students?\n'
    'Yes — enable "Hide identity from peers" in your Profile\'s Safety settings.';

const String aboutUsContent =
    'Saathi is a final year project built to give university students a safe, confidential way to report '
    'harassment, reach emergency help quickly, and track their case from submission to resolution.\n\n'
    'This is a prototype (version 1.0.0) built for academic purposes as part of a BS Computer Science '
    'final year project.';
