# HabitQuest - App de Gestão de Hábitos com Gamificação

**Projeto de Programação Mobile 2025/2026**

## 🎯 Descrição

Aplicação móvel desenvolvida em Flutter para ajudar utilizadores a criar e manter hábitos saudáveis através de um sistema de registo diário, progressão visual, desafios e elementos de gamificação que incentivem a consistência.

## 👥 Grupo

- Aluno 27639
- Aluno 27640
- Aluno 27653

## 🚀 Como Executar

### ⚠️ Pré-requisito: Instalar Flutter

**Se você receber o erro** `flutter : The term 'flutter' is not recognized`:

1. Execute o script de diagnóstico:
   ```powershell
   .\check_flutter.ps1
   ```

2. Ou consulte o guia completo de instalação:
   - **FLUTTER_SETUP_GUIDE.md** - Guia passo-a-passo para Windows
   - **INSTALL.md** - Instruções do projeto

### 1. Instalar as dependências

```bash
flutter pub get
```

### 2. Executar a aplicação

```bash
flutter run
```

Ou utilize o botão "Run" no IDE.

### 💡 Instalação Automática

Execute o script de instalação completo:
```powershell
.\install.ps1
```

## ✨ Funcionalidades Implementadas

### Core Features
- ✅ **CRUD de Hábitos**: Criar, editar, eliminar e visualizar hábitos personalizados
- ✅ **Check-in Diário**: Marcar hábitos como concluídos com animações
- ✅ **Categorias**: 12 categorias de hábitos (Saúde, Fitness, Alimentação, etc.)
- ✅ **Ícones Personalizados**: 32 emojis para personalizar hábitos
- ✅ **Sugestões Rápidas**: 8 hábitos pré-configurados para começar rapidamente

### Sistema de Gamificação
- ✅ **XP (Experience Points)**: Ganhar 5-50 XP ao completar hábitos
- ✅ **Sistema de Níveis**: 10+ níveis progressivos com títulos únicos
  - Iniciante → Aprendiz → Praticante → Dedicado → Mestre → Grão-Mestre → Lenda
- ✅ **Streaks**: Contagem de dias consecutivos
  - Streak atual
  - Melhor streak histórico
  - Indicador visual com 🔥

### Conquistas
- ✅ **17 Conquistas Desbloqueáveis**:
  - 5 conquistas de Streak (3, 7, 14, 30, 100 dias)
  - 4 conquistas de Total de Hábitos
  - 4 conquistas de Completions
  - 2 conquistas de Nível
  - 2 conquistas Especiais (Dia Perfeito, Madrugador)

### Desafios
- ✅ **Desafios Semanais**: 3 desafios que renovam semanalmente
- ✅ **Desafios Mensais**: 2 desafios que renovam mensalmente
- ✅ **Sistema de Progresso**: Barra de progresso e contador
- ✅ **Recompensas XP**: Bónus ao completar desafios

### Estatísticas e Visualização
- ✅ **Dashboard Principal**: Resumo de progresso diário
- ✅ **Detalhes do Hábito**:
  - Calendário de atividade mensal
  - Taxa de sucesso
  - Estatísticas detalhadas
- ✅ **Perfil de Utilizador**:
  - Nível e XP
  - Total de hábitos ativos
  - Estatísticas globais
  
### Persistência de Dados
- ✅ **SharedPreferences**: Armazenamento local de todos os dados
- ✅ **Auto-save**: Dados salvos automaticamente
- ✅ **Não requer internet**: Funciona 100% offline

### Interface e UX
- ✅ **Material Design 3**: UI moderna e responsiva
- ✅ **Tema Claro/Escuro**: Suporte automático baseado no sistema
- ✅ **Animações**: Transições suaves e feedback visual
- ✅ **Gradientes e Cores**: Paleta de cores vibrante
- ✅ **Bottom Navigation**: Navegação intuitiva entre 4 secções

## 📱 Ecrãs da Aplicação

1. **Início (Home)**
   - Lista de hábitos do dia
   - Progresso diário
   - Estatísticas rápidas
   - Botão para adicionar hábitos

2. **Desafios**
   - Desafios ativos
   - Desafios completos
   - Progresso e recompensas

