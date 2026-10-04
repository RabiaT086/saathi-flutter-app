import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// In-memory reactive data store for Saathi.
/// Powers Student Reporting, Case Tracking, Evidence Vault, Notifications,
/// Profile Management, and the Anti-Harassment Authority Dashboard.
class DataStore {
  // -------------------------------------------------------------
  // Cases / Complaints Store
  // -------------------------------------------------------------
  static final ValueNotifier<List<Map<String, String>>> cases = ValueNotifier([
    {
      'id': '#HA-2026-001',
      'student': 'Ayesha Khan (BCS-F22-041)',
      'type': 'Cyber Harassment',
      'date': '2026-08-02 21:40',
      'description': 'An unknown account has been repeatedly sending unwanted messages and comments after I asked them to stop.',
      'priority': 'HIGH',
      'status': 'Investigation',
      'location': 'Online · Instagram DMs',
    },
    {
      'id': '#HA-2026-002',
      'student': 'Fatima Noor (BBA-F23-112)',
      'type': 'Verbal Harassment',
      'date': '2026-08-10 14:15',
      'description': 'Repeated offensive remarks and stalking near the academic block stairs during lunch break.',
      'priority': 'MEDIUM',
      'status': 'Under Review',
      'location': 'Main Campus · Cafeteria Block',
    },
    {
      'id': '#HA-2026-003',
      'student': 'Zainab Bibi (BSCS-F21-089)',
      'type': 'Bullying',
      'date': '2026-08-14 11:30',
      'description': 'Persistent intimidation, verbal mockery, and harassment regarding project submissions.',
      'priority': 'LOW',
      'status': 'Submitted',
      'location': 'CS Department · Lab 3',
    },
    {
      'id': '#HA-2026-004',
      'student': 'Maryam Tariq (BS-ENG-F22-015)',
      'type': 'Physical Harassment',
      'date': '2026-07-28 16:50',
      'description': 'Inappropriate physical blocking and harassment in the administration building corridor.',
      'priority': 'HIGH',
      'status': 'Resolved',
      'location': 'Admin Block Corridor',
    },
  ]);

  // -------------------------------------------------------------
  // Emergency Alerts Store
  // -------------------------------------------------------------
  static final ValueNotifier<List<Map<String, String>>> emergencyAlerts = ValueNotifier([
    {
      'id': 'SOS-901',
      'student': 'Sadia Rafiq (BSCS-F23)',
      'location': 'Near Library / Girls Common Room',
      'time': '12 mins ago',
      'status': 'Active',
      'phone': '0300-1234567',
    },
  ]);

  // -------------------------------------------------------------
  // Notifications Store (FR-12)
  // -------------------------------------------------------------
  static final ValueNotifier<List<Map<String, dynamic>>> notifications = ValueNotifier([
    {
      'id': 'notif-1',
      'title': 'Welcome to Saathi',
      'message': 'Your account is active. Emergency services, SOS shake detection, and harassment reporting are ready.',
      'time': 'Just now',
      'type': 'system',
      'isRead': false,
      'caseId': null,
    },
    {
      'id': 'notif-2',
      'title': 'Case #HA-2026-002 Under Review',
      'message': 'The Anti-Harassment Inquiry Committee has started reviewing case #HA-2026-002.',
      'time': '2 hours ago',
      'type': 'case_update',
      'isRead': false,
      'caseId': '#HA-2026-002',
    },
    {
      'id': 'notif-3',
      'title': 'Case #HA-2026-004 Resolved',
      'message': 'Action taken: Warning letter issued to perpetrator. Case marked as Resolved.',
      'time': '1 day ago',
      'type': 'resolved',
      'isRead': true,
      'caseId': '#HA-2026-004',
    },
  ]);

