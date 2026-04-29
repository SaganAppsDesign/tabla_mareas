import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/constants/app_constants.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/presentation/viewmodel/auth_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodel/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthViewModel>().signUp(
            _emailController.text.trim(),
            _passwordController.text,
            displayName: _nameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900,
              Colors.blue.shade900,
              Colors.indigo.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Theme(
            data: theme.copyWith(
              brightness: Brightness.dark,
              textTheme: theme.textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
              inputDecorationTheme: theme.inputDecorationTheme.copyWith(
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIconColor: Colors.white70,
                fillColor: Colors.white.withAlpha(20),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                              onPressed: () => context.pop(),
                            ),
                            Consumer<ThemeViewModel>(
                              builder: (context, themeVM, _) {
                                return IconButton(
                                  icon: Icon(
                                    themeVM.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => themeVM.toggleTheme(),
                                  tooltip: l10n.toggleThemeTooltip,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        
                        // Icon / Illustration
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.spacingL),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_add_rounded,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.spacingXL),
                        
                        Text(
                          l10n.signUpAction,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Text(
                          l10n.registerSubtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.spacingXXL),
                        
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: l10n.fullNameLabel,
                                  prefixIcon: const Icon(Icons.person_outline_rounded),
                                ),
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return l10n.nameRequiredError;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppConstants.spacingL),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: l10n.emailLabel,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || !value.contains('@')) {
                                    return l10n.invalidEmailError;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppConstants.spacingL),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: l10n.passwordLabel,
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.length < 6) {
                                    return l10n.passwordTooShortError;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppConstants.spacingL),
                              TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: l10n.confirmPasswordLabel,
                                  prefixIcon: const Icon(Icons.lock_reset_rounded),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return l10n.passwordsDoNotMatchError;
                                  }
                                  return null;
                                },
                              ),
                              
                              const SizedBox(height: AppConstants.spacingXXL),
                              
                              Consumer<AuthViewModel>(
                                builder: (context, authVM, _) {
                                  return Column(
                                    children: [
                                      if (authVM.errorMessage != null)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: AppConstants.spacingL),
                                          child: Text(
                                            authVM.mapFailureToMessage(l10n),
                                            style: TextStyle(color: colorScheme.error),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      PrimaryButton(
                                        label: l10n.signUpAction,
                                        onPressed: authVM.isLoading ? null : _handleRegister,
                                        isLoading: authVM.isLoading,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              
                              const SizedBox(height: AppConstants.spacingXL),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    l10n.alreadyHaveAccount,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () => context.pop(),
                                    child: Text(
                                      l10n.signInButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spacingXL),
                            ],
                          ),
                        ),
                      ],
                    ),
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
