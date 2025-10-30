import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [MultilineBlocTextField] integrado ao BLoC.
///
/// Agora não fixa altura; cresce com o conteúdo até `maxLines`.
class MultilineBlocTextField<C extends StateStreamable<S>, S> extends StatelessWidget {
  /// Como pegar o valor atual do estado (ex: `(s) => s.email`)
  final String Function(S state) valueSelector;

  /// Como pegar a mensagem de erro do estado (ex: `(s) => s.emailError`)
  final String? Function(S state)? errorSelector;

  /// Dispara quando o campo muda
  final void Function(String value) onChanged;

  /// Controller externo (opcional, mas recomendado para controle mais avançado)
  final TextEditingController controller;

  /// Label do campo
  final String label;

  /// Largura máxima do campo; se null, ocupa o espaço do pai
  final double? maxWidth;

  /// Linhas mínima e máxima do TextField — controla o redimensionamento.
  final int minLines;
  final int maxLines;

  /// Espaçamentos e demais configs
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
          // Preserva a seleção para o final do texto atual
          controller.text = value;
          controller.selection = TextSelection.collapsed(offset: value.length);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
        child: ConstrainedBox(
          // Se maxWidth for null, não impõe limite (ocupa o espaço do pai)
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
                // não usar expands quando queremos altura dinâmica baseada nas linhas
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