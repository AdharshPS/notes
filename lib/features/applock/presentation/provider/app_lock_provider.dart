import 'package:flutter/material.dart';
import 'package:notes/features/applock/domain/repositories/app_lock_repository.dart';
import 'package:notes/features/applock/domain/usecases/authenticate.dart';
import 'package:notes/features/applock/domain/usecases/authenticate_with_biometrics.dart';
import 'package:notes/features/applock/domain/usecases/get_available_biometrics.dart';

class AppLockProvider with ChangeNotifier {
  final AppLockRepository repo;
  final AuthenticateWithBiometrics _authenticateWithBiometrics;
  final Authenticate _authenticate;
  final CheckBiometricsAvailability _checkBiometricsAvailablity;
  AppLockProvider(this.repo)
    : _authenticateWithBiometrics = AuthenticateWithBiometrics(repo),
      _authenticate = Authenticate(repo),
      _checkBiometricsAvailablity = CheckBiometricsAvailability(repo);

  // ---------------- STATE ----------------

  bool isLoading = false;
  bool isAuthenticated = false;
  bool isBiometricAvailable = false;
  String? error;

  // ---------------- ACTIONS ----------------

  /// Call once on app start
  Future<void> checkBiometrics() async {
    try {
      isLoading = true;
      notifyListeners();

      isBiometricAvailable = await _checkBiometricsAvailablity();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Authenticate using system default (PIN / biometrics)
  Future<void> authenticate() async {
    try {
      isLoading = true;
      notifyListeners();

      final success = await _authenticate();
      isAuthenticated = success;
      error = null;
    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Authenticate using biometrics only
  Future<void> authenticateWithBiometrics() async {
    try {
      isLoading = true;
      notifyListeners();

      final success = await _authenticateWithBiometrics();
      isAuthenticated = success;
      error = null;
    } catch (e) {
      error = e.toString();
      isAuthenticated = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Optional: reset auth state (e.g. app goes background)
  void lock() {
    isAuthenticated = false;
    notifyListeners();
  }
}
