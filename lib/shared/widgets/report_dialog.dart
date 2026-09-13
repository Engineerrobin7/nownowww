import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:nownowww/features/auth/presentation/providers/auth_providers.dart';
import 'package:nownowww/features/reports/domain/models/report_model.dart';
import 'package:nownowww/features/reports/presentation/providers/report_providers.dart';

class ReportDialog extends ConsumerStatefulWidget {
  final String targetId;
  final ReportType targetType;

  const ReportDialog({
    super.key,
    required this.targetId,
    required this.targetType,
  });

  @override
  ConsumerState<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<ReportDialog> {
  final List<String> _reasons = [
    'Spam',
    'Harassment',
    'Hate Speech',
    'Inappropriate Content',
    'Misinformation',
    'Other',
  ];
  String? _selectedReason;
  bool _isSubmitting = false;

  Future<void> _submitReport() async {
    if (_selectedReason == null) return;

    setState(() => _isSubmitting = true);
    try {
      final reporterId = ref.read(currentUserProvider)?.uid;
      if (reporterId == null) return;

      final report = ReportModel(
        id: const Uuid().v4(),
        reporterId: reporterId,
        targetId: widget.targetId,
        targetType: widget.targetType,
        reason: _selectedReason!,
        createdAt: DateTime.now(),
      );

      await ref.read(reportRepositoryProvider).submitReport(report);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully. Thank you.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report ${widget.targetType.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _reasons.map((reason) {
            // Using a simple selection logic to avoid deprecation warnings
            return InkWell(
              onTap: () => setState(() => _selectedReason = reason),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Radio<String>(
                      value: reason,
                      groupValue: _selectedReason,
                      onChanged: (value) => setState(() => _selectedReason = value),
                      activeColor: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(reason),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _selectedReason == null || _isSubmitting ? null : _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Submit Report'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
