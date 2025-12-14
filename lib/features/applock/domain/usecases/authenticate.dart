import 'package:notes/features/applock/domain/repositories/app_lock_repository.dart';

class Authenticate {
  final AppLockRepository repo;
  Authenticate(this.repo);
  Future<bool> call() => repo.authenticate();
}
