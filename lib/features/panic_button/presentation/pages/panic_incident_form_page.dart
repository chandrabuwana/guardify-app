import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../../../shared/widgets/app_scaffold.dart';
import '../bloc/panic_button_bloc.dart';
import '../bloc/panic_button_state.dart';

class PanicIncidentFormPage extends StatelessWidget {
  const PanicIncidentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PanicIncidentFormView();
  }
}

class _PanicIncidentFormView extends StatefulWidget {
  const _PanicIncidentFormView();

  @override
  State<_PanicIncidentFormView> createState() => _PanicIncidentFormViewState();
}

class _PanicIncidentFormViewState extends State<_PanicIncidentFormView> {
  final TextEditingController _kejadianController = TextEditingController();
  final TextEditingController _tindakanController = TextEditingController();
  String? _selectedLocation;

  // File attachments
  List<File> _kejadianFiles = [];
  List<File> _tindakanFiles = [];

  // Camera controller
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _kejadianController.dispose();
    _tindakanController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Panic Button'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: BlocBuilder<PanicButtonBloc, PanicButtonState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: REdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis keadaan darurat yang sesuai',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  24.verticalSpace,

                  // Lokasi Kejadian Dropdown
                  Text(
                    'Lokasi Kejadian',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: REdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE74C3C)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLocation,
                        hint: Text(
                          'Lokasi Kejadian ---',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                        ),
                        items: [
                          'Gedung A',
                          'Gedung B',
                          'Gedung C',
                          'Area Parkir',
                          'Kantin',
                          'Lainnya'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocation = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  24.verticalSpace,

                  // Kejadian field
                  Text(
                    'Kejadian',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE74C3C)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _kejadianController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Kejadian ---',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: REdgeInsets.all(12),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showImagePickerDialog(context, 'kejadian');
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[600],
                                size: 20.r,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showAttachmentDialog(context, 'kejadian');
                              },
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey[600],
                                size: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  // Display kejadian attachments
                  if (_kejadianFiles.isNotEmpty) ...[
                    8.verticalSpace,
                    _buildAttachmentsList('kejadian', _kejadianFiles),
                  ],
                  24.verticalSpace,

                  // Tindakan field
                  Text(
                    'Tindakan',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  8.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE74C3C)),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: TextField(
                      controller: _tindakanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tindakan ---',
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: REdgeInsets.all(12),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                _showImagePickerDialog(context, 'tindakan');
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[600],
                                size: 20.r,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showAttachmentDialog(context, 'tindakan');
                              },
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey[600],
                                size: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                  // Display tindakan attachments
                  if (_tindakanFiles.isNotEmpty) ...[
                    8.verticalSpace,
                    _buildAttachmentsList('tindakan', _tindakanFiles),
                  ],

                  60.verticalSpace,

                  // Bottom button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _isFormValid()
                          ? () {
                              Navigator.pushNamed(
                                  context, '/panic-confirmation');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid()
                            ? const Color(0xFFE74C3C)
                            : Colors.grey[300],
                        foregroundColor:
                            _isFormValid() ? Colors.white : Colors.grey[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'AKTIFKAN',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentsList(String fieldType, List<File> files) {
    return Container(
      padding: REdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'File terlampir ($fieldType):',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          8.verticalSpace,
          ...files.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            final fileName = file.path.split('/').last;
            final isImage = _isImageFile(fileName);

            return Container(
              margin: REdgeInsets.only(bottom: 8),
              padding: REdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    isImage ? Icons.image : _getFileIcon(fileName),
                    color: Colors.grey[600],
                    size: 20.r,
                  ),
                  8.horizontalSpace,
                  Expanded(
                    child: Text(
                      fileName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (fieldType == 'kejadian') {
                          _kejadianFiles.removeAt(index);
                        } else {
                          _tindakanFiles.removeAt(index);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[400],
                      size: 18.r,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  bool _isImageFile(String fileName) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = fileName.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }

  bool _isFormValid() {
    return _selectedLocation != null &&
        _kejadianController.text.isNotEmpty &&
        _tindakanController.text.isNotEmpty;
  }

  void _showImagePickerDialog(BuildContext context, String fieldType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih Sumber Gambar',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera(fieldType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(fieldType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttachmentDialog(BuildContext context, String fieldType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pilih File',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Dokumen'),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument(fieldType);
                },
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack),
                title: const Text('Audio'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAudio(fieldType);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromCamera(String fieldType) async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        _showErrorSnackBar('Akses kamera ditolak');
        return;
      }

      if (_cameras == null || _cameras!.isEmpty) {
        _showErrorSnackBar('Kamera tidak tersedia');
        return;
      }

      // Initialize camera controller
      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      // Navigate to camera screen
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _CameraScreen(
              cameraController: _cameraController!,
              fieldType: fieldType,
            ),
          ),
        );

        if (result != null && result is File) {
          setState(() {
            if (fieldType == 'kejadian') {
              _kejadianFiles.add(result);
            } else {
              _tindakanFiles.add(result);
            }
          });
          _showSuccessSnackBar('Gambar berhasil ditambahkan untuk $fieldType');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error mengambil gambar: $e');
    }
  }

  void _pickImageFromGallery(String fieldType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          if (fieldType == 'kejadian') {
            _kejadianFiles.add(file);
          } else {
            _tindakanFiles.add(file);
          }
        });
        _showSuccessSnackBar('Gambar berhasil ditambahkan untuk $fieldType');
      }
    } catch (e) {
      _showErrorSnackBar('Error memilih gambar: $e');
    }
  }

  void _pickDocument(String fieldType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          if (fieldType == 'kejadian') {
            _kejadianFiles.add(file);
          } else {
            _tindakanFiles.add(file);
          }
        });
        _showSuccessSnackBar('Dokumen berhasil ditambahkan untuk $fieldType');
      }
    } catch (e) {
      _showErrorSnackBar('Error memilih dokumen: $e');
    }
  }

  void _pickAudio(String fieldType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          if (fieldType == 'kejadian') {
            _kejadianFiles.add(file);
          } else {
            _tindakanFiles.add(file);
          }
        });
        _showSuccessSnackBar(
            'File audio berhasil ditambahkan untuk $fieldType');
      }
    } catch (e) {
      _showErrorSnackBar('Error memilih file audio: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE74C3C),
      ),
    );
  }
}

// Camera Screen Widget
class _CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  final String fieldType;

  const _CameraScreen({
    required this.cameraController,
    required this.fieldType,
  });

  @override
  State<_CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<_CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Ambil Foto - ${widget.fieldType}'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(widget.cameraController),
          ),
          Container(
            height: 100.h,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30.r,
                  ),
                ),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 30.r,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _switchCamera,
                  icon: Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: 30.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    try {
      final image = await widget.cameraController.takePicture();
      final file = File(image.path);
      if (mounted) {
        Navigator.pop(context, file);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error mengambil foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _switchCamera() async {
    // Implementation for switching camera would require getting available cameras
    // and reinitializing with different camera
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ganti kamera akan ditambahkan'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
