# Fluxo de Solicitação de Permissões de Notificação

## 📱 Comportamento Implementado

Quando o usuário **ativa o switch de notificação** para uma tarefa:

### ✅ Fluxo Completo

```
1. Usuário toca no switch para ativar (shouldNotify = true)
   ↓
2. App solicita permissão de NOTIFICAÇÕES
   ├─ Android < 13 (API < 33): Concedida automaticamente
   └─ Android >= 13 (API 33+): Exibe diálogo do sistema
   ↓
3. Se permissão de notificações CONCEDIDA:
   ├─ App verifica permissão de EXACT ALARM
   │  ├─ Android < 12 (API < 31): Não necessária
   │  └─ Android >= 12 (API 31+): Verifica se está concedida
   │     ↓
   │     ├─ SE JÁ CONCEDIDA: Ativa notificação (shouldNotify = true) ✅
   │     │
   │     └─ SE NÃO CONCEDIDA:
   │        ├─ Exibe diálogo explicando importância
   │        ├─ Se usuário aceitar: Abre configurações do sistema
   │        │  ├─ Usuário ativa: shouldNotify = true ✅
   │        │  └─ Usuário recusa: Ativa com AVISO ⚠️
   │        └─ Se usuário recusar diálogo: Não ativa (shouldNotify = false) ❌
   │
   └─ Se permissão de notificações NEGADA:
      ├─ Exibe diálogo explicando necessidade
      └─ shouldNotify permanece FALSE ❌
```

---

## 🔐 Permissões por Versão do Android

### Android 5.0 - 11 (API 21-30)
- ✅ **POST_NOTIFICATIONS**: Não necessária (concedida automaticamente)  
- ✅ **SCHEDULE_EXACT_ALARM**: Não necessária (concedida automaticamente)  
- ✅ **WAKE_LOCK**: Declarada no Manifest  

**Resultado:** Notificações funcionam automaticamente

---

### Android 12 (API 31-32)
- ✅ **POST_NOTIFICATIONS**: Concedida automaticamente (obrigatória apenas no API 33+)  
- ⚠️ **SCHEDULE_EXACT_ALARM**: **Necessária verificação runtime**  
  - Declarada no Manifest  
  - Verificada via `canScheduleExactNotifications()`  
  - Solicitada via `requestExactAlarmsPermission()` → Abre Settings  
- ✅ **WAKE_LOCK**: Declarada no Manifest  

**Resultado:** Notificações funcionam se EXACT_ALARM for concedida

---

### Android 13+ (API 33+)
- ⚠️ **POST_NOTIFICATIONS**: **Necessária permissão runtime**  
  - Solicitada via `requestPermissions()`  
  - Usuário pode negar  
- ⚠️ **SCHEDULE_EXACT_ALARM**: **Necessária verificação runtime**  
  - Declarada no Manifest  
  - Verificada via `canScheduleExactNotifications()`  
  - Solicitada via `requestExactAlarmsPermission()` → Abre Settings  
- ✅ **WAKE_LOCK**: Declarada no Manifest  

**Resultado:** Notificações funcionam se AMBAS permissões forem concedidas

---

## 🛠️ Implementação Técnica

### 1. AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

---

### 2. TaskNotificationService

#### Novos Métodos

```dart
// Verifica se pode agendar alarmes exatos (Android 12+)
Future<bool> canScheduleExactAlarms()

// Solicita permissão de exact alarm (abre Settings)
Future<bool> requestExactAlarmPermission()

// Solicita TODAS as permissões necessárias
Future<bool> requestAllPermissions({BuildContext? context})

// Verifica status de todas as permissões
Future<NotificationPermissionStatus> checkAllPermissions()
```

---

### 3. TaskFormPage

#### Novo Comportamento do Switch

Antes:
```dart
Switch(
  value: state.shouldNotify,
  onChanged: (value) {
    bloc.add(TaskFormUpdateFieldsEvent(shouldNotify: value));
  },
)
```

Depois:
```dart
Switch(
  value: state.shouldNotify,
  onChanged: (value) async {
    await _handleNotificationToggle(value, bloc);
  },
)
```

#### Método `_handleNotificationToggle`

1. **Se desativando** (`value = false`): Apenas desativa
2. **Se ativando** (`value = true`):
   - Solicita permissão de **notificações**
   - Se concedida, verifica permissão de **exact alarm**
   - Se exact alarm não estiver concedida:
     - Exibe diálogo explicativo
     - Se usuário aceitar: Abre Settings
     - Após retornar, verifica se foi concedida
     - Se ainda negada: Ativa com **aviso**
   - Se exact alarm estiver concedida: Ativa normalmente

---

## 💬 Diálogos Implementados

### 1. Permissão de Exact Alarm
**Título:** Permissão Adicional  
**Ícone:** 🔔 (laranja)  
**Mensagem:**  
> Para que as notificações funcionem de forma precisa e confiável, é necessário ativar a permissão de "Alarmes e lembretes".  
>  
> Sem essa permissão, as notificações podem ser atrasadas ou não serem exibidas quando o dispositivo estiver em modo de economia de energia.

