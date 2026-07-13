/// Holds all user-facing strings used by the default Updat UI widgets.
///
/// Pass an instance to [UpdatWidget] or [UpdatWindowManager], set
/// [UpdatGlobalOptions.translations] globally, or use one of the built-in
/// presets such as [UpdatTranslations.spanish].
class UpdatTranslations {
  const UpdatTranslations({
    this.updateAvailable = 'Update available',
    this.downloading = 'Downloading...',
    this.readyToInstall = 'Ready to install',
    this.updateReadyToInstall = 'Update Ready to install',
    this.errorTryAgain = 'Error. Try Again.',
    this.pleaseWait = 'Please Wait...',
    this.clickToInstall = 'Click to Install',
    this.updateErrorTooltip =
        'There was an issue with the update. Please try again.',
    this.checkForUpdates = 'Check for Updates',
    this.clickToCheckForUpdates = 'Click to check for updates',
    this.upToDate = 'Up to date',
    this.checkingForUpdates = 'Checking for Updates...',
    this.newVersionAvailable = 'A new version of the app is available.',
    this.changelog = 'Changelog:',
    this.later = 'Later',
    this.updateNow = 'Update Now',
    this.updateReady = 'Update Ready',
    this.updateNowForFeatures =
        'Update now to get the latest features and fixes.',
    this.installNow = 'Install Now',
    this.updateToVersion = _englishUpdateToVersion,
    this.newVersionLabel = _englishNewVersionLabel,
    this.versionReadyToInstall = _englishVersionReadyToInstall,
    this.currentlyRunningVersion = _englishCurrentlyRunningVersion,
  });

  final String updateAvailable;
  final String downloading;
  final String readyToInstall;
  final String updateReadyToInstall;
  final String errorTryAgain;
  final String pleaseWait;
  final String clickToInstall;
  final String updateErrorTooltip;
  final String checkForUpdates;
  final String clickToCheckForUpdates;
  final String upToDate;
  final String checkingForUpdates;
  final String newVersionAvailable;
  final String changelog;
  final String later;
  final String updateNow;
  final String updateReady;
  final String updateNowForFeatures;
  final String installNow;
  final String Function(String version) updateToVersion;
  final String Function(String version) newVersionLabel;
  final String Function(String version) versionReadyToInstall;
  final String Function(String version) currentlyRunningVersion;

  UpdatTranslations copyWith({
    String? updateAvailable,
    String? downloading,
    String? readyToInstall,
    String? updateReadyToInstall,
    String? errorTryAgain,
    String? pleaseWait,
    String? clickToInstall,
    String? updateErrorTooltip,
    String? checkForUpdates,
    String? clickToCheckForUpdates,
    String? upToDate,
    String? checkingForUpdates,
    String? newVersionAvailable,
    String? changelog,
    String? later,
    String? updateNow,
    String? updateReady,
    String? updateNowForFeatures,
    String? installNow,
    String Function(String version)? updateToVersion,
    String Function(String version)? newVersionLabel,
    String Function(String version)? versionReadyToInstall,
    String Function(String version)? currentlyRunningVersion,
  }) {
    return UpdatTranslations(
      updateAvailable: updateAvailable ?? this.updateAvailable,
      downloading: downloading ?? this.downloading,
      readyToInstall: readyToInstall ?? this.readyToInstall,
      updateReadyToInstall:
          updateReadyToInstall ?? this.updateReadyToInstall,
      errorTryAgain: errorTryAgain ?? this.errorTryAgain,
      pleaseWait: pleaseWait ?? this.pleaseWait,
      clickToInstall: clickToInstall ?? this.clickToInstall,
      updateErrorTooltip: updateErrorTooltip ?? this.updateErrorTooltip,
      checkForUpdates: checkForUpdates ?? this.checkForUpdates,
      clickToCheckForUpdates:
          clickToCheckForUpdates ?? this.clickToCheckForUpdates,
      upToDate: upToDate ?? this.upToDate,
      checkingForUpdates: checkingForUpdates ?? this.checkingForUpdates,
      newVersionAvailable: newVersionAvailable ?? this.newVersionAvailable,
      changelog: changelog ?? this.changelog,
      later: later ?? this.later,
      updateNow: updateNow ?? this.updateNow,
      updateReady: updateReady ?? this.updateReady,
      updateNowForFeatures:
          updateNowForFeatures ?? this.updateNowForFeatures,
      installNow: installNow ?? this.installNow,
      updateToVersion: updateToVersion ?? this.updateToVersion,
      newVersionLabel: newVersionLabel ?? this.newVersionLabel,
      versionReadyToInstall:
          versionReadyToInstall ?? this.versionReadyToInstall,
      currentlyRunningVersion:
          currentlyRunningVersion ?? this.currentlyRunningVersion,
    );
  }

