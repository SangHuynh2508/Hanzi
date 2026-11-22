import 'package:bloc_test/bloc_test.dart';
import 'package:doanmonhoc_hanzi/data/repositories/dictionary_repository.dart';
import 'package:doanmonhoc_hanzi/presentation/state/dictionary/search_cubit.dart';
import 'package:doanmonhoc_hanzi/presentation/state/dictionary/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements DictionaryRepository {}

const _xue = DictEntry(
  id: 1,
  simplified: '学生',
  traditional: '學生',
  pinyin: 'xué shēng',
  hanViet: 'học sinh',
  meaningVi: 'học sinh',
  meaningEn: 'student',
  hskLevel: 1,
);

void main() {
  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  blocTest<SearchCubit, SearchState>(
    'typing fast calls the repository once, after 300 ms',
    setUp: () => when(() => repo.search(any()))
        .thenAnswer((_) async => [_xue]),
    build: () => SearchCubit(repo),
    act: (c) async {
      c.queryChanged('x');
      await Future<void>.delayed(const Duration(milliseconds: 40));
      c.queryChanged('xu');
      await Future<void>.delayed(const Duration(milliseconds: 40));
      c.queryChanged('xue');
    },
    wait: const Duration(milliseconds: 400),
    verify: (c) {
      verify(() => repo.search('xue')).called(1);
      verifyNoMoreInteractions(repo);
      expect(c.state.status, SearchStatus.success);
      expect(c.state.results, [_xue]);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'repository error gives a Vietnamese error message',
    setUp: () => when(() => repo.search(any())).thenThrow(Exception('boom')),
    build: () => SearchCubit(repo),
    act: (c) => c.queryChanged('xue'),
    wait: const Duration(milliseconds: 400),
    verify: (c) {
      expect(c.state.status, SearchStatus.failure);
      expect(c.state.error, 'Không tra được từ, thử lại sau.');
    },
  );

  blocTest<SearchCubit, SearchState>(
    'clearing the box resets without calling the repository',
    build: () => SearchCubit(repo),
    act: (c) => c.queryChanged('  '),
    wait: const Duration(milliseconds: 400),
    expect: () => [const SearchState(query: '  ')],
    verify: (_) => verifyNever(() => repo.search(any())),
  );
}
