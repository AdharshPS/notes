import 'package:notes/features/applock/data/datasources/app_lock_data_source.dart';
import 'package:notes/features/applock/domain/repositories/app_lock_repository.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  final AppLockDataSource _appLockDataSource;
  AppLockRepositoryImpl(this._appLockDataSource);

  @override
  Future<bool> authenticateWithBiometrics() async {
    return await _appLockDataSource.authenticateWithBiometrics();
  }

  @override
  Future<bool> authenticate() async {
    return await _appLockDataSource.authenticate();
  }

  @override
  Future<bool> checkBiometricsAvailability() async {
    return await _appLockDataSource.checkBiometrics();
  }
}
