import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';
import '../data_store.dart';

class EvidenceVaultScreen extends StatefulWidget {
  const EvidenceVaultScreen({super.key});

  @override
  State<EvidenceVaultScreen> createState() => _EvidenceVaultScreenState();
}

class _EvidenceVaultScreenState extends State<EvidenceVaultScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Image', 'Video', 'Audio', 'Document'];

  IconData _getFileIcon(String? type) {
    switch (type) {
      case 'Image':
        return Icons.image_outlined;
      case 'Video':
        return Icons.videocam_outlined;
      case 'Audio':
        return Icons.audiotrack_outlined;
      case 'Document':
        return Icons.description_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Color _getFileColor(String? type) {
    switch (type) {
      case 'Image':
        return Colors.blue;
      case 'Video':
        return Colors.deepPurple;
      case 'Audio':
        return Colors.orange;
      case 'Document':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _pickAndAddEvidence() async {
    try {
      final pickedFiles = await FilePicker.pickFiles();
      if (pickedFiles.isNotEmpty) {
        for (final file in pickedFiles) {
          final ext = file.extension?.toLowerCase() ?? '';
          String type = 'Document';
          if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
            type = 'Image';
          } else if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) {
            type = 'Video';
          } else if (['mp3', 'm4a', 'wav', 'aac'].contains(ext)) {
            type = 'Audio';
          }

          int sizeBytes = 0;
          try {
            sizeBytes = await file.xFile.length();
          } catch (_) {}
          final sizeStr = sizeBytes > 1024 * 1024
              ? '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB'
              : '${(sizeBytes / 1024).toStringAsFixed(1)} KB';

          DataStore.addEvidenceFile(
            name: file.name,
            size: sizeStr.isEmpty ? '150 KB' : sizeStr,
            caseId: '#HA-2026-001',
            type: type,
            path: file.path ?? '',
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(' file(s) secured in Evidence Vault.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload note: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _showFileDetails(Map<String, dynamic> file) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getFileColor(file['type']).withOpacity(0.15),
                  child: Icon(_getFileIcon(file['type']), color: _getFileColor(file['type'])),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file['name'] ?? 'Evidence File',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.folder_shared_outlined, size: 20),
              title: const Text('Linked Case ID'),
              subtitle: Text(file['caseId'] ?? 'General Incident Evidence'),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.data_usage_outlined, size: 20),
              title: const Text('File Size & Type'),
              subtitle: Text('${file['size'] ?? "Unknown"} · ${file['type'] ?? "File"}'),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline, size: 20),
              title: const Text('Security & Encryption'),
              subtitle: const Text('AES-256 encrypted at rest. Accessible only to Inquiry Committee.'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.listenable,
      builder: (context, _) {
        return ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: DataStore.evidenceFiles,
          builder: (context, files, _) {
            final filtered = selectedFilter == 'All'
                ? files
                : files.where((f) => f['type'] == selectedFilter).toList();

            return Scaffold(
              backgroundColor: AppColors.background,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _pickAndAddEvidence,
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
                label: const Text('Add Evidence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // Header Banner
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
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
                                  AppText.of(context, 'evidence_vault'),
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${files.length} ${AppText.of(context, "secured_files")}',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Encryption Notice
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.chipBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppText.of(context, 'evidence_encryption_notice'),
                                style: const TextStyle(fontSize: 11, color: AppColors.primaryDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Filter Tabs
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filters.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final filter = filters[index];
                          final active = filter == selectedFilter;
                          return GestureDetector(
                            onTap: () => setState(() => selectedFilter = filter),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: active ? AppColors.primary : AppColors.chipBackground,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: active ? Colors.white : AppColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Evidence List
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.folder_open_rounded, size: 54, color: AppColors.primary.withOpacity(0.5)),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppText.of(context, 'no_files_category'),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Audio recordings, photos, and docs appear here.',
                                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: filtered.length,
                              separatorBuilder: (context, _) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final f = filtered[index];
                                final type = f['type']?.toString();

                                return Card(
                                  elevation: 0,
                                  color: AppColors.cardBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(color: AppColors.cardBorder),
                                  ),
                                  child: ListTile(
                                    onTap: () => _showFileDetails(f),
                                    leading: CircleAvatar(
                                      backgroundColor: _getFileColor(type).withOpacity(0.12),
                                      child: Icon(_getFileIcon(type), color: _getFileColor(type), size: 20),
                                    ),
                                    title: Text(
                                      f['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.primaryDark),
                                    ),
                                    subtitle: Text(
                                      '${f['size'] ?? ""} · ${f['date'] ?? ""} · ${f['caseId'] ?? ""}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                    ),
                                    trailing: const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}