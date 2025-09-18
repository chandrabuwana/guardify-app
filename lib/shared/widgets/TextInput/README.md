# InputPrimary Widget - Improved Base Input Component

## Overview
`InputPrimary` adalah widget input yang telah diperbaiki dan ditingkatkan sebagai komponen dasar untuk form input dalam aplikasi Guardify. Widget ini menyediakan berbagai fitur dan kustomisasi yang diperlukan untuk membuat form yang konsisten dan user-friendly.

## Perbaikan yang Dilakukan

### 1. **Struktur Widget**
- Diubah dari `StatelessWidget` menjadi `StatefulWidget` untuk mengelola state focus
- Ditambahkan FocusNode management untuk kontrol focus yang lebih baik

### 2. **Perbaikan Bug**
- ✅ Fixed typo: `optitonalText` → `optionalText`
- ✅ Fixed typo: `obsecureText` → `obscureText`
- ✅ Menambahkan missing imports untuk colors, styles, dan utilities
- ✅ Membuat AppUtils class yang sebelumnya tidak ada

### 3. **Fitur Baru**
- **Border State Management**: Border yang berubah sesuai state (normal, focus, error, disabled)
- **Custom Border Colors**: Dapat mengatur warna border untuk setiap state
- **Focus Management**: Automatic focus handling dengan visual feedback
- **Enhanced Validation**: Error handling yang lebih baik
- **Flexible Input Types**: Support untuk multiline, password, dan berbagai input type
- **Additional Callbacks**: `onFieldSubmitted`, `onEditingComplete`
- **Accessibility Features**: Autofill hints, restoration ID
- **Counter Management**: Custom counter atau hide counter

### 4. **Properti Baru**
```dart
// Border customization
final Color? focusedBorderColor;
final Color? errorBorderColor;
final Color? disabledBorderColor;
final double borderWidth;
final double focusedBorderWidth;

// Enhanced functionality
final int? minLines;
final bool autofocus;
final bool expands;
final FocusNode? focusNode;
final ScrollController? scrollController;
final bool enableInteractiveSelection;
final Function(String)? onFieldSubmitted;
final Function()? onEditingComplete;

// Accessibility
final Iterable<String>? autofillHints;
final String? restorationId;
final Widget? Function(...)? buildCounter;
```

## Penggunaan

### Basic Input
```dart
InputPrimary(
  label: 'Nama Lengkap',
  hint: 'Masukkan nama lengkap',
  controller: nameController,
  isRequired: true,
  validation: (value) => value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
)
```

### Password Input
```dart
InputPrimary(
  label: 'Password',
  hint: 'Masukkan password',
  controller: passwordController,
  obscureText: true,
  isRequired: true,
  prefixIcon: Icon(Icons.lock),
  suffixIcon: IconButton(
    icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
    onPressed: () => setState(() => showPassword = !showPassword),
  ),
)
```

### Multiline Input
```dart
InputPrimary(
  label: 'Deskripsi',
  hint: 'Masukkan deskripsi',
  controller: descriptionController,
  maxLines: 4,
  minLines: 2,
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
)
```

### Custom Styling
```dart
InputPrimary(
  label: 'Email',
  hint: 'example@email.com',
  controller: emailController,
  focusedBorderColor: Colors.blue,
  errorBorderColor: Colors.red,
  borderRadius: 12,
  borderWidth: 1,
  focusedBorderWidth: 2,
)
```

### Line Style Input
```dart
InputPrimary(
  label: 'Input Line Style',
  hint: 'Garis bawah',
  inputShape: TextFieldShape.line,
  focusedBorderColor: Colors.green,
)
```

## Keunggulan

### 1. **Konsistensi**
- Design yang seragam di seluruh aplikasi
- State management yang terprediksi
- Color scheme yang mengikuti brand guideline

### 2. **User Experience**
- Visual feedback yang jelas saat focus
- Error handling yang informatif
- Smooth animations dan transitions

### 3. **Developer Experience**
- API yang intuitive dan lengkap
- Easy customization
- Type-safe dengan proper validation

### 4. **Accessibility**
- Screen reader support
- Keyboard navigation
- High contrast support

### 5. **Performance**
- Efficient state management
- Minimal rebuilds
- Proper dispose handling

## State Management

Widget ini mengelola beberapa state internal:
- **Focus State**: Mengubah border color dan width saat focus
- **Error State**: Menampilkan error message dan mengubah border color
- **Disabled State**: Visual feedback untuk input yang disabled
- **Validation State**: Real-time validation dengan error display

## Best Practices

1. **Selalu gunakan controller** untuk mengakses dan mengontrol input value
2. **Tambahkan validation** untuk input yang memerlukan validasi
3. **Gunakan proper keyboard type** sesuai jenis input (email, phone, number)
4. **Tambahkan hint text** yang descriptive untuk user guidance
5. **Gunakan isRequired** untuk field yang wajib diisi
6. **Manage focus dengan FocusNode** untuk navigasi form yang smooth

## Examples

Lihat file `lib/examples/input_primary_example.dart` untuk contoh penggunaan lengkap yang mencakup:
- Basic input dengan validation
- Password input dengan show/hide
- Multiline text input
- Custom styling
- Different input shapes
- Disabled state
- Various keyboard types

## Migration dari Versi Lama

Jika menggunakan versi lama InputPrimary:

1. Ganti `optitonalText` → `optionalText`
2. Ganti `obsecureText` → `obscureText`
3. Tambahkan import yang diperlukan:
   ```dart
   import '../../../core/design/colors.dart';
   import '../../../core/design/styles.dart';
   import '../../../core/utils/app_utils.dart';
   ```

## Troubleshooting

### Common Issues:
1. **Import errors**: Pastikan semua import path sudah benar
2. **Color constants not found**: Import colors.dart
3. **TS styles not found**: Import styles.dart
4. **AppUtils not found**: Import app_utils.dart atau buat class AppUtils

Widget ini siap digunakan sebagai base input component yang robust dan fleksibel untuk semua kebutuhan form input dalam aplikasi Guardify.
