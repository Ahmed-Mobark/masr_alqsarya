class AppEndpoints {
  static String baseUrl =
      "https://misr-alosariya_back-uqudc3ap.on-forge.com/api/v1/";

  /// Soketi app key (same as `/app/{key}` in the Soketi dashboard URL).
  static const String soketiAppKey = 'cihrywvayxv8nguraxqy';

  /// If Soketi WebSocket is **not** on the same host as [baseUrl], set this
  /// (e.g. a dedicated `ws.` subdomain or server IP).
  ///
  /// `null` → use API host from [baseUrl] (only works if a reverse proxy
  /// forwards `wss://api-host/app/{key}` to Soketi).
  static String? realtimeWebSocketHost;

  /// Soketi default is often `6001`. If TLS terminates on 443 and nginx
  /// proxies WebSocket, leave `null` to use default port for `wss` (443).
  ///
  /// Set when clients connect directly to Soketi, e.g. `6001`.
  static int? realtimeWebSocketPort;

  /// Path for Laravel `Broadcast::routes()` auth endpoint (POST).
  ///
  /// For mobile Bearer tokens, routes must use Sanctum, e.g.
  /// `Broadcast::routes(['middleware' => ['auth:sanctum']]);`
  /// and return JSON `{"auth":"..."}` (not an empty HTML response).
  static const String broadcastingAuthPath = '/broadcasting/auth';

  /// WebSocket host (same host as the API unless [realtimeWebSocketHost] set).
  static String get soketiHost =>
      realtimeWebSocketHost ?? Uri.parse(baseUrl).host;

  /// Port for WebSocket; [realtimeWebSocketPort] wins, else infer from API URL.
  static int? get soketiPort {
    if (realtimeWebSocketPort != null) return realtimeWebSocketPort;
    final p = Uri.parse(baseUrl).port;
    if (p == 0 || p == 443 || p == 80) return null;
    return p;
  }

  /// Laravel [broadcasting/auth] for private/presence channel signatures.
  static String get broadcastingAuthUrl {
    final u = Uri.parse(baseUrl);
    return Uri(
      scheme: u.scheme,
      host: u.host,
      port: u.hasPort ? u.port : null,
      path: broadcastingAuthPath,
    ).toString();
  }

  /// Chat private channel name (Pusher protocol).
  ///
  /// Backend doc:
  /// - Server channel: `workspace.{workspaceId}.chat.{chatId}`
  /// - Client subscribes to: `private-workspace.{workspaceId}.chat.{chatId}`
  static String privateChatChannelName({
    required int workspaceId,
    required int chatId,
  }) => 'private-workspace.$workspaceId.chat.$chatId';

  // Auth
  static const String authRegister = "auth/register";
  static const String authVerifyEmail = "auth/verify-email-code";
  static const String authResendCode = "auth/resend-verification-code";
  static const String authLogin = "auth/login";
  static const String authLogout = "auth/logout";
  static const String authUser = "auth/user";
  static const String authTwoFactorChallenge = "auth/two-factor-challenge";
  static const String authForgotPassword = "auth/forgot-password";
  static const String authVerifyResetCode = "auth/verify-reset-code";
  static const String authResetPassword = "auth/reset-password";

  // News
  static const String newsFeeds = "news-feeds";
  static String newsFeedReactions(int feedId) => "news-feeds/$feedId/reactions";

  // Family Workspace
  static const String workspace = "workspace";
  static const String workspaceUpgradeToFamily = "workspace/upgrade-to-family";
  static String workspaceChats(int workspaceId) =>
      "workspaces/$workspaceId/chats";
  static String workspaceChatMessages(int workspaceId, int chatId) =>
      "workspaces/$workspaceId/chats/$chatId/messages";
  static String workspaceChatAttachmentDownload(
    int workspaceId,
    int chatId,
    int attachmentId,
  ) =>
      "workspaces/$workspaceId/chats/$chatId/attachments/$attachmentId/download";
  static String workspaceUploadedFiles(int workspaceId) =>
      "workspaces/$workspaceId/uploaded-files";

  static String workspaceUploadedFileDetail(int workspaceId, int assetId) =>
      "workspaces/$workspaceId/uploaded-files/$assetId";

  static String workspaceUploadedFilePermissions(
    int workspaceId,
    int assetId,
  ) => "workspaces/$workspaceId/uploaded-files/$assetId/permissions";

  static String workspaceUploadedFileActivity(
    int workspaceId,
    int assetId,
  ) => "workspaces/$workspaceId/uploaded-files/$assetId/activity";

  static String workspaceUploadedFileEvidence(int workspaceId, int assetId) =>
      "workspaces/$workspaceId/uploaded-files/$assetId/evidence";

  // Calls
  static String workspaceCalls(int workspaceId) =>
      "workspaces/$workspaceId/calls";
  static String workspaceCallJoin(int workspaceId, int callId) =>
      "workspaces/$workspaceId/calls/$callId/join";
  static String workspaceCallRecordingStart(int workspaceId, int callId) =>
      "workspaces/$workspaceId/calls/$callId/recording/start";
  static String workspaceCallRecordingConsent(int workspaceId, int callId) =>
      "workspaces/$workspaceId/calls/$callId/recording/consent";
  static String workspaceCallEnd(int workspaceId, int callId) =>
      "workspaces/$workspaceId/calls/$callId/end";
  static String workspaceCallCancel(int workspaceId, int callId) =>
      "workspaces/$workspaceId/calls/$callId/cancel";

  // Calendar
  static String workspaceCalendarItems(int workspaceId) =>
      "workspaces/$workspaceId/calendar-items";
  static String workspaceCalendarItemTypes(int workspaceId) =>
      "workspaces/$workspaceId/calendar-items/types";
  static const String inviteCoPartner = "family-workspace/invite-co-partner";
  static const String addChild = "family-workspace/add-child";
  static const String familyWorkspaceMembers = "family-workspace/members";
  static const String familyWorkspaceJoinByCode =
      "family-workspace/invitations/respond";

  // Expenses
  static String workspaceRegularExpenses(int workspaceId) =>
      "workspaces/$workspaceId/regular-expenses";
  static String workspaceRegularExpenseDetails(
    int workspaceId,
    int expenseId,
  ) => "workspaces/$workspaceId/regular-expenses/$expenseId";
  static String workspaceSupportExpenses(int workspaceId) =>
      "workspaces/$workspaceId/support-expenses";
  static String workspaceSupportExpenseDetails(
    int workspaceId,
    int expenseId,
  ) => "workspaces/$workspaceId/support-expenses/$expenseId";

  // Categories
  static const String categories = "categories";
}
