import 'package:notes/features/applock/domain/repositories/app_lock_repository.dart';

class AuthenticateWithBiometrics {
  final AppLockRepository repo;
  AuthenticateWithBiometrics(this.repo);
  Future<bool> call() => repo.authenticateWithBiometrics();
}
