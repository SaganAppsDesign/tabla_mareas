import 'package:flutter/material.dart';
import 'package:tabla_mareas/presentation/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/constants/app_constants.dart';
import 'package:tabla_mareas/presentation/viewmodels/random_number_viewmodel.dart';
import 'package:tabla_mareas/presentation/viewmodels/theme_viewmodel.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/presentation/widgets/primary_button.dart';

class RandomNumberScreen extends StatelessWidget {
  const RandomNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const RandomNumberView();
  }
}

class RandomNumberView extends StatelessWidget {
  const RandomNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Consumer<ThemeViewModel>(
            builder: (context, themeViewModel, child) {
              return IconButton(
                icon: Icon(
                  themeViewModel.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () => themeViewModel.toggleTheme(),
                tooltip: l10n.toggleThemeTooltip,
              );
            },
          ),
          Consumer<AuthViewModel>(
            builder: (context, authVM, _) {
              return IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () => authVM.signOut(),
                tooltip: l10n.signOutTooltip,
              );
            },
          ),
          const SizedBox(width: AppConstants.spacingS),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Illustration/Icon
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingL),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(50),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXXL),

              // Main Content Card
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withAlpha(100),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingXL),
                  child: Column(
                    children: [
                      Text(
                        l10n.currentValue,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingM),
                      Selector<RandomNumberViewModel, bool>(
                        selector: (_, vm) => vm.isLoading,
                        builder: (context, isLoading, child) {
                          if (isLoading) {
                            return SizedBox(
                              height: 80,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  strokeCap: StrokeCap.round,
                                  color: colorScheme.primary,
                                ),
                              ),
                            );
                          }
                          return child!;
                        },
                        child: Selector<RandomNumberViewModel, int?>(
                          selector: (_, vm) => vm.randomNumber,
                          builder: (context, number, _) {
                            return Text(
                              number?.toString() ?? '--',
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 84,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.primary,
                                letterSpacing: -2,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Selector<RandomNumberViewModel, String?>(
                        selector: (_, vm) => vm.errorMessage,
                        builder: (context, errorMessage, _) {
                          if (errorMessage == null) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.all(
                              AppConstants.spacingS,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer.withAlpha(50),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusS,
                              ),
                            ),
                            child: Text(
                              errorMessage.isEmpty
                                  ? l10n.genericError
                                  : errorMessage,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: AppConstants.spacingXXL + AppConstants.spacingS,
              ),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: Consumer<RandomNumberViewModel>(
                  builder: (context, viewModel, _) {
                    return PrimaryButton(
                      label: l10n.generateNumber,
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.fetchRandomNumber(),
                      icon: Icons.refresh_rounded,
                      isLoading: viewModel.isLoading,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                l10n.poweredByTemplate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
