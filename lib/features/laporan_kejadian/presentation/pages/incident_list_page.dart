import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/utils/user_role_helper.dart';
import '../../../../core/constants/enums.dart';
import '../bloc/incident_bloc.dart';
import '../bloc/incident_event.dart';
import '../bloc/incident_state.dart';
import '../../domain/entities/incident_entity.dart';
import 'incident_report_form_page.dart';
import 'incident_detail_page.dart';

class IncidentListPage extends StatefulWidget {
  const IncidentListPage({super.key});

  @override
  State<IncidentListPage> createState() => _IncidentListPageState();
}

class _IncidentListPageState extends State<IncidentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;
  bool _isPengawas = false;

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with default 2 tabs first
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    
    // Load user role and update tab controller if needed
    _loadUserRole();
    
    // Load initial data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<IncidentBloc>().add(const LoadIncidentListEvent());
        context.read<IncidentBloc>().add(const LoadIncidentLocationsEvent());
        context.read<IncidentBloc>().add(const LoadIncidentTypesEvent());
      }
    });
  }

  Future<void> _loadUserRole() async {
    final role = await UserRoleHelper.getUserRole();
    final isPengawas = role == UserRole.pengawas;
    
    setState(() {
      _isPengawas = isPengawas;
    });
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging && mounted) {
      if (_tabController.index == 0) {
        context.read<IncidentBloc>().add(const LoadIncidentListEvent());
      } else {
        context.read<IncidentBloc>().add(const LoadMyTasksEvent());
      }
    }
  }

  void _onScroll() {
    if (_isBottom) {
      // Untuk pengawas, selalu load more incident list
      if (_isPengawas) {
        context.read<IncidentBloc>().add(const LoadMoreIncidentListEvent());
      } else {
        if (_tabController.index == 0) {
          context.read<IncidentBloc>().add(const LoadMoreIncidentListEvent());
        } else {
          context.read<IncidentBloc>().add(const LoadMoreMyTasksEvent());
        }
      }
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
      // Untuk pengawas, selalu search incident list
      if (_isPengawas) {
        context.read<IncidentBloc>().add(SearchIncidentListEvent(query));
      } else {
        if (_tabController.index == 0) {
          context.read<IncidentBloc>().add(SearchIncidentListEvent(query));
        } else {
          context.read<IncidentBloc>().add(SearchMyTasksEvent(query));
        }
      }
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
            'Insiden Kejadian',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.download, color: primaryColor, size: 24.r),
              onPressed: () {
                // TODO: Implement download functionality
              },
            ),
          ],
          bottom: _isPengawas
              ? null // Pengawas tidak punya tab bar
              : TabBar(
                  controller: _tabController,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'Daftar Insiden'),
                    Tab(text: 'Tugas Saya'),
                  ],
                ),
        ),
        body: SafeArea(
          child: BlocConsumer<IncidentBloc, IncidentState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Search and Filter Bar (tidak ditampilkan untuk pengawas)
                  if (!_isPengawas)
                    Container(
                      padding: REdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          // Search Bar
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: primaryColor),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Cari',
                                  hintStyle: TextStyle(
                                    color: primaryColor.withOpacity(0.6),
                                    fontSize: 14.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: primaryColor,
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
                              color: primaryColor,
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

                  // Tab View (untuk pengawas hanya tampilkan list semua)
                  Expanded(
                    child: _isPengawas
                        ? _buildIncidentListTab() // Pengawas hanya lihat semua insiden
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildIncidentListTab(),
                              _buildMyTasksTab(),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (newContext) => IncidentReportFormPage.wrapped(context),
              ),
            );
            if (result == true && mounted) {
              // Refresh list after creating incident
              // Untuk pengawas, selalu refresh incident list
              if (_isPengawas) {
                context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
              } else {
                if (_tabController.index == 0) {
                  context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
                } else {
                  context.read<IncidentBloc>().add(const RefreshMyTasksEvent());
                }
              }
            }
          },
          backgroundColor: primaryColor,
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            'Laporkan Insiden',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
    );
  }

  Widget _buildIncidentListTab() {
    return BlocBuilder<IncidentBloc, IncidentState>(
      // Remove buildWhen to ensure it always rebuilds on state changes
      builder: (context, state) {
        if (state.isLoading && state.incidentList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state.incidentList.isEmpty && !state.isLoading) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
            },
            color: primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64.r,
                        color: Colors.grey[400],
                      ),
                      16.verticalSpace,
                      Text(
                        'Tidak ada insiden',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (state.errorMessage != null) ...[
                        8.verticalSpace,
                        Padding(
                          padding: REdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
          },
          color: primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: REdgeInsets.all(16),
            itemCount: state.incidentList.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.incidentList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              final incident = state.incidentList[index];
              return _buildIncidentCard(incident);
            },
          ),
        );
      },
    );
  }

  Widget _buildMyTasksTab() {
    return BlocBuilder<IncidentBloc, IncidentState>(
      builder: (context, state) {
        
        if (state.isLoading && state.myTasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (state.myTasks.isEmpty) {
          return Center(
            child: Text(
              'Tidak ada tugas',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<IncidentBloc>().add(const RefreshMyTasksEvent());
          },
          color: primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: REdgeInsets.all(16),
            itemCount: state.myTasks.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.myTasks.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }

              final incident = state.myTasks[index];
              return _buildIncidentCard(incident);
            },
          ),
        );
      },
    );
  }

  Widget _buildIncidentCard(IncidentEntity incident) {
    final statusColor = _getStatusColor(incident.statusColor);
    final statusTextColor = _getStatusTextColor(incident.statusColor);
    // Untuk pengawas, selalu false (tidak ada tab "Tugas Saya")
    final isFromMyTasks = !_isPengawas && _tabController.index == 1;

    return InkWell(
      onTap: () {
        // Get bloc from parent context before navigation
        final bloc = context.read<IncidentBloc>();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: bloc,
              child: IncidentDetailPage(
                incident: incident, 
                isFromMyTasks: isFromMyTasks,
              ),
            ),
          ),
        ).then((result) {
          if (result == true && mounted) {
            // Refresh list after update
            // Untuk pengawas, selalu refresh incident list
            if (_isPengawas) {
              context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
            } else {
              if (_tabController.index == 0) {
                context.read<IncidentBloc>().add(const RefreshIncidentListEvent());
              } else {
                context.read<IncidentBloc>().add(const RefreshMyTasksEvent());
              }
            }
          }
        });
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
                    incident.formattedId,
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
                      incident.statusDisplayName,
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
              // Tipe Insiden
              _buildInfoRow('Tipe Insiden', incident.tipeInsidenDisplayName),
              8.verticalSpace,
              // Role Pelapor
              _buildInfoRow(
                'Role Pelapor',
                incident.reporterRole != null && incident.reporterRole!.isNotEmpty
                    ? UserRole.fromValue(incident.reporterRole!).displayName
                    : '-',
              ),
              8.verticalSpace,
              // Lokasi
              _buildInfoRow('Lokasi', incident.lokasiInsiden ?? '-'),
              8.verticalSpace,
              // Kejadian
              _buildInfoRow('Kejadian', incident.deskripsiInsiden ?? '-'),
              8.verticalSpace,
              // PIC
              _buildInfoRow('PIC', incident.pic ?? '-'),
              8.verticalSpace,
              // Dibuat
              _buildInfoRow(
                'dibuat',
                incident.createDate != null
                    ? _formatDate(incident.createDate!)
                    : '-',
              ),
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

  Color _getStatusColor(IncidentStatusColor statusColor) {
    switch (statusColor) {
      case IncidentStatusColor.red:
        return Colors.red;
      case IncidentStatusColor.orange:
        return Colors.orange;
      case IncidentStatusColor.yellow:
        return Colors.amber;
      case IncidentStatusColor.blue:
        return Colors.blue;
      case IncidentStatusColor.purple:
        return Colors.purple;
      case IncidentStatusColor.green:
        return Colors.green;
      case IncidentStatusColor.lightYellow:
        return Colors.yellow[300]!;
    }
  }

  Color _getStatusTextColor(IncidentStatusColor statusColor) {
    switch (statusColor) {
      case IncidentStatusColor.red:
        return Colors.red;
      case IncidentStatusColor.orange:
        return Colors.orange;
      case IncidentStatusColor.yellow:
        return Colors.amber[700]!;
      case IncidentStatusColor.blue:
        return Colors.blue;
      case IncidentStatusColor.purple:
        return Colors.purple;
      case IncidentStatusColor.green:
        return Colors.green;
      case IncidentStatusColor.lightYellow:
        return Colors.yellow[700]!;
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'id_ID');
    return formatter.format(date);
  }
}

