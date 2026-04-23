import 'dart:developer' as developer;
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:permission_handler/permission_handler.dart';

class CallRoomView extends StatefulWidget {
  const CallRoomView({
    super.key,
    required this.livekitUrl,
    required this.token,
    required this.roomName,
    required this.isVideo,
  });

  final String livekitUrl;
  final String token;
  final String roomName;
  final bool isVideo;

  @override
  State<CallRoomView> createState() => _CallRoomViewState();
}

class _CallRoomViewState extends State<CallRoomView> {
  Room? _room;
  EventsListener<RoomEvent>? _listener;

  bool _connecting = true;
  bool _micEnabled = true;
  bool _camEnabled = true;
  bool _exiting = false;
  String? _bannerMessage;
  bool _reconnecting = false;
  int _reconnectAttempts = 0;

  @override
  void initState() {
    super.initState();
    // LiveKit uses platform plugins (e.g. device_info_plus). Guard against
    // unsupported runtimes (desktop/web) to avoid MissingPluginException.
    final isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
    if (!isMobile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        appToast(
          context: context,
          type: ToastType.error,
          message: context.tr.callUnsupportedPlatform,
        );
        sl<AppNavigator>().pop();
      });
      return;
    }
    _connect();
  }

  void _showBanner(String message) {
    if (!mounted) return;
    setState(() => _bannerMessage = message);
  }

  Future<void> _attemptReconnect() async {
    if (_reconnecting || _exiting) return;
    if (_reconnectAttempts >= 3) {
      _showBanner(context.tr.callDisconnected);
      return;
    }
    _reconnecting = true;
    _reconnectAttempts += 1;
    _showBanner(context.tr.callReconnecting);
    setState(() => _connecting = true);

    // Tear down current room/listener before re-connecting.
    try {
      _listener?.dispose();
    } catch (_) {}
    _listener = null;
    try {
      await _room?.disconnect();
    } catch (_) {}
    _room = null;

    // Small backoff.
    await Future<void>.delayed(Duration(milliseconds: 350 * _reconnectAttempts));
    if (!mounted || _exiting) return;
    _reconnecting = false;
    await _connect();
  }

  String _sanitizeLiveKitUrl(String raw) {
    var url = raw.trim();
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    if (url.startsWith('https://')) {
      url = 'wss://${url.substring('https://'.length)}';
    } else if (url.startsWith('http://')) {
      url = 'ws://${url.substring('http://'.length)}';
    }
    return url;
  }

  Future<void> _connect() async {
    setState(() => _connecting = true);
    final room = Room(
      roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
    );

    _listener = room.createListener();
    _listener?.on<RoomDisconnectedEvent>((event) {
      if (kDebugMode) {
        developer.log(
          'LiveKit disconnected: ${event.reason}',
          name: 'CallRoomView',
        );
      }
      if (!mounted || _exiting) return;

      final reason = (event.reason ?? '').toString().toLowerCase();
      final replaced = reason.contains('duplicate') ||
          reason.contains('replaced') ||
          reason.contains('identity');
      final networkLike = reason.contains('network') ||
          reason.contains('transport') ||
          reason.contains('timeout') ||
          reason.contains('server') ||
          reason.contains('unknown') ||
          reason.isEmpty;

      if (replaced) {
        _showBanner(context.tr.callConnectionReplaced);
        // Give the user a moment to read, then exit.
        Future<void>.delayed(const Duration(milliseconds: 900), () {
          if (!mounted || _exiting) return;
          _exiting = true;
          sl<AppNavigator>().pop();
        });
        return;
      }

      if (networkLike) {
        // Try reconnect without throwing user out.
        _attemptReconnect();
        return;
      }

      // Fallback: show a message then exit.
      _showBanner(context.tr.callDisconnected);
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!mounted || _exiting) return;
        _exiting = true;
        sl<AppNavigator>().pop();
      });
    });

    try {
      final url = _sanitizeLiveKitUrl(widget.livekitUrl);
      await room.connect(
        url,
        widget.token,
        connectOptions: const ConnectOptions(autoSubscribe: true),
      );
      if (!mounted) return;
      // Clear any previous banner after successful connection.
      setState(() => _bannerMessage = null);

      // Request runtime permissions before creating media tracks.
      // On Android, missing runtime permission commonly throws TrackCreateException.
      final micStatus = await Permission.microphone.request();
      final camStatus = widget.isVideo
          ? await Permission.camera.request()
          : PermissionStatus.denied;

      // Enabling sources can throw (e.g. no permission, no camera device, etc).
      // Never let it crash the whole call; degrade gracefully.
      if (micStatus.isGranted) {
        try {
          await room.localParticipant?.setMicrophoneEnabled(true);
          _micEnabled = true;
        } catch (e, st) {
          _micEnabled = false;
          if (kDebugMode) {
            developer.log(
              'Failed to enable microphone',
              name: 'CallRoomView',
              error: e,
              stackTrace: st,
            );
          }
          if (mounted) {
            appToast(
              context: context,
              type: ToastType.error,
              message: context.tr.callMicPermissionRequired,
            );
          }
        }
      } else {
        _micEnabled = false;
        if (mounted) {
          appToast(
            context: context,
            type: ToastType.error,
            message: context.tr.callMicPermissionRequired,
          );
        }
      }

      if (widget.isVideo) {
        if (camStatus.isGranted) {
          try {
            await room.localParticipant?.setCameraEnabled(true);
            _camEnabled = true;
          } catch (e, st) {
            _camEnabled = false;
            if (kDebugMode) {
              developer.log(
                'Failed to enable camera',
                name: 'CallRoomView',
                error: e,
                stackTrace: st,
              );
            }
            if (mounted) {
              appToast(
                context: context,
                type: ToastType.error,
                message: context.tr.callCameraPermissionRequired,
              );
            }
            // Stay connected audio-only instead of failing the whole join.
            try {
              await room.localParticipant?.setCameraEnabled(false);
            } catch (_) {}
          }
        } else {
          _camEnabled = false;
          if (mounted) {
            appToast(
              context: context,
              type: ToastType.error,
              message: context.tr.callCameraPermissionRequired,
            );
          }
          try {
            await room.localParticipant?.setCameraEnabled(false);
          } catch (_) {}
        }
      } else {
        _camEnabled = false;
        try {
          await room.localParticipant?.setCameraEnabled(false);
        } catch (_) {}
      }

      _room = room;
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          'LiveKit connect failed',
          name: 'CallRoomView',
          error: e,
          stackTrace: st,
        );
      }
      if (mounted) {
        final raw = e.toString().toLowerCase();
        final msg = raw.contains('no internet')
            ? context.tr.callNoInternet
            : context.tr.callConnectFailed;
        appToast(context: context, type: ToastType.error, message: msg);
        _exiting = true;
        sl<AppNavigator>().pop();
      }
      return;
    }

    if (!mounted) return;
    setState(() => _connecting = false);
  }

  Future<void> _leave() async {
    _exiting = true;
    try {
      await _room?.disconnect();
    } catch (_) {}
    if (mounted) sl<AppNavigator>().pop();
  }

  Future<void> _toggleMic() async {
    final room = _room;
    if (room == null) return;
    final next = !_micEnabled;
    if (next) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          appToast(
            context: context,
            type: ToastType.error,
            message: context.tr.callMicPermissionRequired,
          );
        }
        return;
      }
    }

    setState(() => _micEnabled = next);
    try {
      await room.localParticipant?.setMicrophoneEnabled(next);
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          'Failed to toggle microphone',
          name: 'CallRoomView',
          error: e,
          stackTrace: st,
        );
      }
      if (!mounted) return;
      setState(() => _micEnabled = !next);
      appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.callMicPermissionRequired,
      );
    }
  }

  Future<void> _toggleCam() async {
    final room = _room;
    if (room == null) return;
    final next = !_camEnabled;
    if (next) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          appToast(
            context: context,
            type: ToastType.error,
            message: context.tr.callCameraPermissionRequired,
          );
        }
        return;
      }
    }

    setState(() => _camEnabled = next);
    try {
      await room.localParticipant?.setCameraEnabled(next);
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          'Failed to toggle camera',
          name: 'CallRoomView',
          error: e,
          stackTrace: st,
        );
      }
      if (!mounted) return;
      setState(() => _camEnabled = !next);
      appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.callCameraPermissionRequired,
      );
    }
  }

  @override
  void dispose() {
    _listener?.dispose();
    _listener = null;
    try {
      _room?.disconnect();
    } catch (_) {}
    _room = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final room = _room;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            if (_bannerMessage != null)
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 16.w,
                  end: 16.w,
                  top: 8.h,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Text(
                    _bannerMessage!,
                    style: AppTextStyles.bodyMedium(color: Colors.white70)
                        .copyWith(fontSize: 12.sp),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _exiting ? null : _leave,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      widget.roomName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium(
                        color: Colors.white,
                      ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _Pill(
                    text: _connecting
                        ? context.tr.callConnecting
                        : context.tr.callLive,
                    color: _connecting ? Colors.white24 : Colors.green,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _connecting || room == null
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _VideoStage(room: room),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoundControlButton(
                    icon: _micEnabled ? Icons.mic : Icons.mic_off,
                    label: context.tr.callMic,
                    isActive: _micEnabled,
                    onTap: _toggleMic,
                  ),
                  SizedBox(width: 18.w),
                  if (widget.isVideo) ...[
                    _RoundControlButton(
                      icon: _camEnabled ? Icons.videocam : Icons.videocam_off,
                      label: context.tr.callCamera,
                      isActive: _camEnabled,
                      onTap: _toggleCam,
                    ),
                    SizedBox(width: 18.w),
                  ],
                  _RoundControlButton(
                    icon: Icons.call_end,
                    label: context.tr.callLeave,
                    isActive: true,
                    danger: true,
                    onTap: _leave,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoStage extends StatelessWidget {
  const _VideoStage({required this.room});
  final Room room;

  VideoTrack? _firstSubscribedVideo(Participant participant) {
    for (final pub in participant.videoTrackPublications) {
      final track = pub.track;
      if (track is VideoTrack) return track;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final remoteParticipants = room.remoteParticipants.values.toList();
    final remote = remoteParticipants.isNotEmpty
        ? remoteParticipants.first
        : null;
    final remoteVideo = remote == null ? null : _firstSubscribedVideo(remote);
    final local = room.localParticipant;
    final localVideo = local == null ? null : _firstSubscribedVideo(local);

    return Stack(
      children: [
        Positioned.fill(
          child: remoteVideo == null
              ? Center(
                  child: Text(
                    context.tr.callWaitingForOther,
                    style: AppTextStyles.bodyMedium(color: Colors.white70),
                  ),
                )
              : VideoTrackRenderer(remoteVideo, fit: VideoViewFit.cover),
        ),
        Positioned(
          right: 12.w,
          bottom: 12.h,
          child: SizedBox(
            width: 110.w,
            height: 150.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: ColoredBox(
                color: Colors.white10,
                child: localVideo == null
                    ? const SizedBox.shrink()
                    : VideoTrackRenderer(localVideo, fit: VideoViewFit.cover),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  const _RoundControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = danger
        ? Colors.red
        : isActive
        ? Colors.white
        : Colors.white24;
    final fg = danger ? Colors.white : (isActive ? Colors.black : Colors.white);

    return InkWell(
      borderRadius: BorderRadius.circular(999.r),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54.r,
            height: 54.r,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: fg, size: 24.sp),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: AppTextStyles.tiny(
              color: Colors.white70,
            ).copyWith(fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        text,
        style: AppTextStyles.tiny(
          color: Colors.white,
        ).copyWith(fontSize: 11.sp),
      ),
    );
  }
}
