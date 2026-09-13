// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportModelImpl _$$ReportModelImplFromJson(Map<String, dynamic> json) =>
    _$ReportModelImpl(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      targetId: json['targetId'] as String,
      targetType: $enumDecode(_$ReportTypeEnumMap, json['targetType']),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
    );

Map<String, dynamic> _$$ReportModelImplToJson(_$ReportModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'targetId': instance.targetId,
      'targetType': _$ReportTypeEnumMap[instance.targetType]!,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
      'isResolved': instance.isResolved,
    };

const _$ReportTypeEnumMap = {
  ReportType.post: 'post',
  ReportType.comment: 'comment',
  ReportType.user: 'user',
};
