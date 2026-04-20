// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get errorFieldRequired => 'Ce champ est obligatoire';

  @override
  String get errorInvalidName => 'Format de nom invalide';

  @override
  String get errorInvalidUrl => 'URL invalide';

  @override
  String get errorInvalidPhoneNumber => 'Numéro de téléphone invalide';

  @override
  String get errorInvalidEmail => 'Adresse e-mail invalide';

  @override
  String get errorInvalidPassword =>
      'Le mot de passe doit contenir au moins 8 caractères avec des majuscules, des minuscules et des caractères spéciaux';

  @override
  String get errorPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get errorInvalidNumber => 'Nombre invalide';

  @override
  String get errorInvalidIban => 'Format IBAN invalide';

  @override
  String get errorInvalidMobileNumber => 'Numéro de mobile invalide';

  @override
  String get errorInvalidStcPayId => 'Identifiant STC Pay invalide';

  @override
  String get errorInvalidNationalId => 'Numéro d\'identité nationale invalide';

  @override
  String get errorInvalidPassport => 'Numéro de passeport invalide';

  @override
  String get sorryMessage => 'Nous sommes désolés';

  @override
  String get nothingFound => 'Aucun résultat trouvé';

  @override
  String errorPhoneValidation(Object length, Object start) {
    return 'Le numéro de téléphone doit commencer par $start et contenir $length chiffres.';
  }

  @override
  String get errorExperienceRequired =>
      'Vous devez ajouter au moins une expérience.';

  @override
  String get errorIdDocumentRequired =>
      'Vous devez télécharger un document d\'identité pour vérifier votre identité.';

  @override
  String get errorPhotoRequired =>
      'Vous devez télécharger une photo avec un fond blanc';

  @override
  String get updateAvailableTitle => 'Mise à jour disponible';

  @override
  String get updateMandatoryMessage =>
      'Une nouvelle version de l\'application est disponible. Veuillez mettre à jour pour continuer à utiliser l\'application.';

  @override
  String get updateOptionalMessage =>
      'Une nouvelle version de l\'application est disponible. Nous vous recommandons de mettre à jour pour une meilleure expérience.';

  @override
  String get updateNow => 'Mettre à jour maintenant';

  @override
  String get skip => 'Ignorer';

  @override
  String get chooseImage => 'Téléverser choisir une image';

  @override
  String get takePicture => 'Téléverser prendre une photo';

  @override
  String get chooseFromFiles => 'Téléverser choisir depuis les fichiers';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsPushNotifications => 'Notifications push';

  @override
  String get settingsEmailNotifications => 'Notifications e-mail';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsToneAnalysis => 'Analyse du ton';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get navHomeTabLabel => 'Accueil';

  @override
  String get navScheduleTabLabel => 'Agenda';

  @override
  String get navNewsTabLabel => 'Actualités';

  @override
  String get navMessagesTabLabel => 'Messages';

  @override
  String get navExpenseTabLabel => 'Dépenses';

  @override
  String get scheduleSharedCalendarTitle => 'Calendrier partagé';

  @override
  String get scheduleNoEventsForDay => 'Aucun événement pour ce jour';

  @override
  String get scheduleEventTypePickup => 'Récupération';

  @override
  String get scheduleEventTypeMedical => 'Médical';

  @override
  String get scheduleEventTypeActivity => 'Activité';

  @override
  String get scheduleEventTypeSchool => 'École';

  @override
  String get scheduleEventTypeCustody => 'Garde';

  @override
  String get scheduleAllDay => 'Toute la journée';

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authLoginIntroTitle => 'Bienvenue sur Masr Al-Osariya';

  @override
  String get authLoginIntroSubtitle =>
      'Commencez à construire une expérience de coparentalité sûre et organisée.';

  @override
  String get authEmailTab => 'E-mail';

  @override
  String get authPhoneTab => 'Numéro de téléphone';

  @override
  String get authEmailLabel => 'E-mail';

  @override
  String get authEmailEntryHint => 'Entrez l’e-mail';

  @override
  String get authEmailHint => 'example@email.com';

  @override
  String get authPhoneLabel => 'Numéro de téléphone';

  @override
  String get authPhoneHint => '+20 123 456 7890';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authPasswordHint => '********';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authLoginButton => 'SE CONNECTER';

  @override
  String get authOrContinueWith => 'Ou continuer avec';

  @override
  String get authDontHaveAccountPrefix => 'Vous n’avez pas de compte ? ';

  @override
  String get authSignUp => 'S’inscrire';

  @override
  String get authSignUpTitle => 'Inscription';

  @override
  String get authSignUpIntroTitle =>
      'Comment allez-vous utiliser l’application ?';

  @override
  String get authSignUpIntroSubtitle =>
      'Choisissez l’option qui vous décrit le mieux.';

  @override
  String get authFullNameLabel => 'Nom complet';

  @override
  String get authFullNameHint => 'Nom complet';

  @override
  String get authFirstNameLabel => 'Prénom';

  @override
  String get authFirstNameHint => 'Jean';

  @override
  String get authLastNameLabel => 'Nom';

  @override
  String get authLastNameHint => 'Dupont';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authAgreeTermsPrefix => 'Veuillez accepter les ';

  @override
  String get authTermsAndConditions => 'Conditions générales';

  @override
  String get authAgreeTermsSuffix => ' pour continuer.';

  @override
  String get authAgreeTermsToContinue =>
      'Veuillez accepter les Conditions générales pour continuer.';

  @override
  String get authOrShort => 'Ou';

  @override
  String get authContinueWithGoogle => 'Continuer avec Google';

  @override
  String get authContinueWithApple => 'Continuer avec Apple';

  @override
  String get authSignUpButton => 'S’INSCRIRE';

  @override
  String get authAlreadyHaveAccountPrefix => 'Vous avez déjà un compte ? ';

  @override
  String get authLoginLink => 'CONNEXION';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileMenuAccountSecurity => 'Compte et sécurité';

  @override
  String get profileMenuFamilyInformation => 'Informations familiales';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuLanguage => 'Langue';

  @override
  String get profileMenuTermsOfUse => 'Conditions d’utilisation';

  @override
  String get profileMenuInvitePeople => 'Inviter des personnes';

  @override
  String get profileMenuLogout => 'Déconnexion';

  @override
  String get profileTermsTitle => 'Conditions d’utilisation';

  @override
  String get profileTermsBody =>
      'En utilisant cette application, vous acceptez les conditions suivantes. Veuillez les lire attentivement avant de continuer.\\n\\n1. Vous devez avoir au moins 18 ans pour utiliser ce service.\\n\\n2. Toutes les informations fournies doivent être exactes et à jour.\\n\\n3. Vous êtes responsable de la confidentialité de votre compte.\\n\\n4. Nous nous réservons le droit de modifier ces conditions à tout moment.\\n\\n5. Toute utilisation abusive de la plateforme peut entraîner la suspension du compte.';

  @override
  String get profileInviteTitle => 'Inviter des personnes';

  @override
  String get profileInviteDescription =>
      'Partagez votre code d’invitation avec votre famille et vos amis.';

  @override
  String get profileLogoutTitle => 'Déconnexion';

  @override
  String get profileLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get accountSecurityTitle => 'Compte et sécurité';

  @override
  String get accountSecurityEmailLabel => 'E-mail';

  @override
  String get accountSecurityPhoneLabel => 'Téléphone';

  @override
  String get accountSecurityChangePassword => 'Changer le mot de passe';

  @override
  String get accountSecurityEnableTwoFactor =>
      'Activer l’authentification à deux facteurs';

  @override
  String get accountSecurityDeleteAccount => 'Supprimer le compte';

  @override
  String get accountSecurityDeleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.';

  @override
  String get familyInfoTitle => 'Informations familiales';

  @override
  String get familyChildrenTitle => 'Enfants';

  @override
  String get familyAddChild => 'Ajouter un enfant';

  @override
  String get familyInfoSaved => 'Informations familiales enregistrées';

  @override
  String get familyCoParent => 'Co-parent';

  @override
  String get familyConnected => 'Connecté';

  @override
  String familyYearsOld(Object age) {
    return '$age ans';
  }

  @override
  String get familyChildNameHint => 'Nom de l’enfant';

  @override
  String get familyChildAgeHint => 'Âge';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'Aucune notification pour le moment';

  @override
  String get notificationsEmptySubtitle =>
      'Nous vous informerons dès qu’il y aura du nouveau';

  @override
  String get notificationsNewMessageTitle => 'Nouveau message';

  @override
  String get notificationsNewMessageBody =>
      'Fatima vous a envoyé un message au sujet du planning de ce week-end.';

  @override
  String get notificationsScheduleUpdatedTitle => 'Agenda mis à jour';

  @override
  String get notificationsScheduleUpdatedBody =>
      'Le planning de coparentalité de la semaine prochaine a été mis à jour.';

  @override
  String get notificationsExpenseAddedTitle => 'Dépense ajoutée';

  @override
  String get notificationsExpenseAddedBody =>
      'Une nouvelle dépense partagée de 500 EGP a été enregistrée.';

  @override
  String get notificationsReminderTitle => 'Rappel';

  @override
  String get notificationsReminderBody =>
      'N’oubliez pas la réunion parents-professeurs demain à 16 h.';

  @override
  String get notificationsSecurityAlertTitle => 'Alerte de sécurité';

  @override
  String get notificationsSecurityAlertBody =>
      'Un nouvel appareil a été utilisé pour se connecter à votre compte.';

  @override
  String timeMinutesAgo(Object minutes) {
    return 'Il y a $minutes min';
  }

  @override
  String timeHoursAgo(Object hours) {
    return 'Il y a $hours h';
  }

  @override
  String timeHoursAgoPlural(Object hours) {
    return 'Il y a $hours h';
  }

  @override
  String get timeYesterday => 'Hier';

  @override
  String timeDaysAgo(Object days) {
    return 'Il y a $days jours';
  }

  @override
  String get chatTypeMessageHint => 'Écrire un message...';

  @override
  String get updatePleaseUpdateToContinue =>
      'Veuillez mettre à jour l’application pour continuer.';

  @override
  String get updateNewVersionAvailableShort =>
      'Une nouvelle version est disponible.';

  @override
  String get languageSelectTitle => 'Choisir la langue';

  @override
  String get commonStart => 'Commencer';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesSearch => 'Rechercher';

  @override
  String get newsTitle => 'Actualités';

  @override
  String get expenseTitle => 'Dépenses';

  @override
  String get expenseTotalThisMonth => 'Total ce mois-ci';

  @override
  String get expenseYouPaid => 'Vous avez payé';

  @override
  String get expenseCoParentPaid => 'Co-parent a payé';

  @override
  String get expenseAddExpense => 'Ajouter une dépense';

  @override
  String get addExpenseTitle => 'Ajouter une dépense';

  @override
  String get addExpenseCategoryLabel => 'Catégorie';

  @override
  String get addExpenseSelectCategoryHint => 'Sélectionner une catégorie';

  @override
  String get addExpenseDateLabel => 'Date';

  @override
  String get addExpenseSelectDateHint => 'Sélectionner une date';

  @override
  String get addExpenseAmountLabel => 'Montant';

  @override
  String get addExpenseEnterAmountHint => 'Saisir le montant';

  @override
  String get addExpenseAmountRequired => 'Le montant est obligatoire';

  @override
  String get addExpenseEnterValidAmount => 'Saisissez un montant valide';

  @override
  String get addExpenseCurrencyLabel => 'Devise';

  @override
  String get addExpenseSelectCurrencyHint => 'Sélectionner une devise';

  @override
  String get addExpenseDescriptionLabel => 'Description';

  @override
  String get addExpenseEnterDescriptionHint => 'Saisir la description';

  @override
  String get addExpenseProofOfPurchaseLabel => 'Justificatif d’achat';

  @override
  String get addExpenseTapToUpload => 'Appuyez pour téléverser';

  @override
  String get addExpenseUploadFormats => 'JPG, PNG ou PDF';

  @override
  String get addExpenseAlreadyPaidQuestion =>
      'Avez-vous déjà payé cette dépense ?';

  @override
  String get ourMissionDescription =>
      'Notre mission est de fournir des solutions de chimie de la construction haute performance répondant aux plus hauts standards de qualité, de sécurité et de durabilité. Nous accompagnons nos clients avec des produits innovants et des conseils d’experts afin de leur permettre d’obtenir des résultats de construction durables, efficaces et respectueux de l’environnement.';

  @override
  String get onboardingSkip => 'Ignorer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get onboardingGetStarted => 'Commencer !';

  @override
  String get onboardingLogin => 'Connexion';

  @override
  String get onboardingJoinUsingCode => 'Rejoindre avec un code';

  @override
  String get onboardingPage1Title => 'Une meilleure façon de coparenter';

  @override
  String get onboardingPage1Subtitle =>
      'Un espace sécurisé conçu pour aider les parents à communiquer, s’organiser et prendre des décisions avec moins de conflits et plus de clarté.';

  @override
  String get onboardingPage2Title => 'Une communication claire et respectueuse';

  @override
  String get onboardingPage2Subtitle =>
      'Tous les messages sont documentés, horodatés et ne peuvent être ni modifiés ni supprimés, pour des échanges responsables et constructifs.';

  @override
  String get onboardingPage3Title =>
      'Documents importants, stockés en toute sécurité';

  @override
  String get onboardingPage3Subtitle =>
      'Gardez les documents médicaux, scolaires, juridiques et financiers chiffrés et accessibles avec un historique complet des accès.';

  @override
  String get onboardingPage4Title =>
      'Fondé sur la confiance et la confidentialité';

  @override
  String get onboardingPage4Subtitle =>
      'Vos données sont protégées par des mesures de sécurité solides et traitées conformément à la loi égyptienne sur la protection des données.';

  @override
  String get authVerifyTitle => 'Vérification';

  @override
  String get authVerifyCodeHeading => 'Entrez le code de vérification';

  @override
  String get authVerifySubtitle =>
      'Nous avons envoyé un code de vérification à votre adresse e-mail. Veuillez le saisir ci-dessous.';

  @override
  String get authDidntReceive => 'Vous n\'avez pas reçu le code ?';

  @override
  String get authResend => 'Renvoyer';

  @override
  String get authContinue => 'Continuer';

  @override
  String get authVerificationCodeSent =>
      'Code de vérification envoyé avec succès';

  @override
  String get authRoleOptionsTitle => 'Options de rôle';

  @override
  String get authRoleOptionsHeading =>
      'Comment allez-vous utiliser l\'application ?';

  @override
  String get authRoleOptionsSubtitle =>
      'Choisissez l\'option qui décrit le mieux votre situation.';

  @override
  String get authRoleFamilySpace => 'Espace familial';

  @override
  String get authRoleFamilySpaceDesc =>
      'Coparentez avec votre partenaire dans un espace familial partagé.';

  @override
  String get authRoleSolo => 'Solo';

  @override
  String get authRoleSoloDesc =>
      'Gérez votre emploi du temps parental de manière indépendante.';

  @override
  String get authNext => 'Suivant';

  @override
  String get authCoParentDetailsTitle => 'Détails du co-parent';

  @override
  String get authCoParentDetailsHeading => 'Invitez votre co-parent';

  @override
  String get authCoParentDetailsSubtitle =>
      'Entrez les détails de votre co-parent pour lui envoyer une invitation.';

  @override
  String get authCoParentFirstName => 'Prénom';

  @override
  String get authCoParentLastName => 'Nom';

  @override
  String get authCoParentEmail => 'E-mail';

  @override
  String get authCoParentPhone => 'Numéro de téléphone';

  @override
  String get authCoParentDate => 'Date de naissance';

  @override
  String get authCoParentNote =>
      'Votre co-parent recevra une invitation par e-mail pour rejoindre l\'espace familial.';

  @override
  String get familyChildDisplayNameLabel => 'Nom d\'affichage';

  @override
  String get familyChildDisplayNameHint => 'Entrez le nom d\'affichage';

  @override
  String get familyChildFirstNameLabel => 'Prénom';

  @override
  String get familyChildFirstNameHint => 'Entrez le prénom';

  @override
  String get familyChildLastNameLabel => 'Nom';

  @override
  String get familyChildLastNameHint => 'Entrez le nom';

  @override
  String get familyChildEmailLabel => 'E-mail';

  @override
  String get familyChildEmailHint => 'Entrez l\'adresse e-mail';

  @override
  String get familyChildPhoneLabel => 'Numéro de téléphone';

  @override
  String get familyChildPhoneHint => 'Entrez le numéro de téléphone';

  @override
  String get familyChildDateOfBirthLabel => 'Date de naissance';

  @override
  String get familyChildDateOfBirthHint => 'JJ-MM-AAAA';

  @override
  String get familyChildAddedSuccess => 'Enfant ajouté avec succès';

  @override
  String get authForgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get authForgotPasswordHeading => 'Réinitialiser votre mot de passe';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre adresse e-mail et nous vous enverrons un code pour réinitialiser votre mot de passe.';

  @override
  String get authForgotPasswordButton => 'ENVOYER LE CODE';

  @override
  String get authForgotPasswordOtpTitle => 'Vérifier le code';

  @override
  String get authForgotPasswordOtpHeading =>
      'Entrez le code de réinitialisation';

  @override
  String get authForgotPasswordOtpSubtitle =>
      'Nous avons envoyé un code de réinitialisation à votre adresse e-mail.';

  @override
  String get authResetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get authResetPasswordHeading => 'Créer un nouveau mot de passe';

  @override
  String get authResetPasswordSubtitle =>
      'Votre nouveau mot de passe doit être différent de votre mot de passe précédent.';

  @override
  String get authNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get authNewPasswordHint => '********';

  @override
  String get authConfirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get authResetPasswordButton => 'RÉINITIALISER';

  @override
  String get authPasswordResetSuccess =>
      'Votre mot de passe a été réinitialisé avec succès.';

  @override
  String get authBackToLogin => 'Retour à la connexion';
}