  static const english = UpdatTranslations();

  static const spanish = UpdatTranslations(
    updateAvailable: 'Actualización disponible',
    downloading: 'Descargando...',
    readyToInstall: 'Listo para instalar',
    updateReadyToInstall: 'Actualización lista para instalar',
    errorTryAgain: 'Error. Intentar de nuevo.',
    pleaseWait: 'Por favor espere...',
    clickToInstall: 'Clic para instalar',
    updateErrorTooltip:
        'Hubo un problema con la actualización. Por favor intente de nuevo.',
    checkForUpdates: 'Buscar actualizaciones',
    clickToCheckForUpdates: 'Clic para buscar actualizaciones',
    upToDate: 'Actualizado',
    checkingForUpdates: 'Buscando actualizaciones...',
    newVersionAvailable: 'Hay una nueva versión de la aplicación disponible.',
    changelog: 'Registro de cambios:',
    later: 'Más tarde',
    updateNow: 'Actualizar ahora',
    updateReady: 'Actualización lista',
    updateNowForFeatures:
        'Actualice ahora para obtener las últimas funciones y correcciones.',
    installNow: 'Instalar ahora',
    updateToVersion: _spanishUpdateToVersion,
    newVersionLabel: _spanishNewVersionLabel,
    versionReadyToInstall: _spanishVersionReadyToInstall,
    currentlyRunningVersion: _spanishCurrentlyRunningVersion,
  );

  static const french = UpdatTranslations(
    updateAvailable: 'Mise à jour disponible',
    downloading: 'Téléchargement...',
    readyToInstall: 'Prêt à installer',
    updateReadyToInstall: 'Mise à jour prête à installer',
    errorTryAgain: 'Erreur. Réessayer.',
    pleaseWait: 'Veuillez patienter...',
    clickToInstall: 'Cliquer pour installer',
    updateErrorTooltip:
        'Un problème est survenu lors de la mise à jour. Veuillez réessayer.',
    checkForUpdates: 'Rechercher des mises à jour',
    clickToCheckForUpdates: 'Cliquer pour rechercher des mises à jour',
    upToDate: 'À jour',
    checkingForUpdates: 'Recherche de mises à jour...',
    newVersionAvailable:
        'Une nouvelle version de l\'application est disponible.',
    changelog: 'Journal des modifications :',
    later: 'Plus tard',
    updateNow: 'Mettre à jour',
    updateReady: 'Mise à jour prête',
    updateNowForFeatures:
        'Mettez à jour maintenant pour obtenir les dernières fonctionnalités et corrections.',
    installNow: 'Installer maintenant',
    updateToVersion: _frenchUpdateToVersion,
    newVersionLabel: _frenchNewVersionLabel,
    versionReadyToInstall: _frenchVersionReadyToInstall,
    currentlyRunningVersion: _frenchCurrentlyRunningVersion,
  );

