import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';
import 'package:provider/provider.dart';

class LockOverlay extends StatefulWidget {
  const LockOverlay({super.key});

  @override
  State<LockOverlay> createState() => _LockOverlayState();
}

class _LockOverlayState extends State<LockOverlay> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AppLockProvider>();
      if (auth.isAuthenticated) return;

      if (auth.isBiometricAvailable) {
        auth.authenticateWithBiometrics();
      } else {
        auth.authenticate(); // fallback to PIN / system auth
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppLockProvider>();

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Colors.black.withValues(alpha: .4),
          child: Center(
            child: auth.isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 64, color: Colors.white),
                      const SizedBox(height: 20),
                      const Text(
                        'Unlock to continue',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: context.read<AppLockProvider>().authenticate,
                        child: const Text('Unlock'),
                      ),

                      if (auth.isBiometricAvailable) ...[
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: context
                              .read<AppLockProvider>()
                              .authenticateWithBiometrics,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Use biometrics'),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
