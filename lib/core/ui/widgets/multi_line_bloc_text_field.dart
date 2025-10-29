import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// [MultilineBlocTextField] integrado ao BLoC.
///
/// Essa versão usa [BlocBuilder] com `buildWhen`:
/// - O campo só rebuilda quando o valor ou o erro mudarem.
/// - Mais flexível que o [BlocSelector], pois você acessa o estado inteiro
///   e pode aplicar condições de comparação personalizadas.
///
/// Deve ser utilizado para quando o campo depender de **mais de um pedaço do estado**
/// ou se a lógica para decidir rebuild for mais complexa.
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

  /// Configurações extras
  final double textFieldWith;
  final double textFieldHeight;
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
    this.textFieldWith = 400,
    this.textFieldHeight = 240,
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
        child: SizedBox(
          width: textFieldWith,
          height: textFieldHeight,
          /// Observa apenas o erro para rebuilder o widget,
          /// em caso de problemas, trocar por BlocBuilder com listenerWhen, para observar o erro.
          /// 
          /// OBS.: não precisa observar a mudança de texto por os BlocListener já atualiza o controller altomaticamente
          child: BlocSelector<C, S, String?>(
            selector: (state) => errorSelector?.call(state),
            builder: (context, errorText) {
              return TextField(
                controller: controller,
                enabled: enabled,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                maxLength: maxLength,
                maxLines: null,
                expands: true,
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
