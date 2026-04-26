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
  String get profileMoreInformation => 'Plus d’informations';

  @override
  String get profileMenuAccount => 'Compte';

  @override
  String get profileMenuFamilySpace => 'Espace familial';

  @override
  String get profileMenuPrivacySecurity => 'Confidentialité et sécurité';

  @override
  String get profileMenuNotification => 'Notification';

  @override
  String get profileMenuAccountSecurity => 'Compte et sécurité';

  @override
  String get profileMenuFamilyInformation => 'Informations familiales';

  @override
  String get profileMenuNotifications => 'Notifications';

  @override
  String get profileMenuLanguage => 'Langue';

  @override
  String get profileMenuLegalTerms => 'Mentions légales et conditions';

  @override
  String get profileMenuTermsOfUse => 'Conditions d’utilisation';

  @override
  String get profileMenuInvitePeople => 'Inviter des personnes';

  @override
  String get profileMenuDeleteAccount => 'Supprimer le compte';

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
  String get accountSecurityPersonalInfo => 'Informations personnelles';

  @override
  String get accountSecurityFirstNameLabel => 'Prénom';

  @override
  String get accountSecurityLastNameLabel => 'Nom de famille';

  @override
  String get accountSecurityEmailAddressLabel => 'Adresse e-mail';

  @override
  String get accountSecurityPhoneNumberLabel => 'Numéro de téléphone';

  @override
  String get accountSecurityEmailLabel => 'E-mail';

  @override
  String get accountSecurityPhoneLabel => 'Téléphone';

  @override
  String get accountSecurityChangePassword => 'Changer le mot de passe';

  @override
  String get accountSecurityEmailMissingForPassword =>
      'Aucune adresse e-mail n’est associée à votre compte. Ajoutez-en une avant de changer le mot de passe.';

  @override
  String get accountSecurityEnableTwoFactor =>
      'Activer l’authentification à deux facteurs';

  @override
  String get accountSecurityDeleteAccount => 'Supprimer le compte';

  @override
  String get accountSecurityDeleteConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.';

  @override
  String get languageDeviceLanguage => 'Langue de l’appareil';

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
  String get messagesAll => 'Tous';

  @override
  String get messagesUnread => 'Non lus';

  @override
  String get messagesMarkAllRead => 'Tout marquer comme lu';

  @override
  String get messagesLoadError => 'Impossible de charger les conversations.';

  @override
  String get messagesWorkspaceMissing =>
      'L’espace de travail n’est pas prêt. Reconnectez-vous.';

  @override
  String get messagesEmptyTitle => 'Aucune conversation';

  @override
  String get messagesEmptySubtitle =>
      'Vos fils de discussion apparaîtront ici.';

  @override
  String get messagesRetry => 'Réessayer';

  @override
  String get chatLoadError => 'Impossible de charger les messages.';

  @override
  String get chatEmptyTitle => 'Aucun message';

  @override
  String get chatEmptySubtitle => 'Envoyez un message pour démarrer.';

  @override
  String get messagesRoleOwner => 'Titulaire';

  @override
  String get messagesRoleCoPartner => 'Co-parent';

  @override
  String get messagesRoleChild => 'Enfant';

  @override
  String get messagesNoPreview => 'Aucun message';

  @override
  String get chatAttachmentFallback => 'Pièce jointe';

  @override
  String get chatAttachmentDownloadAction => 'Télécharger';

  @override
  String get chatAttachmentDownloadFailed =>
      'Impossible de télécharger le fichier.';

  @override
  String chatAttachmentDownloadSuccess(String fileName) {
    return 'Enregistré : $fileName';
  }

  @override
  String get newsTitle => 'Actualités';

  @override
  String get expenseTitle => 'Dépenses';

  @override
  String get expenseRegularExpense => 'Dépense régulière';

  @override
  String get expenseSupportPayment => 'Pension alimentaire';

  @override
  String get expenseChildName => 'Nom de l\'enfant';

  @override
  String get expenseSubmittedBy => 'Soumis par';

  @override
  String get expenseReferenceNumber => 'Numéro de référence';

  @override
  String get expensePaymentPeriod => 'Période de paiement';

  @override
  String get expenseCourtCase => 'Dossier judiciaire';

  @override
  String get expensePaidBadge => 'PAYÉ';

  @override
  String get expenseViewReceipt => 'VOIR LE REÇU';

  @override
  String get expenseTotalThisMonth => 'Total ce mois-ci';

  @override
  String get expenseYouPaid => 'Vous avez payé';

  @override
  String get expenseCoParentPaid => 'Co-parent a payé';

  @override
  String get expenseAddExpense => 'Ajouter une dépense';

  @override
  String get invoiceTitle => 'Facture';

  @override
  String get invoiceNumberPrefix => 'Facture #';

  @override
  String get invoiceExpenseInformation => 'Informations sur la dépense';

  @override
  String get invoiceCategory => 'Catégorie';

  @override
  String get invoiceDateOfService => 'Date de service';

  @override
  String get invoiceDescription => 'Description';

  @override
  String get invoicePaymentDetails => 'Détails du paiement';

  @override
  String get invoiceReferenceNumber => 'Numéro de référence';

  @override
  String get invoicePaidOn => 'Payé le';

  @override
  String get invoicePaymentMethod => 'Méthode de paiement';

  @override
  String get invoiceVerifiedBy => 'Vérifié par';

  @override
  String get invoiceAttachments => 'Pièces jointes';

  @override
  String get addExpenseTitle => 'Ajouter une dépense';

  @override
  String get addExpenseChildLabel => 'Enfant';

  @override
  String get addExpenseChildBothChildren => 'Les deux enfants';

  @override
  String get addExpensePayerName => 'Nom du payeur';

  @override
  String get addExpensePayerId => 'ID du payeur';

  @override
  String get addExpensePayeeName => 'Nom du bénéficiaire';

  @override
  String get addExpensePayeeId => 'ID du bénéficiaire';

  @override
  String get addExpenseFieldHint => 'Titre de la dépense';

  @override
  String get addExpenseCurrencyRequired => 'La devise est obligatoire';

  @override
  String get addExpenseExpenseTitleLabel => 'Titre de la dépense';

  @override
  String get addExpenseCategoryMedical => 'Médical';

  @override
  String get addExpenseCategoryGroceries => 'épicerie';

  @override
  String get addExpenseDatePlaceholder => 'Date';

  @override
  String get addExpenseNotesOptional => 'Notes ( Optionnel )';

  @override
  String get addExpenseNotesHint => 'note';

  @override
  String get addExpenseYesIPaidIt => 'Oui, je l’ai payée';

  @override
  String get addExpenseNotPaidYet => 'Non, elle n’a pas encore été payée';

  @override
  String get addExpenseUploadReceiptOrInvoice =>
      'Téléverser le reçu ou la facture';

  @override
  String get addExpenseProofTooLarge =>
      'Le fichier est trop volumineux (max 5 Mo).';

  @override
  String get addExpenseProofPickFailed =>
      'Impossible de sélectionner le fichier.';

  @override
  String get addExpenseSubmitExpense => 'Soumettre la dépense';

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
  String get authOnboardingAddChildTitle => 'Ajouter des enfants';

  @override
  String get authOnboardingAddChildHeading => 'Informations sur l’enfant';

  @override
  String get authOnboardingAddChildSubtitle =>
      'Saisissez les informations de chaque enfant. Appuyez sur « Ajouter un autre » pour enregistrer et saisir un autre enfant, ou sur « Suivant » pour terminer et accéder à l’application.';

  @override
  String get authAddAnotherChild => 'Ajouter un autre';

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
  String get authForgotPasswordHeading => 'Mot de passe oublié ?';

  @override
  String get authForgotPasswordSubtitle =>
      'Entrez votre e-mail et nous vous enverrons un code de vérification.';

  @override
  String get authForgotPasswordButton => 'Envoyer le code';

  @override
  String get authForgotPasswordOtpTitle => 'Code de vérification';

  @override
  String get authForgotPasswordOtpHeading => 'Entrez le code de vérification';

  @override
  String get authForgotPasswordOtpSubtitle =>
      'Nous avons envoyé un code de vérification à votre e-mail. Veuillez le saisir ci-dessous.';

  @override
  String get authResetPasswordTitle => 'Réinitialiser le mot de passe';

  @override
  String get authResetPasswordHeading => 'Créer un nouveau mot de passe';

  @override
  String get authResetPasswordSubtitle =>
      'Votre nouveau mot de passe doit être différent de ceux utilisés auparavant.';

  @override
  String get authNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get authNewPasswordHint => '********';

  @override
  String get authConfirmNewPasswordLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get authResetPasswordButton => 'Réinitialiser';

  @override
  String get authPasswordResetSuccess =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get back => 'Retour';

  @override
  String get homeQuickActions => 'Actions rapides';

  @override
  String get homeAwaitingResponse => 'En attente de votre réponse';

  @override
  String get homeRecentActivity => 'Activité récente';

  @override
  String get homeGuest => 'Invité';

  @override
  String get homeWelcomeBack => 'Bon retour';

  @override
  String get homeGoodMorning => 'Bonjour';

  @override
  String get homeFrom => 'De : ';

  @override
  String get newsFilter => 'Filtrer';

  @override
  String get newsResetFilters => 'Réinitialiser';

  @override
  String get newsSearchByName => 'Rechercher par nom';

  @override
  String get newsSearchHint => 'Rechercher';

  @override
  String get newsSearchByType => 'Rechercher par type';

  @override
  String get newsSortBy => 'Trier par';

  @override
  String get newsApplyFilters => 'APPLIQUER LES FILTRES';

  @override
  String get newsAllPosts => 'Toutes les publications';

  @override
  String get newsUpdates => 'Mises à jour';

  @override
  String get newsAnnouncements => 'Annonces';

  @override
  String get newsPhotos => 'Photos';

  @override
  String get newsDocuments => 'Documents';

  @override
  String get newsExpenseUpdates => 'Mises à jour des dépenses';

  @override
  String get newsNewest => 'Plus récent';

  @override
  String get newsOldest => 'Plus ancien';

  @override
  String get newsName => 'Nom';

  @override
  String get newsSeeMore => 'voir plus';

  @override
  String get newsShowLess => 'voir moins';

  @override
  String get newsLike => 'J\'aime';

  @override
  String get newsHelpful => 'Utile';

  @override
  String get expenseCategoryEducation => 'Éducation';

  @override
  String get expenseCategoryHealthcare => 'Santé';

  @override
  String get expenseCategoryActivities => 'Activités';

  @override
  String get expenseCategoryEssentials => 'Essentiels';

  @override
  String get expenseCategoryClothing => 'Vêtements';

  @override
  String get expenseCategoryFood => 'Alimentation';

  @override
  String get expenseCategoryTransportation => 'Transport';

  @override
  String get expenseCategoryOther => 'Autre';

  @override
  String get scheduleFilterAll => 'Tout';

  @override
  String get scheduleFilterParentingTime => 'Temps parental';

  @override
  String get scheduleFilterSchoolActivities => 'École et activités';

  @override
  String get scheduleFilterMedical => 'Médical';

  @override
  String get scheduleFilterCalls => 'Appels';

  @override
  String get scheduleLegendApproved => 'Approuvé';

  @override
  String get scheduleLegendPending => 'En attente';

  @override
  String get scheduleLegendEvent => 'Événement';

  @override
  String get scheduleLegendCall => 'Appel';

  @override
  String get scheduleCallMode => 'Mode d\'appel';

  @override
  String get scheduleCallModeAudio => 'Audio';

  @override
  String get scheduleCallModeVideo => 'Vidéo';

  @override
  String get scheduleCreateCall => 'CRÉER UN APPEL';

  @override
  String get scheduleErrorWorkspaceMissing =>
      'L’espace de travail n’est pas prêt. Reconnectez-vous.';

  @override
  String get scheduleErrorScheduledStartsAtAfterNow =>
      'Veuillez choisir une date ultérieure.';

  @override
  String get scheduleErrorStartDateRequired =>
      'Veuillez sélectionner une date de début.';

  @override
  String get scheduleCallCreatedSuccess => 'Appel créé avec succès.';

  @override
  String get scheduleRoomName => 'Salle';

  @override
  String get scheduleVideoCall => 'Appel vidéo';

  @override
  String get scheduleAudioCall => 'Appel audio';

  @override
  String get scheduleLegendRejected => 'Rejeté';

  @override
  String get scheduleNewScheduleRequest => 'Nouvelle demande de planning';

  @override
  String get scheduleAllCalls => 'Tous les appels';

  @override
  String get scheduleNoCalls => 'Aucun appel pour le moment';

  @override
  String get scheduleAddNewSchedule => 'Ajouter un nouveau planning';

  @override
  String get scheduleEventType => 'Type d\'événement';

  @override
  String get scheduleChild => 'Enfant';

  @override
  String get scheduleDate => 'Date';

  @override
  String get scheduleTime => 'Heure';

  @override
  String get scheduleNotes => 'Notes';

  @override
  String get scheduleSendRequest => 'ENVOYER LA DEMANDE';

  @override
  String get scheduleSelect => 'Sélectionner';

  @override
  String get scheduleVoiceCall => 'Appel vocal';

  @override
  String get scheduleJoin => 'REJOINDRE';

  @override
  String get scheduleJoinCallSuccess => 'Connexion à l’appel réussie.';

  @override
  String get scheduleJoinCallFailed =>
      'Impossible de rejoindre l’appel. Veuillez réessayer.';

  @override
  String get callConnecting => 'Connexion…';

  @override
  String get callLive => 'En direct';

  @override
  String get callMic => 'Micro';

  @override
  String get callCamera => 'Caméra';

  @override
  String get callLeave => 'Quitter';

  @override
  String get callWaitingForOther => 'En attente de l’autre participant…';

  @override
  String get callConnectFailed => 'Impossible de se connecter à l’appel.';

  @override
  String get callNoInternet =>
      'Pas de connexion Internet. Vérifiez votre réseau et réessayez.';

  @override
  String get callMicPermissionRequired =>
      'L’autorisation du micro est requise pour rejoindre l’appel.';

  @override
  String get callCameraPermissionRequired =>
      'L’autorisation de la caméra est requise pour les appels vidéo.';

  @override
  String get callDisconnected => 'Vous avez été déconnecté de l’appel.';

  @override
  String get callReconnecting => 'Connexion perdue. Reconnexion…';

  @override
  String get callConnectionReplaced =>
      'Appel terminé car vous vous êtes connecté depuis un autre appareil.';

  @override
  String get callUnsupportedPlatform =>
      'Les appels en direct sont disponibles uniquement sur Android/iOS. Lancez l’app mobile.';

  @override
  String get scheduleViewReceipt => 'VOIR LE REÇU';

  @override
  String get scheduleExpensePaid => 'Dépense payée';

  @override
  String get scheduleCategory => 'Catégorie';

  @override
  String get homeSendMessage => 'Envoyer un message';

  @override
  String get homeAddSchedule => 'Ajouter un horaire';

  @override
  String get homeExpense => 'Dépenses';

  @override
  String get homeSessions => 'Sessions';

  @override
  String get homeSessionsLibrary => 'Bibliothèque';

  @override
  String get homeDocuments => 'Documents';

  @override
  String get homeUpcomingCall => 'Appel à venir';

  @override
  String get homeReminder => 'Rappel';

  @override
  String get homeConfirm => 'CONFIRMER';

  @override
  String get homeRequestReschedule => 'REPROGRAMMER';

  @override
  String get homeNewEvent => 'Nouvel événement';

  @override
  String get homeNewSession => 'Nouvelle session';

  @override
  String homePendingCost(Object count) {
    return '$count coût en attente';
  }

  @override
  String get homeReview => 'EXAMINER';

  @override
  String get rescheduleTitle => 'Demande de reprogrammation';

  @override
  String get rescheduleSelectDate => 'Sélectionnez une nouvelle date';

  @override
  String get rescheduleSelectTime => 'Sélectionner l\'heure';

  @override
  String get rescheduleSubmit => 'REPROGRAMMER';
}
