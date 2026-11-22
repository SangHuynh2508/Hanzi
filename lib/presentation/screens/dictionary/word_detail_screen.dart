import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/services/tts_service.dart';
import '../decks/add_hsk_sheet.dart';
import '../../state/dictionary/word_detail_cubit.dart';
import '../../state/dictionary/word_detail_state.dart';
import '../../widgets/hanzi_breakdown.dart';

class WordDetailScreen extends StatelessWidget {
  const WordDetailScreen({super.key, required this.id, this.preview});

  final int id;

  /// Entry already loaded by the search list, if we came from there.
  final DictEntry? preview;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordDetailCubit(
        context.read<DictionaryRepository>(),
        preview: preview,
      )..load(id),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chi tiết từ')),
        body: BlocBuilder<WordDetailCubit, WordDetailState>(
          builder: (context, state) {
            final e = state.entry;
            if (state.status == WordDetailStatus.notFound) {
              return const Center(child: Text('Không có từ này'));
            }
            if (e == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return _Body(entry: e, state: state);
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.entry, required this.state});

  final DictEntry entry;
  final WordDetailState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = entry;
    Widget heading(String s) => Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(s, style: theme.textTheme.titleMedium),
        );

    return ListView(padding: const EdgeInsets.all(16), children: [
      Center(
        child: Hero(
          tag: 'word-${e.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(e.simplified, style: theme.textTheme.displayLarge),
          ),
        ),
      ),
      if (e.traditional != e.simplified)
        Center(child: Text('Phồn thể: ${e.traditional}')),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(e.pinyin, style: theme.textTheme.titleLarge),
        IconButton(
          icon: const Icon(Icons.volume_up),
          tooltip: 'Nghe phát âm',
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (!await context.read<TtsService>().speak(e.simplified)) {
              messenger.showSnackBar(const SnackBar(
                content: Text('Máy chưa có giọng đọc tiếng Trung. '
                    'Cài "Speech Services by Google" để nghe phát âm.'),
              ));
            }
          },
        ),
      ]),
      Center(
        child: Text('Hán-Việt: ${e.hanViet.toUpperCase()}',
            style: theme.textTheme.titleMedium),
      ),
      if (e.hskLevel != null) Center(child: Text('HSK ${e.hskLevel}')),
      heading('Nghĩa'),
      Text(e.meaningVi, style: theme.textTheme.bodyLarge),
      if (e.meaningEn.isNotEmpty)
        Text(e.meaningEn, style: theme.textTheme.bodySmall),
      heading('Cấu tạo chữ'),
      switch (state.status) {
        WordDetailStatus.loaded => HanziBreakdown(chars: state.chars),
        WordDetailStatus.failure => const Text('Không tải được cấu tạo chữ.'),
        _ => const LinearProgressIndicator(),
      },
      const SizedBox(height: 24),
      FilledButton.tonalIcon(
        onPressed: () => _addToDeck(context, e),
        icon: const Icon(Icons.add),
        label: const Text('Thêm vào bộ…'),
      ),
    ]);
  }
}

/// Pick a deck (or make one) and add [e] to it as a new card.
Future<void> _addToDeck(BuildContext context, DictEntry e) async {
  final decks = context.read<DeckRepository>();
  final cards = context.read<CardRepository>();
  final messenger = ScaffoldMessenger.of(context);

  final picked = await showModalBottomSheet<({String id, String name})>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => StreamBuilder<List<Deck>>(
      stream: decks.watchDecks(),
      builder: (_, snap) => ListView(shrinkWrap: true, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text('Thêm ${e.simplified} vào bộ…',
              style: Theme.of(sheet).textTheme.titleMedium),
        ),
        ListTile(
          leading: const Icon(Icons.create_new_folder_outlined),
          title: const Text('Tạo bộ mới…'),
          onTap: () async {
            final r = await showDeckDialog(sheet, title: 'Bộ mới');
            if (r == null) return;
            final id = await decks.create(r.name, r.description);
            if (sheet.mounted) Navigator.pop(sheet, (id: id, name: r.name));
          },
        ),
        for (final d in snap.data ?? const <Deck>[])
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(d.name),
            subtitle: Text('${d.cardCount} thẻ'),
            onTap: () => Navigator.pop(sheet, (id: d.id, name: d.name)),
          ),
      ]),
    ),
  );
  if (picked == null) return;
  await cards.create(picked.id, CardDraft.fromEntry(e));
  messenger.showSnackBar(
      SnackBar(content: Text('Đã thêm ${e.simplified} vào "${picked.name}"')));
}
