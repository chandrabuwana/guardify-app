import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../bloc/panic_button_bloc.dart';
import '../bloc/panic_button_event.dart';
import '../bloc/panic_button_state.dart';
import '../../domain/entities/panic_button_history_item.dart';
import 'panic_button_detail_page.dart';

class PanicButtonHistoryPage extends StatefulWidget {
  const PanicButtonHistoryPage({super.key});

  @override
  State<PanicButtonHistoryPage> createState() => _PanicButtonHistoryPageState();
}

class _PanicButtonHistoryPageState extends State<PanicButtonHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PanicButtonBloc>().add(
              const LoadPanicButtonHistoryEvent(start: 0, length: 10),
            );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PanicButtonBloc>().add(const LoadMorePanicButtonHistoryEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _performSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PanicButtonBloc>().add(SearchPanicButtonHistoryEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Riwayat Panic Button',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocConsumer<PanicButtonBloc, PanicButtonState>(
          listener: (context, state) {
            if (state.historyErrorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.historyErrorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Search and Filter Bar
                Container(
                  padding: REdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE74C3C)),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari',
                              hintStyle: TextStyle(
                                color: const Color(0xFFE74C3C).withOpacity(0.6),
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: const Color(0xFFE74C3C),
                                size: 20.r,
                              ),
                              border: InputBorder.none,
                              contentPadding: REdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(fontSize: 14.sp),
                            onChanged: _performSearch,
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      // Filter Button
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE74C3C),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.filter_list, color: Colors.white),
                          onPressed: () {
                            // TODO: Implement filter dialog
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: _buildList(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(PanicButtonState state) {
    if (state.isLoadingHistory && state.historyItems.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE74C3C)),
      );
    }

    if (state.historyItems.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada riwayat',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PanicButtonBloc>().add(const RefreshPanicButtonHistoryEvent());
      },
      color: const Color(0xFFE74C3C),
      child: ListView.builder(
        controller: _scrollController,
        padding: REdgeInsets.all(16),
        itemCount: state.historyItems.length + (state.isLoadingMoreHistory ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.historyItems.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Color(0xFFE74C3C)),
              ),
            );
          }

          final item = state.historyItems[index];
          return _buildHistoryCard(item);
        },
      ),
    );
  }

  Widget _buildHistoryCard(PanicButtonHistoryItem item) {
    final statusColor = _getStatusColor(item.statusColor);
    final statusTextColor = _getStatusTextColor(item.statusColor);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => getIt<PanicButtonBloc>(),
              child: PanicButtonDetailPage(incidentId: item.id),
            ),
          ),
        );
        // Reload list if result is true (submission successful)
        if (result == true && mounted) {
          context.read<PanicButtonBloc>().add(
                const RefreshPanicButtonHistoryEvent(),
              );
        }
      },
      child: Container(
        margin: REdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border(
            left: BorderSide(
              color: statusColor,
              width: 4.w,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ID and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.formattedId,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              // Jenis Keadaan
              _buildInfoRow('Jenis Keadaan', item.incidentTypeName ?? '-'),
              8.verticalSpace,
              // Lokasi
              _buildInfoRow('Lokasi', item.areaName ?? '-'),
              8.verticalSpace,
              // Kejadian
              _buildInfoRow('Kejadian', item.description),
              8.verticalSpace,
              // Tindakan
              if (item.feedback != null && item.feedback!.isNotEmpty)
                _buildInfoRow('Tindakan', item.feedback!),
              if (item.feedback != null && item.feedback!.isNotEmpty) 8.verticalSpace,
              // Dibuat
              _buildInfoRow('dibuat', _formatDate(item.createDate)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(PanicButtonStatusColor statusColor) {
    switch (statusColor) {
      case PanicButtonStatusColor.red:
        return Colors.red;
      case PanicButtonStatusColor.orange:
        return Colors.orange;
      case PanicButtonStatusColor.blue:
        return Colors.blue[700]!;
      case PanicButtonStatusColor.grey:
        return Colors.grey;
    }
  }

  Color _getStatusTextColor(PanicButtonStatusColor statusColor) {
    switch (statusColor) {
      case PanicButtonStatusColor.red:
        return Colors.red;
      case PanicButtonStatusColor.orange:
        return Colors.orange;
      case PanicButtonStatusColor.blue:
        return Colors.blue[700]!;
      case PanicButtonStatusColor.grey:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final formatter = DateFormat('dd/MM/yyyy', 'id_ID');
    return formatter.format(date);
  }
}

