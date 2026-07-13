import 'package:flutter/material.dart';
import 'package:updat/l10n/updat_translations.dart';

class MultilingualExampleCard extends StatelessWidget {
  const MultilingualExampleCard({
    required this.translations,
    required this.onTranslationsChanged,
    super.key,
  });

  final UpdatTranslations translations;
  final ValueChanged<UpdatTranslations> onTranslationsChanged;

  static const _languages = <String, UpdatTranslations>{
    'English': UpdatTranslations.english,
    'Español': UpdatTranslations.spanish,
    'Français': UpdatTranslations.french,
    'Deutsch': UpdatTranslations.german,
    'עברית': UpdatTranslations.hebrew,
  };

  @override
  Widget build(BuildContext context) {
    final isRtl = translations == UpdatTranslations.hebrew;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Localization',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Switch languages to preview how the default Updat UI strings '
              'are translated. Pass the selected translations to '
              'UpdatWindowManager or UpdatWidget.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _languages.entries.map((entry) {
                final selected = entry.value == translations;
                return ChoiceChip(
                  label: Text(entry.key),
                  selected: selected,
                  onSelected: (_) => onTranslationsChanged(entry.value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Preview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PreviewRow(
                    label: 'Chip',
                    value: translations.updateAvailable,
                  ),
                  _PreviewRow(
                    label: 'Download',
                    value: translations.downloading,
                  ),
                  _PreviewRow(
                    label: 'Install',
                    value: translations.installNow,
                  ),
                  _PreviewRow(
                    label: 'Dialog',
                    value: translations.newVersionAvailable,
                  ),
                  _PreviewRow(
                    label: 'Version',
                    value: translations.newVersionLabel('1.2.3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
