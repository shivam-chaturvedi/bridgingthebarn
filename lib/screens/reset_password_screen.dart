import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth_screen.dart';
import '../services/auth_service.dart';
import '../theme/theme_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const _minPasswordLength = 8;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onInputChanged);
    _confirmController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onInputChanged);
    _confirmController.removeListener(_onInputChanged);
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  int get _strengthScore {
    final password = _passwordController.text.trim();
    var score = 0;
    if (password.length >= ResetPasswordScreen._minPasswordLength) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;
    return score;
  }

  bool get _hasLength => _passwordController.text.trim().length >= ResetPasswordScreen._minPasswordLength;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _hasDigit => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSymbol => RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);
  bool get _passwordsMatch => _passwordController.text == _confirmController.text;

  String get _strengthLabel {
    if (_strengthScore <= 2) {
      return 'Weak';
    }
    if (_strengthScore <= 4) {
      return 'Medium';
    }
    return 'Strong';
  }

  Color get _strengthColor {
    if (_strengthScore <= 2) {
      return Colors.redAccent;
    }
    if (_strengthScore <= 4) {
      return Colors.orangeAccent;
    }
    return Colors.greenAccent;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);
    try {
      await AuthService.updatePassword(password: _passwordController.text.trim());
      await AuthService.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated. Sign in with your new password.'),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AuthScreen(initialTab: AuthTab.signIn),
        ),
      );
    } on AuthException catch (error) {
      _showError(error.message ?? 'Unable to reset your password.');
    } catch (error) {
      _showError('Unable to reset your password right now. Try again later.');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildStrengthIndicator() {
    final progress = (_strengthScore / 5).clamp(0.0, 1.0).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white12,
                color: _strengthColor,
                minHeight: 6,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _strengthLabel,
              style: TextStyle(color: _strengthColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Use uppercase, lowercase, numbers, and symbols for a strong password.',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRequirement(String label, bool satisfied) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(
            satisfied ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: satisfied ? Colors.greenAccent : Colors.white30,
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: satisfied ? Colors.white : Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        title: const Text('Reset Bridging Barn password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create a new password',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your recovery link allows a one-time password reset session. Create a password you can remember while keeping it strong.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'New password',
                        labelStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().length < ResetPasswordScreen._minPasswordLength) {
                          return 'Use at least ${ResetPasswordScreen._minPasswordLength} characters.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildStrengthIndicator(),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        labelStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value != _passwordController.text) {
                          return 'Passwords must match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildRequirement('At least ${ResetPasswordScreen._minPasswordLength} characters', _hasLength),
                    _buildRequirement('Upper and lower case letters', _hasUppercase && _hasLowercase),
                    _buildRequirement('Numbers and symbols', _hasDigit && _hasSymbol),
                    _buildRequirement('Passwords match', _passwordsMatch),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isProcessing ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                      )
                    : const Text('Update password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
