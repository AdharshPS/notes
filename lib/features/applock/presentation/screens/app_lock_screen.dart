import 'package:flutter/material.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';
import 'package:provider/provider.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  @override
  void initState() {
    super.initState();

    // Run AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AppLockProvider>();

      if (!auth.isAuthenticated) {
        auth.authenticate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppLockProvider>();

    return Scaffold(
      body: Center(
        child: auth.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 64),
                  const SizedBox(height: 24),
                  const Text(
                    'Unlock to see your notes',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Optional fallback button
                  ElevatedButton(
                    onPressed: auth.authenticate,
                    child: const Text(
                      'Try again',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  if (auth.isBiometricAvailable) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: auth.authenticateWithBiometrics,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Use biometrics'),
                    ),
                  ],

                  if (auth.error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      auth.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
