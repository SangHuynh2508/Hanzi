import 'package:material_ui/material_ui.dart';

import '../../data/repositories/dictionary_repository.dart';

/// One row per character: the character, its Hán-Việt reading, radical,
/// decomposition and meaning.
class HanziBreakdown extends StatelessWidget {
  const HanziBreakdown({super.key, required this.chars});

  final List<HanziInfo> chars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      for (final h in chars)
        Card(
          child: ListTile(
            leading: Text(h.char, style: theme.textTheme.headlineMedium),
            title: Text(h.hanVietReadings.isEmpty
                ? '—'
                : h.hanVietReadings.toUpperCase()),
            subtitle: Text([
              if (h.radical.isNotEmpty) 'Bộ ${h.radical}',
              if (h.decomposition.isNotEmpty) h.decomposition,
              if (h.meaning.isNotEmpty) h.meaning,
            ].join(' · ')),
          ),
        ),
    ]);
  }
}
