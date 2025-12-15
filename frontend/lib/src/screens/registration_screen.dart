import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_text_field.dart';

/// Registration screen with ID card upload
class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ssnController = TextEditingController();
  final _dobController = TextEditingController();
  
  File? _idCardImage;
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _ssnController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    
    if (pickedFile != null) {
      setState(() {
        _idCardImage = File(pickedFile.path);
        _isProcessing = true;
      });
      
      // Simulate ID card processing/OCR
      await Future.delayed(const Duration(seconds: 2));
      
      // Auto-fill fields (simulated)
      setState(() {
        _nameController.text = 'John Doe';
        _ssnController.text = '123-45-6789';
        _dobController.text = '01/15/1990';
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ ID Card verified! Information extracted.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _register() {
    // ID card image is now optional - user can skip it
    // Just check basic fields are filled
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in at least name, email, and password'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigate directly to financial details (skip personal info step)
    context.go('/financials');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Create Account', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Register with ID Card',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo of your ID card to auto-fill your information',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            
            // ID Card Upload Section
            _buildIdCardUpload(),
            
            const SizedBox(height: 32),
            
            // Form Fields
            if (_idCardImage != null) ...[
              _buildFormFields(),
              const SizedBox(height: 32),
              _buildRegisterButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardUpload() {
    return GestureDetector(
      onTap: _isProcessing ? null : _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _idCardImage != null ? AppColors.primaryCyan : AppColors.textSecondary.withOpacity(0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: _isProcessing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Processing ID card...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : _idCardImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to capture ID card',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Front side only',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _idCardImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.refresh),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _nameController,
          hintText: 'Full Name',
          dark: true,
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _ssnController,
          hintText: 'SSN',
          dark: true,
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _dobController,
          hintText: 'Date of Birth (MM/DD/YYYY)',
          dark: true,
          prefixIcon: Icons.calendar_today_outlined,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _emailController,
          hintText: 'Email Address',
          dark: true,
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _phoneController,
          hintText: 'Phone Number',
          dark: true,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 16),
        
        CustomTextField(
          controller: _passwordController,
          hintText: 'Password',
          dark: true,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _register,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primaryCyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
