import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/dictionary_repository.dart';
import '../../state/decks/card_editor_cubit.dart';
import '../../state/decks/card_editor_state.dart';

/// Create a card in [deckId], or edit [existing].
class CardEditorScreen extends StatelessWidget {
  const CardEditorScreen({super.key, required this.deckId, this.existing});

  final String deckId;
  final CardItem? existing;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CardEditorCubit(
        cards: context.read<CardRepository>(),
        dictionary: context.read<DictionaryRepository>(),
        deckId: deckId,
        existing: existing,
      ),
      child: const _CardForm(),
    );
  }
}

class _CardForm extends StatefulWidget {
  const _CardForm();

  @override
  State<_CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<_CardForm> {
  late final CardEditorCubit _cubit = context.read<CardEditorCubit>();
  late final _hanzi = TextEditingController(text: _cubit.state.draft.hanzi);
  late final _pinyin = TextEditingController(text: _cubit.state.draft.pinyin);
  late final _hanViet = TextEditingController(text: _cubit.state.draft.hanViet);
  late final _meaning = TextEditingController(text: _cubit.state.draft.meaning);
  late final _example = TextEditingController(text: _cubit.state.draft.example);

  @override
  void dispose() {
    for (final c in [_hanzi, _pinyin, _hanViet, _meaning, _example]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fillFrom(CardEditorState s) {
    _hanzi.text = s.draft.hanzi;
    _pinyin.text = s.draft.pinyin;
    _hanViet.text = s.draft.hanViet;
    _meaning.text = s.draft.meaning;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<CardEditorCubit>().state;
    return MultiBlocListener(
      listeners: [
        // A dictionary suggestion was picked: show its fields.
        BlocListener<CardEditorCubit, CardEditorState>(
          listenWhen: (a, b) =>
              b.draft.dictEntryId != null &&
              a.draft.dictEntryId != b.draft.dictEntryId,
          listener: (_, s) => _fillFrom(s),
        ),
        BlocListener<CardEditorCubit, CardEditorState>(
          listenWhen: (a, b) => !a.saved && b.saved,
          listener: (context, _) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Đã lưu thẻ ${_hanzi.text.trim()}')));
            context.pop();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.isEdit ? 'Sửa thẻ' : 'Thêm thẻ'),
          actions: [
            TextButton(onPressed: _cubit.save, child: const Text('Lưu')),
          ],
        ),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          TextField(
            controller: _hanzi,
            onChanged: _cubit.hanziChanged,
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(
              labelText: 'Chữ Hán',
              helperText: 'Gõ chữ Hán để lấy gợi ý từ từ điển',
              errorText: s.errors['hanzi'],
              border: const OutlineInputBorder(),
            ),
          ),
          for (final e in s.suggestions)
            ListTile(
              dense: true,
              leading: Text(e.simplified,
                  style: Theme.of(context).textTheme.titleLarge),
              title: Text('${e.pinyin} · ${e.hanViet}'),
              subtitle: Text(e.meaningVi,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => _cubit.pickSuggestion(e),
            ),
          const SizedBox(height: 16),
          _field(_pinyin, 'Pinyin', _cubit.pinyinChanged),
          _field(_hanViet, 'Hán-Việt', _cubit.hanVietChanged),
          _field(_meaning, 'Nghĩa', _cubit.meaningChanged,
              error: s.errors['meaning']),
          _field(_example, 'Ví dụ (không bắt buộc)', _cubit.exampleChanged,
              maxLines: 3),
          const SizedBox(height: 8),
          FilledButton(onPressed: _cubit.save, child: const Text('Lưu thẻ')),
        ]),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    ValueChanged<String> onChanged, {
    String? error,
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextField(
          controller: c,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            errorText: error,
            border: const OutlineInputBorder(),
          ),
        ),
      );
}
