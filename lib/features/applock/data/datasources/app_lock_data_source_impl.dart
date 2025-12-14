import 'package:flutter/services.dart';
import 'package:notes/features/applock/data/datasources/app_lock_data_source.dart';
import 'package:local_auth/local_auth.dart';

class AppLockDataSourceImpl implements AppLockDataSource {
  final LocalAuthentication auth;
  AppLockDataSourceImpl(this.auth);
  @override
  Future<bool> isDeviceSupported() async {
    try {
      return await auth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
      return authenticated;
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Unlock to see your notes',
        persistAcrossBackgrounding: true,
      );
      return authenticated;
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
  }

  @override
  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics;
    bool deviceSupport;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      deviceSupport = await auth.isDeviceSupported();
      return canCheckBiometrics && deviceSupport;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      return availableBiometrics;
    } on PlatformException {
      availableBiometrics = <BiometricType>[];
      return availableBiometrics;
    }
  }
}
