import 'package:flutter/widgets.dart';
import 'package:updat/l10n/updat_translations.dart';
import 'package:updat/utils/global_options.dart';

/// Provides [UpdatTranslations] to the default Updat UI widgets.
class UpdatTranslationsScope extends InheritedWidget {
  const UpdatTranslationsScope({
    required this.translations,
    required super.child,
    super.key,
  });

  final UpdatTranslations translations;

  static UpdatTranslations of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<UpdatTranslationsScope>();
    return scope?.translations ?? UpdatGlobalOptions.translations;
  }

  @override
  bool updateShouldNotify(UpdatTranslationsScope oldWidget) {
    return translations != oldWidget.translations;
  }
}
