import 'package:flutter/material.dart';

/// Widget slider para avaliação de dor na escala 0-10
class PainSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final String? label;
  final bool enabled;
  final bool showLabels;
  final bool showTooltip;

  const PainSlider({
    required this.value, required this.onChanged, super.key,
    this.label,
    this.enabled = true,
    this.showLabels = true,
    this.showTooltip = true,
  });

  Color _getPainColor(BuildContext context, int value) {
    if (value <= 2) {
      return Colors.green;
    } else if (value <= 4) {
      return Colors.yellow.shade700;
    } else if (value <= 6) {
      return Colors.orange;
    } else if (value <= 8) {
      return Colors.deepOrange;
    } else {
      return Colors.red;
    }
  }

  String _getPainLabel(int value) {
    switch (value) {
      case 0:
        return 'Sem dor';
      case 1:
      case 2:
        return 'Dor leve';
      case 3:
      case 4:
        return 'Dor moderada';
      case 5:
      case 6:
        return 'Dor intensa';
      case 7:
      case 8:
        return 'Dor muito intensa';
      case 9:
      case 10:
        return 'Dor insuportável';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final painColor = _getPainColor(context, value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Indicador visual do nível de dor
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: painColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: painColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    value == 0 ? Icons.sentiment_very_satisfied : Icons.healing,
                    color: painColor,
                    size: 32,
                  ),
                  Column(
                    children: [
                      Text(
                        value.toString(),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: painColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getPainLabel(value),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: painColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    value >= 9
                        ? Icons.sentiment_very_dissatisfied
                        : Icons.local_hospital,
                    color: painColor,
                    size: 32,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: painColor,
                  inactiveTrackColor: painColor.withValues(alpha: 0.3),
                  thumbColor: painColor,
                  overlayColor: painColor.withValues(alpha: 0.2),
                  valueIndicatorColor: painColor,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: value.toDouble(),
                  max: 10,
                  divisions: 10,
                  label: showTooltip ? value.toString() : null,
                  onChanged: enabled
                      ? (newValue) => onChanged(newValue.round())
                      : null,
                ),
              ),

              // Labels da escala
              if (showLabels)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(11, (index) {
                    return Text(
                      index.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: index == value
                            ? painColor
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                        fontWeight: index == value
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Descrição da escala de dor
        Text(
          'Escala de dor: 0 = sem dor, 10 = dor insuportável',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
