# Reorganização da Feature Theme

## 📋 Análise da Situação Atual

### ❌ **Problemas Identificados:**
1. Theme está dividido entre `core/theme/` e `features/theme/`
2. Inconsistência: ThemeProvider no core, ThemeRepository em features
3. Violação da Clean Architecture: Theme não é uma feature de negócio

### ✅ **Solução: Theme como Shared Concern**

Theme deve estar em `shared/` ou `core/` porque:
- É usado por todas as features
- Não tem regras de negócio próprias
- É infraestrutura transversal
- Não representa um domínio

## 🏗️ Nova Estrutura Proposta

```
📁 core/
├── 📁 theme/
│   ├── theme_enum.dart           # Enums de tema
│   ├── app_theme.dart            # Definições dos temas
│   ├── theme_config.dart         # Configurações
│   └── theme_extension.dart      # Extensions
│
📁 shared/
├── 📁 theme/
│   ├── 📁 domain/
│   │   ├── models/
│   │   │   └── theme_preference_model.dart
│   │   └── repositories/
│   │       └── theme_repository.dart
│   ├── 📁 data/
│   │   └── theme_repository_impl.dart
│   ├── 📁 infra/
│   │   └── theme_data_source.dart
│   └── 📁 presentation/
│       └── providers/
│           └── theme_provider.dart
│
📁 features/
├── 📁 settings/
│   └── presentation/
│       └── widgets/
│           └── theme_selector_widget.dart  # Widget específico de settings
```

## 🔄 Migração Planejada

### Passo 1: Criar estrutura shared
### Passo 2: Mover arquivos de features/theme para shared/theme
### Passo 3: Atualizar imports
### Passo 4: Remover features/theme
### Passo 5: Atualizar DI