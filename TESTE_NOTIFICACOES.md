# 🔍 Guia de Teste e Debug - Notificações

## ⚠️ Problema Relatado
Notificações não estão sendo exibidas nem com app aberto nem fechado.

## ✅ Correções Aplicadas

### 1. **Removida solicitação duplicada de permissões nos Use Cases**
- ❌ **Antes:** Use cases tentavam solicitar permissões sem BuildContext → Falhava silenciosamente
- ✅ **Agora:** Use cases apenas agendam notificações (permissões já foram solicitadas no switch)

### 2. **Corrigida lógica do switch de notificação**
- ❌ **Antes:** Se permissões fossem negadas, switch poderia ficar em estado inconsistente
- ✅ **Agora:** Se permissões forem negadas, switch reverte automaticamente para `false`

### 3. **Adicionada verificação de permissões antes de agendar**
- Serviço agora verifica permissões antes de tentar agendar
- Se permissões não estiverem concedidas, retorna com log de alerta

### 4. **Adicionados logs detalhados**
- ✅ Log quando notificação é agendada com sucesso
- ⚠️ Log quando permissões não estão concedidas
- ❌ Log quando há erro no agendamento

---

## 🧪 Como Testar (Passo a Passo)

### Teste 1: Verificar Permissões

```bash
# Execute o app em modo debug
flutter run

# Preste atenção nos logs do console
```

**Passos:**
1. Abra o formulário de criação de tarefa
2. Preencha título, data e hora
3. **Ative o switch de notificação**
4. Observe os logs no console:

**Logs Esperados:**
```
[TaskNotificationService] Permission request result: true
[TaskNotificationService] Can schedule exact alarms: true (Android 12+)
```

**Se aparecer:**
```
[TaskNotificationService] Permission request result: false
```
→ **PROBLEMA:** Usuário negou permissão de notificações

4. Toque em **Salvar**
5. Observe os logs:

**Logs Esperados:**
```
[TaskNotificationService] ✅ Scheduling notification for task X at 2026-03-15 14:50:00.000
[TaskNotificationService] ✅ SUCCESS! Notification scheduled for task X at 2026-03-15 14:50:00.000
[TaskNotificationService]    - Task title: Minha Tarefa
[TaskNotificationService]    - Scheduled for: 2026-03-15 14:50:00.000
[TaskNotificationService]    - Minutes before: 10
[TaskNotificationService]    - Task due: 2026-03-15 15:00:00.000
```

**Se aparecer:**
```
[TaskNotificationService] ⚠️ WARNING: Notification permission not granted! Skipping scheduling.
```
→ **PROBLEMA:** Permissões não estão concedidas (mesmo após ativar o switch)

---

### Teste 2: Verificar Notificações Pendentes

Adicione este código temporariamente no final do método `scheduleTaskNotification`:

```dart
// Debug: Verificar notificações pendentes
final pending = await _notificationsPlugin.pendingNotificationRequests();
log('[TaskNotificationService] 📋 Total pending notifications: ${pending.length}');
for (var notif in pending) {
  log('[TaskNotificationService]    - ID: ${notif.id}, Title: ${notif.title}');
}
```

**Logs Esperados:**
```
[TaskNotificationService] 📋 Total pending notifications: 1
[TaskNotificationService]    - ID: 1, Title: Lembrete: Minha Tarefa
```

---

### Teste 3: Testar Notificação Imediata

Para testar se as notificações estão funcionando, crie uma tarefa com:
- **Data:** Hoje
- **Hora:** 2 minutos no futuro
- **Notificar antes:** 0 minutos

Exemplo:
- Hora atual: 14:30
- Hora da tarefa: 14:32
- Notificar: 0 minutos antes

**Resultado Esperado:** Notificação deve aparecer em 2 minutos

---

## 🔍 Checklist de Diagnóstico

Execute este checklist para identificar o problema:

### ☑️ 1. Permissões do Sistema

**Android 13+:**
- [ ] Ir em **Configurações** → **Apps** → **iKanban** → **Permissões**
- [ ] Verificar se **Notificações** está ativada
- [ ] Ir em **Alarmes e lembretes** → Verificar se está ativada

**Android 12:**
- [ ] Ir em **Configurações** → **Apps** → **iKanban** → **Alarmes e lembretes**
- [ ] Verificar se está ativada

**Android < 12:**
- [ ] Notificações devem estar ativadas automaticamente

---

