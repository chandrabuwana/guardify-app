import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../core/design/colors.dart';
import '../../core/design/styles.dart';
import '../../core/di/injection.dart';
import '../../core/models/api_log_model.dart';
import '../../core/services/api_log_service.dart';
import 'Buttons/ui_button.dart';

/// Dialog untuk menampilkan dan mengelola API logs
class ApiLogViewerDialog extends StatefulWidget {
  const ApiLogViewerDialog({super.key});

  @override
  State<ApiLogViewerDialog> createState() => _ApiLogViewerDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (context) => const ApiLogViewerDialog(),
    );
  }
}

class _ApiLogViewerDialogState extends State<ApiLogViewerDialog> {
  late final ApiLogService _logService;

  List<ApiLogModel> _logs = [];
  ApiLogModel? _selectedLog;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _logService = getIt<ApiLogService>();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    try {
      final logs = await _logService.getAllLogs();
      setState(() {
        _logs = logs;
        if (_logs.isNotEmpty && _selectedLog == null) {
          _selectedLog = _logs.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _clearLogs() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: const Text('Clear All Logs?'),
        content: const Text('Apakah Anda yakin ingin menghapus semua log?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: errorColor),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _logService.clearLogs();
      setState(() {
        _logs = [];
        _selectedLog = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logs berhasil dihapus'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
        );
      }
    }
  }

  Future<void> _copyLog(ApiLogModel log) async {
    final formattedLog = log.getFormattedLog();
    await Clipboard.setData(ClipboardData(text: formattedLog));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Log berhasil di-copy'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
    }
  }

  Future<void> _copyAllLogs() async {
    final buffer = StringBuffer();
    for (var log in _logs) {
      buffer.writeln(log.getFormattedLog());
      buffer.writeln('\n');
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua logs berhasil di-copy'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );
    }
  }

  IconData _getMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Icons.get_app;
      case 'POST':
        return Icons.add_circle_outline;
      case 'PUT':
        return Icons.edit_outlined;
      case 'DELETE':
        return Icons.delete_outline;
      case 'PATCH':
        return Icons.border_color;
      default:
        return Icons.http;
    }
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            // Header dengan gradient
            Container(
              padding: REdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: REdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.bug_report, color: Colors.white, size: 24),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'API Logs',
                          style: TS.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${_logs.length} log entries',
                          style: TS.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Container(
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: UIButton(
                      text: 'Clear All',
                      buttonType: UIButtonType.outline,
                      variant: UIButtonVariant.error,
                      onPressed: _logs.isEmpty ? null : _clearLogs,
                      size: UIButtonSize.small,
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: UIButton(
                      text: 'Copy All',
                      buttonType: UIButtonType.outline,
                      variant: UIButtonVariant.primary,
                      onPressed: _logs.isEmpty ? null : _copyAllLogs,
                      size: UIButtonSize.small,
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _loadLogs,
                      tooltip: 'Refresh',
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _logs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_outlined,
                                  size: 80.sp, color: Colors.grey.shade300),
                              16.verticalSpace,
                              Text(
                                'Tidak ada log',
                                style: TS.titleMedium.copyWith(
                                    color: Colors.grey.shade600),
                              ),
                              8.verticalSpace,
                              Text(
                                'API logs akan muncul di sini',
                                style: TS.bodySmall.copyWith(
                                    color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            // Log List
                            Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.grey.shade50,
                                child: ListView.builder(
                                  padding: REdgeInsets.all(8),
                                  itemCount: _logs.length,
                                  itemBuilder: (context, index) {
                                    final log = _logs[index];
                                    final isSelected = _selectedLog?.id == log.id;
                                    final isError = log.error != null;
                                    final statusColor = isError
                                        ? errorColor
                                        : log.statusCode != null &&
                                                log.statusCode! >= 400
                                            ? Colors.orange
                                            : successColor;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() => _selectedLog = log);
                                      },
                                      child: Container(
                                        margin: REdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? primaryColor.withOpacity(0.1)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: isSelected
                                                ? primaryColor
                                                : Colors.grey.shade200,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: primaryColor.withOpacity(0.1),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.05),
                                                    blurRadius: 2,
                                                    offset: const Offset(0, 1),
                                                  ),
                                                ],
                                        ),
                                        padding: REdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            // Method Icon
                                            Container(
                                              width: 36.w,
                                              height: 36.h,
                                              decoration: BoxDecoration(
                                                color: _getMethodColor(log.method)
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                              child: Icon(
                                                _getMethodIcon(log.method),
                                                color: _getMethodColor(log.method),
                                                size: 14.sp,
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          log.method,
                                                          style: TS.bodySmall.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: _getMethodColor(log.method),
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      8.horizontalSpace,
                                                      Container(
                                                        padding: REdgeInsets.symmetric(
                                                            horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: statusColor.withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius.circular(4.r),
                                                        ),
                                                        child: Text(
                                                          log.statusCode?.toString() ??
                                                              'PENDING',
                                                          style: TS.bodyMini.copyWith(
                                                            color: statusColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  4.verticalSpace,
                                                  Text(
                                                    log.url.length > 50
                                                        ? '${log.url.substring(0, 50)}...'
                                                        : log.url,
                                                    style: TS.bodyMini.copyWith(
                                                      color: Colors.grey.shade700,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  if (log.durationMs != null) ...[
                                                    4.verticalSpace,
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.timer_outlined,
                                                            size: 12.sp,
                                                            color: Colors.grey.shade500),
                                                        4.horizontalSpace,
                                                        Flexible(
                                                          child: Text(
                                                            '${log.durationMs}ms',
                                                            style: TS.bodyMini.copyWith(
                                                              color: Colors.grey.shade600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            1.horizontalSpace,
                            // Log Detail
                            Expanded(
                              flex: 3,
                              child: _selectedLog == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.description_outlined,
                                              size: 64.sp, color: Colors.grey.shade300),
                                          16.verticalSpace,
                                          Text(
                                            'Pilih log untuk melihat detail',
                                            style: TS.bodyLarge.copyWith(
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Header Detail
                                          Container(
                                            padding: REdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.grey.shade200),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: REdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: _getMethodColor(
                                                            _selectedLog!.method)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(8.r),
                                                  ),
                                                  child: Icon(
                                                    _getMethodIcon(_selectedLog!.method),
                                                    color: _getMethodColor(
                                                        _selectedLog!.method),
                                                    size: 20.sp,
                                                  ),
                                                ),
                                                12.horizontalSpace,
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        _selectedLog!.method,
                                                        style: TS.titleSmall.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: _getMethodColor(
                                                              _selectedLog!.method),
                                                        ),
                                                      ),
                                                      Text(
                                                        _selectedLog!.url,
                                                        style: TS.bodySmall.copyWith(
                                                          color: Colors.grey.shade700,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      size: 20),
                                                  onPressed: () =>
                                                      _copyLog(_selectedLog!),
                                                  tooltip: 'Copy Log',
                                                  color: primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Detail Content
                                          Expanded(
                                            child: SingleChildScrollView(
                                              padding: REdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  // Timestamp
                                                  _buildDetailSection(
                                                    'Timestamp',
                                                    DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                                                        .format(_selectedLog!.timestamp),
                                                    icon: Icons.access_time,
                                                  ),
                                                  16.verticalSpace,
                                                  // Request Section
                                                  _buildSectionTitle('REQUEST', Icons.send),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.headers != null &&
                                                      _selectedLog!.headers!.isNotEmpty)
                                                    _buildDetailSection(
                                                      'Headers',
                                                      _formatHeaders(
                                                          _selectedLog!.headers!),
                                                      icon: Icons.list,
                                                    ),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.requestBody != null)
                                                    _buildDetailSection(
                                                      'Request Body',
                                                      _formatJson(
                                                          _selectedLog!.requestBody),
                                                      icon: Icons.code,
                                                      isJson: true,
                                                    ),
                                                  16.verticalSpace,
                                                  // Response Section
                                                  _buildSectionTitle('RESPONSE',
                                                      _selectedLog!.error != null
                                                          ? Icons.error_outline
                                                          : Icons.check_circle_outline),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.statusCode != null)
                                                    _buildDetailSection(
                                                      'Status Code',
                                                      '${_selectedLog!.statusCode}',
                                                      icon: Icons.info_outline,
                                                      valueColor: _selectedLog!.statusCode! >=
                                                              400
                                                          ? errorColor
                                                          : successColor,
                                                    ),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.durationMs != null)
                                                    _buildDetailSection(
                                                      'Duration',
                                                      '${_selectedLog!.durationMs}ms',
                                                      icon: Icons.timer,
                                                    ),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.error != null)
                                                    _buildDetailSection(
                                                      'Error',
                                                      _selectedLog!.error!,
                                                      icon: Icons.error,
                                                      valueColor: errorColor,
                                                    ),
                                                  12.verticalSpace,
                                                  if (_selectedLog!.responseBody != null)
                                                    _buildDetailSection(
                                                      'Response Body',
                                                      _formatJson(
                                                          _selectedLog!.responseBody),
                                                      icon: Icons.code,
                                                      isJson: true,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: primaryColor),
        8.horizontalSpace,
        Text(
          title,
          style: TS.labelLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
    bool isJson = false,
  }) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14.sp, color: Colors.grey.shade600),
                6.horizontalSpace,
              ],
              Text(
                label,
                style: TS.labelSmall.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          SelectableText(
            value,
            style: TS.bodySmall.copyWith(
              fontFamily: isJson ? 'monospace' : null,
              color: valueColor ?? Colors.black87,
              height: isJson ? 1.5 : 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    final buffer = StringBuffer();
    headers.forEach((key, value) {
      if (key.toLowerCase() == 'authorization') {
        buffer.writeln('$key: Bearer ***');
      } else {
        buffer.writeln('$key: $value');
      }
    });
    return buffer.toString().trim();
  }

  String _formatJson(dynamic data) {
    try {
      if (data is Map || data is List) {
        // Use JsonEncoder for pretty formatting
        final encoder = const JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      } else {
        return data.toString();
      }
    } catch (e) {
      return data.toString();
    }
  }
}
