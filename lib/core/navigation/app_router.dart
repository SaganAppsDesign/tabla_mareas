import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tabla_mareas/core/constants/route_names.dart';
import 'package:tabla_mareas/l10n/app_localizations.dart';
import 'package:tabla_mareas/presentation/views/home_screen.dart';
import 'package:tabla_mareas/presentation/views/login/login_screen.dart';
import 'package:tabla_mareas/presentation/views/register/register_screen.dart';
import 'package:tabla_mareas/presentation/views/login/forgot_password_screen.dart';
import 'package:tabla_mareas/presentation/viewmodels/auth_viewmodel.dart';

import 'package:tabla_mareas/core/di/injection_container.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: sl<AuthViewModel>(),
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            path: RoutePaths.forgotPassword,
            name: RouteNames.forgotPassword,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    redirect: (context, state) {
      final authViewModel = context.read<AuthViewModel>();
      final isAuthenticated = authViewModel.isAuthenticated;
      
      // Public routes that don't require authentication
      final isLoginRoute = state.matchedLocation == RoutePaths.login;
      final isRegisterRoute = state.matchedLocation == RoutePaths.register;
      final isForgotPasswordRoute = state.matchedLocation == '/login/forgot-password';
      
      final isPublicRoute = isLoginRoute || isRegisterRoute || isForgotPasswordRoute;

      if (!isAuthenticated && !isPublicRoute) {
        return RoutePaths.login;
      }
      
      if (isAuthenticated && (isLoginRoute || isRegisterRoute)) {
        return RoutePaths.home;
      }

      return null;
    },
    errorBuilder: (context, state) {
      final l10n = AppLocalizations.of(context);
      final prefix = l10n?.navigationErrorPrefix ?? 'Error';

      return Scaffold(body: Center(child: Text('$prefix: ${state.error}')));
    },
  );
}
