import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final additionalInfoController = TextEditingController();

  final List<String> harassmentTypes = [
    'Verbal Harassment',
    'Physical Harassment',
    'Cyber Harassment',
    'Sexual Harassment',
    'Bullying',
    'Other',
  ];

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  String get _dateLabel {
    if (selectedDate == null) return 'Select date';
    return '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}';
  }

  String get _timeLabel {
    if (selectedTime == null) return 'Select time';
    return selectedTime!.format(context);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

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
    return ValueListenableBuilder<bool>(
      valueListenable: AppState.isUrdu,
      builder: (context, _, __) {
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppText.of(context, 'report_harassment'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(AppText.of(context, 'confidential_form'), style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              _label(AppText.of(context, 'harassment_type')),
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
                        _label(AppText.of(context, 'date')),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today_outlined)),
                            child: Text(_dateLabel, style: TextStyle(color: selectedDate == null ? AppColors.textMuted : AppColors.primaryDark)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(AppText.of(context, 'time')),
                        InkWell(
                          onTap: _pickTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(border: OutlineInputBorder(), suffixIcon: Icon(Icons.access_time)),
                            child: Text(_timeLabel, style: TextStyle(color: selectedTime == null ? AppColors.textMuted : AppColors.primaryDark)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              _label(AppText.of(context, 'location')),
              TextField(controller: locationController, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. Cafeteria block, Main Campus')),

              _label(AppText.of(context, 'description_incident')),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Describe what happened, who was involved and whether it happened before.'),
              ),

              _label(AppText.of(context, 'additional_info')),
              TextField(
                controller: additionalInfoController,
                maxLines: 3,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Witnesses, previous complaints, anything else the committee should know.'),
              ),

              _label(AppText.of(context, 'evidence_attachment')),
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
                    if (selectedType == null || locationController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill harassment type, location and description.')),
                      );
                      return;
                    }

                    final dateText = selectedDate != null
                        ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')} ${selectedTime?.format(context) ?? ''}'
                        : DateTime.now().toString().substring(0, 16);

                    final newId = DataStore.addCase(
                      type: selectedType!,
                      date: dateText,
                      location: locationController.text.trim(),
                      description: descriptionController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Complaint submitted successfully. Case ID: $newId')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(AppText.of(context, 'submit_complaint'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
        );
      },
    );
  }
}
