import 'package:flutter/material.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  final AppLockProvider provider;

  AppLifecycleObserver(this.provider);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      provider.lock();
    }
  }
}
