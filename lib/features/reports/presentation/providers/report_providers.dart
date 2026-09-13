import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/firestore_report_repository.dart';
import '../../domain/repositories/report_repository.dart';

part 'report_providers.g.dart';

@riverpod
IReportRepository reportRepository(ReportRepositoryRef ref) {
  return FirestoreReportRepository();
}
