import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Dados para configurar o seletor de data
class DateSelectorData {
  final DateTime? selectedDate;
  final Color color;
  final IconData icon;
  final String text;
  final String? subtitle;

  DateSelectorData({
    required this.selectedDate,
    required this.color,
    required this.icon,
    required this.text,
    this.subtitle,
  });
}

/// Widget para o seletor de data de vencimento
/// Calcula automaticamente as cores e textos baseado na data selecionada
class DateSelectorField<TBloc extends StateStreamable<TState>, TState>
    extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateSelectorField({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<TBloc, TState>(
          builder: (context, state) {
            final dateData = _calculateDateData(selectedDate);

            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedDate != null
                        ? dateData.color.withAlpha(100)
                        : theme.colorScheme.onSurface.withAlpha(300),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: selectedDate != null
                      ? dateData.color.withValues(alpha: 0.05)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (selectedDate != null 
                                ? dateData.color 
                                : theme.colorScheme.onSurface)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        dateData.icon,
                        color: selectedDate != null
                            ? dateData.color
                            : theme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateData.text,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: selectedDate != null 
                                  ? dateData.color 
                                  : null,
                            ),
                          ),
                          if (dateData.subtitle != null)
                            Text(
                              dateData.subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: selectedDate != null
                                    ? dateData.color.withAlpha(180)
                                    : theme.colorScheme.onSurface.withAlpha(600),
                                fontWeight: selectedDate != null
                                    ? FontWeight.w500
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: selectedDate != null
                          ? dateData.color.withAlpha(150)
                          : theme.colorScheme.onSurface.withAlpha(600),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Calcula as informações de exibição da data baseado na data selecionada
  DateSelectorData _calculateDateData(DateTime? date) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final now = DateTime.now();

    if (date == null) {
      return DateSelectorData(
        selectedDate: null,
        color: Colors.grey,
        icon: Icons.calendar_today,
        text: 'Definir data de vencimento',
        subtitle: 'Clique para definir quando a tarefa deve ser concluída',
      );
    }

    // Calcula se a data está atrasada
    final isOverdue = date.isBefore(
      DateTime(now.year, now.month, now.day),
    );

    // Calcula se é hoje
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    // Calcula se é amanhã
    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow = date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;

    if (isOverdue) {
      return DateSelectorData(
        selectedDate: date,
        color: Colors.red,
        icon: Icons.warning,
        text: 'Atrasada - ${dateFormat.format(date)}',
        subtitle: 'Esta tarefa está atrasada',
      );
    }

    if (isToday) {
      return DateSelectorData(
        selectedDate: date,
        color: Colors.orange,
        icon: Icons.today,
        text: 'Hoje - ${dateFormat.format(date)}',
        subtitle: 'Vence hoje',
      );
    }

    if (isTomorrow) {
      return DateSelectorData(
        selectedDate: date,
        color: Colors.blue,
        icon: Icons.wb_sunny,
        text: 'Amanhã - ${dateFormat.format(date)}',
        subtitle: 'Vence amanhã',
      );
    }

    return DateSelectorData(
      selectedDate: date,
      color: Colors.green,
      icon: Icons.schedule,
      text: dateFormat.format(date),
      subtitle: 'Vencimento futuro',
    );
  }
}