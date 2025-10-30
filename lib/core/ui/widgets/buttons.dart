import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool enabled;
  final bool isLoading;
  final Widget? icon; // Ícone opcional antes do texto
  final Widget? trailingIcon; // Ícone opcional depois do texto
  final ButtonSize size;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.enabled = true,
    this.isLoading = false,
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: _getPadding(),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withOpacity(0.5),
        disabledForegroundColor: foregroundColor.withOpacity(0.5),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white,
              ),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon!,
        if (icon != null) const SizedBox(width: 8), // Espaçamento entre ícone e texto
        Text(text, style: _getTextStyle()),
        if (trailingIcon != null) const SizedBox(width: 8), // Espaço entre texto e ícone final
        if (trailingIcon != null) trailingIcon!,
      ],
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 16);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(vertical: 18, horizontal: 32);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(vertical: 12, horizontal: 24);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
      case ButtonSize.large:
        return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
      case ButtonSize.medium:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    }
  }
}
