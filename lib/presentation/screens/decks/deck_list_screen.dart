import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/deck_repository.dart';
import '../../state/decks/deck_list_cubit.dart';
import '../../state/decks/deck_list_state.dart';
import '../../widgets/skeleton_list.dart';
import '../../widgets/undo_snackbar.dart';
import 'add_hsk_sheet.dart';

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeckListCubit(context.read<DeckRepository>()),
      child: const _DeckListView(),
    );
  }
}

class _DeckListView extends StatelessWidget {
  const _DeckListView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeckListCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Bộ từ')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tạo bộ'),
        onPressed: () async {
          final id = await showNewDeckSheet(context, cubit);
          if (id != null && context.mounted) context.push('/decks/$id');
        },
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: cubit.filterChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Lọc bộ từ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<DeckListCubit, DeckListState>(
            builder: (context, s) {
              if (s.loading) return const SkeletonList();
              if (s.decks.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      s.filter.trim().isEmpty
                          ? 'Chưa có bộ từ nào.\n'
                              'Bấm "Tạo bộ" để tạo bộ trống hoặc thêm bộ HSK.'
                          : 'Không có bộ nào khớp.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 88), // room for FAB
                itemCount: s.decks.length,
                itemBuilder: (_, i) => _DeckTile(s.decks[i]),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile(this.deck);

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeckListCubit>();
    final scheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(deck.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: scheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete_outline, color: scheme.onErrorContainer),
      ),
      onDismissed: (_) {
        cubit.delete(deck.id);
        showUndoSnackBar(ScaffoldMessenger.of(context),
            'Đã xoá bộ "${deck.name}"', () => cubit.restore(deck.id));
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(deck.hskLevel?.toString() ??
              deck.name.characters.first.toUpperCase()),
        ),
        title: Text(deck.name),
        subtitle: Text('${deck.cardCount} thẻ'),
        trailing: deck.dueCount == 0
            ? null
            : Chip(
                label: Text('${deck.dueCount} đến hạn'),
                backgroundColor: scheme.primaryContainer,
                side: BorderSide.none,
              ),
        onTap: () => context.push('/decks/${deck.id}'),
      ),
    );
  }
}
