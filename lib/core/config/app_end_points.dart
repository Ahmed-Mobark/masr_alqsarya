class AppEndpoints {
  static String baseUrl =
      "https://misr-alosariya_back-uqudc3ap.on-forge.com/api/v1/";

  /// Soketi app key (same as `/app/{key}` in the Soketi dashboard URL).
  static const String soketiAppKey = 'cihrywvayxv8nguraxqy';

  /// WebSocket host (same host as the API, no path).
  static String get soketiHost => Uri.parse(baseUrl).host;

  /// Optional explicit WSS port; `null` = default (443 for `wss`).
  static int? get soketiPort {
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
      path: '/broadcasting/auth',
    ).toString();
  }

  /// Must match the server-side private channel name (e.g. `PrivateChannel('chat.'.$id)` → `private-chat.$id`).
  static String privateChatChannelName(int chatId) => 'private-chat.$chatId';

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
  static const String inviteCoPartner = "family-workspace/invite-co-partner";
  static const String addChild = "family-workspace/add-child";
}
