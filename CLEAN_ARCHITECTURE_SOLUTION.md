# Clean Architecture - Solução para Exportação de Dados

## 🏗️ Estrutura Implementada

### **Problema Original:**
- A função de exportar tarefas estava diretamente na página de Settings
- Violação dos princípios da Clean Architecture (features se conversando diretamente)
- Acoplamento forte entre Settings e Tasks

### **Solução Implementada:**

```
📁 core/
├── 📁 use_cases/
│   ├── export_data_use_case.dart     # Coordena exportação de todas as features
│   └── import_data_use_case.dart     # Coordena importação de todas as features
│
├── 📁 services/
│   └── data_backup_service.dart      # Facade para operações de backup
│
└── 📁 di/
    └── app_locator.dart              # Registro de dependências

📁 features/
├── 📁 settings/
│   └── presentation/
│       ├── bloc/settings_bloc.dart   # Usa DataBackupService
│       └── events/settings_events.dart
│
└── 📁 task/
    └── domain/
        └── repository/task_repository.dart  # Interface para acesso a dados
```

## 🔄 Fluxo da Arquitetura

### **1. Camada de Apresentação (Settings)**
```dart
// SettingsPage dispara evento
context.read<SettingsBloc>().add(ExportDataEvent());
```

### **2. Camada de Aplicação (BLoC)**
```dart
// SettingsBloc delega para serviço de aplicação
final outcome = await dataBackupService.exportAllData();
```

### **3. Camada de Serviços (Core)**
```dart
// DataBackupService coordena use cases
return exportDataUseCase.execute();
```

### **4. Camada de Casos de Uso (Core)**
```dart
// ExportDataUseCase acessa repositórios através de interfaces
final settingsOutcome = await _settingsRepository.loadSettings();
final tasksOutcome = await _taskRepository.watchTasks(...);
```

### **5. Camada de Domínio (Features)**
```dart
// Repositórios implementam interfaces do domínio
// Não há comunicação direta entre features
```

## ✅ Princípios da Clean Architecture Atendidos

### **1. Independência de Features**
- ❌ **Antes**: Settings acessava diretamente dados de Tasks
- ✅ **Depois**: Use case coordena através de interfaces de repositório

### **2. Inversão de Dependência**
- ❌ **Antes**: Dependência direta Settings → Tasks
- ✅ **Depois**: Ambas dependem de abstrações (interfaces)

### **3. Separação de Responsabilidades**
- **Use Cases**: Lógica de negócio específica (export/import)
- **Services**: Coordenação de múltiplos use cases
- **BLoC**: Gerenciamento de estado da UI
- **Repositories**: Acesso a dados

### **4. Testabilidade**
- Cada camada pode ser testada independentemente
- Mocks podem ser injetados facilmente
- Use cases são puramente funcionais

## 🎯 Benefícios Obtidos

### **1. Baixo Acoplamento**
```dart
// Settings não conhece Tasks diretamente
class SettingsBloc {
  final DataBackupService dataBackupService; // ← Depende da abstração
}
```

### **2. Alta Coesão**
```dart
// Cada use case tem responsabilidade única
class ExportDataUseCase {
  Future<Outcome<String, ExportDataError>> execute() // ← Faz só uma coisa
}
```

### **3. Reutilização**
```dart
// DataBackupService pode ser usado em qualquer feature
class AdminPanel {
  final DataBackupService dataBackupService; // ← Reutilização
}
```

### **4. Manutenibilidade**
- Mudanças em Tasks não afetam Settings
- Novos tipos de export podem ser adicionados facilmente
- Lógica centralizada e organizada

## 🔧 Como Usar

### **Exportação:**
```dart
// Na UI (Settings)
context.read<SettingsBloc>().add(ExportDataEvent());

// No BLoC
final outcome = await dataBackupService.exportAllData();
outcome.when(
  success: (filePath) => /* sucesso */,
  failure: (error, message, throwable) => /* erro */,
);
```

### **Importação:**
```dart
// Na UI (Settings)  
context.read<SettingsBloc>().add(ImportDataEvent(filePath: path));

// No BLoC
final outcome = await dataBackupService.importDataFromFile(filePath);
outcome.when(
  success: (result) => /* ${result.tasksImported} tarefas */,
  failure: (error, message, throwable) => /* erro */,
);
```

## 🧪 Testes

### **Use Cases (Unitários)**
```dart
test('should export data successfully', () async {
  // Given
  final mockSettingsRepo = MockSettingsRepository();
  final mockTaskRepo = MockTaskRepository();
  final useCase = ExportDataUseCase(/*...*/);
  
  // When
  final result = await useCase.execute();
  
  // Then
  expect(result.isSuccess, true);
});
```

### **Services (Integração)**
```dart
test('should coordinate export and import', () async {
  // Test DataBackupService coordinating multiple use cases
});
```

### **BLoC (Estado)**
```dart
test('should emit success state on export', () async {
  // Test SettingsBloc state management
});
```

## 🚀 Extensibilidade

### **Novos Tipos de Export:**
```dart
class ExportToCloudUseCase { 
  // Implementar export para nuvem
}

class ExportToPDFUseCase { 
  // Implementar export para PDF
}
```

### **Novas Features:**
```dart
class ExportProjectsUseCase { 
  // Adicionar export de projetos sem afetar código existente
}
```

---

## 📋 Resultado Final

✅ **Features independentes**  
✅ **Baixo acoplamento**  
✅ **Alta coesão**  
✅ **Facilmente testável**  
✅ **Altamente reutilizável**  
✅ **Manutenível**  
✅ **Extensível**  

**Esta é a implementação ideal seguindo os princípios da Clean Architecture!** 🎉