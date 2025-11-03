# 📋 iKanban - Flutter Task Management App

<div align="center">
  <img src="assets/images/logo.png" alt="iKanban Logo" width="150"/>
  
  **Um aplicativo completo de gerenciamento de tarefas inspirado no método Kanban**
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)
  
</div>

---

## 📖 Sobre o Projeto

**iKanban** é um aplicativo de produtividade desenvolvido em **Flutter** que implementa o método Kanban para gerenciamento visual de tarefas. O projeto combina uma interface moderna e intuitiva com uma arquitetura robusta baseada em **Clean Architecture**.

### 🎯 **Características Principais:**
- 📱 **Multi-plataforma**: Android, iOS, Web, Windows, Linux e macOS
- 🎨 **Interface moderna** com temas claro/escuro
- 🔍 **Sistema de busca** expansível e responsivo
- 📊 **Kanban board** visual para organização de tarefas
- 🏷️ **Sistema completo de categorização** (prioridade, complexidade, status)
- 💾 **Armazenamento local** com SQLite
- 🌍 **Internacionalização** (PT-BR e EN-US)

---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com uma estrutura bem definida:

```
lib/
├── core/                    # Núcleo da aplicação
│   ├── database/           # Configuração do banco de dados (Drift)
│   ├── di/                 # Injeção de dependência (Get It)
│   ├── navigation/         # Roteamento (Go Router)
│   ├── theme/             # Temas e configurações visuais
│   ├── ui/                # Componentes UI reutilizáveis
│   └── utils/             # Utilitários e helpers
├── features/               # Funcionalidades por domínio
│   ├── board/             # Funcionalidade do quadro Kanban
│   ├── task/              # Gerenciamento de tarefas
│   └── settings/          # Configurações da aplicação
└── main.dart              # Ponto de entrada da aplicação
```

### 🔧 **Padrões Arquiteturais:**
- **Clean Architecture** - Separação clara de responsabilidades
- **BLoC Pattern** - Gerenciamento de estado reativo
- **Repository Pattern** - Abstração da camada de dados
- **Dependency Injection** - Inversão de controle com GetIt
- **Feature-based Structure** - Organização por funcionalidades

---

## ⚙️ Tecnologias e Dependências

### 📦 **Principais Dependências:**

| Categoria | Tecnologia | Propósito |
|-----------|------------|-----------|
| **Estado** | `flutter_bloc` | Gerenciamento de estado |
| **Banco de Dados** | `drift` + `sqlite3_flutter_libs` | ORM e persistência local |
| **Navegação** | `go_router` | Roteamento declarativo |
| **DI** | `get_it` | Injeção de dependência |
| **Serialização** | `freezed` + `json_annotation` | Modelos imutáveis |
| **Tema** | `provider` | Gerenciamento de temas |
| **Internacionalização** | `intl` | Suporte multi-idioma |

### 🛠️ **Ferramentas de Desenvolvimento:**

```yaml
dev_dependencies:
  build_runner: ^2.6.0      # Geração de código
  drift_dev: ^2.28.1        # Geração do banco de dados
  flutter_lints: ^5.0.0     # Análise de código
  flutter_launcher_icons: ^0.14.4  # Geração de ícones
```

---

## 🚀 Funcionalidades

### 📋 **Gerenciamento de Tarefas**
- ✅ **CRUD completo** - Criar, editar, visualizar e excluir tarefas
- 🏷️ **Categorização avançada**:
  - **Status**: Backlog, A Fazer, Em Progresso, Bloqueado, Em Revisão, Testando, Concluído, Cancelado
  - **Prioridade**: Mínima, Baixa, Média, Alta, Máxima, Crítica
  - **Complexidade**: Fácil, Média, Difícil, Muito Difícil
  - **Tipo**: Pessoal, Trabalho, Estudo, Projeto
- 🎨 **Sistema de cores** personalizáveis para tarefas
- 📅 **Datas de vencimento** com controle temporal
- 🔍 **Busca inteligente** com filtros avançados

### 🎛️ **Interface e UX**
- 📱 **AppBar customizada** com busca expansível
- 🌙 **Modo escuro/claro** com alternância automática
- 📊 **Visualização em Kanban** para fluxo de trabalho
- 🧭 **Navegação inferior** intuitiva
- 📱 **Design responsivo** para todas as telas

### 🔧 **Configurações**
- 🎨 **Personalização de temas**
- 🌍 **Seleção de idioma**
- 📊 **Preferências de visualização**
- 🔔 **Configurações de notificação**

---

## 📱 Screenshots

### 🏠 Tela Principal - Lista de Tarefas
- Visualização em lista com filtros
- Cards coloridos por categoria
- Indicadores de status e prioridade

### 📝 Criação/Edição de Tarefas
- Formulário completo com validação
- Seletores visuais para categorias
- Picker de data intuitivo

### ⚙️ Configurações
- Toggle para tema escuro/claro
- Seleção de idioma
- Preferências de usuário

---

## 🛠️ Instalação e Configuração

### 📋 **Pré-requisitos:**
- **Flutter SDK** ≥ 3.9.2
- **Dart SDK** ≥ 3.0.0
- **Android Studio** / **VS Code** com extensões Flutter
- **Git** para controle de versão

