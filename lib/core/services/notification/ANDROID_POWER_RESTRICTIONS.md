# Restrições de Energia do Android e Notificações Precisas

## 📱 O Problema: Restrições Modernas do Android

Desde o **Android 6.0 (API 23)**, o Google introduziu mecanismos agressivos de economia de energia que podem **atrasar ou bloquear** notificações agendadas:

### 1. **Doze Mode** (Android 6.0+)

#### O que é?
Quando o dispositivo fica **inativo, desconectado e com tela desligada** por um período:
- O sistema entra em "Doze" (soneca)
- Apps entram em modo de espera profunda
- Network access é cortado
- Wakelocks são ignorados
- **Alarmes são adiados** para janelas de manutenção

#### Comportamento
```
Tela desligada → 30 min → Doze leve → 1-2h → Doze profundo
                          ↓                    ↓
                    Janelas de manutenção   Janelas mais espaçadas
                    (a cada 15 min)          (a cada horas)
```

Durante Doze:
- ❌ Alarmes normais (`set()`, `setRepeating()`) são **adiados** até próxima janela
- ❌ Jobs agendados são **cancelados** ou adiados
- ❌ Sincronização de rede é **bloqueada**
- ✅ Alarmes **exatos + idle whitelist** são permitidos

**Fonte:** [Optimize for Doze and App Standby](https://developer.android.com/training/monitoring-device-state/doze-standby)

---

### 2. **App Standby** (Android 6.0+)

#### O que é?
Quando o app **não é usado** por alguns dias e não está em foreground:
- O sistema coloca o app em "standby"
- Network access é bloqueado
- Jobs e syncs são adiados

#### Comportamento
Apps saem de standby quando:
- Usuário abre o app
- Dispositivo é conectado ao carregador
- Sistema entra em janela de manutenção

**Fonte:** [App Standby Buckets](https://developer.android.com/topic/performance/appstandby)

---

### 3. **Background Limits** (Android 8.0+/API 26+)

#### O que é?
- Apps não podem mais rodar **background services** indefinidamente
- Limite de poucos minutos após app sair de foreground
- Após timeout, sistema **mata** o service

#### Impacto em Notificações
- Apps não podem mais usar **background service** para disparar notificações
- Necessário usar **AlarmManager** ou **WorkManager**
- AlarmManager regular ainda pode ser adiado por Doze

**Fonte:** [Background Execution Limits](https://developer.android.com/about/versions/oreo/background)

---

### 4. **Restrições de Bateria** (Android 9.0+/API 28+)

#### App Standby Buckets
O Android categoriza apps em "buckets" baseado em uso:

| Bucket | Descrição | Restrições |
|--------|-----------|------------|
| **Active** | App usado recentemente | Nenhuma |
| **Working Set** | Usado regularmente | Leves |
| **Frequent** | Usado frequentemente mas não diariamente | Moderadas |
| **Rare** | Pouco usado | Severas (jobs rodados 1x/dia) |
| **Restricted** | Consumo excessivo de bateria | Muito severas |

Apps em buckets "Rare" ou "Restricted":
- ❌ Jobs adiados até 24h
- ❌ Network bloqueado
- ❌ Alarmes normais significativamente atrasados

**Fonte:** [Power Management Restrictions](https://developer.android.com/topic/performance/power)

---

### 5. **Exact Alarm Restrictions** (Android 12+/API 31+)

#### Nova Permissão Obrigatória
A partir do Android 12, apps precisam de **permissão especial** para agendar alarmes exatos:

```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

Ou para apps de alarme/lembretes:
```xml
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
```

**Diferença:**
- `SCHEDULE_EXACT_ALARM`: Usuário pode **revogar** nas configurações
- `USE_EXACT_ALARM`: Garantida para apps de alarme/calendário (**não revogável**)

**Fonte:** [Schedule exact alarms](https://developer.android.com/training/scheduling/alarms#exact-alarms)

---

## ✅ A Solução: `setExactAndAllowWhileIdle()`

### Por que é necessário?

Métodos tradicionais do `AlarmManager`:

| Método | Precisão | Funciona em Doze? | Uso |
|--------|----------|-------------------|-----|
| `set()` | ± 10 min | ❌ Adiado | Alarmes não críticos |
| `setRepeating()` | ± 15 min | ❌ Adiado | Alarmes repetitivos |
| `setWindow()` | Janela de tempo | ❌ Adiado | Sync flexível |
| `setExact()` | Preciso | ❌ Adiado em Doze | Alarmes precisos |
| **`setExactAndAllowWhileIdle()`** | **Preciso** | ✅ **Funciona** | **Notificações críticas** |
| `setAlarmClock()` | Preciso | ✅ Funciona | Alarmes relógio |

### Como `setExactAndAllowWhileIdle()` funciona?

1. **Precise (Exact):** Dispara no horário exato, não é adiado
2. **Allow While Idle:** Funciona mesmo durante **Doze Mode**
3. **Wakelock temporário:** Sistema garante wakelock para entregar alarme
4. **Whitelisted:** Temporariamente coloca app na whitelist de energia

### Limitações

⚠️ **Frequência Limitada:**
- A partir do Android 12, `setExactAndAllowWhileIdle()` tem limite de frequência
- Máximo ~1 alarme a cada 15 minutos por app
- Para alarmes mais frequentes, considerar `setAlarmClock()`

**Fonte:** [AlarmManager API Documentation](https://developer.android.com/reference/android/app/AlarmManager#setExactAndAllowWhileIdle(int,%20long,%20android.app.PendingIntent))

---

## 🛠️ Implementação no iKanban

### 1. Permissões no AndroidManifest

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<!-- Permissões para notificações precisas -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

**Por quê:**
- `POST_NOTIFICATIONS`: Exigida no Android 13+ para mostrar notificações
- `SCHEDULE_EXACT_ALARM`: Permite usar `setExactAndAllowWhileIdle()`
- `USE_EXACT_ALARM`: Garante permissão para apps de lembrete (não revogável)
- `RECEIVE_BOOT_COMPLETED`: Reagenda notificações após reinicialização

---

### 2. Receivers de Notificação

```xml
<!-- Receiver para reagendar após boot -->
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
    </intent-filter>
</receiver>

<!-- Receiver para notificações agendadas -->
<receiver android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
    android:exported="false" />
```

**Por quê:**
- `BootReceiver`: Quando dispositivo reinicia, alarmes agendados são **perdidos**. Este receiver restaura as notificações.
- `ScheduledNotificationReceiver`: Recebe broadcasts do `AlarmManager` e exibe notificação

---

### 3. Configuração no Flutter

**Arquivo:** `lib/core/services/notification/task_notification_service.dart`

```dart
await _notificationsPlugin.zonedSchedule(
  task.id!,
  'Lembrete: ${task.title}',
  notificationBody,
  tz.TZDateTime.from(scheduledDate, tz.local),
  notificationDetails,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅ CRUCIAL
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
  payload: task.id.toString(),
);
```

**`androidScheduleMode` options:**

| Opção | Método AlarmManager | Funciona em Doze? |
|-------|---------------------|-------------------|
| `exact` | `setExact()` | ❌ |
| `exactAllowWhileIdle` | `setExactAndAllowWhileIdle()` | ✅ |
| `inexact` | `set()` | ❌ |
| `inexactAllowWhileIdle` | `setAndAllowWhileIdle()` | ✅ (mas impreciso) |

**Por quê usamos `exactAllowWhileIdle`:**
- ✅ Notificações são exibidas **no horário exato** (ou X minutos antes)
- ✅ Funciona mesmo com dispositivo em **Doze Mode**
- ✅ Funciona mesmo com app em **App Standby**
- ✅ App **NÃO precisa** estar aberto

---

### 4. Activity Configuration

**Arquivo:** `android/app/src/main/AndroidManifest.xml`

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"  <!-- ✅ IMPORTANTE -->
    ...>
```

**Por quê `singleTop`:**
- Quando usuário **clica na notificação**, app abre
- `singleTop` evita criar **múltiplas instâncias** da activity
- Se app já está aberto, reutiliza instância existente
- Permite navegar para tela específica via callback

---

### 5. Callback de Tap na Notificação

```dart
void _onNotificationTapped(NotificationResponse response) {
  log('[TaskNotificationService] Notification tapped: ${response.payload}');
  // Aqui você pode navegar para a tela da tarefa
  // usando o task ID do payload
}
```

**Configurado na inicialização:**
```dart
await _notificationsPlugin.initialize(
  initSettings,
  onDidReceiveNotificationResponse: _onNotificationTapped, // ✅ CALLBACK
);
```

**Comportamento:**
1. Usuário clica na notificação
2. Sistema abre o app (MainActivity)
3. Callback `_onNotificationTapped` é chamado
4. Payload contém ID da tarefa
5. App pode navegar para tela de detalhes da tarefa

---

## 📊 Fluxo Completo

### Caso 1: App Fechado + Dispositivo em Doze
```
1. Usuário agenda tarefa para 14:00 (notificar 10 min antes)
2. App fecha
3. Dispositivo fica inativo por 2h → entra em Doze Mode
4. 13:50 chega
   ↓
5. AlarmManager acorda dispositivo (setExactAndAllowWhileIdle)
6. ScheduledNotificationReceiver recebe broadcast
7. Notificação é exibida (app continua fechado)
8. Usuário clica na notificação
   ↓
9. MainActivity abre
10. Callback onDidReceiveNotificationResponse é chamado
11. App navega para tela da tarefa
```

### Caso 2: Dispositivo Reinicia
```
1. Notificações agendadas na memória são perdidas
2. Sistema envia BOOT_COMPLETED broadcast
3. ScheduledNotificationBootReceiver recebe
4. flutter_local_notifications restaura notificações salvas
5. Alarmes são reagendados no AlarmManager
```

---

## 🔐 Verificação de Permissões em Runtime

### Android 13+ (API 33+)
Notificações requerem permissão runtime:

```dart
Future<bool> requestPermissions({BuildContext? context}) async {
  final result = await _permissionService.requestPermission(
    PermissionType.notification,
    context: context,
    ...
  );
  return result == PermissionRequestResult.granted;
}
```

### Verificar Exact Alarm Permission (Android 12+)
```dart
// flutter_local_notifications faz isso internamente
// mas você pode verificar manualmente se necessário
final canScheduleExactAlarms = await _notificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.canScheduleExactNotifications() ?? false;
```

Se `false`, usuário precisa ativar manualmente em:
**Settings → Apps → iKanban → Alarms & reminders**

---

## 📚 Fontes Oficiais

### Documentação Android
1. **Doze and App Standby:**  
   https://developer.android.com/training/monitoring-device-state/doze-standby

2. **Background Execution Limits:**  
   https://developer.android.com/about/versions/oreo/background

3. **App Standby Buckets:**  
   https://developer.android.com/topic/performance/appstandby

4. **Power Management:**  
   https://developer.android.com/topic/performance/power

5. **Schedule Exact Alarms:**  
   https://developer.android.com/training/scheduling/alarms#exact-alarms

6. **AlarmManager API:**  
   https://developer.android.com/reference/android/app/AlarmManager

7. **setExactAndAllowWhileIdle():**  
   https://developer.android.com/reference/android/app/AlarmManager#setExactAndAllowWhileIdle(int,%20long,%20android.app.PendingIntent)

8. **Schedule notifications (Training):**  
   https://developer.android.com/training/scheduling/alarms

### Flutter Packages
9. **flutter_local_notifications:**  
   https://pub.dev/packages/flutter_local_notifications

10. **flutter_local_notifications - Scheduled Notifications:**  
    https://pub.dev/packages/flutter_local_notifications#-scheduling-a-notification

11. **permission_handler:**  
    https://pub.dev/packages/permission_handler

### Android Compatibility
12. **Android 12 Behavior Changes:**  
    https://developer.android.com/about/versions/12/behavior-changes-12#exact-alarm-permission

13. **Android 13 Behavior Changes:**  
    https://developer.android.com/about/versions/13/behavior-changes-13#runtime-permission

---

## ✅ Garantias da Implementação Atual

### ✅ Notificações são exibidas mesmo com:
- App fechado
- Dispositivo em Doze Mode
- App em App Standby
- App em bucket "Rare"
- Tela desligada

### ✅ Ao clicar na notificação:
- App abre automaticamente
- Activity principal é iniciada (ou retomada se já aberta)
- Callback recebe ID da tarefa
- Possível navegar para tela específica

### ✅ Após reinicialização:
- Notificações são automaticamente reagendadas
- Nenhuma intervenção manual necessária

### ✅ Precisão:
- Notificações disparam no horário **exato** agendado
- Não são adiadas (exceto limite de 15 min entre alarmes no Android 12+)

---

## ⚠️ Considerações Importantes

### 1. Fabricantes podem impor restrições adicionais
Alguns fabricantes (Xiaomi, Huawei, Samsung) têm sistemas PRÓPRIOS de gerenciamento de energia:
- **MIUI (Xiaomi):** "Battery Saver" pode matar apps
- **EMUI (Huawei):** "Protected Apps" precisa ser ativado
- **Samsung:** "Sleeping Apps" pode bloquear alarmes

**Solução:** Orientar usuários a adicionar app à lista de exceções

### 2. Limite de frequência (Android 12+)
Apps não podem agendar alarmes exactAllowWhileIdle mais frequentes que ~15 minutos

### 3. Permissão pode ser revogada
`SCHEDULE_EXACT_ALARM` pode ser desativada pelo usuário em Settings

### 4. Battery optimization
Usuário pode colocar app em "Battery optimization" que restringe ainda mais.
Verificar com:
```dart
final isIgnoringBatteryOptimizations = await Permission
    .ignoreBatteryOptimizations
    .isGranted;
```

---

## 🎯 Conclusão

A implementação atual do iKanban **garante** que:
1. ✅ Notificações sejam exibidas no horário correto
2. ✅ Funcionem mesmo com app fechado
3. ✅ Sobrevivam a Doze Mode e App Standby
4. ✅ Abram o app ao serem clicadas
5. ✅ Sejam reagendadas após reinicialização

Isso foi alcançado usando:
- `AndroidScheduleMode.exactAllowWhileIdle`
- Permissões corretas no manifest
- Receivers para boot e notificações
- Activity com `launchMode="singleTop"`
- Callbacks para interação do usuário

Todas as práticas seguem a documentação oficial do Android e as melhores práticas de 2024.
