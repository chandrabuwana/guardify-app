import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';

/// Custom SearchBar dengan design yang konsisten untuk pencarian dokumen
///
/// SearchBar ini menyediakan:
/// - Input field dengan placeholder "Cari"
/// - Search icon di kiri dengan warna merah
/// - Clear button di kanan ketika ada text
/// - Border dan styling yang konsisten
class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    Key? key,
    this.placeholder = 'Cari',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.enabled = true,
    this.autofocus = false,
  }) : super(key: key);

  /// Placeholder text yang ditampilkan di search bar
  final String placeholder;

  /// Callback ketika text berubah
  final ValueChanged<String>? onChanged;

  /// Callback ketika user menekan enter/submit
  final ValueChanged<String>? onSubmitted;

  /// Callback ketika clear button ditekan
  final VoidCallback? onClear;

  /// Text controller untuk mengontrol input
  final TextEditingController? controller;

  /// Apakah search bar enabled atau disabled
  final bool enabled;

  /// Apakah auto focus ketika widget dibuat
  final bool autofocus;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: neutral30,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        onSubmitted: widget.onSubmitted,
        style: TS.bodyMedium.copyWith(
          color: neutral90,
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          hintStyle: TS.bodyMedium.copyWith(
            color: neutral50,
          ),
          prefixIcon: Padding(
            padding: REdgeInsets.only(left: 16, right: 12),
            child: Icon(
              Icons.search,
              color: primaryColor,
              size: 20.w,
            ),
          ),
          suffixIcon: _hasText
              ? Padding(
                  padding: REdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: neutral50,
                      size: 20.w,
                    ),
                    onPressed: widget.enabled ? _onClear : null,
                    splashRadius: 16.r,
                  ),
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: REdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

/// Factory methods untuk variasi SearchBar yang umum digunakan
extension CustomSearchBarFactory on CustomSearchBar {
  /// SearchBar dengan debounce untuk performance
  static Widget withDebounce({
    String placeholder = 'Cari',
    required ValueChanged<String> onChanged,
    Duration debounceDuration = const Duration(milliseconds: 500),
    TextEditingController? controller,
    bool enabled = true,
  }) {
    return _DebouncedSearchBar(
      placeholder: placeholder,
      onChanged: onChanged,
      debounceDuration: debounceDuration,
      controller: controller,
      enabled: enabled,
    );
  }
}

/// Internal widget untuk debounced search
class _DebouncedSearchBar extends StatefulWidget {
  const _DebouncedSearchBar({
    required this.placeholder,
    required this.onChanged,
    required this.debounceDuration,
    this.controller,
    required this.enabled,
  });

  final String placeholder;
  final ValueChanged<String> onChanged;
  final Duration debounceDuration;
  final TextEditingController? controller;
  final bool enabled;

  @override
  State<_DebouncedSearchBar> createState() => _DebouncedSearchBarState();
}

class _DebouncedSearchBarState extends State<_DebouncedSearchBar> {
  Timer? _debounceTimer;

  void _onTextChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged(text);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearchBar(
      placeholder: widget.placeholder,
      onChanged: _onTextChanged,
      controller: widget.controller,
      enabled: widget.enabled,
    );
  }
}
