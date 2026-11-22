import 'package:material_ui/material_ui.dart';

import '../../state/decks/deck_list_cubit.dart';

/// Bottom sheet: empty deck or a ready-made HSK 1–6 deck. Returns the new
/// (or existing) deck id, or null if cancelled.
Future<String?> showNewDeckSheet(BuildContext context, DeckListCubit cubit) {
  final messenger = ScaffoldMessenger.of(context);
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tạo bộ mới', style: Theme.of(sheet).textTheme.titleLarge),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Bộ trống'),
              subtitle: const Text('Tự thêm từng thẻ'),
              onTap: () async {
                final r = await showDeckDialog(sheet, title: 'Bộ trống');
                if (r == null) return;
                final id = await cubit.create(r.name, r.description);
                if (sheet.mounted) Navigator.pop(sheet, id);
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Bộ HSK có sẵn'),
            ),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (var level = 1; level <= 6; level++)
                ActionChip(
                  label: Text('HSK $level'),
                  onPressed: () async {
                    final id = await cubit.addHsk(level);
                    if (id == null) {
                      messenger.showSnackBar(SnackBar(
                          content: Text('Từ điển chưa có từ HSK $level.')));
                    }
                    if (sheet.mounted) Navigator.pop(sheet, id);
                  },
                ),
            ]),
          ],
        ),
      ),
    ),
  );
}

/// Name + description dialog used for creating and renaming decks.
Future<({String name, String description})?> showDeckDialog(
  BuildContext context, {
  required String title,
  String name = '',
  String description = '',
}) {
  final nameCtrl = TextEditingController(text: name);
  final descCtrl = TextEditingController(text: description);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: nameCtrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Tên bộ'),
        ),
        TextField(
          controller: descCtrl,
          decoration:
              const InputDecoration(labelText: 'Mô tả (không bắt buộc)'),
        ),
      ]),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
        FilledButton(
          onPressed: () {
            if (nameCtrl.text.trim().isEmpty) return;
            Navigator.pop(
                ctx, (name: nameCtrl.text, description: descCtrl.text));
          },
          child: const Text('Lưu'),
        ),
      ],
    ),
  );
}
