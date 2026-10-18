import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for Cloud Firestore operations in Saathi App.
/// Handles User Profiles, Harassment Complaints, Emergency Alerts, and Status Updates.
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _usersCol =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _complaintsCol =>
      _firestore.collection('complaints');

  CollectionReference<Map<String, dynamic>> get _emergencyCol =>
      _firestore.collection('emergency_alerts');

  /// Save or update user profile document in Firestore: users/{uid}
  Future<void> saveUserProfile({
    required String uid,
    required String fullName,
    required String email,
    required String universityId,
    String? emergencyName,
    String? emergencyPhone,
    String role = 'student',
  }) async {
    try {
      await _usersCol.doc(uid).set({
        'uid': uid,
        'fullName': fullName.trim(),
        'email': email.trim().toLowerCase(),
        'universityId': universityId.trim(),
        'emergencyName': emergencyName?.trim() ?? '',
        'emergencyPhone': emergencyPhone?.trim() ?? '',
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('FirestoreService: Profile saved for uid $uid');
    } catch (e) {
      debugPrint('FirestoreService.saveUserProfile error: $e');
      // Do not crash UI flow
    }
  }

  /// Get user profile by UID
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCol.doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('FirestoreService.getUserProfile error: $e');
      return null;
    }
  }

  /// Submit a harassment complaint to Firestore: complaints/{caseId}
  Future<void> submitComplaint({
    required String caseId,
    required String type,
    required String date,
    required String location,
    required String description,
    String? additionalInfo,
    String? student,
    String? studentUid,
    List<String>? attachmentNames,
    String priority = 'MEDIUM',
    String status = 'Submitted',
  }) async {
    try {
      await _complaintsCol.doc(caseId).set({
        'caseId': caseId,
        'type': type,
        'incidentDate': date,
        'location': location,
        'description': description,
        'additionalInfo': additionalInfo ?? '',
        'student': student ?? 'Confidential Student',
        'studentUid': studentUid ?? '',
        'priority': priority,
        'status': status,
        'attachments': attachmentNames ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('FirestoreService: Complaint $caseId saved to Firestore');
    } catch (e) {
      debugPrint('FirestoreService.submitComplaint error: $e');
    }
  }

  /// Update complaint investigation status and remarks
  Future<void> updateCaseStatus(
    String caseId,
    String newStatus, {
    String? remark,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (remark != null && remark.isNotEmpty) {
        updateData['remark'] = remark;
      }
      await _complaintsCol.doc(caseId).update(updateData);
      debugPrint('FirestoreService: Case $caseId status updated to $newStatus');
    } catch (e) {
      debugPrint('FirestoreService.updateCaseStatus error: $e');
    }
  }

  /// Trigger and record an Emergency SOS alert in Firestore: emergency_alerts/{alertId}
  Future<void> triggerEmergencyAlert({
    required String alertId,
    required String student,
    required String location,
    required String phone,
    String? mapsUrl,
    String? studentUid,
  }) async {
    try {
      await _emergencyCol.doc(alertId).set({
        'alertId': alertId,
        'student': student,
        'location': location,
        'phone': phone,
        'mapsUrl': mapsUrl ?? '',
        'studentUid': studentUid ?? '',
        'status': 'Active',
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('FirestoreService: Emergency alert $alertId recorded in Firestore');
    } catch (e) {
      debugPrint('FirestoreService.triggerEmergencyAlert error: $e');
    }
  }

  /// Resolve an emergency alert
  Future<void> resolveEmergencyAlert(String alertId) async {
    try {
      await _emergencyCol.doc(alertId).update({
        'status': 'Resolved',
        'resolvedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('FirestoreService.resolveEmergencyAlert error: $e');
    }
  }

  /// Stream complaints in real-time
  Stream<List<Map<String, dynamic>>> streamComplaints({String? studentUid}) {
    Query<Map<String, dynamic>> query = _complaintsCol.orderBy('createdAt', descending: true);
    if (studentUid != null && studentUid.isNotEmpty) {
      query = query.where('studentUid', isEqualTo: studentUid);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data()).toList());
  }

  /// Stream emergency alerts in real-time
  Stream<List<Map<String, dynamic>>> streamEmergencyAlerts() {
    return _emergencyCol
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }
}
