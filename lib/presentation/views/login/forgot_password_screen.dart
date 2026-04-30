import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/constants/app_constants.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/presentation/viewmodels/auth_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleReset() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthViewModel>().resetPassword(_emailController.text.trim());
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
                        Text(
                          l10n.forgotPasswordTitle,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Text(
                          l10n.forgotPasswordSubtitle,
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
                                        label: l10n.sendResetLinkButton,
                                        onPressed: authVM.isLoading ? null : _handleReset,
                                        isLoading: authVM.isLoading,
                                      ),
                                    ],
                                  );
                                },
                              ),
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
