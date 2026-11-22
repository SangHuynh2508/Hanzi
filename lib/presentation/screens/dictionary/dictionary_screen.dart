import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../data/repositories/dictionary_repository.dart';
import '../../state/dictionary/search_cubit.dart';
import '../../state/dictionary/search_state.dart';
import '../../widgets/skeleton_list.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(context.read<DictionaryRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tra từ')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Builder(
              builder: (context) => TextField(
                onChanged: context.read<SearchCubit>().queryChanged,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Chữ Hán, pinyin hoặc tiếng Việt',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const Expanded(child: _Results()),
        ]),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SearchCubit>().state;
    return switch (state.status) {
      SearchStatus.initial => const _Message(
          'Thử gõ 学生, xuesheng, xue2sheng1 hoặc học sinh'),
      SearchStatus.loading => const SkeletonList(),
      SearchStatus.failure => _Message(state.error!),
      SearchStatus.success when state.results.isEmpty =>
        const _Message('Không tìm thấy'),
      SearchStatus.success => ListView.separated(
          itemCount: state.results.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) => _EntryTile(state.results[i]),
        ),
    };
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.e);

  final DictEntry e;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Hero(
        tag: 'word-${e.id}',
        child: Material(
          type: MaterialType.transparency,
          child: Text(e.simplified, style: theme.textTheme.headlineSmall),
        ),
      ),
      title: Text('${e.pinyin} · ${e.hanViet}'),
      subtitle: Text(e.meaningVi, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: e.hskLevel == null ? null : Text('HSK ${e.hskLevel}'),
      onTap: () => context.push('/dictionary/word/${e.id}', extra: e),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(text, textAlign: TextAlign.center),
        ),
      );
}
