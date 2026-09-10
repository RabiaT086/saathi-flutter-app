import 'package:flutter/material.dart';

/// Temporary in-memory data store so submitted reports show up in
/// "My Cases" and Home's "Latest case" during local testing, without
/// waiting for the real Firebase backend. Resets when the app restarts.
class DataStore {
  static final ValueNotifier<List<Map<String, String>>> cases = ValueNotifier([
    {
      'id': '#HA-2026-001',
      'type': 'Cyber Harassment',
      'date': '2026-08-02 21:40',
      'description': 'An unknown account has been repeatedly sending unwanted messages and comments after I asked them to stop.',
      'priority': 'HIGH',
      'status': 'Investigation',
      'location': 'Online · Instagram DMs',
    },
  ]);

  static int _counter = 1;

  static String addCase({
    required String type,
    required String date,
    required String location,
    required String description,
  }) {
    _counter++;
    final id = '#HA-2026-${_counter.toString().padLeft(3, '0')}';
    final newCase = {
      'id': id,
      'type': type,
      'date': date,
      'description': description,
      'priority': 'MEDIUM',
      'status': 'Submitted',
      'location': location,
    };
    cases.value = [newCase, ...cases.value];
    return id;
  }
}
