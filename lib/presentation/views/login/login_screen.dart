import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/constants/app_constants.dart';
import 'package:tabla_mareas/core/constants/route_names.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/presentation/viewmodels/auth_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/presentation/widgets/primary_button.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthViewModel>().signIn(
            _emailController.text.trim(),
            _passwordController.text,
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
        width: double.infinity,
        height: double.infinity,
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
              Align(
                alignment: Alignment.centerRight,
                child: Consumer<ThemeViewModel>(
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
              ),
              const SizedBox(height: AppConstants.spacingL),
              const SizedBox(height: AppConstants.spacingXXL),
              
              // Header Illustration/Icon Placeholder
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withAlpha(50),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_person_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXXL),
              
              Text(
                l10n.loginTitle,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                l10n.loginSubtitle,
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
                    const SizedBox(height: AppConstants.spacingL),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.passwordLabel,
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.emptyPasswordError;
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingS),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.pushNamed(RouteNames.forgotPassword),
                        child: Text(
                          l10n.forgotPasswordAction,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXL),
                    
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
                              label: l10n.signInButton,
                              onPressed: authVM.isLoading ? null : _handleLogin,
                              isLoading: authVM.isLoading,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.spacingXXL),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.signUpPrompt,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () => context.pushNamed(RouteNames.register),
                    child: Text(
                      l10n.signUpAction,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingL),
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<AuthViewModel>().signInAsGuest();
                  },
                  child: Text(
                    l10n.guestLoginAction,
                    style: const TextStyle(
                      color: Colors.white70,
                      decoration: TextDecoration.underline,
                    ),
                  ),
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
