import 'package:material_ui/material_ui.dart';

/// Grey placeholder rows shown while a list is loading.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 8});

  final int count;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double w, double h) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(6)),
        );
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          bar(48, 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              bar(160, 14),
              const SizedBox(height: 8),
              bar(double.infinity, 12),
            ]),
          ),
        ]),
      ),
    );
  }
}
