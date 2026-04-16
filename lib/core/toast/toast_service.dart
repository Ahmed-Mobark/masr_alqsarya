import 'dart:math';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/core/toast/custom_toast.dart';
import 'package:flutter/material.dart';

class ToastViewManager<T> extends ValueNotifier<T> {
  ToastViewManager(super.val);
}

enum ToastLength {short, medium, long, ages, never }

class ToastService {
  static final ToastViewManager<int> _expandedIndex = ToastViewManager<int>(-1);
  static final List<OverlayEntry?> _overlayEntries = [];
  static final List<double> _overlayPositions = [];
  static final List<int> _overlayIndexList = [];
  static final List<AnimationController?> _animationControllers = [];
  static OverlayState? _overlayState;
  static int? _showToastNumber;

  static void showToastNumber(int val) {
    assert(val > 0, "Show toast number can't be negative or zero. Default show toast number is 5.");
    if (val > 0) {_showToastNumber = val;}
  }

  static void _reverseAnimation(int index) {
    if (_overlayIndexList.contains(index)) {
      _animationControllers[index]?.reverse().then((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        _removeOverlayEntry(index);
      });
    }
  }

  static void _removeOverlayEntry(int index) {
    _overlayEntries[index]?.remove();
    _animationControllers[index]?.dispose();
    _overlayIndexList.remove(index);
  }

  static void _forwardAnimation(int index) {
    _overlayState?.insert(_overlayEntries[index]!);
    _animationControllers[index]?.forward();
  }

  static double _calculatePosition(int index) {
    return _overlayPositions[index];
  }

  static void _addOverlayPosition(int index) {
    _overlayPositions.add(40);
    _overlayIndexList.add(index);
  }

  static bool _isToastInFront(int index) => index > _overlayPositions.length - 5;

  static void _updateOverlayPositions({bool isReverse = false, int pos = 0}) {
    if (isReverse) {
      _reverseUpdatePositions(pos: pos);
    } else {
      _forwardUpdatePositions();
    }
  }

  static void _rebuildPositions() {
    for (int i = 0; i < _overlayPositions.length; i++) {
      _overlayEntries[i]?.markNeedsBuild();
    }
  }

  static void _reverseUpdatePositions({int pos = 0}) {
    for (int i = pos - 1; i >= 0; i--) {
      _overlayPositions[i] = _overlayPositions[i] - 10;
      _overlayEntries[i]?.markNeedsBuild();
    }
  }

  static void _forwardUpdatePositions() {
    for (int i = 0; i < _overlayPositions.length; i++) {
      _overlayPositions[i] = _overlayPositions[i] + 10;
      _overlayEntries[i]?.markNeedsBuild();
    }
  }

  static double _calculateOpacity(int index) {
    int noOfShowToast = _showToastNumber ?? 5;
    if (_overlayIndexList.length <= noOfShowToast) return 1;
    final isFirstFiveToast = _overlayIndexList.sublist(_overlayIndexList.length - noOfShowToast).contains(index);
    return isFirstFiveToast ? 1 : 0;
  }

  static void _toggleExpand(int index) {
    if (_expandedIndex.value == index) {
      _expandedIndex.value = -1;
    } else {
      _expandedIndex.value = index;
    }
    _rebuildPositions();
  }

  static Duration _toastDuration(ToastLength length) {
    return switch (length) {
      ToastLength.short => const Duration(milliseconds: 2000),
      ToastLength.medium => const Duration(milliseconds: 4000),
      ToastLength.long => const Duration(milliseconds: 6000),
      ToastLength.ages => const Duration(minutes: 2),
      ToastLength.never => Duration.zero
    };
  }

  static Future<void> _showToast(
    BuildContext context, {
    required ToastType type,
    required String message,
    String? description,
    TextStyle? messageStyle,
    TextStyle? descriptionStyle,
    Curve? slideCurve,
    bool topView = false,
    bool isClosable = false,
    double expandedHeight = 100,
    Curve positionCurve = Curves.elasticOut,
    ToastLength length = ToastLength.short,
    DismissDirection dismissDirection = DismissDirection.down,
  }) async {
    assert(expandedHeight >= 0.0, "Expanded height should not be a negative number!");
    if (context.mounted) {
      _overlayState = Overlay.of(context);
      final controller = AnimationController(
        vsync: _overlayState!,
        duration: const Duration(milliseconds: 1000),
        reverseDuration: const Duration(milliseconds: 1000),
      );
      _animationControllers.add(controller);
      int controllerIndex = _animationControllers.indexOf(controller);
      _addOverlayPosition(controllerIndex);
      final overlayEntry = OverlayEntry(
        builder: (context) => AnimatedPositioned(
          top: topView?_calculatePosition(controllerIndex) + (_expandedIndex.value == controllerIndex ? expandedHeight : 0.0):null,
          left: 10,
          right: 10,
          bottom: topView?null:30,
          duration: const Duration(milliseconds: 500),
          curve: positionCurve,
          child: Dismissible(
            key: Key(UniqueKey().toString()),
            direction: dismissDirection,
            onDismissed: (_) {
              _removeOverlayEntry(_animationControllers.indexOf(controller));
              _updateOverlayPositions(
                isReverse: true,
                pos: _animationControllers.indexOf(controller),
              );
            },
            child: AnimatedPadding(
              padding: EdgeInsets.symmetric(horizontal: (_expandedIndex.value == controllerIndex ? 10 : max(_calculatePosition(controllerIndex) - 35, 0.0))),
              duration: const Duration(milliseconds: 500),
              curve: positionCurve,
              child: AnimatedOpacity(
                opacity: _calculateOpacity(controllerIndex),
                duration: const Duration(milliseconds: 500),
                child: CustomToast(
                  type: type,
                  message: message,
                  description: description,
                  messageStyle: messageStyle,
                  descriptionStyle: descriptionStyle,
                  curve: slideCurve,
                  isClosable: isClosable,
                  isInFront: _isToastInFront(_animationControllers.indexOf(controller)),
                  controller: controller,
                  onTap: () => _toggleExpand(controllerIndex),
                  onClose: () {
                    _removeOverlayEntry(_animationControllers.indexOf(controller));
                    _updateOverlayPositions(isReverse: true, pos: _animationControllers.indexOf(controller));
                  },
                ),
              ),
            ),
          ),
        ),
      );
      _overlayEntries.add(overlayEntry);
      _updateOverlayPositions();
      _forwardAnimation(_animationControllers.indexOf(controller));
      await Future.delayed(_toastDuration(length));
      _reverseAnimation(_animationControllers.indexOf(controller));
    }
  }

  
  static Future<void> showToast(
    BuildContext context, {
    required ToastType type,
    required String message,
    String? description,
    TextStyle? messageStyle,
    TextStyle? descriptionStyle,
    Curve? slideCurve,
    bool? topView = false,
    bool? isClosable = false,
    double? expandedHeight = 100,
    Curve? positionCurve = Curves.elasticOut,
    ToastLength? length = ToastLength.medium,
    DismissDirection? dismissDirection = DismissDirection.down,
  }) async {
    _showToast(
      context,
      type: type,
      message: message,
      description: description,
      messageStyle: messageStyle,
      descriptionStyle: descriptionStyle,
      slideCurve: slideCurve,
      topView: topView = true,
      isClosable: isClosable = false,
      expandedHeight: expandedHeight = 100,
      positionCurve: positionCurve = Curves.elasticOut,
      length: length = ToastLength.short,
      dismissDirection: dismissDirection = DismissDirection.down,
    );
  }
}