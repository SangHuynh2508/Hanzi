import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/db/dictionary_database.dart';
import 'data/repositories/dictionary_repository.dart';
import 'data/services/tts_service.dart';
import 'presentation/screens/splash/splash_screen.dart';

class HanziApp extends StatefulWidget {
  const HanziApp({
    super.key,
    this.openDictionary = DictionaryDatabase.openFromAssets,
  });

  final DictionaryOpener openDictionary;

  @override
  State<HanziApp> createState() => _HanziAppState();
}

class _HanziAppState extends State<HanziApp> {
  final GoRouter _router = buildRouter();
  double _progress = 0;
  DictionaryDatabase? _dictionary;

  @override
  void initState() {
    super.initState();
    widget
        .openDictionary((p) => setState(() => _progress = p))
        .then((db) => setState(() => _dictionary = db));
  }

  @override
  Widget build(BuildContext context) {
    if (_dictionary == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: SplashScreen(progress: _progress),
      );
    }
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => DictionaryRepository(_dictionary!)),
        RepositoryProvider(create: (_) => TtsService()),
      ],
      child: MaterialApp.router(
        title: 'Hanzi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