### 🚀 **Passos para executar:**

```bash
# 1. Clone o repositório
git clone https://github.com/igorsantos314/flutter-ikanban-app.git
cd flutter-ikanban-app

# 2. Instale as dependências
flutter pub get

# 3. Gere os arquivos necessários
flutter packages pub run build_runner build

# 4. Execute o aplicativo
flutter run
```

### 🗄️ **Configuração do Banco de Dados:**

O projeto utiliza **Drift** como ORM. Os arquivos são gerados automaticamente:

```bash
# Gerar arquivos do banco de dados
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 🎨 **Configuração de Ícones:**

```bash
# Gerar ícones para todas as plataformas
flutter pub run flutter_launcher_icons
```

---

## 📁 Estrutura Detalhada do Projeto

### 🎯 **Core (Núcleo)**
```
core/
├── database/
│   ├── app_database.dart          # Configuração principal do banco
│   └── app_database.g.dart        # Arquivo gerado pelo Drift
├── di/
│   └── app_locator.dart           # Configuração da injeção de dependência
├── navigation/
│   ├── app_navigation.dart        # Configuração de rotas
│   └── ui/scaffold_with_nav_bar.dart  # Layout principal
├── theme/
│   └── theme_provider.dart        # Gerenciador de temas
├── ui/widgets/
│   └── appbar/custom_app_bar.dart # AppBar personalizada
└── utils/
    └── mapper/                    # Conversores de tipo SQL
```

### 🔧 **Features (Funcionalidades)**

#### 📋 **Tasks (Tarefas)**
```
features/task/
├── data/
│   └── task_repository_impl.dart      # Implementação do repositório
├── domain/
│   ├── enums/                         # Enumerações (Status, Prioridade, etc.)
│   ├── model/task_model.dart          # Modelo da tarefa
│   └── repository/task_repository.dart # Interface do repositório
├── infra/local/
│   └── tables/task_table_entity.dart  # Entidade do banco de dados
└── presentation/
    ├── colors/task_colors.dart        # Sistema de cores
    └── pages/                         # Telas da funcionalidade
```

#### 🎛️ **Settings (Configurações)**
```
features/settings/
└── presentation/pages/
    └── settings_page.dart             # Tela de configurações
```

---

## 🔄 Fluxo de Dados

### 📊 **Arquitetura em Camadas:**

```
UI (Presentation) 
    ↓ Events
BLoC (Business Logic)
    ↓ Calls
Repository (Domain)
    ↓ Implementation
Data Source (Infrastructure)
    ↓ Persistence
SQLite Database
```

### 🔄 **Ciclo de Vida das Tarefas:**

```
Backlog → A Fazer → Em Progresso → Em Revisão → Concluído
                      ↓
                   Bloqueado ←→ Testando
                      ↓
                   Cancelado
```

---

## 🧪 Testes

### 🔍 **Estrutura de Testes:**
```
test/
├── unit/                 # Testes unitários
├── integration/          # Testes de integração
└── widget/              # Testes de widgets
    └── widget_test.dart # Exemplo de teste
```

### ▶️ **Executar Testes:**
```bash
# Todos os testes
flutter test

# Testes com coverage
flutter test --coverage
```

---

## 🚀 Build e Deploy

### 📱 **Android:**
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

### 🍎 **iOS:**
```bash
# iOS Build
flutter build ios --release
```

### 🌐 **Web:**
```bash
# Web Build
flutter build web --release
```

### 🖥️ **Desktop:**
```bash
# Windows
flutter build windows --release

# Linux
flutter build linux --release

# macOS
flutter build macos --release
```

---

## 🤝 Contribuindo

### 📝 **Como Contribuir:**

1. **Fork** o projeto
2. Crie uma **branch** para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. Abra um **Pull Request**

### 📋 **Padrões de Código:**
- Seguir o **Dart Style Guide**
- Utilizar **flutter_lints** para análise
- Manter **cobertura de testes** > 80%
- Documentar **APIs públicas**

---

## 📄 Licença

Este projeto está sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

---

## 👥 Autor

**Igor Santos**
- GitHub: [@igorsantos314](https://github.com/igorsantos314)
- LinkedIn: [Igor Santos](https://linkedin.com/in/igorsantos314)

---

## 🎯 Roadmap

### 🔮 **Próximas Funcionalidades:**
- [ ] 🔔 Sistema de notificações push
- [ ] ☁️ Sincronização em nuvem
- [ ] 👥 Colaboração em equipe
- [ ] 📊 Relatórios e analytics
- [ ] 🔄 Integração com APIs externas
- [ ] 📱 Widget para tela inicial
- [ ] 🎵 Sons e haptic feedback
- [ ] 🌐 PWA (Progressive Web App)

### 🛠️ **Melhorias Técnicas:**
- [ ] 🧪 Aumentar cobertura de testes
- [ ] 🚀 Otimizações de performance
- [ ] 🔧 CI/CD com GitHub Actions
- [ ] 📚 Documentação da API
- [ ] 🐛 Sistema de crash reporting

---

<div align="center">
  
**⭐ Se este projeto foi útil para você, considere dar uma estrela!**

**📚 Desenvolvido com 💙 em Flutter**

</div>