**Botões:**  
- "Agora não" → Cancela  
- "Ativar" → Abre Settings  

---

### 2. Permissão Negada
**Título:** Permissão Negada  
**Ícone:** ⚠️ (vermelho)  
**Mensagem:**  
> A permissão de notificações é necessária para enviar lembretes sobre suas tarefas.  
>  
> Para ativar notificações, você precisa conceder a permissão de notificações nas configurações do app.

**Botões:**  
- "OK" → Fecha  

---

### 3. Aviso (Exact Alarm Negada)
**Título:** Aviso  
**Ícone:** ⚠️ (laranja)  
**Mensagem:**  
> As notificações foram ativadas, mas sem a permissão de "Alarmes e lembretes", elas podem não funcionar corretamente quando o dispositivo estiver em modo de economia de energia.  
>  
> Para garantir que as notificações funcionem, vá em Configurações > Apps > iKanban > Alarmes e lembretes e ative a permissão.

**Botões:**  
- "Entendi" → Fecha  

---

## 🔄 Cenários de Uso

### Cenário 1: Todas as Permissões Concedidas
1. Usuário ativa switch  
2. Permissão de notificações já está concedida  
3. Permissão de exact alarm já está concedida  
4. ✅ `shouldNotify = true` (sem diálogos)  

---

### Cenário 2: Primeira Vez (Android 13+)
1. Usuário ativa switch  
2. Sistema solicita permissão de notificações  
3. Usuário concede  
4. App verifica exact alarm (não concedida)  
5. Exibe diálogo explicativo sobre exact alarm  
6. Usuário aceita  
7. Abre Settings  
8. Usuário ativa "Alarmes e lembretes"  
9. ✅ `shouldNotify = true`  

---

### Cenário 3: Usuário Nega Notificações (Android 13+)
1. Usuário ativa switch  
2. Sistema solicita permissão de notificações  
3. Usuário nega  
4. Exibe diálogo "Permissão Negada"  
5. ❌ `shouldNotify = false` (reverte)  

---

### Cenário 4: Usuário Nega Exact Alarm (Android 12+)
1. Usuário ativa switch  
2. Permissão de notificações já está concedida  
3. App verifica exact alarm (não concedida)  
4. Exibe diálogo explicativo  
5. Usuário recusa ou não ativa nas Settings  
6. Exibe diálogo de "Aviso"  
7. ⚠️ `shouldNotify = true` (ativa mas com aviso)  

---

### Cenário 5: Android 11 ou inferior
1. Usuário ativa switch  
2. Permissões concedidas automaticamente  
3. ✅ `shouldNotify = true` (sem diálogos)  

---

## 📝 Observações Importantes

### Permissão `USE_EXACT_ALARM` vs `SCHEDULE_EXACT_ALARM`

- **USE_EXACT_ALARM**: Garantida para apps de alarme/calendário (não revogável)  
- **SCHEDULE_EXACT_ALARM**: Usuário pode revogar nas configurações  

Ambas estão declaradas no Manifest para máxima compatibilidade.

---

### Por que solicitar no toggle em vez de na criação da tarefa?

**Vantagens:**
1. ✅ Usuário só vê pedido de permissão quando **realmente quer** ativar notificações  
2. ✅ Evita pedidos "surpresa" durante salvamento de tarefa  
3. ✅ Se permissão for negada, switch reverte imediatamente (feedback visual)  
4. ✅ Usuário entende melhor **por que** a permissão é necessária  

---

### Tratamento de `mounted` no widget

O código verifica `mounted` antes de exibir diálogos para evitar erros se o widget for descartado durante operações assíncronas:

```dart
if (mounted) {
  _showPermissionDeniedDialog();
}
```

---

## 🎯 Checklist de Testes

- [ ] Testar no Android 11 (sem pedidos de permissão)  
- [ ] Testar no Android 12 (pedir exact alarm)  
- [ ] Testar no Android 13 (pedir notificações + exact alarm)  
- [ ] Testar negação de notificações (switch deve reverter)  
- [ ] Testar negação de exact alarm (deve ativar com aviso)  
- [ ] Testar desativação de notificação (deve desativar sem pedidos)  
- [ ] Testar com permissões já concedidas (deve ativar sem diálogos)  
- [ ] Testar revogação de permissões nas Settings e tentar ativar novamente  

---

## ✅ Garantias

### Com as mudanças implementadas:

1. ✅ Permissões são solicitadas **apenas quando necessário**  
2. ✅ Usuário recebe **feedback claro** sobre o que está acontecendo  
3. ✅ Se permissão for negada, o switch **reverte automaticamente**  
4. ✅ Tratamento específico para **cada versão do Android**  
5. ✅ Notificações funcionam corretamente quando permissões são concedidas  
6. ✅ App não trava ou gera erros se permissões forem negadas  
