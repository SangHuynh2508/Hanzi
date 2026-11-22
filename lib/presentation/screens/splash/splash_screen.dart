import 'package:material_ui/material_ui.dart';

/// Shown while the dictionary is copied from assets on first launch.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('汉字', style: theme.textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('Hanzi', style: theme.textTheme.titleLarge),
            const SizedBox(height: 32),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text('Đang chuẩn bị từ điển…', style: theme.textTheme.bodySmall),
          ]),
        ),
      ),
    );
  }
}
