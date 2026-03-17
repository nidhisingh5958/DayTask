import 'package:daytask_app/auth/auth_controller.dart';
import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _googleLoading = false;
  bool _resendLoading = false;
  bool _agreed = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || !_agreed) {
      if (!_agreed) {
        _showError('Please agree to terms to continue');
      }
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final response = await ref
          .read(authServiceProvider)
          .signUp(
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _fullNameController.text,
          );

      if (!mounted) {
        return;
      }

      final requiresEmailVerification = response.session == null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            requiresEmailVerification
                ? 'Account created. Check your email to verify, then sign in.'
                : 'Account created. You can now continue.',
          ),
        ),
      );

      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) _showError(_cleanError(error));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _googleLoading = true;
    });

    try {
      await ref.read(authServiceProvider).signInWithGoogle();
    } catch (error) {
      if (mounted) _showError(_cleanError(error));
    } finally {
      if (mounted) {
        setState(() => _googleLoading = false);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    final emailError = emailValidator(_emailController.text);
    if (emailError != null) {
      _showError('Enter a valid email first');
      return;
    }

    setState(() {
      _resendLoading = true;
    });

    try {
      await ref
          .read(authServiceProvider)
          .resendSignupVerificationEmail(email: _emailController.text);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification email sent to ${_emailController.text.trim()}',
          ),
        ),
      );
    } catch (error) {
      if (mounted) _showError(_cleanError(error));
    } finally {
      if (mounted) {
        setState(() => _resendLoading = false);
      }
    }
  }

  String _cleanError(Object error) {
    final raw = error.toString();
    final match = RegExp(
      r'message:\s*(.*?)(?:,\s*(?:statusCode|code)|[)]|$)',
    ).firstMatch(raw);
    return match?.group(1)?.trim() ?? raw;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildBranding() {
    return Column(
      children: const [
        CircleAvatar(
          radius: 28,
          backgroundColor: Color(0x33F4C95D),
          child: Icon(Icons.watch_later_outlined, color: AppTheme.accent),
        ),
        SizedBox(height: 10),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Day',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
              TextSpan(
                text: 'Task',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final formWidth = width > 700 ? 430.0 : width * 0.92;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1525), AppTheme.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: formWidth),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildBranding()),
                      const SizedBox(height: 24),
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Full Name',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) =>
                            requiredValidator(value, fieldName: 'Full name'),
                        decoration: const InputDecoration(
                          hintText: 'Your full name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Email Address',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailController,
                        validator: emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Password',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        validator: passwordValidator,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Create password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      CheckboxListTile(
                        value: _agreed,
                        onChanged: (value) {
                          setState(() => _agreed = value ?? false);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: const Text(
                          'I have read & agreed to DayTask Privacy Policy, Terms & Condition',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign Up'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: _resendLoading
                            ? null
                            : _resendVerificationEmail,
                        child: _resendLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Resend verification email'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Expanded(child: Divider(color: AppTheme.textMuted)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(color: AppTheme.textMuted),
                            ),
                          ),
                          Expanded(child: Divider(color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _googleLoading ? null : _continueWithGoogle,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(color: Color(0xFF8DA1B4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: _googleLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.g_mobiledata, size: 26),
                        label: const Text('Google'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Already have an account? Log In'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
