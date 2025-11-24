import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget para campos numéricos com validação e formatação
class NumberField extends StatelessWidget {
  final String label;
  final double? value;
  final ValueChanged<double?> onChanged;
  final String? suffix;
  final String? hint;
  final double? min;
  final double? max;
  final int decimals;
  final String? errorText;
  final bool enabled;
  final bool required;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const NumberField({
    required this.label, required this.onChanged, super.key,
    this.value,
    this.suffix,
    this.hint,
    this.min,
    this.max,
    this.decimals = 2,
    this.errorText,
    this.enabled = true,
    this.required = false,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      initialValue: controller == null ? value?.toString() : null,
      keyboardType: TextInputType.numberWithOptions(
        decimal: decimals > 0,
        signed: min != null && min! < 0,
      ),
      inputFormatters: [
        if (decimals == 0)
          FilteringTextInputFormatter.digitsOnly
        else
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d*\.?\d{0,' + decimals.toString() + r'}'),
          ),
      ],
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        hintText: hint,
        suffixText: suffix,
        errorText: errorText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerHighest,
      ),
      validator: (text) {
        if (required && (text == null || text.trim().isEmpty)) {
          return 'Campo obrigatório';
        }

        if (text != null && text.trim().isNotEmpty) {
          final parsedValue = double.tryParse(text);
          if (parsedValue == null) {
            return 'Valor numérico inválido';
          }

          if (min != null && parsedValue < min!) {
            return 'Valor deve ser maior ou igual a ${min!}';
          }

          if (max != null && parsedValue > max!) {
            return 'Valor deve ser menor ou igual a ${max!}';
          }
        }

        return null;
      },
      onChanged: (text) {
        if (text.trim().isEmpty) {
          onChanged(null);
        } else {
          final parsedValue = double.tryParse(text);
          onChanged(parsedValue);
        }
      },
      style: TextStyle(
        color: enabled
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
