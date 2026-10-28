# Minha Lista de Compras

Aplicativo Android desenvolvido em Flutter para a disciplina **Desenvolvimento para Dispositivos Móveis (2026)**. Consiste em uma lista de compras funcional com armazenamento local em SQLite, sincronização simulada com servidor, navegação declarativa, *deep linking* e integração com código nativo Kotlin, estruturada em Arquitetura em Camadas (Apresentação, Domínio e Dados).

---

## 👨‍💻 Autoria
- **Desenvolvedor:** Lafaete Dias Alves
- **Matrícula:** 000000000
- **Turma:** Desenvolvimento para Dispositivos Móveis — 2026

---

## 📌 Sumário
1. [Prints do Aplicativo](#-prints-do-aplicativo)
2. [Funcionalidades](#-funcionalidades)
3. [Tecnologias Utilizadas](#-tecnologias-utilizadas)
4. [Arquitetura](#-arquitetura)
5. [Estrutura de Pastas](#-estrutura-de-pastas)
6. [Banco de Dados](#-banco-de-dados)
7. [Sincronização e Conectividade](#-sincronização-e-conectividade)
8. [Navegação e Ligação Profunda (Deep Linking)](#-navegação-e-ligação-profunda-deep-linking)
9. [Canal de Plataforma (Kotlin)](#-canal-de-plataforma-kotlin)
10. [Responsividade, Tema e Acessibilidade](#-responsividade-tema-e-acessibilidade)
11. [Como Executar o Projeto](#-como-executar-o-projeto)
12. [Testes Automatizados](#-testes-automatizados)
13. [Gerar e Instalar o APK](#-gerar-e-instalar-o-apk)
14. [Decisões de Projeto e Simplificações](#-decisões-de-projeto-e-simplificações)
15. [Referências](#-referências)

---

## 📱 Prints do Aplicativo

*(Adicione suas capturas de tela dentro da pasta `docs/prints/` do repositório)*

| Lista de Itens | Formulário / Edição | Tela Sobre |
|:---:|:---:|:---:|
| ![Lista](docs/prints/tela_lista.png) | ![Formulário](docs/prints/tela_item.png) | ![Sobre](docs/prints/tela_sobre.png) |

---

## ✨ Funcionalidades
- **Cadastro e Edição:** Inserção e atualização de itens com nome, categoria, quantidade e observação, com validação de campos.
- **Gerenciamento de Estado:** Marcação de itens como comprados (item riscado e ordenado para o fim da lista).
- **Remoção Otimista:** Exclusão de itens via gesto de arrastar (*Dismissible*).
- **Persistência Local (SQLite):** Os dados são mantidos permanentemente no dispositivo via banco relacional `sqflite`.
- **Conectividade e Retentativas:** Sincronização offline-first com servidor simulado via *backoff exponencial com jitter*.
- **Aviso de Rede:** Detecção de estado offline e sincronização automática ao restabelecer conexão.
- **Deep Linking:** Abertura direta de itens pelo esquema `compras://app/item/<id>`.
- **Canal Nativo:** Exibição de informações do aparelho (marca, modelo, versão do Android e bateria) obtidas via Kotlin (`MethodChannel`).
- **Interface Responsiva:** Adaptação da grade em 1, 2 ou 3 colunas conforme a largura da tela (*LayoutBuilder*).
- **Suporte a Temas:** Alternância automática entre tema claro e escuro baseando-se no sistema.

---

## 🛠️ Tecnologias Utilizadas
| Tecnologia | Uso |
| :--- | :--- |
| **Flutter & Dart** | Framework e linguagem principal |
| **flutter_riverpod** | Gerenciamento de estado e injeção de dependências (`AsyncNotifier`, `Notifier`) |
| **go_router** | Rotas declarativas e tratamento de deep links |
| **sqflite** | Persistência relacional SQLite no Android |
| **connectivity_plus** | Monitoramento em tempo real da conexão de rede |
| **Kotlin** | Código nativo do Android para comunicação via `MethodChannel` |
| **sqflite_common_ffi** | Suporte ao SQLite para execução de testes unitários/integração no computador |

---

## 🏗️ Arquitetura

O projeto adota uma arquitetura em camadas rígida, garantindo que o **Domínio** permaneça completamente isolado e independente de frameworks ou bancos de dados:

```text
┌──────────────────────── Apresentação ────────────────────────┐
│ Telas, Componentes e Widgets                                 │
│ providers.dart (Composition Root / Injeção de Dependências)  │
└───────────────┬──────────────────────────────────────────────┘
                │ usa
┌───────────────▼──────────────────────────────────────────────┐
│ Domínio: Entidade Item, Regras de Validação,                 │
│          Contrato ItemRepository                             │
└───────────────▲──────────────────────────────────────────────┘
                │ implementa
┌───────────────┴──────────────────────────────────────────────┐
│ Dados: SQLite (sqflite), Servidor Simulado,                  │
│        Sincronização e Canal de Plataforma                   │
└──────────────────────────────────────────────────────────────┘
```

---

## 📂 Estrutura de Pastas

```text
app_sql_lite/
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml          # Permissões e esquema de Deep Link
│       └── kotlin/.../MainActivity.kt   # Lado Kotlin do MethodChannel
├── docs/
│   └── prints/                          # Capturas de tela para documentação
├── lib/
│   ├── main.dart                        # Ponto de entrada (ProviderScope)
│   ├── app.dart                         # MaterialApp.router e configuração de temas
│   ├── config/
│   │   └── identidade.dart              # Dados do projeto, autoria e categorias
│   ├── dominio/
│   │   ├── item.dart                    # Entidade imutável
│   │   ├── regras_item.dart             # Regras de validação e ordenação
│   │   └── item_repository.dart        # Interface do repositório
│   ├── dados/
│   │   ├── local/
│   │   │   ├── banco_de_dados.dart      # Abertura e esquema SQLite
│   │   │   ├── item_mapper.dart         # Conversão Map <-> Item
│   │   │   └── item_repository_sqlite.dart
│   │   ├── remoto/
│   │   │   ├── nova_tentativa.dart      # Algoritmo de Backoff com Jitter
│   │   │   └── servico_remoto_simulado.dart
│   │   ├── plataforma/
│   │   │   └── dispositivo_nativo.dart  # Lado Dart do MethodChannel
│   │   └── sincronizador.dart
│   └── apresentacao/
│       ├── providers.dart               # Gerenciadores Riverpod
│       ├── rotas.dart                   # Configuração das rotas GoRouter
│       ├── telas/
│       │   ├── tela_lista.dart
│       │   ├── tela_item.dart
│       │   ├── tela_sobre.dart
│       │   └── tela_nao_encontrada.dart
│       └── componentes/
│           ├── cartao_item.dart
│           └── faixa_offline.dart
└── pubspec.yaml
```

---

## 🗄️ Banco de Dados

O banco de dados relacional armazena os dados no arquivo SQLite privado `compras.db`.

### Tabela `itens`
| Coluna | Tipo | Restrições / Detalhes |
| :--- | :--- | :--- |
| `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` |
| `nome` | `TEXT` | `NOT NULL` |
| `quantidade` | `INTEGER` | `NOT NULL CHECK (quantidade BETWEEN 1 AND 99)` |
| `categoria` | `TEXT` | `NOT NULL` |
| `observacao` | `TEXT` | `NOT NULL DEFAULT ''` |
| `comprado` | `INTEGER` | `NOT NULL DEFAULT 0` (0 ou 1) |
| `sincronizado` | `INTEGER` | `NOT NULL DEFAULT 0` (Possui índice `idx_itens_sincronizado`) |
| `criado_em` | `INTEGER` | Epoch em milissegundos |
| `atualizado_em` | `INTEGER` | Epoch em milissegundos |

---

## 🔗 Navegação e Deep Linking

Rotas declarativas estruturadas com `go_router`:
- `/` — Lista principal de itens.
- `/item/novo` — Formulário de criação.
- `/item/:id` — Formulário de edição de item específico.
- `/sobre` — Tela informativa de créditos e dados do sistema.

### Testar Deep Link no Emulador
Com o aplicativo instalado no emulador, execute no terminal:
```bash
adb shell am start -W -a android.intent.action.VIEW -d "compras://app/item/1" com.example.app_sql_lite
```

---

## 🚀 Como Executar o Projeto

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/SEU_USUARIO/app_sql_lite.git
   cd app_sql_lite
   ```

2. **Instalar as dependências:**
   ```bash
   flutter pub get
   ```

3. **Executar em um emulador ou dispositivo Android:**
   ```bash
   flutter run
   ```

---

## 🧪 Testes Automatizados

O projeto contém testes de unidade, integração e interface:
```bash
flutter test
```

---

## 📦 Gerar e Instalar o APK

Para gerar o arquivo executável de distribuição do Android (`.apk`):

```bash
flutter build apk --release
```

O arquivo gerado estará no caminho:  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 📚 Referências
- Documentação Oficial do Flutter: [flutter.dev](https://flutter.dev)
- Material da Disciplina: *Aula 15 — Flutter: tutorial integrador com SQLite*