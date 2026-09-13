import '../models/report_model.dart';

abstract class IReportRepository {
  Future<void> submitReport(ReportModel report);
}
