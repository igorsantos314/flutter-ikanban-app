import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueDateSelectorBottomSheet extends StatefulWidget {
  final DateTime? selectedDueDate;
  final Function(DateTime?) onDueDateSelected;

  const DueDateSelectorBottomSheet({
    super.key,
    required this.selectedDueDate,
    required this.onDueDateSelected,
  });

  @override
  State<DueDateSelectorBottomSheet> createState() =>
      _DueDateSelectorBottomSheetState();
}

class _DueDateSelectorBottomSheetState
    extends State<DueDateSelectorBottomSheet> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDueDate;
  }

  // Opções predefinidas de datas
  List<DateOption> get _quickOptions {
    final now = DateTime.now();
    return [
      DateOption(
        label: 'Hoje',
        date: now,
        icon: Icons.today,
        color: Colors.green,
      ),
      DateOption(
        label: 'Amanhã',
        date: now.add(const Duration(days: 1)),
        icon: Icons.wb_sunny,
        color: Colors.blue,
      ),
      DateOption(
        label: 'Esta semana',
        date: _getEndOfWeek(now),
        icon: Icons.date_range,
        color: Colors.orange,
      ),
      DateOption(
        label: 'Próxima semana',
        date: _getEndOfWeek(now.add(const Duration(days: 7))),
        icon: Icons.next_week,
        color: Colors.purple,
      ),
      DateOption(
        label: 'Este mês',
        date: _getEndOfMonth(now),
        icon: Icons.calendar_month,
        color: Colors.indigo,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Selecione a Data de Vencimento',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_selectedDate != null)
            Text(
              'Data selecionada: ${_dateFormat.format(_selectedDate!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            )
          else
            Text(
              'Nenhuma data selecionada',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Opção para remover data
                  _buildRemoveDateOption(theme),
                  const SizedBox(height: 16),

                  // Opções rápidas
                  Text(
                    'Opções Rápidas',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._quickOptions.map((option) => _buildQuickOption(option)),

                  const SizedBox(height: 16),

                  // Seleção personalizada
                  Text(
                    'Data Personalizada',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCustomDateOption(theme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onDueDateSelected(_selectedDate);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Confirmar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveDateOption(ThemeData theme) {
    final isSelected = _selectedDate == null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedDate = null),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.surface.withValues(alpha: 0.1)
                : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.clear,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sem data de vencimento',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickOption(DateOption option) {
    final theme = Theme.of(context);
    final isSelected =
        _selectedDate != null && _isSameDay(_selectedDate!, option.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedDate = option.date),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? option.color.withValues(alpha: 0.1)
                : theme.colorScheme.surface.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? option.color
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(option.icon, color: option.color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: option.color,
                      ),
                    ),
                    Text(
                      _dateFormat.format(option.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: option.color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomDateOption(ThemeData theme) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: _showDatePicker,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Escolher data específica',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary.withValues(alpha: 0.9),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: theme.colorScheme.primary.withValues(alpha: 0.9),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Garante que a data inicial não seja anterior ao dia de hoje
    DateTime initialDate;
    if (_selectedDate != null &&
        _selectedDate!.isAfter(today.subtract(const Duration(days: 1)))) {
      initialDate = _selectedDate!;
    } else {
      initialDate = today;
    }

    try {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: today,
        lastDate: DateTime(now.year + 5),
        helpText: 'Selecione a data de vencimento',
        cancelText: 'Cancelar',
        confirmText: 'Confirmar',
      );

      if (picked != null) {
        setState(() => _selectedDate = picked);
      }
    } catch (e) {
      // Se der erro, não faz nada - apenas não seleciona a data
      debugPrint('Erro ao abrir DatePicker: $e');
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  DateTime _getEndOfWeek(DateTime date) {
    // Calcula o domingo da semana (considerando domingo como fim de semana)
    final daysUntilSunday = 7 - date.weekday;
    return date.add(Duration(days: daysUntilSunday));
  }

  DateTime _getEndOfMonth(DateTime date) {
    // Calcula o último dia do mês atual
    return DateTime(date.year, date.month + 1, 0);
  }

  // ignore: unused_element
  static Future<void> show({
    required BuildContext context,
    required DateTime? selectedDueDate,
    required Function(DateTime?) onDueDateSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DueDateSelectorBottomSheet(
          selectedDueDate: selectedDueDate,
          onDueDateSelected: onDueDateSelected,
        ),
      ),
    );
  }
}

class DateOption {
  final String label;
  final DateTime date;
  final IconData icon;
  final Color color;

  const DateOption({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
  });
}
