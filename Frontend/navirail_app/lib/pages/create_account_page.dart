import 'package:flutter/material.dart';
import '../ui/design_system.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blue = Colors.blue;

    InputBorder outline([Color? color]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color ?? const Color(0xFFE5E7EB), width: 1.2),
        );

    final labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Create Account',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.train_outlined, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'NaviRail',
                          style: TextStyle(
                            color: blue,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Full Name
                    const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _FullWidth(
                      child: TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: outline(),
                          enabledBorder: outline(),
                          focusedBorder: outline(blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Phone Number
                    const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _FullWidth(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g., +91 9876543210',
                          prefixIcon: const Icon(Icons.call_outlined),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: outline(),
                          enabledBorder: outline(),
                          focusedBorder: outline(blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Email Address
                    const Text('Email Address', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _FullWidth(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'your.email@example.com',
                          prefixIcon: const Icon(Icons.alternate_email),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: outline(),
                          enabledBorder: outline(),
                          focusedBorder: outline(blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Password
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _FullWidth(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Minimum 8 characters',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: outline(),
                          enabledBorder: outline(),
                          focusedBorder: outline(blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Confirm Password
                    const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _FullWidth(
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Minimum 8 characters',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                          ),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          border: outline(),
                          enabledBorder: outline(),
                          focusedBorder: outline(blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Create Account button
                    _FullWidth(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: .2),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullWidth extends StatelessWidget {
  const _FullWidth({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: child),
      ],
    );
  }
}
