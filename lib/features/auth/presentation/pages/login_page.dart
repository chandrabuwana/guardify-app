import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/TextInput/input_primary.dart';
import '../../../../shared/widgets/Buttons/ui_button.dart';
import '../../../../core/design/colors.dart';
import '../../../../core/design/styles.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nrpController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _nrpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _nrpController.text, // Using NRP as identifier
              password: _passwordController.text,
            ),
          );
    }
  }

  void _onForgotPasswordPressed() {
    Navigator.pushNamed(context, '/reset-password');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state.status == AuthStatus.error) {
            _showMessage(state.errorMessage ?? 'Login gagal');
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                primaryColor,
                Colors.white,
              ],
              stops: [0.4, 0.4],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                  child: Stack(
                children: [
                  Container(
                    height: ScreenUtils.halfHeight,
                    color: primaryColor,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        // Top section with logo and title
                        30.verticalSpace,

                        // Shield logo
                        Container(
                          width: 80.w,
                          height: 80.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: const BoxDecoration(
                            // color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/images/shield_logo.svg',
                          ),
                        ),

                        // SizedBox(height: 40.h),

                        // Title
                        Text(
                          'Log in to your\nAccount',
                          textAlign: TextAlign.center,
                          style: TS.headlineLarge.copyWith(
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),

                        16.verticalSpace,

                        // Subtitle
                        Text(
                          'Enter your NRP and password to log in',
                          textAlign: TextAlign.center,
                          style: TS.bodyLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        30.verticalSpace,

                        // Form Section
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 32.h),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NRP Field using InputPrimary
                                InputPrimary(
                                  label: 'NRP',
                                  hint: '',
                                  controller: _nrpController,
                                  isRequired: true,
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'NRP tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                  borderRadius: 12,
                                  color: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 8.h,
                                  ),
                                ),

                                24.verticalSpace,

                                // Password Field using InputPrimary
                                InputPrimary(
                                  label: 'Password',
                                  hint: '',
                                  controller: _passwordController,
                                  isRequired: true,
                                  obscureText: !_isPasswordVisible,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: neutral50,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  validation: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  borderRadius: 12,
                                  color: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                    vertical: 8.h,
                                  ),
                                ),

                                20.verticalSpace,

                                // Remember me and Forgot password row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          activeColor: primaryColor,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        Text(
                                          'Remember me',
                                          style: TS.bodyMedium.copyWith(
                                            color: neutral70,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: _onForgotPasswordPressed,
                                      child: Text(
                                        'Forgot Password ?',
                                        style: TS.bodyMedium.copyWith(
                                          color: const Color(0xFF4A90E2),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                30.verticalSpace,

                                // Login Button using UIButton
                                BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    return UIButton(
                                      text: 'Log In',
                                      fullWidth: true,
                                      size: UIButtonSize.medium,
                                      variant: UIButtonVariant.primary,
                                      isLoading: state.isLoading,
                                      onPressed: state.isLoading
                                          ? null
                                          : _onLoginPressed,
                                      borderRadius: 12,
                                    );
                                  },
                                ),

                                40.verticalSpace,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
