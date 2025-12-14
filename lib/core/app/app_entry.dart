import 'package:flutter/material.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';
import 'package:notes/features/applock/presentation/screens/app_lock_screen.dart';
import 'package:notes/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:provider/provider.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppLockProvider>();

    // First time: check biometric availability
    if (!auth.isBiometricAvailable && !auth.isAuthenticated) {
      return const AppLockScreen();
    }

    if (!auth.isAuthenticated) {
      return const AppLockScreen();
    }

    return const NotesListScreen();
  }
}
