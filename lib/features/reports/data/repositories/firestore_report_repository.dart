import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nownowww/core/constants/firebase_constants.dart';
import '../../domain/models/report_model.dart';
import '../../domain/repositories/report_repository.dart';

class FirestoreReportRepository implements IReportRepository {
  final FirebaseFirestore _firestore;

  FirestoreReportRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> submitReport(ReportModel report) async {
    await _firestore
        .collection(FirebaseConstants.reportsCollection)
        .doc(report.id)
        .set(report.toJson());
  }
}
