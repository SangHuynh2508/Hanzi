import 'package:go_router/go_router.dart';

import '../../data/repositories/card_repository.dart';
import '../../data/repositories/dictionary_repository.dart';
import '../../presentation/screens/decks/card_editor_screen.dart';
import '../../presentation/screens/decks/deck_detail_screen.dart';
import '../../presentation/screens/decks/deck_list_screen.dart';
import '../../presentation/screens/dictionary/dictionary_screen.dart';
import '../../presentation/screens/dictionary/word_detail_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/shell/main_shell.dart';
import '../../presentation/screens/stats/stats_screen.dart';

class AppRoutes {
  static const home = '/home';
  static const decks = '/decks';
  static const dictionary = '/dictionary';
  static const stats = '/stats';
}

GoRouter buildRouter() {
  StatefulShellBranch branch(String path, GoRouterWidgetBuilder builder,
          [List<RouteBase> routes = const []]) =>
      StatefulShellBranch(
          routes: [GoRoute(path: path, builder: builder, routes: routes)]);

  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(navigationShell: shell),
        branches: [
          branch(AppRoutes.home, (_, _) => const HomeScreen()),
          branch(AppRoutes.decks, (_, _) => const DeckListScreen(), [
            GoRoute(
              path: ':deckId',
              builder: (_, s) =>
                  DeckDetailScreen(deckId: s.pathParameters['deckId']!),
              routes: [
                // extra: the CardItem to edit; absent = new card.
                GoRoute(
                  path: 'card',
                  builder: (_, s) => CardEditorScreen(
                    deckId: s.pathParameters['deckId']!,
                    existing: s.extra as CardItem?,
                  ),
                ),
              ],
            ),
          ]),
          branch(AppRoutes.dictionary, (_, _) => const DictionaryScreen(), [
            GoRoute(
              path: 'word/:id',
              builder: (_, s) => WordDetailScreen(
                id: int.parse(s.pathParameters['id']!),
                preview: s.extra as DictEntry?,
              ),
            ),
          ]),
          branch(AppRoutes.stats, (_, _) => const StatsScreen()),
        ],
      ),
    ],
  );
}
