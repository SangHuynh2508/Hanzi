import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/card_repository.dart';
import '../../../data/repositories/deck_repository.dart';
import '../../state/decks/deck_detail_cubit.dart';
import '../../state/decks/deck_detail_state.dart';
import '../../widgets/skeleton_list.dart';
import '../../widgets/undo_snackbar.dart';
import 'add_hsk_sheet.dart';

class DeckDetailScreen extends StatelessWidget {
  const DeckDetailScreen({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeckDetailCubit(
        context.read<DeckRepository>(),
        context.read<CardRepository>(),
        deckId,
      ),
      child: const _DeckDetailView(),
    );
  }
}

class _DeckDetailView extends StatelessWidget {
  const _DeckDetailView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeckDetailCubit>();
    final deck = context.select((DeckDetailCubit c) => c.state.deck);
    return Scaffold(
      appBar: AppBar(
        title: Text(deck?.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Đổi tên bộ',
            onPressed: deck == null
                ? null
                : () async {
                    final r = await showDeckDialog(context,
                        title: 'Đổi tên bộ',
                        name: deck.name,
                        description: deck.description);
                    if (r != null) await cubit.rename(r.name, r.description);
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Xoá bộ',
            onPressed: deck == null
                ? null
                : () {
                    final messenger = ScaffoldMessenger.of(context);
                    cubit.deleteDeck();
                    context.pop();
                    showUndoSnackBar(messenger, 'Đã xoá bộ "${deck.name}"',
                        cubit.restoreDeck);
                  },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Thêm thẻ'),
        onPressed: () => context.push('/decks/${cubit.deckId}/card'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            onChanged: cubit.filterChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Lọc theo chữ Hán, pinyin, Hán-Việt, nghĩa',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        if (deck != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${deck.cardCount} thẻ · ${deck.dueCount} đến hạn',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ),
        Expanded(
          child: BlocBuilder<DeckDetailCubit, DeckDetailState>(
            builder: (context, s) {
              if (s.loading) return const SkeletonList();
              if (s.cards.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      s.filter.trim().isEmpty
                          ? 'Bộ này chưa có thẻ.\nBấm "Thêm thẻ" hoặc thêm từ '
                              'ở tab Tra từ.'
                          : 'Không có thẻ nào khớp.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: s.cards.length,
                itemBuilder: (_, i) => _CardTile(s.cards[i]),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile(this.card);

  final CardItem card;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeckDetailCubit>();
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(card.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: theme.colorScheme.errorContainer,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete_outline,
            color: theme.colorScheme.onErrorContainer),
      ),
      onDismissed: (_) {
        cubit.deleteCard(card.id);
        showUndoSnackBar(ScaffoldMessenger.of(context),
            'Đã xoá thẻ ${card.hanzi}', () => cubit.restoreCard(card.id));
      },
      child: ListTile(
        leading: Text(card.hanzi, style: theme.textTheme.headlineSmall),
        title: Text([card.pinyin, card.hanViet]
            .where((s) => s.isNotEmpty)
            .join(' · ')),
        subtitle:
            Text(card.meaning, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () =>
            context.push('/decks/${cubit.deckId}/card', extra: card),
      ),
    );
  }
}
