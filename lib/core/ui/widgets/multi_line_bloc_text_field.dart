import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultilineBlocTextField<C extends StateStreamable<S>, S> extends StatelessWidget {
  final String Function(S state) valueSelector;
  final String? Function(S state)? errorSelector;
  final void Function(String value) onChanged;
  final TextEditingController controller;
  final String label;
  final double? maxWidth;
  final int minLines;
  final int maxLines;

  final double paddingTop;
  final double paddingBottom;
  final bool enabled;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final VoidCallback? onEditingComplete;

  const MultilineBlocTextField({
    super.key,
    required this.valueSelector,
    required this.onChanged,
    required this.controller,
    required this.label,
    this.errorSelector,
    this.maxWidth,
    this.minLines = 1,
    this.maxLines = 6,
    this.paddingTop = 8.0,
    this.paddingBottom = 8.0,
    this.enabled = true,
    this.keyboardType = TextInputType.multiline,
    this.inputFormatters,
    this.maxLength,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      listenWhen: (prev, curr) => valueSelector(prev) != valueSelector(curr),
      listener: (context, state) {
        final value = valueSelector(state);
        if (controller.text != value) {
          controller.text = value;
          controller.selection = TextSelection.collapsed(offset: value.length);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? double.infinity,
          ),
          child: BlocSelector<C, S, String?>(
            selector: (state) => errorSelector?.call(state),
            builder: (context, errorText) {
              return TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                minLines: minLines,
                maxLines: maxLines,
                textAlignVertical: TextAlignVertical.top,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  labelText: label,
                  errorText: errorText,
                  alignLabelWithHint: true,
                ),
                onChanged: onChanged,
              );
            },
          ),
        ),
      ),
    );
  }
}