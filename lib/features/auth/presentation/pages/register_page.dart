import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:resume_riverpod_builder/core/router/route_names.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_form_provider.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_button.dart';
import 'package:resume_riverpod_builder/shared/widgets/app_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authFormNotifierProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authFormNotifierProvider);
    final isLoading = authState is AuthFormLoading;
    final theme = Theme.of(context);

    ref.listen(authFormNotifierProvider, (_, next) {
      if (next is AuthFormError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: theme.colorScheme.error),
        );
        ref.read(authFormNotifierProvider.notifier).reset();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(48),
                    Text(
                      'Create account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Start building resumes that pass every ATS.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(40),
                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      validator: (v) => v != null && v.trim().isNotEmpty ? null : 'Enter your name',
                    ),
                    const Gap(16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                    ),
                    const Gap(16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                    ),
                    const Gap(16),
                    AppTextField(
                      controller: _confirmController,
                      label: 'Confirm Password',
                      obscureText: true,
                      validator: (v) => v == _passwordController.text ? null : 'Passwords do not match',
                    ),
                    const Gap(24),
                    AppButton(
                      label: 'Create Account',
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                    ),
                    const Gap(24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () => context.go(RouteNames.login),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(48),
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
