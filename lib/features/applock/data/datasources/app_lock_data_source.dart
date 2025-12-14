import 'package:local_auth/local_auth.dart';

abstract class AppLockDataSource {
  Future<bool> isDeviceSupported();
  Future<bool> checkBiometrics();
  Future<List<BiometricType>> getAvailableBiometrics();
  Future<bool> authenticate();
  Future<bool> authenticateWithBiometrics();
  Future<void> cancelAuthentication();
}
