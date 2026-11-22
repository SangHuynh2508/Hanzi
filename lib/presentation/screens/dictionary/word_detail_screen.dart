import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/dictionary_repository.dart';
import '../../../data/services/tts_service.dart';
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
          onPressed: () => context.read<TtsService>().speak(e.simplified),
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
      // Enabled in L6 when decks exist.
      FilledButton.tonalIcon(
        onPressed: null,
        icon: const Icon(Icons.add),
        label: const Text('Thêm vào bộ…'),
      ),
    ]);
  }
}
