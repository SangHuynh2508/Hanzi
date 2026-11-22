import 'package:go_router/go_router.dart';

import '../../presentation/screens/decks/decks_screen.dart';
import '../../data/repositories/dictionary_repository.dart';
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
  StatefulShellBranch branch(String path, GoRouterWidgetBuilder builder) =>
      StatefulShellBranch(routes: [GoRoute(path: path, builder: builder)]);

  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(navigationShell: shell),
        branches: [
          branch(AppRoutes.home, (_, _) => const HomeScreen()),
          branch(AppRoutes.decks, (_, _) => const DecksScreen()),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.dictionary,
              builder: (_, _) => const DictionaryScreen(),
              routes: [
                GoRoute(
                  path: 'word/:id',
                  builder: (_, state) => WordDetailScreen(
                    id: int.parse(state.pathParameters['id']!),
                    preview: state.extra as DictEntry?,
                  ),
                ),
              ],
            ),
          ]),
          branch(AppRoutes.stats, (_, _) => const StatsScreen()),
        ],
      ),
    ],
  );
}
