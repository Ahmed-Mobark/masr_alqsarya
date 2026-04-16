import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateManager {
  ForceUpdateManager({
    this.isTestMode = false,
    this.testStoreVersion = '',
    this.isMandatoryUpdate = true,
    Widget Function(
      BuildContext context,
      VoidCallback onUpdateNow,
      VoidCallback? onSkip,
    )?
    customUpdateDialog,
  }) : _customUpdateDialog = customUpdateDialog;

  String _installedVersion = "";

  final bool isTestMode;
  final String testStoreVersion;
  bool isMandatoryUpdate;

  String androidPackageName = 'com.app.shajrateldor';
  String iosBundleId = 'com.app.shajrateldor';
  String iosAppId = '6759283526';

  final Widget Function(
    BuildContext context,
    VoidCallback onUpdateNow,
    VoidCallback? onSkip,
  )?
  _customUpdateDialog;

  bool _isDialogShowing = false;

  Future<void> initialize() async {
    await _getInstalledVersion();
  }

  Future<void> _getInstalledVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _installedVersion = packageInfo.version.trim();
      log(' Installed version: $_installedVersion');
    } catch (e) {
      log('Error getting app version: $e');
    }
  }

  Future<void> checkForUpdates(BuildContext context) async {
    if (_isDialogShowing) return;

    if (_installedVersion.isEmpty) {
      await _getInstalledVersion();
    }

    if (!context.mounted) return;

    if (Platform.isAndroid) {
      await _checkForUpdateAndroid(context);
    } else if (Platform.isIOS) {
      await _checkForUpdateIOS(context);
    }
  }

  // ================= ANDROID =================

  Future<void> _checkForUpdateAndroid(BuildContext context) async {
    try {
      if (isTestMode) {
        if (_isUpdateRequired(_installedVersion, testStoreVersion)) {
          _showUpdateDialog(context);
        }
        return;
      }

      final updateInfo = await InAppUpdate.checkForUpdate();
      if (!context.mounted) return;

      log('🤖 Android update info: $updateInfo');

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        _showUpdateDialog(context);
      }
    } catch (e) {
      log(' Android update error: $e');
    }
  }

  // ================= iOS =================

  Future<void> _checkForUpdateIOS(BuildContext context) async {
    try {
      if (isTestMode) {
        if (_isUpdateRequired(_installedVersion, testStoreVersion)) {
          _showUpdateDialog(context);
        }
        return;
      }

      final response = await Dio().get(
        'https://itunes.apple.com/lookup?bundleId=$iosBundleId',
      );
      if (!context.mounted) return;

      if (response.statusCode != 200) {
        log(' iTunes API failed: ${response.statusCode}');
        return;
      }

      final data = json.decode(response.data);

      if (data['results'] == null || data['results'].isEmpty) {
        log(' No results from App Store API');
        return;
      }

      final storeVersion = data['results'][0]['version'];

      log(' Store version: $storeVersion');
      log('Installed version: $_installedVersion');

      if (_isUpdateRequired(_installedVersion, storeVersion)) {
        _showUpdateDialog(context);
      }
    } catch (e) {
      log(' iOS update error: $e');
    }
  }

  // ================= VERSION COMPARISON =================

  bool _isUpdateRequired(String currentVersion, String storeVersion) {
    final current = _normalizeVersion(currentVersion);
    final store = _normalizeVersion(storeVersion);

    log('🔍 Compare → Installed: $current | Store: $store');

    for (int i = 0; i < 3; i++) {
      if (store[i] > current[i]) return true;
      if (store[i] < current[i]) return false;
    }
    return false;
  }

  List<int> _normalizeVersion(String version) {
    final parts = version
        .trim()
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    while (parts.length < 3) {
      parts.add(0);
    }

    return parts.sublist(0, 3);
  }

  // ================= UI =================

  void _showUpdateDialog(BuildContext context) {
    if (!context.mounted) return;

    _isDialogShowing = true;

    showCupertinoDialog(
      context: context,
      barrierDismissible: !isMandatoryUpdate,
      builder: (dialogContext) {
        return _customUpdateDialog?.call(
              dialogContext,
              () {
                Navigator.pop(dialogContext);
                _openStore();
              },
              isMandatoryUpdate ? null : () => Navigator.pop(dialogContext),
            ) ??
            _defaultDialog(dialogContext);
      },
    ).then((_) => _isDialogShowing = false);
  }

  Widget _defaultDialog(BuildContext context) {
    return PopScope(
      canPop: !isMandatoryUpdate,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Available'),
        content: Text(
          isMandatoryUpdate
              ? 'Please update the app to continue.'
              : 'A new version is available.',
        ),
        actions: [
          if (!isMandatoryUpdate)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openStore();
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  // ================= STORE =================

  Future<void> _openStore() async {
    final url = Platform.isAndroid
        ? 'market://details?id=$androidPackageName'
        : 'itms-apps://itunes.apple.com/app/$iosAppId';

    final fallback = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$androidPackageName'
        : 'https://apps.apple.com/app/id$iosAppId';

    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await _launchFallback(fallback);
      }
    } catch (_) {
      await _launchFallback(fallback);
    }
  }

  Future<void> _launchFallback(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log(' Fallback failed: $e');
    }
  }
}