3. **Conquistas**
   - Galeria de badges
   - Conquistas desbloqueadas/bloqueadas
   - Progresso global

4. **Perfil**
   - Informações do utilizador
   - Nível e XP
   - Estatísticas globais
   - Configurações

5. **Adicionar/Editar Hábito**
   - Formulário completo
   - Seletor de ícone
   - Categorias
   - XP e meta personalizáveis
   - Sugestões rápidas

6. **Detalhes do Hábito**
   - Calendário de atividade
   - Estatísticas detalhadas
   - Gráficos de progresso

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework principal
- **Dart**: Linguagem de programação
- **Provider**: Gestão de estado
- **SharedPreferences**: Persistência de dados
- **Material Design 3**: Sistema de design

## 📦 Estrutura do Projeto

```
lib/
├── main.dart                    # Entrada da aplicação
├── models/                      # Modelos de dados
│   ├── habit.dart
│   ├── user_profile.dart
│   ├── achievement.dart
│   └── challenge.dart
├── providers/                   # Gestão de estado
│   └── habit_provider.dart
├── screens/                     # Ecrãs da aplicação
│   ├── home_screen.dart
│   ├── add_habit_screen.dart
│   ├── habit_detail_screen.dart
│   ├── challenges_screen.dart
│   ├── achievements_screen.dart
│   └── profile_screen.dart
├── services/                    # Serviços
│   └── storage_service.dart
├── utils/                       # Utilitários
│   └── constants.dart
└── widgets/                     # Componentes reutilizáveis
    ├── habit_card.dart
    ├── progress_widgets.dart
    ├── achievement_badge.dart
    └── challenge_card.dart
```

## 🎨 Design e Tema

- **Cores Principais**:
  - Primária: #6C63FF (Roxo)
  - Secundária: #00D9A5 (Verde)
  - Accent: #FFB74D (Laranja)
  
- **Fontes**: Fonte padrão do sistema
- **Ícones**: Material Icons + Emojis

## 📊 Dados Persistentes

Todos os dados são armazenados localmente usando SharedPreferences:
- Hábitos criados e seu histórico
- Perfil do utilizador (nome, XP, nível)
- Conquistas desbloqueadas
- Progresso dos desafios

## 🔄 Fluxo da Aplicação

1. **Primeira Execução**: Utilizador é recebido com perfil padrão
2. **Criar Hábito**: Adicionar hábito personalizado ou usar sugestão
3. **Completar Diariamente**: Marcar hábitos como completos
4. **Ganhar XP**: Receber pontos e subir de nível
5. **Desbloquear Conquistas**: Atingir objetivos e receber badges
6. **Completar Desafios**: Ganhar XP extra
7. **Ver Progresso**: Acompanhar estatísticas e evolução

## 🐛 Resolução de Problemas

### ❌ Erro: "flutter is not recognized"
**Causa**: Flutter não está instalado ou não está no PATH do sistema.

**Solução Rápida**:
```powershell
.\check_flutter.ps1
```

**Solução Completa**: Consulte **FLUTTER_SETUP_GUIDE.md**

Passos básicos:
1. Baixar Flutter SDK de: https://docs.flutter.dev/get-started/install/windows
2. Extrair para: `C:\src\flutter\`
3. Adicionar ao PATH: `C:\src\flutter\bin`
4. Reiniciar o terminal/IDE
5. Verificar: `flutter doctor`

### Erro "Target of URI doesn't exist"
Execute: `flutter pub get`

### Problemas de compilação
Execute: `flutter clean` seguido de `flutter pub get`

### Flutter Doctor mostra avisos
Execute: `flutter doctor --android-licenses` para aceitar licenças do Android

## 📝 Notas de Desenvolvimento

- **SDK Flutter**: ^3.9.2
- **Provider**: ^6.1.2
- **SharedPreferences**: ^2.3.4

## 🎓 Projeto Académico

Este projeto foi desenvolvido como parte da avaliação da unidade curricular de Programação Mobile no 1º Semestre de 2025/2026.

Data de Entrega: 06 de janeiro de 2026

---

**Desenvolvido com ❤️ usando Flutter**