  static const german = UpdatTranslations(
    updateAvailable: 'Update verfügbar',
    downloading: 'Wird heruntergeladen...',
    readyToInstall: 'Bereit zur Installation',
    updateReadyToInstall: 'Update bereit zur Installation',
    errorTryAgain: 'Fehler. Erneut versuchen.',
    pleaseWait: 'Bitte warten...',
    clickToInstall: 'Klicken zum Installieren',
    updateErrorTooltip:
        'Beim Update ist ein Problem aufgetreten. Bitte versuchen Sie es erneut.',
    checkForUpdates: 'Nach Updates suchen',
    clickToCheckForUpdates: 'Klicken, um nach Updates zu suchen',
    upToDate: 'Auf dem neuesten Stand',
    checkingForUpdates: 'Suche nach Updates...',
    newVersionAvailable: 'Eine neue Version der App ist verfügbar.',
    changelog: 'Änderungsprotokoll:',
    later: 'Später',
    updateNow: 'Jetzt aktualisieren',
    updateReady: 'Update bereit',
    updateNowForFeatures:
        'Aktualisieren Sie jetzt, um die neuesten Funktionen und Fehlerbehebungen zu erhalten.',
    installNow: 'Jetzt installieren',
    updateToVersion: _germanUpdateToVersion,
    newVersionLabel: _germanNewVersionLabel,
    versionReadyToInstall: _germanVersionReadyToInstall,
    currentlyRunningVersion: _germanCurrentlyRunningVersion,
  );

  static const hebrew = UpdatTranslations(
    updateAvailable: 'עדכון זמין',
    downloading: 'מוריד...',
    readyToInstall: 'מוכן להתקנה',
    updateReadyToInstall: 'העדכון מוכן להתקנה',
    errorTryAgain: 'שגיאה. נסה שוב.',
    pleaseWait: 'אנא המתן...',
    clickToInstall: 'לחץ להתקנה',
    updateErrorTooltip: 'אירעה בעיה בעדכון. אנא נסה שוב.',
    checkForUpdates: 'בדוק עדכונים',
    clickToCheckForUpdates: 'לחץ לבדיקת עדכונים',
    upToDate: 'מעודכן',
    checkingForUpdates: 'בודק עדכונים...',
    newVersionAvailable: 'גרסה חדשה של האפליקציה זמינה.',
    changelog: 'יומן שינויים:',
    later: 'מאוחר יותר',
    updateNow: 'עדכן עכשיו',
    updateReady: 'העדכון מוכן',
    updateNowForFeatures: 'עדכן עכשיו כדי לקבל את התכונות והתיקונים האחרונים.',
    installNow: 'התקן עכשיו',
    updateToVersion: _hebrewUpdateToVersion,
    newVersionLabel: _hebrewNewVersionLabel,
    versionReadyToInstall: _hebrewVersionReadyToInstall,
    currentlyRunningVersion: _hebrewCurrentlyRunningVersion,
  );
}

String _englishUpdateToVersion(String version) => 'Update to version $version';
String _englishNewVersionLabel(String version) => 'New Version: $version';
String _englishVersionReadyToInstall(String version) =>
    'Version $version is now ready to be installed!';
String _englishCurrentlyRunningVersion(String version) =>
    'You are currently running version $version.';

String _spanishUpdateToVersion(String version) =>
    'Actualizar a la versión $version';
String _spanishNewVersionLabel(String version) => 'Nueva versión: $version';
String _spanishVersionReadyToInstall(String version) =>
    '¡La versión $version está lista para instalarse!';
String _spanishCurrentlyRunningVersion(String version) =>
    'Actualmente está ejecutando la versión $version.';

String _frenchUpdateToVersion(String version) =>
    'Mettre à jour vers la version $version';
String _frenchNewVersionLabel(String version) => 'Nouvelle version : $version';
String _frenchVersionReadyToInstall(String version) =>
    'La version $version est prête à être installée !';
String _frenchCurrentlyRunningVersion(String version) =>
    'Vous utilisez actuellement la version $version.';

String _germanUpdateToVersion(String version) =>
    'Auf Version $version aktualisieren';
String _germanNewVersionLabel(String version) => 'Neue Version: $version';
String _germanVersionReadyToInstall(String version) =>
    'Version $version ist jetzt zur Installation bereit!';
String _germanCurrentlyRunningVersion(String version) =>
    'Sie verwenden derzeit Version $version.';

String _hebrewUpdateToVersion(String version) => 'עדכן לגרסה $version';
String _hebrewNewVersionLabel(String version) => 'גרסה חדשה: $version';
String _hebrewVersionReadyToInstall(String version) =>
    'גרסה $version מוכנה להתקנה!';
String _hebrewCurrentlyRunningVersion(String version) =>
    'אתה מריץ כעת גרסה $version.';