### ☑️ 2. Verificação no App

- [ ] Abrir formulário de tarefa
- [ ] Tentar ativar switch de notificação
- [ ] Se diálogo de permissão aparecer → **Conceder**
- [ ] Se diálogo de "Alarmes e lembretes" aparecer → **Ativar**
- [ ] Verificar se switch fica **verde/ativado**
- [ ] Se switch reverter para **cinza/desativado** → Permissões NÃO foram concedidas

---

### ☑️ 3. Verificação dos Logs

Execute:
```bash
flutter run --verbose
```

Procure por:
- ✅ `[TaskNotificationService] ✅ SUCCESS!` → Notificação agendada
- ⚠️ `[TaskNotificationService] ⚠️ WARNING:` → Problema com permissões
- ❌ `[TaskNotificationService] ❌ ERROR` → Erro no agendamento

---

### ☑️ 4. Teste de Economia de Energia

**Algumas fabricantes (Xiaomi, Huawei, Samsung) bloqueiam notificações:**

**Xiaomi (MIUI):**
- [ ] Configurações → Apps → iKanban → "Economia de bateria" → **Sem restrições**
- [ ] Configurações → Apps → iKanban → "Iniciar automaticamente" → **Ativar**

**Huawei (EMUI):**
- [ ] Configurações → Apps → iKanban → "Otimização de bateria" → **Não otimizar**

**Samsung:**
- [ ] Configurações → Bateria → Apps em segundo plano → iKanban → **Sem restrições**

---

## 🐛 Possíveis Causas do Problema

### 1. Permissões Não Concedidas
**Sintoma:** Switch reverte para desativado
**Solução:** 
- Conceder permissões manualmente em Configurações
- Ou desinstalar e reinstalar o app

### 2. Hora da Notificação Já Passou
**Sintoma:** Notificação agendada mas nunca aparece
**Solução:**
- Verificar se `scheduledDate` não está no passado
- Logs devem mostrar: `Cannot schedule notification: time has passed`

### 3. Exact Alarm Negada (Android 12+)
**Sintoma:** Notificação atrasada ou não aparece com dispositivo em Doze mode
**Solução:**
- Ativar "Alarmes e lembretes" em Configurações → Apps → iKanban

### 4. Dispositivo em Modo de Economia de Energia
**Sintoma:** Notificações só aparecem quando app está aberto
**Solução:**
- Adicionar app à lista de exceções de economia de bateria
- Desativar "Otimização de bateria" para o app

### 5. Fabricante Bloqueando Notificações
**Sintoma:** Notificações não aparecem mesmo com permissões concedidas
**Solução:**
- Verificar configurações específicas do fabricante (Xiaomi, Huawei, etc.)
- Adicionar app à "lista branca" ou "apps protegidos"

---

## 📊 Teste Completo (Para Reportar Problema)

Execute este teste e envie os resultados:

```bash
flutter run --verbose > test_log.txt 2>&1
```

**Passos:**
1. Abrir app
2. Criar nova tarefa
3. Ativar switch de notificação (conceder todas as permissões)
4. Definir data/hora para 2 minutos no futuro
5. Salvar tarefa
6. Aguardar 2 minutos
7. Verificar se notificação apareceu

**Enviar:**
- [ ] Arquivo `test_log.txt`
- [ ] Versão do Android: _________
- [ ] Fabricante do dispositivo: _________
- [ ] Notificação apareceu? (Sim/Não): _________

---

## ✅ Se Tudo Estiver Funcionando

Você deve ver nos logs:

```
[TaskNotificationService] ✅ Scheduling notification for task 1 at 2026-03-15 14:50:00.000
[TaskNotificationService] ✅ SUCCESS! Notification scheduled for task 1 at 2026-03-15 14:50:00.000
```

E a notificação deve aparecer no horário agendado, **mesmo com app fechado**.

---

## 🆘 Ainda Não Funciona?

Se após todas as verificações as notificações ainda não funcionarem:

1. **Limpar dados do app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Desinstalar e reinstalar:**
   - Desinstalar app completamente
   - Reinstalar via `flutter run`
   - Conceder permissões novamente

3. **Verificar versão do package:**
   ```yaml
   # pubspec.yaml
   flutter_local_notifications: ^17.0.0  # Ou mais recente
   ```

4. **Reportar problema:**
   - Enviar `test_log.txt`
   - Informações do dispositivo
   - Screenshots das permissões
