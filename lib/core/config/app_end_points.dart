class AppEndpoints {
  static String baseUrl =
      "https://misr-alosariya_back-uqudc3ap.on-forge.com/api/v1/";

  // Auth
  static const String authRegister = "auth/register";
  static const String authVerifyEmail = "auth/verify-email-code";
  static const String authResendCode = "auth/resend-verification-code";
  static const String authLogin = "auth/login";
  static const String authLogout = "auth/logout";
  static const String authUser = "auth/user";
  static const String authTwoFactorChallenge = "auth/two-factor-challenge";

  // Family Workspace
  static const String inviteCoPartner = "family-workspace/invite-co-partner";
  static const String addChild = "family-workspace/add-child";
}
