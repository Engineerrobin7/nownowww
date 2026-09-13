import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

enum ReportType { post, comment, user }

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String id,
    required String reporterId,
    required String targetId,
    required ReportType targetType,
    required String reason,
    required DateTime createdAt,
    @Default(false) bool isResolved,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);
}
