import 'package:flutter/material.dart';

/// In-memory data store for Saathi.
/// Powers both student reporting and the Anti-Harassment Authority Dashboard.
class DataStore {
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

  static int _counter = 4;

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
    final newCase = {
      'id': id,
      'student': student ?? 'Confidential Student (FUUAST)',
      'type': type,
      'date': date,
      'description': description,
      'priority': priority,
      'status': 'Submitted',
      'location': location,
    };
    cases.value = [newCase, ...cases.value];
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
}