  // -------------------------------------------------------------
  // Evidence Vault Store (FR-06, FR-08)
  // -------------------------------------------------------------
  static final ValueNotifier<List<Map<String, dynamic>>> evidenceFiles = ValueNotifier([
    {
      'id': 'ev-1',
      'name': 'dm-screenshot-01.png',
      'size': '1.2 MB',
      'date': '2026-08-03',
      'caseId': '#HA-2026-001',
      'type': 'Image',
      'path': '',
      'url': '',
    },
    {
      'id': 'ev-2',
      'name': 'fake-account-profile.png',
      'size': '890 KB',
      'date': '2026-08-03',
      'caseId': '#HA-2026-001',
      'type': 'Image',
      'path': '',
      'url': '',
    },
    {
      'id': 'ev-3',
      'name': 'cctv_corridor_incident.mp4',
      'size': '14.5 MB',
      'date': '2026-07-28',
      'caseId': '#HA-2026-004',
      'type': 'Video',
      'path': '',
      'url': '',
    },
    {
      'id': 'ev-4',
      'name': 'witness_statement.pdf',
      'size': '320 KB',
      'date': '2026-08-10',
      'caseId': '#HA-2026-002',
      'type': 'Document',
      'path': '',
      'url': '',
    },
  ]);

  // -------------------------------------------------------------
  // Current Logged-in User Profile & Contacts (FR-14)
  // -------------------------------------------------------------
  static final ValueNotifier<Map<String, dynamic>> currentUser = ValueNotifier({
    'name': 'Areesha Naz',
    'email': 'areesha@fuuast.edu.pk',
    'department': 'BS Computer Science',
    'semester': '8th Semester',
    'universityId': 'BCS-F22-041',
    'contacts': [
      {'name': 'Rabia Tabassum', 'relation': 'Sister', 'phone': '+92 301 7654321'},
      {'name': 'Campus Security Office', 'relation': 'University', 'phone': '+92 21 99261300'},
    ],
    'shakeDetection': true,
    'autoRecord': true,
    'pushNotifications': true,
    'caseUpdateEmails': false,
    'shareLocation': true,
    'hideIdentity': true,
  });

  static int _counter = 4;

  // -------------------------------------------------------------
  // Cases Methods
  // -------------------------------------------------------------
  static String addCase({
    required String type,
    required String date,
    required String location,
    required String description,
    String? student,
    String priority = 'MEDIUM',
  }) {
    _counter++;
    final id = '#HA-2026-${_counter.toString().padLeft(3, '0')}';
    final String studentName = (student ?? currentUser.value['name'] ?? 'Confidential Student (FUUAST)').toString();
    final Map<String, String> newCase = {
      'id': id,
      'student': studentName,
      'type': type,
      'date': date,
      'description': description,
      'priority': priority,
      'status': 'Submitted',
      'location': location,
    };
    cases.value = [newCase, ...cases.value];

    // Auto-generate in-app notification
    addNotification(
      title: 'Complaint Registered ($id)',
      message: 'Your report for "$type" was submitted and assigned Case ID $id. You can track progress in My Cases.',
      type: 'case_update',
      caseId: id,
    );

    return id;
  }

  static void updateCaseStatus(String id, String newStatus, {String? remark}) {
    final list = List<Map<String, String>>.from(cases.value);
    final idx = list.indexWhere((c) => c['id'] == id);
    if (idx != -1) {
      final updated = Map<String, String>.from(list[idx]);
      updated['status'] = newStatus;
      if (remark != null && remark.trim().isNotEmpty) {
        updated['remark'] = remark.trim();
      }
      list[idx] = updated;
      cases.value = list;

      // Auto-generate notification
      final remarkText = (remark != null && remark.trim().isNotEmpty) ? ' Note: "$remark"' : '';
      addNotification(
        title: 'Case $id Status: $newStatus',
        message: 'The committee updated your case status to "$newStatus".$remarkText',
        type: newStatus == 'Resolved' ? 'resolved' : 'case_update',
        caseId: id,
      );
    }
  }

  static void resolveAlert(String id) {
    final list = List<Map<String, String>>.from(emergencyAlerts.value);
    final idx = list.indexWhere((a) => a['id'] == id);
    if (idx != -1) {
      final updated = Map<String, String>.from(list[idx]);
      updated['status'] = 'Resolved';
      list[idx] = updated;
      emergencyAlerts.value = list;
    }
  }

