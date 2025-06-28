
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FilterChips extends StatelessWidget {
  final TrendingSince selectedSince;
  final ValueChanged<TrendingSince> onSelected;

  const FilterChips({
    super.key,
    required this.selectedSince,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: TrendingSince.values.map((TrendingSince since) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: FilterChip(
            label: Text(since.displayName),
            selected: selectedSince == since,
            onSelected: (bool selected) {
              if (selected) {
                onSelected(since);
              }
            },
            showCheckmark: false,
            selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            labelStyle: TextStyle(
              color: selectedSince == since
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      }).toList(),
    );
  }
}

extension TrendingSinceExtension on TrendingSince {
  String get displayName {
    switch (this) {
      case TrendingSince.daily:
        return 'Day';
      case TrendingSince.weekly:
        return 'Week';
      case TrendingSince.monthly:
        return 'Month';
      default:
        return '';
    }
  }
}
