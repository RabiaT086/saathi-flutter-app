import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Centralized service for uploading and managing evidence files in Firebase Cloud Storage.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseStorage get instance => _storage;

  /// Upload a single picked file to Firebase Storage under evidence/{caseId}/{timestamp}_{filename}
  /// Returns the permanent public download URL.
  Future<String> uploadEvidenceFile({
    required PlatformFile file,
    required String caseId,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeName = file.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final path = 'evidence/$caseId/${timestamp}_$safeName';
      final ref = _storage.ref().child(path);

      UploadTask uploadTask;
      final metadata = SettableMetadata(
        contentType: _getContentType(file.extension),
        customMetadata: {
          'caseId': caseId,
          'originalName': file.name,
          'size': file.size.toString(),
        },
      );

      if (kIsWeb || file.bytes != null) {
        if (file.bytes == null) {
          debugPrint('StorageService: Web file bytes are null');
          return file.name;
        }
        uploadTask = ref.putData(file.bytes!, metadata);
      } else if (file.path != null) {
        final ioFile = io.File(file.path!);
        if (await ioFile.exists()) {
          uploadTask = ref.putFile(ioFile, metadata);
        } else {
          return file.name;
        }
      } else {
        return file.name;
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('StorageService: Uploaded ${file.name} to $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('StorageService.uploadEvidenceFile error: $e');
      // Fallback to storing original filename so submission is never blocked
      return file.name;
    }
  }

  /// Upload multiple picked files.
  /// Returns list of download URLs or fallback file names.
  Future<List<String>> uploadMultipleFiles({
    required List<PlatformFile> files,
    required String caseId,
  }) async {
    if (files.isEmpty) return [];
    final List<String> results = [];
    for (final file in files) {
      final url = await uploadEvidenceFile(file: file, caseId: caseId);
      results.add(url);
    }
    return results;
  }

  String _getContentType(String? extension) {
    final ext = (extension ?? '').toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
        return 'audio/mp4';
      case 'wav':
        return 'audio/wav';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
      case 'docx':
        return 'application/msword';
      default:
        return 'application/octet-stream';
    }
  }
}
