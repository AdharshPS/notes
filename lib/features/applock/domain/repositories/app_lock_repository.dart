abstract class AppLockRepository {
  Future<bool> checkBiometricsAvailability();
  Future<bool> authenticate();
  Future<bool> authenticateWithBiometrics();
}