  // -------------------------------------------------------------
  // Notification Methods
  // -------------------------------------------------------------
  static void addNotification({
    required String title,
    required String message,
    String type = 'system',
    String? caseId,
  }) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final notif = {
      'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'message': message,
      'time': timeStr,
      'type': type,
      'isRead': false,
      'caseId': caseId,
    };
    notifications.value = [notif, ...notifications.value];
  }

  static void markAllNotificationsRead() {
    final list = notifications.value.map((n) {
      final map = Map<String, dynamic>.from(n);
      map['isRead'] = true;
      return map;
    }).toList();
    notifications.value = list;
  }

  static void clearNotifications() {
    notifications.value = [];
  }

  // -------------------------------------------------------------
  // Evidence Methods
  // -------------------------------------------------------------
  static void addEvidenceFile({
    required String name,
    required String size,
    required String caseId,
    required String type,
    String path = '',
    String url = '',
  }) {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final newEvidence = {
      'id': 'ev-${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'size': size,
      'date': dateStr,
      'caseId': caseId,
      'type': type,
      'path': path,
      'url': url,
    };
    evidenceFiles.value = [newEvidence, ...evidenceFiles.value];
  }

  // -------------------------------------------------------------
  // Profile & Contact Methods
  // -------------------------------------------------------------
  static void updateProfile({
    String? name,
    String? email,
    String? department,
    String? semester,
    String? universityId,
  }) {
    final current = Map<String, dynamic>.from(currentUser.value);
    if (name != null) current['name'] = name.trim();
    if (email != null) current['email'] = email.trim();
    if (department != null) current['department'] = department.trim();
    if (semester != null) current['semester'] = semester.trim();
    if (universityId != null) current['universityId'] = universityId.trim();
    currentUser.value = current;
  }

  static void addEmergencyContact({
    required String name,
    required String relation,
    required String phone,
  }) {
    final current = Map<String, dynamic>.from(currentUser.value);
    final contactsList = List<Map<String, String>>.from(current['contacts'] ?? []);
    contactsList.add({'name': name.trim(), 'relation': relation.trim(), 'phone': phone.trim()});
    current['contacts'] = contactsList;
    currentUser.value = current;
  }

  static void removeEmergencyContact(int index) {
    final current = Map<String, dynamic>.from(currentUser.value);
    final contactsList = List<Map<String, String>>.from(current['contacts'] ?? []);
    if (index >= 0 && index < contactsList.length) {
      contactsList.removeAt(index);
      current['contacts'] = contactsList;
      currentUser.value = current;
    }
  }

  static void updateUserSetting(String key, dynamic value) {
    final current = Map<String, dynamic>.from(currentUser.value);
    current[key] = value;
    currentUser.value = current;
  }

  // -------------------------------------------------------------
  // Supabase Sync
  // -------------------------------------------------------------
  static Future<void> loadFromSupabase() async {
    try {
      final client = Supabase.instance.client;

      final complaintsData = await client
          .from('complaints')
          .select()
          .order('created_at', ascending: false);

      final loadedCases = (complaintsData as List).map((row) {
        return {
          'id': (row['case_id'] ?? '').toString(),
          'student': (row['student'] ?? 'Confidential Student (FUUAST)').toString(),
          'type': (row['harassment_type'] ?? '').toString(),
          'date': (row['incident_date'] ?? '').toString(),
          'description': (row['description'] ?? '').toString(),
          'priority': (row['priority'] ?? 'MEDIUM').toString(),
          'status': (row['status'] ?? 'Submitted').toString(),
          'location': (row['location'] ?? '').toString(),
          if (row['remark'] != null) 'remark': row['remark'].toString(),
        };
      }).toList().cast<Map<String, String>>();

      if (loadedCases.isNotEmpty) {
        cases.value = loadedCases;
      }

      final alertsData = await client
          .from('emergency_alerts')
          .select()
          .order('created_at', ascending: false);

      final loadedAlerts = (alertsData as List).map((row) {
        return {
          'id': (row['alert_id'] ?? '').toString(),
          'student': (row['student_name'] ?? '').toString(),
          'location': (row['location_text'] ?? '').toString(),
          'time': (row['created_at'] ?? '').toString(),
          'status': (row['status'] ?? 'Active').toString(),
          'phone': (row['phone'] ?? '').toString(),
        };
      }).toList().cast<Map<String, String>>();

      if (loadedAlerts.isNotEmpty) {
        emergencyAlerts.value = loadedAlerts;
      }
    } catch (e) {
      debugPrint('Load from Supabase failed: $e');
    }
  }
}