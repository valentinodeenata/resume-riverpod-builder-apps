import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:resume_riverpod_builder/core/router/route_names.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/pages/login_page.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/pages/register_page.dart';
import 'package:resume_riverpod_builder/features/auth/presentation/providers/auth_provider.dart';
import 'package:resume_riverpod_builder/features/ats_analyzer/presentation/pages/ats_analyzer_page.dart';
import 'package:resume_riverpod_builder/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:resume_riverpod_builder/features/export/presentation/pages/export_page.dart';
import 'package:resume_riverpod_builder/features/profile/presentation/pages/profile_page.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/pages/resume_editor_page.dart';
import 'package:resume_riverpod_builder/features/resume_builder/presentation/pages/resume_preview_page.dart';

part 'app_router.g.dart';

/// Application-wide router powered by [GoRouter].
///
/// Auth state changes trigger automatic redirects so
/// protected routes are never accessible when signed out.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isOnAuthRoute = state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register;

      if (!isLoggedIn && !isOnAuthRoute) return RouteNames.login;
      if (isLoggedIn && isOnAuthRoute) return RouteNames.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboard,
        builder: (_, __) => const DashboardPage(),
      ),
      GoRoute(
        path: '${RouteNames.resumeEditor}/:resumeId',
        name: RouteNames.resumeEditor,
        builder: (_, state) => ResumeEditorPage(
          resumeId: state.pathParameters['resumeId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.atsAnalyzer}/:resumeId',
        name: RouteNames.atsAnalyzer,
        builder: (_, state) => AtsAnalyzerPage(
          resumeId: state.pathParameters['resumeId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.export}/:resumeId',
        name: RouteNames.export,
        builder: (_, state) => ExportPage(
          resumeId: state.pathParameters['resumeId']!,
        ),
      ),
      GoRoute(
        path: '${RouteNames.resumePreview}/:resumeId',
        name: RouteNames.resumePreview,
        builder: (_, state) => ResumePreviewPage(
          resumeId: state.pathParameters['resumeId']!,
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
}
