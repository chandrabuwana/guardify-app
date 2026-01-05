import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/security/security_manager.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/data/datasources/auth_remote_data_source.dart';
import '../../../auth/data/models/current_location_request_model.dart';
import '../../../auth/data/models/current_location_response_model.dart';
import '../../../patrol/data/models/area_list_api_response.dart' as patrol_models;
import '../../../patrol/data/models/route_detail_api_response.dart';

class EmployeeLocationTrackingPage extends StatefulWidget {
  const EmployeeLocationTrackingPage({super.key});

  @override
  State<EmployeeLocationTrackingPage> createState() => _EmployeeLocationTrackingPageState();
}

class _EmployeeLocationTrackingPageState extends State<EmployeeLocationTrackingPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  
  List<EmployeeLocationModel> _filteredLocations = [];
  List<patrol_models.AreaModel> _areas = [];
  String? _selectedAreaId;
  bool _isLoadingAreas = true;
  bool _isLoadingLocations = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDataTogether();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  /// Memuat data area/list dan CurrentLocation/employee secara bersamaan
  Future<void> _loadDataTogether() async {
    setState(() {
      _isLoadingAreas = true;
      _isLoadingLocations = true;
      _errorMessage = null;
    });

    try {
      final authRemoteDataSource = getIt<AuthRemoteDataSource>();
      final userId = await SecurityManager.readSecurely(AppConstants.userIdKey);
      
      if (userId == null || userId.isEmpty) {
        setState(() {
          _isLoadingAreas = false;
          _isLoadingLocations = false;
          _errorMessage = 'User ID tidak ditemukan';
        });
        return;
      }

      final searchQuery = _searchController.text.trim();
      
      // Prepare requests untuk Areas/list API
      final areaRequest = patrol_models.AreaListRequest(
        filter: [
          FilterModel(field: '', search: ''),
        ],
        sort: SortModel(field: '', type: 0), // 0 = ascending
        start: 0,
        length: 0, // 0 untuk get all areas
      );

      // Selalu panggil kedua API secara parallel untuk performa lebih baik
      // Gunakan _selectedAreaId yang sudah ada, atau null jika search aktif
      String? areaIdForFilter = searchQuery.isEmpty ? _selectedAreaId : null;
      
      final locationRequest = CurrentLocationRequestModel(
        idUser: userId,
        search: searchQuery,
        idAreas: areaIdForFilter,
      );
      
      print('📍 [LocationTracking] Calling both APIs in parallel...');
      print('📍   idUser: $userId');
      print('📍   search: "$searchQuery"');
      print('📍   idAreas: $areaIdForFilter');
      
      // Panggil kedua API secara parallel (selalu parallel untuk performa lebih baik)
      final areaResponseFuture = authRemoteDataSource.getAreaList(areaRequest);
      final locationResponseFuture = authRemoteDataSource.getEmployeeLocations(locationRequest);

      // Wait for both responses
      print('📍 [LocationTracking] Waiting for API responses...');
      try {
        final results = await Future.wait([
          areaResponseFuture,
          locationResponseFuture,
        ]);
        
        final areaResponse = results[0] as patrol_models.AreaListResponse;
        final locationResponse = results[1] as CurrentLocationResponseModel;
        
        print('📍 [LocationTracking] API responses received');
        print('📍   Areas API - Succeeded: ${areaResponse.succeeded}, Count: ${areaResponse.list.length}');
        print('📍   Locations API - Succeeded: ${locationResponse.succeeded}, Count: ${locationResponse.list.length}');
        
        // Process responses dan update state sekali
        List<patrol_models.AreaModel> allAreas = [];
        List<EmployeeLocationModel> validLocations = [];
        String? errorMsg;
        String? newSelectedAreaId = _selectedAreaId;

        // Process area response
        if (areaResponse.succeeded) {
          allAreas = areaResponse.list;
          
          // Set area pertama sebagai default jika belum ada yang dipilih dan tidak ada search
          if (searchQuery.isEmpty && newSelectedAreaId == null && allAreas.isNotEmpty) {
            newSelectedAreaId = allAreas.first.id;
            print('📍 [LocationTracking] Auto-selected first area: ${allAreas.first.name} (ID: ${allAreas.first.id})');
          }
        } else {
          print('⚠️ [LocationTracking] Areas API failed: ${areaResponse.message}');
        }

        // Process location response
        if (locationResponse.succeeded) {
          // Filter out invalid locations (removed print statements from filter for performance)
          validLocations = locationResponse.list.where((emp) {
            final lat = emp.latitude;
            final lng = emp.longitude;
            return lat != 0.0 && lng != 0.0 && 
                   lat >= -90 && lat <= 90 && 
                   lng >= -180 && lng <= 180;
          }).toList();
          
          print('📍 [LocationTracking] Valid employee locations: ${validLocations.length}');
          
          // Jika ada search query dan ada data employee, pindah map ke area dari employee pertama
          if (searchQuery.isNotEmpty && validLocations.isNotEmpty && allAreas.isNotEmpty) {
            final firstEmployee = validLocations.first;
            String? employeeAreaId = firstEmployee.idAreas.isNotEmpty 
                ? firstEmployee.idAreas 
                : firstEmployee.areas?.id;
            
            if (employeeAreaId != null && employeeAreaId.isNotEmpty) {
              try {
                final matchingArea = allAreas.firstWhere((area) => area.id == employeeAreaId);
                newSelectedAreaId = employeeAreaId;
                print('📍 [LocationTracking] Search result: Moving map to employee area: ${matchingArea.name} (ID: $employeeAreaId)');
              } catch (e) {
                print('⚠️ [LocationTracking] Area from employee not found in areas list: $employeeAreaId');
              }
            }
          }
        } else {
          errorMsg = locationResponse.message.isNotEmpty 
              ? locationResponse.message 
              : 'Tidak ada lokasi ditemukan';
          print('⚠️ [LocationTracking] Locations API failed: $errorMsg');
        }

        // Update state sekali untuk mengurangi rebuilds
        if (mounted) {
          setState(() {
            _areas = allAreas;
            _filteredLocations = validLocations;
            _selectedAreaId = newSelectedAreaId;
            _isLoadingAreas = false;
            _isLoadingLocations = false;
            _errorMessage = errorMsg;
          });

          // Zoom ke area yang dipilih setelah areas dimuat
          if (allAreas.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _zoomToSelectedArea();
              }
            });
          }
        }
      } catch (e, stackTrace) {
        print('❌ [LocationTracking] Error in Future.wait: $e');
        print('❌ Stack trace: $stackTrace');
        if (mounted) {
          setState(() {
            _areas = [];
            _filteredLocations = [];
            _isLoadingAreas = false;
            _isLoadingLocations = false;
            _errorMessage = 'Gagal memuat data: ${e.toString()}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _areas = [];
          _filteredLocations = [];
          _isLoadingAreas = false;
          _isLoadingLocations = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _loadEmployeeLocations() async {
    // This method now calls _loadDataTogether to reload both APIs together
    await _loadDataTogether();
  }

  /// Mendapatkan center map berdasarkan area yang dipilih
  LatLng _getInitialMapCenter() {
    // Pastikan selalu menggunakan area pertama jika belum ada yang dipilih
    // Ini untuk menghindari map yang rancu saat pertama kali dibuka
    String? areaIdToUse = _selectedAreaId;
    if (areaIdToUse == null && _areas.isNotEmpty) {
      areaIdToUse = _areas.first.id;
      print('📍 [LocationTracking] No area selected, using first area: ${_areas.first.name} (ID: ${_areas.first.id})');
    }
    
    if (areaIdToUse != null && _areas.isNotEmpty) {
      final selectedArea = _areas.firstWhere(
        (area) => area.id == areaIdToUse,
        orElse: () => _areas.first,
      );
      if (selectedArea.latitude != null && selectedArea.longitude != null) {
        // Normalisasi koordinat
        var lat = selectedArea.latitude!;
        var lng = selectedArea.longitude!;
        
        // Normalisasi latitude
        if (lat < -90) lat = -90;
        if (lat > 90) lat = 90;
        
        // Normalisasi longitude
        // Jika longitude > 180, kemungkinan data salah atau perlu interpretasi berbeda
        // Untuk Indonesia, longitude biasanya 95-141
        // Jika longitude > 141, mungkin perlu dikurangi 360
        if (lng > 180) {
          // Coba normalisasi dengan mengurangi 360
          lng = lng - 360;
          print('📍 [LocationTracking] Longitude > 180 detected, normalizing: ${selectedArea.longitude} -> $lng');
        }
        
        lng = ((lng + 180) % 360) - 180;
        if (lng < -180) lng = -180;
        if (lng > 180) lng = 180;
        
        // Validasi final
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          print('📍 [LocationTracking] Initial center from area: ${selectedArea.name} ($lat, $lng)');
          return LatLng(lat, lng);
        } else {
          print('⚠️ [LocationTracking] Invalid coordinates after normalization: $lat, $lng');
        }
      }
    }
    
    // Jika tidak ada area yang dipilih, gunakan area pertama
    if (_areas.isNotEmpty) {
      final firstArea = _areas.first;
      if (firstArea.latitude != null && firstArea.longitude != null) {
        // Normalisasi koordinat
        var lat = firstArea.latitude!;
        var lng = firstArea.longitude!;
        
        // Normalisasi
        if (lat < -90) lat = -90;
        if (lat > 90) lat = 90;
        
        // Normalisasi longitude
        if (lng > 180) {
          lng = lng - 360;
        }
        lng = ((lng + 180) % 360) - 180;
        if (lng < -180) lng = -180;
        if (lng > 180) lng = 180;
        
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          print('📍 [LocationTracking] Initial center from first area: $lat, $lng');
          return LatLng(lat, lng);
        }
      }
    }
    
    // Jika tidak ada area atau koordinat invalid, gunakan area pertama yang valid
    // atau tunggu sampai area dimuat
    if (_areas.isNotEmpty) {
      // Coba cari area manapun yang memiliki koordinat valid
      for (var area in _areas) {
        if (area.latitude != null && area.longitude != null) {
          var lat = area.latitude!;
          var lng = area.longitude!;
          
          // Normalisasi
          if (lat < -90) lat = -90;
          if (lat > 90) lat = 90;
          if (lng > 180) lng = lng - 360;
          lng = ((lng + 180) % 360) - 180;
          if (lng < -180) lng = -180;
          if (lng > 180) lng = 180;
          
          if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
            print('📍 [LocationTracking] Using first valid area: ${area.name} ($lat, $lng)');
            return LatLng(lat, lng);
          }
        }
      }
    }
    
    // Jika benar-benar tidak ada area valid, return koordinat default (akan diganti setelah area dimuat)
    print('⚠️ [LocationTracking] No valid area found, using temporary center');
    return const LatLng(0.0, 0.0);
  }

  void _onSearchChanged(String value) {
    // Debounce search - reload after user stops typing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        _loadDataTogether();
      }
    });
  }

  void _onAreaSelected(String? areaId) {
    setState(() {
      _selectedAreaId = areaId;
    });
    _loadDataTogether();
    // Zoom ke area yang dipilih setelah data dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _zoomToSelectedArea();
    });
  }

  /// Zoom map ke area yang dipilih berdasarkan lat/long dari area
  void _zoomToSelectedArea() {
    // Cek apakah areas sudah dimuat
    if (_areas.isEmpty) {
      print('⚠️ [LocationTracking] No areas available for zoom');
      return;
    }

    // Cari area yang dipilih
    patrol_models.AreaModel? selectedArea;
    
    if (_selectedAreaId != null) {
      try {
        selectedArea = _areas.firstWhere(
          (area) => area.id == _selectedAreaId,
        );
      } catch (e) {
        print('⚠️ [LocationTracking] Selected area not found: $_selectedAreaId, error: $e');
        // Gunakan area pertama sebagai fallback
        if (_areas.isNotEmpty) {
          selectedArea = _areas.first;
        }
      }
    } else {
      // Jika tidak ada area yang dipilih, gunakan area pertama
      if (_areas.isNotEmpty) {
        selectedArea = _areas.first;
        print('📍 [LocationTracking] No area selected, using first area: ${selectedArea.name}');
      }
    }

    // Cek apakah selectedArea tidak null sebelum digunakan
    if (selectedArea == null) {
      print('⚠️ [LocationTracking] No area available for zoom');
      return;
    }

    if (selectedArea.latitude != null && selectedArea.longitude != null) {
      // Normalisasi koordinat
      var lat = selectedArea.latitude!;
      var lng = selectedArea.longitude!;
      
      // Normalisasi
      if (lat < -90) lat = -90;
      if (lat > 90) lat = 90;
      
      // Normalisasi longitude
      if (lng > 180) {
        lng = lng - 360;
        print('📍 [LocationTracking] Longitude > 180 detected in zoom, normalizing: ${selectedArea.longitude} -> $lng');
      }
      
      lng = ((lng + 180) % 360) - 180;
      if (lng < -180) lng = -180;
      if (lng > 180) lng = 180;
      
      // Validasi koordinat
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        print('⚠️ [LocationTracking] Invalid coordinates for area ${selectedArea.name}: $lat, $lng');
        return;
      }
      
      // Gunakan radius untuk menentukan zoom level (dikurangi agar marker employee lebih terlihat)
      double zoom = 11.0;
      if (selectedArea.radius != null) {
        // Radius dalam meter, konversi ke zoom level
        final radiusKm = selectedArea.radius! / 1000;
        if (radiusKm > 10) {
          zoom = 9.0;
        } else if (radiusKm > 5) {
          zoom = 10.0;
        } else if (radiusKm > 1) {
          zoom = 10.5;
        } else {
          zoom = 11.0;
        }
      }

      print('📍 [LocationTracking] Zooming to area: ${selectedArea.name}');
      print('📍   Latitude: $lat, Longitude: $lng');
      print('📍   Radius: ${selectedArea.radius}, Zoom: $zoom');

      try {
        _mapController.move(
          LatLng(lat, lng),
          zoom,
        );
      } catch (e) {
        print('❌ [LocationTracking] Error moving map: $e');
      }
    }
  }

  void _showEmployeeDetail(EmployeeLocationModel employee) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: REdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 30.sp, color: Colors.grey[600]),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.user?.fullname ?? 'Unknown',
                        style: TS.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      4.verticalSpace,
                      if (employee.user?.noNrp != null)
                        Text(
                          'NRP: ${employee.user!.noNrp}',
                          style: TS.bodySmall.copyWith(color: Colors.grey[600]),
                        ),
                      if (employee.user?.jabatan != null)
                        Text(
                          employee.user!.jabatan,
                          style: TS.bodySmall.copyWith(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            24.verticalSpace,
            if (employee.areas?.name != null && employee.areas!.name.isNotEmpty)
              _buildDetailRow('Area', employee.areas!.name),
            _buildDetailRow('Latitude', employee.latitude.toStringAsFixed(6)),
            _buildDetailRow('Longitude', employee.longitude.toStringAsFixed(6)),
            if (employee.updateDate.isNotEmpty)
              _buildDetailRow('Terakhir Update', employee.updateDate),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: REdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TS.bodyMedium.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TS.bodyMedium.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Lacak Lokasi Anggota',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: REdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama anggota',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _searchController.clear();
                          _loadEmployeeLocations();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: _onSearchChanged,
              onSubmitted: (_) => _loadEmployeeLocations(),
            ),
          ),
          
          // Area Filter Chips (Horizontal Scrollable)
          SizedBox(
            height: 50.h,
            child: _isLoadingAreas
                ? Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    ),
                  )
                : _areas.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada area ditemukan',
                          style: TS.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        padding: REdgeInsets.symmetric(horizontal: 16),
                        children: _areas.map((area) {
                          final areaName = area.name ?? 'Unknown';
                          return Padding(
                            padding: REdgeInsets.only(right: 8),
                            child: _buildAreaChip(
                              areaName,
                              area.id,
                            ),
                          );
                        }).toList(),
                      ),
          ),
          
          16.verticalSpace,
          
          // Map
          Expanded(
            child: Container(
              margin: REdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    FlutterMap(
                      key: ValueKey('map_${_selectedAreaId ?? 'default'}_${_areas.length}'),
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _getInitialMapCenter(),
                        initialZoom: 11.0,
                        minZoom: 8.0,
                        maxZoom: 18.0,
                        onMapReady: () {
                          // Zoom ke area setelah map ready
                          if (_selectedAreaId != null || _areas.isNotEmpty) {
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted) {
                                _zoomToSelectedArea();
                              }
                            });
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.guardify.app',
                          maxZoom: 19,
                          tileProvider: NetworkTileProvider(),
                          // Error handling: Tile errors are expected when offline/no connection
                          // FlutterMap handles these gracefully by showing empty tiles
                          errorTileCallback: (tile, error, stackTrace) {
                            // Silently handle tile errors - this is expected behavior when offline
                          },
                        ),
                        // Marker untuk employee jika ada
                        if (_filteredLocations.isNotEmpty)
                          MarkerLayer(
                            markers: _filteredLocations.map((employee) {
                              // Pastikan menggunakan koordinat dari API
                              final lat = employee.latitude;
                              final lng = employee.longitude;
                              
                              return Marker(
                                point: LatLng(
                                  lat,
                                  lng,
                                ),
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () => _showEmployeeDetail(employee),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Outer circle
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Inner circle with icon
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                    
                    if (_isLoadingLocations)
                      Container(
                        color: Colors.white.withOpacity(0.8),
                        child: Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      ),
                    
                    if (!_isLoadingLocations && _filteredLocations.isEmpty)
                      Container(
                        color: Colors.white.withOpacity(0.9),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64.sp,
                                color: Colors.grey[400],
                              ),
                              16.verticalSpace,
                              Text(
                                _errorMessage ?? 'Tidak ada lokasi ditemukan',
                                style: TS.bodyMedium.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Floating action button untuk zoom ke area yang dipilih
                    if (_selectedAreaId != null)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: _zoomToSelectedArea,
                          backgroundColor: primaryColor,
                          child: Icon(Icons.my_location, color: Colors.white),
                          mini: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          16.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildAreaChip(String label, String? areaId) {
    final isSelected = _selectedAreaId == areaId;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        // Tidak bisa unselect, hanya bisa pilih area lain
        if (!isSelected && areaId != null) {
          _onAreaSelected(areaId);
        }
      },
      selectedColor: primaryColor.withOpacity(0.2),
      checkmarkColor: primaryColor,
      labelStyle: TS.bodyMedium.copyWith(
        color: isSelected ? primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}

