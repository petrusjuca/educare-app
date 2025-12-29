# 📚 Educare APP

TODO: add descrição

### 📋 Objetivos principais
- add objetivos

### 💻 Ferramentas utilizadas
- **Dart:** Linguagem de programação
- **Flutter:** Framework de desenvolvimento mobile multiplataforma
- **MobX:** Gerenciamento de estados
- **Figma:** Prototipação e UI Design

### 🛠️ Requisitos necessários
- Smartphone Android ou iOS
- Flutter SDK mais recente

### 📱 Utilização
**1.** Configure as dependências do pubspec.yaml
```
flutter pub get
```
**2.** Conecte um dispositivo Android, iOS ou configure um emulador <br>
**3.** Rode a aplicação com o comando abaixo
```
flutter run
```
---

### ⛓️ Arquitetura e Organização

O projeto conta com a ferramenta MobX para gerenciamento de estados, mesmo que a ferramenta não exija uma arquitetura padrão para funcionamento, a hierarquia de diretórios deverá seguir a seguinte orientação para melhor organização do código, usando snake_case para nomeação de diretórios e arquivos quando necessário.

```
lib/
 ┣ modules/              # Módulos da aplicação
 ┃ ┣ feature_name/       # Nome da feature principal
 ┃ ┃ ┣ subfeature_name/  # Submódulo, se necessário
 ┃ ┃ ┃ ┣ domain/         # Regras de negócio (entidades, use cases, interfaces)
 ┃ ┃ ┃ ┣ infra/          # Implementações externas (API, banco, etc.)
 ┃ ┃ ┃ ┣ presenter/      # Interface e lógica de apresentação
 ┃ ┃ ┃ ┃ ┣ pages/        # Páginas da subfeature
 ┃ ┃ ┃ ┃ ┣ widgets/      # Componentes reutilizáveis
 ┗ main.dart             # Entrada principal da aplicação
```

Para a organização da UI, também há um padrão de organização de diretórios a ser seguido.

```
presenter/
 ┣ pages/
 ┃ ┣ page_name/
 ┃ ┃ ┣ pagename_page.dart
 ┃ ┃ ┣ pagename_page_controller.dart
 ┃ ┃ ┗ stores/
 ┣ widgets/
 ┗ ┻ simple_widget.dart
```

Cada página pode ter um ou mais diretórios de subpáginas, cada com sua própria store, para melhor encapsulamento das regras de negócio. <br>

As páginas devem ter acesso aos controllers, que, por sua vez, possibilitarão a comunicação delas com os stores ou outras ferramentas a serem adotadas ao longo do desenvolvimento do projeto. <br>

Ao realizar alterações em arquivos que envolvam o MobX, o seguinte comando deve ser executado:

```
flutter pub run build_runner build
```

Esse comando é necessário, pois, o mobx_codegen irá gerar ou atualizar automaticamente arquivos relacionados ao MobX, que são cruciais para o funcionamento correto das regras de negócio e gerenciamentos de estado. <br>

No Figma, está disponível o manual de design a ser implementado no arquivo de design system, que deve conter as tipografias, padrão de cores e assets do projeto. Os assets (arquivos de tipografia e imagens) deverão estar numa pasta chamada assets, na raíz do projeto, adotando a seguinte estrutura: <br>

```
assets/
 ┣ fonts/
 ┗ images/
```

Ao adicionar qualquer elemento nos assets, estes deverão ser referenciados no pubspec de acordo com o exemplo abaixo:
```
flutter:
    assets:
    - assets/images/logo.png
    - assets/images/banner.jpg

    fonts:
    - family: MyFontFamily
        fonts:
        - asset: fonts/MyFontFamily-Bold.ttf
        - asset: fonts/MyFontFamily-Regular.ttf
```

Para carregar dependências, assets novos, ou ao rodar o projeto pela primeira vez, usar o comando:
```
flutter pub get
```
