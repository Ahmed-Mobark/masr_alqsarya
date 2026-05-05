import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// In-app playback for session-library URLs (pages or direct media).
class SessionLibraryWatchView extends StatefulWidget {
  const SessionLibraryWatchView({
    super.key,
    required this.initialUrl,
    this.title,
  });

  final String initialUrl;
  final String? title;

  @override
  State<SessionLibraryWatchView> createState() =>
      _SessionLibraryWatchViewState();
}

class _SessionLibraryWatchViewState extends State<SessionLibraryWatchView> {
  late final WebViewController _controller;
  var _loading = true;
  String? _error;
  var _badUrl = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (err) {
            if (mounted) {
              setState(() {
                _loading = false;
                _error = err.description;
              });
            }
          },
        ),
      );
    _loadContent();
  }

  bool _looksLikeDirectMedia(Uri uri) {
    final p = uri.path.toLowerCase();
    return p.endsWith('.mp4') ||
        p.endsWith('.webm') ||
        p.endsWith('.m3u8') ||
        p.endsWith('.mov');
  }

  String _htmlVideoPage(String src) {
    final escaped = src
        .replaceAll('&', '&amp;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('<', '&lt;');
    return '<!DOCTYPE html><html><head>'
        '<meta charset="utf-8">'
        '<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">'
        '</head><body style="margin:0;background:#000;display:flex;align-items:center;justify-content:center;">'
        '<video controls playsinline webkit-playsinline style="width:100%;max-height:100vh;" src="$escaped"></video>'
        '</body></html>';
  }

  Future<void> _loadContent() async {
    final raw = widget.initialUrl.trim();
    if (raw.isEmpty) {
      if (mounted) {
        setState(() {
          _loading = false;
          _badUrl = true;
        });
      }
      return;
    }

    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme) {
      if (mounted) {
        setState(() {
          _loading = false;
          _badUrl = true;
        });
      }
      return;
    }

    if (_looksLikeDirectMedia(uri)) {
      await _controller.loadHtmlString(
        _htmlVideoPage(raw),
        baseUrl: '${uri.scheme}://${uri.host}/',
      );
    } else {
      await _controller.loadRequest(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final title = (widget.title?.trim().isNotEmpty ?? false)
        ? widget.title!.trim()
        : tr.sessionsLibraryWatchInAppTitle;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 24.sp,
            color: AppColors.darkText,
          ),
          onPressed: () => sl<AppNavigator>().pop(),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 15.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          if (!_badUrl)
            Positioned.fill(
              child: WebViewWidget(controller: _controller),
            ),
          if (_badUrl)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  tr.sessionsLibraryWatchLoadFailed,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: Colors.white70),
                ),
              ),
            ),
          if (_loading && !_badUrl)
            const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            ),
          if (_error != null && _error!.isNotEmpty && !_badUrl)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
