import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/features/sessions/domain/entities/live_session_summary.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/widgets/session_offer_card.dart';

class LiveSessionListTile extends StatelessWidget {
  const LiveSessionListTile({
    super.key,
    required this.session,
    required this.onJoin,
    required this.onBookNow,
    this.isBooking = false,
  });

  final LiveSessionSummary session;
  final VoidCallback onJoin;
  final VoidCallback onBookNow;
  final bool isBooking;

  static const String _dash = '\u2014';

  static String _statusBadgeLabel(BuildContext context, String code) {
    switch (code.toLowerCase().trim()) {
      case 'upcoming':
        return context.tr.sessionsStatusUpcoming;
      case 'scheduled':
        return context.tr.sessionsStatusScheduled;
      case 'live':
        return context.tr.sessionsStatusLive;
      case 'ended':
        return context.tr.sessionsStatusEnded;
      case 'archived':
        return context.tr.sessionsStatusArchived;
      default:
        if (code.isEmpty) return context.tr.sessionsStatusUpcoming;
        return code;
    }
  }

  static String _sessionTypeCorner(BuildContext context, LiveSessionSummary s) {
    if (s.isBooked == true) return context.tr.sessionsBookedBadge;
    final v = s.visibility?.toLowerCase().trim();
    if (v == 'private') return context.tr.sessionsPrivate;
    if (v == 'public') return context.tr.sessionsPublic;
    return _statusBadgeLabel(context, s.status);
  }

  static String _primaryCta(BuildContext context, LiveSessionSummary s) {
    if (!(s.isBooked ?? false)) return context.tr.sessionsBookNow;
    final v = s.visibility?.toLowerCase().trim();
    if (v == 'private') return context.tr.sessionsBookSession;
    return context.tr.sessionsJoin;
  }

  String _dateLabel(BuildContext context) {
    final d = session.startsAt;
    if (d == null) return _dash;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).format(d.toLocal());
  }

  String _timeLabel(BuildContext context) {
    final d = session.startsAt;
    if (d == null) return _dash;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.jm(locale).format(d.toLocal());
  }

  String _durationLabel(BuildContext context) {
    final m = session.durationMinutes;
    if (m == null) return _dash;
    return context.tr.sessionLobbyDurationValue(m);
  }

  bool _showJoinButton() {
    if (session.status.toLowerCase().trim() == 'live') return true;
    final start = session.startsAt?.toLocal();
    if (start == null) return false;
    return !DateTime.now().isBefore(start);
  }

  bool _showPrimaryButton() {
    if (!(session.isBooked ?? false)) return true;
    return _showJoinButton();
  }

  VoidCallback _onPrimaryTap() {
    if (!(session.isBooked ?? false)) return onBookNow;
    return onJoin;
  }

  @override
  Widget build(BuildContext context) {
    final role = session.mediatorTitle.trim().isNotEmpty
        ? session.mediatorTitle
        : session.title;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        // Card tap should always open details; booking is explicit via CTA button.
        onTap: onJoin,
        borderRadius: BorderRadius.circular(20.r),
        child: SessionOfferCard(
          sessionTypeLabel: _sessionTypeCorner(context, session),
          expertName: session.mediatorName.isNotEmpty
              ? session.mediatorName
              : session.title,
          expertRole: session.mediatorName.isNotEmpty ? role : '',
          ratingLabel: session.mediatorRating,
          primaryLabel: _primaryCta(context, session),
          onPrimaryPressed: _onPrimaryTap(),
          showPrimaryButton: _showPrimaryButton(),
          isPrimaryLoading: isBooking,
          networkImageUrl: session.mediatorImageUrl,
          scheduleDateLabel: _dateLabel(context),
          scheduleTimeLabel: _timeLabel(context),
          scheduleDurationLabel: _durationLabel(context),
        ),
      ),
    );
  }
}
