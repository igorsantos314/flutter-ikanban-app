# Gerenciamento de Notificações - iKanban

## Comportamento Automático

### ✅ Remoção Automática de Notificações
Quando uma notificação agendada é exibida ao usuário:
- **Automaticamente removida** da fila de notificações pendentes pelo sistema
- Não requer limpeza manual
- O método `pendingNotificationRequests()` não listará mais essa notificação

### ⚠️ Limite do Android
O Android impõe um **limite de 500 notificações agendadas** por aplicativo:
- Quando o limite é atingido, novas notificações **NÃO podem ser agendadas**
- O sistema Android silenciosamente ignora tentativas de agendar além do limite
- **Importante:** Este limite é para notificações AGENDADAS (pending), não para notificações já exibidas

## Arquitetura de Notificações

### ID de Notificação
Usamos o **ID da tarefa** como ID da notificação:
```dart
await _notificationsPlugin.zonedSchedule(
  task.id!, // ID único da tarefa = ID da notificação
  ...
);
```

**Vantagens:**
- ✅ Fácil cancelamento (sabemos o ID exato)
- ✅ Previne notificações duplicadas para mesma tarefa
- ✅ Atualização simples (cancelar + reagendar)

**Limitação:**
- ⚠️ Cada tarefa pode ter apenas 1 notificação agendada
- Para múltiplas notificações por tarefa, seria necessário usar IDs compostos

### Fluxo de Vida da Notificação

```
1. Task criada com shouldNotify=true
   ↓
2. scheduleTaskNotification() agendada
   ↓
3. Notificação fica em "pending" (conta no limite de 500)
   ↓
4. Horário chega → Sistema mostra notificação
   ↓
5. Sistema REMOVE automaticamente da fila pending
   ↓
6. Contador de pending diminui automaticamente
```

## Métodos de Gerenciamento

### Verificação de Limite
```dart
// Conta notificações pendentes
final count = await notificationService.getPendingNotificationsCount();

// Verifica se próximo do limite (>= 450)
final nearLimit = await notificationService.isNearNotificationLimit();

// Verifica se atingiu limite (>= 500)
final atLimit = await notificationService.hasReachedNotificationLimit();
```

### Agendamento Seguro
```dart
// Método que verifica limite antes de agendar
final result = await notificationService.scheduleTaskNotificationSafe(task);

switch (result) {
  case NotificationScheduleResult.success:
    // Agendada com sucesso
  case NotificationScheduleResult.limitReached:
    // Limite atingido - não foi possível agendar
  case NotificationScheduleResult.permissionDenied:
    // Sem permissão
  case NotificationScheduleResult.error:
    // Erro ao agendar
}
```

### Limpeza
```dart
// Cancela notificação específica
await notificationService.cancelTaskNotification(taskId);

// Cancela todas as notificações
await notificationService.cancelAllNotifications();

// Tenta limpar notificações expiradas (limitado)
await notificationService.cleanExpiredNotifications();
```

## Limitações e Considerações

### ❌ Notificações Expiradas
**Problema:** Se o dispositivo estava desligado ou app não executando no horário agendado:
- Notificação pode permanecer na fila "pending" mesmo após horário passar
- Não há API direta para obter horário agendado de cada notificação
- Difícil identificar quais notificações expiraram

**Solução Atual:**
- Log para alertar sobre alto número de pending
- Sugestão para cancelar todas e reagendar

**Solução Futura:**
- Salvar horários agendados em banco de dados local
- Sincronizar e limpar periodicamente notificações expiradas
- Implementar job periódico para limpeza

### 📊 Monitoramento Recomendado
```dart
// Em settings ou debug menu, mostrar:
final count = await notificationService.getPendingNotificationsCount();
print('Notificações agendadas: $count / 500');

if (count > 450) {
  // Alertar usuário que está próximo do limite
  // Sugerir cancelar notificações de tarefas antigas
}
```

### 🔄 Estratégias para Gerenciar Limite

#### 1. Cancelamento Automático de Tarefas Concluídas
```dart
// Quando tarefa é marcada como concluída/cancelada
if (task.status == TaskStatus.done || task.status == TaskStatus.cancelled) {
  await notificationService.cancelTaskNotification(task.id!);
}
```

#### 2. Limpeza Periódica Manual
Oferecer opção nas configurações:
- "Cancelar notificações de tarefas antigas (> 30 dias)"
- "Cancelar todas as notificações e reagendar ativas"

#### 3. Priorização Inteligente
Se próximo do limite (>450):
- Agendar apenas tarefas de alta prioridade
- Agendar apenas próximas N tarefas cronologicamente
- Notificar usuário que algumas notificações não foram agendadas

#### 4. Sincronização com Backend
- Apenas tarefas dos próximos 30 dias com notificação
- Reagendar automaticamente conforme tarefas vão sendo concluídas

## Boas Práticas

### ✅ FAZER:
- Sempre verificar `hasReachedNotificationLimit()` antes de loops de agendamento
- Cancelar notificação quando tarefa for concluída/cancelada
- Cancelar notificação antiga antes de reagendar (ao atualizar tarefa)
- Usar `scheduleTaskNotificationSafe()` para verificação automática
- Monitorar contagem de pending periodicamente

### ❌ NÃO FAZER:
- Agendar sem verificar limite em operações em lote
- Assumir que notificações antigas serão limpas automaticamente
- Criar IDs de notificação aleatórios (dificulta gerenciamento)
- Agendar notificações duplicadas para mesma tarefa

## Debugging

### Ver Notificações Pendentes
```dart
final pending = await notificationService.getPendingNotifications();
for (var notification in pending) {
  print('ID: ${notification.id}, Title: ${notification.title}');
}
```

### Limpar Tudo (Debug Only)
```dart
await notificationService.cancelAllNotifications();
print('Todas as notificações canceladas');
```

## Recursos Adicionais

- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Android Notification Limits](https://developer.android.com/training/notify-user/build-notification#limit-notifications)
- [iOS Notification Limits](https://developer.apple.com/documentation/usernotifications/scheduling_a_notification_locally_from_your_app)
