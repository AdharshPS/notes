import 'package:notes/features/applock/domain/repositories/app_lock_repository.dart';

class CheckBiometricsAvailability {
  final AppLockRepository repo;
  CheckBiometricsAvailability(this.repo);
  Future<bool> call() => repo.checkBiometricsAvailability();
}
