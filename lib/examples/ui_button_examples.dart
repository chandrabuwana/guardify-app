import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/widgets/Buttons/ui_button.dart';
import '../shared/widgets/app_scaffold.dart';

/// Contoh penggunaan UIButton untuk berbagai skenario dalam aplikasi
class UIButtonExamples extends StatefulWidget {
  const UIButtonExamples({super.key});

  @override
  State<UIButtonExamples> createState() => _UIButtonExamplesState();
}

class _UIButtonExamplesState extends State<UIButtonExamples> {
  bool isLoading = false;
  bool isEnabled = true;

  void _simulateLoading() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('UIButton Examples'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      child: Padding(
        padding: REdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Button Types',
              [
                _buildExample(
                  'Filled Button (Default)',
                  UIButton(
                    text: 'Filled Button',
                    onPressed: () => _showSnackbar('Filled button pressed'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Outline Button',
                  UIButton(
                    text: 'Outline Button',
                    buttonType: UIButtonType.outline,
                    onPressed: () => _showSnackbar('Outline button pressed'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Text Button',
                  UIButton(
                    text: 'Text Button',
                    buttonType: UIButtonType.text,
                    onPressed: () => _showSnackbar('Text button pressed'),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'Button Sizes',
              [
                _buildExample(
                  'Small Button',
                  UIButton(
                    text: 'Small',
                    size: UIButtonSize.small,
                    onPressed: () => _showSnackbar('Small button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Medium Button (Default)',
                  UIButton(
                    text: 'Medium',
                    size: UIButtonSize.medium,
                    onPressed: () => _showSnackbar('Medium button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Large Button',
                  UIButton(
                    text: 'Large',
                    size: UIButtonSize.large,
                    onPressed: () => _showSnackbar('Large button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Extra Large Button',
                  UIButton(
                    text: 'Extra Large',
                    size: UIButtonSize.extraLarge,
                    onPressed: () => _showSnackbar('Extra large button'),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'Color Variants',
              [
                _buildExample(
                  'Primary (Default)',
                  UIButton(
                    text: 'Primary',
                    variant: UIButtonVariant.primary,
                    onPressed: () => _showSnackbar('Primary variant'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Success',
                  UIButton(
                    text: 'Success',
                    variant: UIButtonVariant.success,
                    onPressed: () => _showSnackbar('Success variant'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Error/Danger',
                  UIButton(
                    text: 'Error',
                    variant: UIButtonVariant.error,
                    onPressed: () => _showSnackbar('Error variant'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Warning',
                  UIButton(
                    text: 'Warning',
                    variant: UIButtonVariant.warning,
                    onPressed: () => _showSnackbar('Warning variant'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Info',
                  UIButton(
                    text: 'Info',
                    variant: UIButtonVariant.info,
                    onPressed: () => _showSnackbar('Info variant'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Neutral',
                  UIButton(
                    text: 'Neutral',
                    variant: UIButtonVariant.neutral,
                    onPressed: () => _showSnackbar('Neutral variant'),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'Loading & States',
              [
                _buildExample(
                  'Loading Button',
                  UIButton(
                    text: 'Loading...',
                    isLoading: isLoading,
                    onPressed: _simulateLoading,
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Disabled Button',
                  UIButton(
                    text: 'Disabled',
                    enable: false,
                    onPressed: () {},
                  ),
                ),
                8.verticalSpace,
                Row(
                  children: [
                    Text('Enable buttons: '),
                    Switch(
                      value: isEnabled,
                      onChanged: (value) => setState(() => isEnabled = value),
                    ),
                  ],
                ),
                8.verticalSpace,
                _buildExample(
                  'Toggle Enabled',
                  UIButton(
                    text: isEnabled ? 'Enabled' : 'Disabled',
                    enable: isEnabled,
                    onPressed: isEnabled
                        ? () => _showSnackbar('Button enabled and pressed')
                        : null,
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'With Icons',
              [
                _buildExample(
                  'Icon Prefix',
                  UIButton(
                    text: 'Share',
                    icon:
                        const Icon(Icons.share, size: 18, color: Colors.white),
                    onPressed: () => _showSnackbar('Share button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Icon Suffix',
                  UIButton(
                    text: 'Next',
                    suffixIcon: const Icon(Icons.arrow_forward,
                        size: 18, color: Colors.white),
                    onPressed: () => _showSnackbar('Next button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Both Icons',
                  UIButton(
                    text: 'Download',
                    icon: const Icon(Icons.download,
                        size: 18, color: Colors.white),
                    suffixIcon: const Icon(Icons.arrow_downward,
                        size: 18, color: Colors.white),
                    size: UIButtonSize.large,
                    onPressed: () => _showSnackbar('Download button'),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'Layout Options',
              [
                _buildExample(
                  'Full Width Button',
                  UIButton(
                    text: 'Full Width',
                    fullWidth: true,
                    size: UIButtonSize.large,
                    onPressed: () => _showSnackbar('Full width button'),
                  ),
                ),
                8.verticalSpace,
                _buildExample(
                  'Custom Border Radius',
                  UIButton(
                    text: 'Rounded',
                    borderRadius: 25,
                    size: UIButtonSize.large,
                    onPressed: () => _showSnackbar('Rounded button'),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            _buildSection(
              'Real-world Examples',
              [
                _buildExample(
                  'Login Form',
                  Column(
                    children: [
                      UIButton(
                        text: 'Login',
                        fullWidth: true,
                        size: UIButtonSize.large,
                        variant: UIButtonVariant.primary,
                        onPressed: () => _showSnackbar('Login pressed'),
                      ),
                      12.verticalSpace,
                      UIButton(
                        text: 'Create Account',
                        fullWidth: true,
                        buttonType: UIButtonType.outline,
                        size: UIButtonSize.large,
                        onPressed: () =>
                            _showSnackbar('Create account pressed'),
                      ),
                      8.verticalSpace,
                      UIButton(
                        text: 'Forgot Password?',
                        buttonType: UIButtonType.text,
                        size: UIButtonSize.small,
                        onPressed: () =>
                            _showSnackbar('Forgot password pressed'),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                _buildExample(
                  'Emergency Button',
                  UIButton(
                    text: 'PANIC BUTTON',
                    fullWidth: true,
                    size: UIButtonSize.extraLarge,
                    variant: UIButtonVariant.error,
                    icon: const Icon(Icons.warning,
                        color: Colors.white, size: 24),
                    borderRadius: 16,
                    elevation: 4,
                    onPressed: () => _showSnackbar('PANIC BUTTON ACTIVATED!'),
                  ),
                ),
                16.verticalSpace,
                _buildExample(
                  'Action Dialog',
                  Row(
                    children: [
                      Expanded(
                        child: UIButton(
                          text: 'Cancel',
                          buttonType: UIButtonType.outline,
                          variant: UIButtonVariant.neutral,
                          onPressed: () => _showSnackbar('Cancelled'),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: UIButton(
                          text: 'Delete',
                          variant: UIButtonVariant.error,
                          onPressed: () => _showSnackbar('Deleted'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        12.verticalSpace,
        ...children,
      ],
    );
  }

  Widget _buildExample(String description, Widget button) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        8.verticalSpace,
        button,
      ],
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Widget untuk mendemonstrasikan berbagai kombinasi UIButton
class UIButtonShowcase extends StatelessWidget {
  const UIButtonShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('UIButton Showcase'),
      ),
      child: Padding(
        padding: REdgeInsets.all(20),
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: REdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'UIButton',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    'Base Button Component for Guardify App',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            24.verticalSpace,

            // Feature cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildFeatureCard(
                  'Multiple Types',
                  'Filled, Outline, Text & Elevated',
                  Icons.category,
                  () {},
                ),
                _buildFeatureCard(
                  'Responsive Sizes',
                  'Small to Extra Large',
                  Icons.photo_size_select_large,
                  () {},
                ),
                _buildFeatureCard(
                  'Color Variants',
                  'Primary, Success, Error & More',
                  Icons.palette,
                  () {},
                ),
                _buildFeatureCard(
                  'Smart Features',
                  'Loading, Icons & Animations',
                  Icons.smart_toy,
                  () {},
                ),
              ],
            ),

            24.verticalSpace,

            // CTA Button
            UIButton(
              text: 'View All Examples',
              fullWidth: true,
              size: UIButtonSize.large,
              variant: UIButtonVariant.primary,
              icon: const Icon(Icons.visibility, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UIButtonExamples(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32.r,
              color: const Color(0xFFE74C3C),
            ),
            12.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            4.verticalSpace,
            Text(
              description,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
