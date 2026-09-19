import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../services/supabase_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  final additionalInfoController = TextEditingController();

  final List<PlatformFile> _attachedFiles = [];
  bool _isSubmitting = false;

  final List<String> harassmentTypes = [
    'Verbal Harassment',
    'Physical Harassment',
    'Cyber Harassment',
    'Sexual Harassment',
    'Bullying',
    'Stalking',
    'Other',
  ];

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    additionalInfoController.dispose();
    super.dispose();
  }

  String _dateLabel(BuildContext context) {
    if (selectedDate == null) return AppText.of(context, 'select_date');
    return '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}';
  }

  String _timeLabel(BuildContext context) {
    if (selectedTime == null) return AppText.of(context, 'select_time');
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

  Future<void> _pickFiles(FileType type, [List<String>? extensions]) async {
    try {
      final files = await FilePicker.pickFiles(
        type: type,
        allowedExtensions: extensions,
      );
      if (files.isNotEmpty) {
        setState(() {
          for (final file in files) {
            if (!_attachedFiles.any((f) => f.name == file.name)) {
              _attachedFiles.add(file);
            }
          }
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${files.length} file(s) attached successfully.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not attach file: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return 'Unknown size';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(String? ext) {
    final e = (ext ?? '').toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(e)) return Icons.image;
    if (['mp4', 'mov', 'avi', 'mkv'].contains(e)) return Icons.videocam;
    if (['mp3', 'wav', 'm4a', 'aac'].contains(e)) return Icons.audiotrack;
    if (['pdf'].contains(e)) return Icons.picture_as_pdf;
    return Icons.insert_drive_file;
  }

  Future<void> _submitReport() async {
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the type of harassment.')),
      );
      return;
    }

    final location = locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the location of the incident.')),
      );
      return;
    }

    final description = descriptionController.text.trim();
    if (description.isEmpty || description.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a detailed description (at least 10 characters).')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final dateText = selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')} ${selectedTime?.format(context) ?? ''}'
          : DateTime.now().toString().substring(0, 16);

      final newId = await SupabaseService.submitComplaint(
        type: selectedType!,
        date: dateText,
        location: location,
        description: description,
        additionalInfo: additionalInfoController.text.trim(),
        attachmentNames: _attachedFiles.map((f) => f.name).toList(),
      );

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Complaint Submitted'),
            ],
          ),
          content: Text(
            'Your complaint has been registered securely.\n\nCase ID: $newId\n\nYou can track updates and committee remarks in "My Cases".',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission error: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 18),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
      );

  Widget _uploadTile(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.chipBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(height: 6),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primaryDark)),
            ],
          ),
        ),
      ),
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
              child: Form(
                key: _formKey,
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
                              Text(
                                AppText.of(context, 'report_harassment'),
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                AppText.of(context, 'confidential_form'),
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    _label(AppText.of(context, 'harassment_type')),
                    DropdownButtonFormField<String>(
                      initialValue: selectedType,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppText.of(context, 'select_harassment_type'),
                      ),
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
                                  child: Text(_dateLabel(context), style: TextStyle(color: selectedDate == null ? AppColors.textMuted : AppColors.primaryDark)),
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
                                  child: Text(_timeLabel(context), style: TextStyle(color: selectedTime == null ? AppColors.textMuted : AppColors.primaryDark)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    _label(AppText.of(context, 'location')),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppText.of(context, 'location_hint'),
                      ),
                    ),

                    _label(AppText.of(context, 'description_incident')),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppText.of(context, 'description_hint'),
                      ),
                    ),

                    _label(AppText.of(context, 'additional_info')),
                    TextField(
                      controller: additionalInfoController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: AppText.of(context, 'additional_info_hint'),
                      ),
                    ),

                    _label(AppText.of(context, 'evidence_attachment')),
                    Row(
                      children: [
                        _uploadTile(
                          Icons.image_outlined,
                          AppText.of(context, 'upload_photo'),
                          () => _pickFiles(FileType.image),
                        ),
                        _uploadTile(
                          Icons.videocam_outlined,
                          AppText.of(context, 'upload_video'),
                          () => _pickFiles(FileType.video),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _uploadTile(
                          Icons.mic_none_outlined,
                          AppText.of(context, 'upload_audio'),
                          () => _pickFiles(FileType.audio),
                        ),
                        _uploadTile(
                          Icons.description_outlined,
                          AppText.of(context, 'upload_document'),
                          () => _pickFiles(FileType.custom, ['pdf', 'doc', 'docx', 'txt']),
                        ),
                      ],
                    ),

                    if (_attachedFiles.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      Text(
                        'Attached Files (${_attachedFiles.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDark),
                      ),
                      const SizedBox(height: 8),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _attachedFiles.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 6),
                        itemBuilder: (context, idx) {
                          final file = _attachedFiles[idx];
                          final size = file.lengthSync() ?? 0;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Row(
                              children: [
                                Icon(_getFileIcon(file.extension), color: AppColors.primary, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      Text(_formatFileSize(size), style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20, color: AppColors.danger),
                                  onPressed: () => _removeFile(idx),
                                  tooltip: 'Remove',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                AppText.of(context, 'submit_complaint'),
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
