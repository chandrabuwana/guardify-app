import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/design/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PhotoPickerField extends StatefulWidget {
  final String label;
  final List<String> photos;
  final Function(List<String>) onPhotosChanged;
  final String? errorText;
  final bool isRequired;
  final EdgeInsets margin;
  final bool multiple;
  final int maxPhotos;

  const PhotoPickerField({
    Key? key,
    required this.label,
    required this.photos,
    required this.onPhotosChanged,
    this.errorText,
    this.isRequired = false,
    this.margin = EdgeInsets.zero,
    this.multiple = true,
    this.maxPhotos = 5,
  }) : super(key: key);

  @override
  State<PhotoPickerField> createState() => _PhotoPickerFieldState();
}

class _PhotoPickerFieldState extends State<PhotoPickerField> {
  List<CameraDescription>? _cameras;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
    } catch (_) {}
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _ensureCapacityOrToast() async {
    if (widget.multiple && widget.photos.length >= widget.maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal ${widget.maxPhotos} foto'),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('capacity_reached');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      await _ensureCapacityOrToast();
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        final updatedPhotos = List<String>.from(widget.photos);
        if (widget.multiple) {
          updatedPhotos.add(result.files.single.path!);
        } else {
          updatedPhotos
            ..clear()
            ..add(result.files.single.path!);
        }
        widget.onPhotosChanged(updatedPhotos);
      }
    } catch (e) {
      if (e.toString().contains('capacity_reached')) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      await _ensureCapacityOrToast();
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Akses kamera ditolak'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_cameras == null || _cameras!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kamera tidak tersedia'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();

      if (!mounted) return;
      final file = await Navigator.push<File?>(
        context,
        MaterialPageRoute(
          builder: (context) => _CameraCaptureScreen(
            cameraController: _cameraController!,
          ),
        ),
      );

      if (file != null) {
        final updatedPhotos = List<String>.from(widget.photos);
        if (widget.multiple) {
          updatedPhotos.add(file.path);
        } else {
          updatedPhotos
            ..clear()
            ..add(file.path);
        }
        widget.onPhotosChanged(updatedPhotos);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<String>.from(widget.photos);
    updatedPhotos.removeAt(index);
    widget.onPhotosChanged(updatedPhotos);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  widget.label,
                  style: TS.labelLarge,
                ),
                if (widget.isRequired)
                  Text(
                    '*',
                    style: TS.bodyLarge.copyWith(color: Colors.red),
                  ),
              ],
            ),
            8.verticalSpace,
          ],

          // Photos Grid
          if (widget.photos.isNotEmpty) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 1,
              ),
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade200,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 24.sp,
                              color: Colors.grey.shade600,
                            ),
                            4.verticalSpace,
                            Text(
                              'Foto ${index + 1}',
                              style: TS.bodySmall.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: REdgeInsets.all(4),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            8.verticalSpace,
          ],

          // Add Photo Button
          if (!widget.multiple || widget.photos.length < widget.maxPhotos)
            GestureDetector(
              onTap: _showPhotoOptions,
              child: Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: widget.errorText != null
                        ? Colors.red
                        : Colors.grey.shade300,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 32.sp,
                      color: Colors.grey.shade600,
                    ),
                    4.verticalSpace,
                    Text(
                      widget.photos.isEmpty
                          ? 'Tambah Foto'
                          : 'Tambah Foto Lagi',
                      style: TS.bodyMedium.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (widget.multiple) ...[
                      2.verticalSpace,
                      Text(
                        '${widget.photos.length}/${widget.maxPhotos}',
                        style: TS.bodySmall.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          if (widget.errorText != null) ...[
            4.verticalSpace,
            Text(
              widget.errorText!,
              style: TS.bodySmall.copyWith(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}

class _CameraCaptureScreen extends StatefulWidget {
  final CameraController cameraController;
  const _CameraCaptureScreen({required this.cameraController});

  @override
  State<_CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<_CameraCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Ambil Foto'),
      ),
      body: Column(
        children: [
          Expanded(child: CameraPreview(widget.cameraController)),
          Container(
            height: 100.h,
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.white, size: 28.sp),
                ),
                GestureDetector(
                  onTap: _capture,
                  child: Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt, size: 30.sp),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _capture() async {
    try {
      final xfile = await widget.cameraController.takePicture();
      if (!mounted) return;
      Navigator.pop(context, File(xfile.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

