import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../app_state.dart';

class KnowYourRightsScreen extends StatelessWidget {
  const KnowYourRightsScreen({super.key});

  Widget _lawCard({
    required IconData icon,
    required String title,
    required String actName,
    required List<Widget> points,
    Color? badgeColor,
    String? badgeText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.chipBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      actName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppColors.chipBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeColor != null ? Colors.white : AppColors.primaryDark,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.cardBorder),
          const SizedBox(height: 12),
          ...points,
        ],
      ),
    );
  }

  Widget _bulletPoint(String heading, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.circle, size: 6, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                children: [
                  TextSpan(
                    text: '$heading: ',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRightItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.chipBackground,
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primaryDark, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: AppColors.primary, size: 18),
        ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Framed Top Gradient Header
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppText.of(context, 'know_your_rights_title'),
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                AppText.of(context, 'legal_framework_subtitle'),
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Summary Card
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
                            const Icon(Icons.shield_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              AppText.of(context, 'fundamental_rights'),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _summaryRightItem(Icons.lock_outline, AppText.of(context, 'complete_confidentiality'), AppText.of(context, 'complete_confidentiality_desc')),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _summaryRightItem(Icons.security_outlined, AppText.of(context, 'retaliation_protection'), AppText.of(context, 'retaliation_protection_desc')),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _summaryRightItem(Icons.timer_outlined, AppText.of(context, 'time_bound_inquiry'), AppText.of(context, 'time_bound_inquiry_desc')),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        _summaryRightItem(Icons.gavel_outlined, AppText.of(context, 'right_to_appeal'), AppText.of(context, 'right_to_appeal_desc')),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    AppText.of(context, 'applicable_laws'),
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 12),

                  // Law 1: Workplace Harassment Act 2010
                  _lawCard(
                    icon: Icons.balance_outlined,
                    title: 'Workplace Harassment Act',
                    actName: 'Protection Against Harassment Act 2010',
                    badgeText: 'Federal Law',
                    badgeColor: AppColors.primary,
                    points: [
                      _bulletPoint('Definition', 'Any unwelcome sexual advance, request for sexual favors, or verbal/written communication or physical conduct of a sexual nature.'),
                      _bulletPoint('Inquiry Committee', 'Universities must maintain a standing 3-member Inquiry Committee with at least one woman member.'),
                      _bulletPoint('Timeline', 'The committee must begin inquiry within 3 days and conclude within 30 days of receiving the complaint.'),
                      _bulletPoint('Penalties', 'Penalties range from reprimand and withholding increments to demotion, compulsory retirement, or dismissal from service/university.'),
                    ],
                  ),

                  // Law 2: HEC Policy for Higher Education Institutions
                  _lawCard(
                    icon: Icons.school_outlined,
                    title: 'HEC University Policy',
                    actName: 'HEC Policy on Sexual Harassment in HEIs (2020)',
                    badgeText: 'University Policy',
                    badgeColor: const Color(0xFF0284C7),
                    points: [
                      _bulletPoint('Jurisdiction', 'Covers entire university premises, classrooms, campus hostels, research laboratories, study tours, and university transport.'),
                      _bulletPoint('Interim Relief', 'During inquiry, students can request class schedule changes, instructor reassignments, or hostel adjustments for safety.'),
                      _bulletPoint('Appeals', 'If not satisfied with the committee decision, students can appeal to the Ombudsperson within 30 days.'),
                      _bulletPoint('Equal Coverage', 'Applies to faculty, visiting teachers, administration staff, students, and third-party contractors.'),
                    ],
                  ),

                  // Law 3: PPC Section 509
                  _lawCard(
                    icon: Icons.gavel_outlined,
                    title: 'Pakistan Penal Code (PPC)',
                    actName: 'PPC Section 509 - Harassment in Public/Institutions',
                    badgeText: 'Criminal Code',
                    badgeColor: AppColors.danger,
                    points: [
                      _bulletPoint('Criminal Offense', 'Criminalizes any word, gesture, or act intended to insult the modesty of a woman or cause harassment in public or educational spaces.'),
                      _bulletPoint('Punishment', 'Perpetrators face imprisonment of up to 3 years, heavy financial fine, or both.'),
                      _bulletPoint('Police Action', 'Allows registering an FIR at the relevant police station or dialing 15 for emergency police assistance.'),
                    ],
                  ),

                  // Law 4: PECA 2016 Cyber Harassment
                  _lawCard(
                    icon: Icons.phonelink_lock_outlined,
                    title: 'PECA Cyber Harassment Act',
                    actName: 'Prevention of Electronic Crimes Act 2016',
                    badgeText: 'Digital Safety',
                    badgeColor: const Color(0xFF7C3AED),
                    points: [
                      _bulletPoint('Cyber Stalking (Sec 24)', 'Online stalking, persistent unwanted messaging, following on social media after being asked to stop.'),
                      _bulletPoint('Unlawful Media (Sec 21)', 'Sharing private photos/videos without consent carries up to 5 years imprisonment and up to 5 million PKR fine.'),
                      _bulletPoint('FIA Reporting', 'Complaints can be lodged directly with FIA Cyber Crime Wing via Helpline 1991 or complaint.fia.gov.pk.'),
                    ],
                  ),

                  // Helpline Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.chipBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone_in_talk_outlined, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              AppText.of(context, 'emergency_helplines'),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('• Police Emergency: 15', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const Text('• Federal Ombudsperson (FOSPAH): 051-9262942', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const Text('• FIA Cyber Crime Helpline: 1991', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const Text('• Sindh Women Helpline: 1094', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
