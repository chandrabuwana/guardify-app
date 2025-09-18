import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/widgets/TextInput/input_primary.dart';

/// Example usage of the improved InputPrimary widget
class InputPrimaryExample extends StatefulWidget {
  const InputPrimaryExample({super.key});

  @override
  State<InputPrimaryExample> createState() => _InputPrimaryExampleState();
}

class _InputPrimaryExampleState extends State<InputPrimaryExample> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _obscurePassword = true;
  String? _nameError;
  String? _emailError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InputPrimary Examples'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input Examples',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            20.verticalSpace,

            // 1. Basic Required Input
            InputPrimary(
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap Anda',
              controller: _nameController,
              isRequired: true,
              validation: _validateName,
              prefixIcon: const Icon(Icons.person),
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {
                  _nameError = _validateName(value);
                });
              },
              errorMessage: _nameError,
            ),
            16.verticalSpace,

            // 2. Email Input with Custom Style
            InputPrimary(
              label: 'Email',
              hint: 'contoh@email.com',
              controller: _emailController,
              isRequired: true,
              validation: _validateEmail,
              prefixIcon: const Icon(Icons.email),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              focusedBorderColor: Colors.blue,
              borderRadius: 12,
              onChanged: (value) {
                setState(() {
                  _emailError = _validateEmail(value);
                });
              },
              errorMessage: _emailError,
            ),
            16.verticalSpace,

            // 3. Phone Input with Formatter
            InputPrimary(
              label: 'Nomor Telepon',
              hint: '0812-3456-7890',
              controller: _phoneController,
              isOptional: true,
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              maxLength: 15,
            ),
            16.verticalSpace,

            // 4. Password Input
            InputPrimary(
              label: 'Kata Sandi',
              hint: 'Masukkan kata sandi',
              controller: _passwordController,
              isRequired: true,
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kata sandi tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Kata sandi minimal 6 karakter';
                }
                return null;
              },
              borderRadius: 8,
              focusedBorderWidth: 2,
            ),
            16.verticalSpace,

            // 5. Multiline Text Input
            InputPrimary(
              label: 'Deskripsi',
              hint: 'Tuliskan deskripsi di sini...',
              controller: _descriptionController,
              maxLines: 4,
              minLines: 3,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              isOptional: true,
              optionalText: 'Opsional',
              optionalTextStyle: TextStyle(
                color: Colors.grey,
                fontSize: 12.sp,
              ),
            ),
            16.verticalSpace,

            // 6. Line Style Input
            InputPrimary(
              label: 'Input dengan Garis',
              hint: 'Style garis bawah',
              inputShape: TextFieldShape.line,
              focusedBorderColor: Colors.green,
              focusedBorderWidth: 3,
            ),
            16.verticalSpace,

            // 7. Disabled Input
            InputPrimary(
              label: 'Input Disabled',
              hint: 'Tidak dapat diedit',
              enable: false,
              disabledBorderColor: Colors.grey.shade400,
              color: Colors.grey.shade100,
            ),
            16.verticalSpace,

            // 8. Custom Border Colors
            InputPrimary(
              label: 'Input dengan Border Custom',
              hint: 'Border warna custom',
              outlineColor: Colors.purple.shade200,
              focusedBorderColor: Colors.purple,
              errorBorderColor: Colors.red.shade600,
              borderRadius: 16,
              borderWidth: 2,
              focusedBorderWidth: 3,
            ),
            32.verticalSpace,

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validate all fields and show snackbar
                  bool isValid = true;
                  String message = 'Form valid!';

                  if (_validateName(_nameController.text) != null) {
                    isValid = false;
                    message = 'Nama tidak valid';
                  } else if (_validateEmail(_emailController.text) != null) {
                    isValid = false;
                    message = 'Email tidak valid';
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: isValid ? Colors.green : Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit Form',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
