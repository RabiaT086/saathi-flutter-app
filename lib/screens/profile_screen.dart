import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_drawer.dart';
import '../app_state.dart';
import '../data_store.dart';
import 'welcome_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const ProfileScreen({super.key, this.onBackToHome});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController departmentController;
  late final TextEditingController semesterController;

  final newContactNameController = TextEditingController();
  final newContactRelationController = TextEditingController();
  final newContactPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = DataStore.currentUser.value;
    nameController = TextEditingController(text: user['name'] ?? 'Areesha Naz');
    emailController = TextEditingController(text: user['email'] ?? 'areesha@fuuast.edu.pk');
    departmentController = TextEditingController(text: user['department'] ?? 'BS Computer Science');
    semesterController = TextEditingController(text: user['semester'] ?? '8th Semester');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    newContactNameController.dispose();
    newContactRelationController.dispose();
    newContactPhoneController.dispose();
    super.dispose();
  }

  Widget _toggleRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Switch(value: value, activeThumbColor: AppColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _infoField(String label, TextEditingController controller) {
    if (!isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(controller.text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
      ),
    );
  }

  void _saveProfileChanges() {
    DataStore.updateProfile(
      name: nameController.text,
      email: emailController.text,
      department: departmentController.text,
      semester: semesterController.text,
    );
    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
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

            final shakeDetection = user['shakeDetection'] ?? true;
            final autoRecord = user['autoRecord'] ?? true;
            final pushNotifications = user['pushNotifications'] ?? true;
            final caseUpdateEmails = user['caseUpdateEmails'] ?? false;
            final shareLocationWithAuthority = user['shareLocation'] ?? true;
            final hideIdentityFromPeers = user['hideIdentity'] ?? true;

            return Scaffold(
              backgroundColor: AppColors.background,
              drawer: const AppDrawer(),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            Builder(
                              builder: (scaffoldContext) => IconButton(
                                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                                icon: const Icon(Icons.menu, color: Colors.white),
                                tooltip: 'Menu',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppText.of(context, 'profile'),
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  AppText.of(context, 'manage_account_safety'),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name / Dept / Email / Edit / Change password Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.chipBackground,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.primary, width: 2),
                                  ),
                                  child: const Icon(Icons.person_rounded, size: 32, color: AppColors.primary),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: isEditing
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _infoField(AppText.of(context, 'name'), nameController),
                                            _infoField(AppText.of(context, 'department'), departmentController),
                                            _infoField(AppText.of(context, 'semester'), semesterController),
                                            _infoField(AppText.of(context, 'email'), emailController),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['name'] ?? nameController.text,
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                                            ),
                                            Text(
                                              '${user['department'] ?? departmentController.text} (${user['semester'] ?? semesterController.text})',
                                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                            ),
                                            Text(
                                              user['email'] ?? emailController.text,
                                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: AppColors.cardBorder),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    if (isEditing) {
                                      _saveProfileChanges();
                                    } else {
                                      setState(() => isEditing = true);
                                    }
                                  },
                                  icon: Icon(isEditing ? Icons.check : Icons.edit_outlined, size: 18),
                                  label: Text(isEditing ? 'Save Changes' : AppText.of(context, 'edit_profile')),
                                  style: TextButton.styleFrom(foregroundColor: AppColors.primary, padding: EdgeInsets.zero),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                                  },
                                  child: Text(
                                    AppText.of(context, 'change_password'),
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Emergency contacts list
                      const SizedBox(height: 25),
                      Text(
                        AppText.of(context, 'emergency_contacts'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      ),
                      const SizedBox(height: 10),
                      ...contacts.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final c = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                                    Text('${c['relation']} · ${c['phone']}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DataStore.removeEmergencyContact(idx);
                                },
                                icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                              ),
                            ],
                          ),
                        );
                      }),

                      // Add New Contact Section
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.of(context, 'add_contact'),
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: newContactNameController,
                              decoration: InputDecoration(
                                labelText: AppText.of(context, 'name'),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: newContactRelationController,
                                    decoration: InputDecoration(
                                      labelText: AppText.of(context, 'relation'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: newContactPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: AppText.of(context, 'phone'),
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  final name = newContactNameController.text.trim();
                                  final relation = newContactRelationController.text.trim();
                                  final phone = newContactPhoneController.text.trim();

                                  if (name.isEmpty || relation.isEmpty || phone.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please fill name, relation and phone.')),
                                    );
                                    return;
                                  }

                                  DataStore.addEmergencyContact(name: name, relation: relation, phone: phone);
                                  newContactNameController.clear();
                                  newContactRelationController.clear();
                                  newContactPhoneController.clear();
                                },
                                icon: const Icon(Icons.add),
                                label: Text('+ ${AppText.of(context, "add_contact")}'),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Safety settings toggles (FR-04, FR-06, FR-14)
                      const SizedBox(height: 25),
                      Text(
                        AppText.of(context, 'safety_settings'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
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
                            _toggleRow(
                              AppText.of(context, 'shake_detection'),
                              AppText.of(context, 'shake_detection_desc'),
                              shakeDetection,
                              (v) => DataStore.updateUserSetting('shakeDetection', v),
                            ),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            _toggleRow(
                              AppText.of(context, 'auto_record'),
                              AppText.of(context, 'auto_record_desc'),
                              autoRecord,
                              (v) => DataStore.updateUserSetting('autoRecord', v),
                            ),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            _toggleRow(
                              AppText.of(context, 'push_notifications'),
                              AppText.of(context, 'push_notifications_desc'),
                              pushNotifications,
                              (v) => DataStore.updateUserSetting('pushNotifications', v),
                            ),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            _toggleRow(
                              AppText.of(context, 'case_update_emails'),
                              AppText.of(context, 'case_update_emails_desc'),
                              caseUpdateEmails,
                              (v) => DataStore.updateUserSetting('caseUpdateEmails', v),
                            ),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            _toggleRow(
                              AppText.of(context, 'share_location_authority'),
                              AppText.of(context, 'share_location_authority_desc'),
                              shareLocationWithAuthority,
                              (v) => DataStore.updateUserSetting('shareLocation', v),
                            ),
                            const Divider(height: 1, color: AppColors.cardBorder),
                            _toggleRow(
                              AppText.of(context, 'hide_identity_peers'),
                              AppText.of(context, 'hide_identity_peers_desc'),
                              hideIdentityFromPeers,
                              (v) => DataStore.updateUserSetting('hideIdentity', v),
                            ),
                          ],
                        ),
                      ),

                      // Logout Button
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.logout),
                          label: Text(AppText.of(context, 'logout')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: Colors.white,
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