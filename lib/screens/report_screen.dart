import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedType;

  final List<String> harassmentTypes = [
    'Verbal Harassment',
    'Physical Harassment',
    'Cyber Harassment',
    'Sexual Harassment',
    'Bullying',
    'Other',
  ];

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 18),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
      );

  Widget _uploadTile(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.chipBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.primaryDark)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Report harassment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Confidential complaint form', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              _label('Harassment type'),
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select type of harassment'),
                items: harassmentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => selectedType = value),
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Date'),
                        const TextField(decoration: InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today_outlined))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Time'),
                        const TextField(decoration: InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time))),
                      ],
                    ),
                  ),
                ],
              ),

              _label('Location'),
              const TextField(decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Cafeteria block, Main Campus')),

              _label('Description of incident'),
              const TextField(
                maxLines: 4,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Describe what happened, who was involved and whether it happened before.'),
              ),

              _label('Additional information (optional)'),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Witnesses, previous complaints, anything else the committee should know.'),
              ),

              _label('Evidence attachment'),
              Row(
                children: [
                  _uploadTile(Icons.image_outlined, 'Upload Photo'),
                  _uploadTile(Icons.videocam_outlined, 'Upload Video'),
                ],
              ),
              Row(
                children: [
                  _uploadTile(Icons.mic_none_outlined, 'Upload Audio'),
                  _uploadTile(Icons.description_outlined, 'Upload Document'),
                ],
              ),

              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Complaint submitted successfully.')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Submit complaint', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
