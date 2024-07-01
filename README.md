# React Starter

React Starter é um projeto boilerplate projetado para ajudá-lo a configurar rapidamente uma aplicação React com uma estrutura de pastas personalizável, suporte a TypeScript e configuração pré-configurada de testes usando Jest e React Testing Library. Este projeto tem como objetivo simplificar o processo de configuração inicial e fornecer uma base robusta para a construção de aplicações React.

## Funcionalidades

- Criação de um projeto React com ou sem suporte a TypeScript.
- Estrutura de pastas personalizável para melhor organização do projeto.
- Configuração inicial de testes unitários usando Jest e React Testing Library.
- Configuração fácil de Babel e Jest.
- Inserção automática de declarações de importação do React, se ausentes.

## Primeiros Passos

### Pré-requisitos

Certifique-se de ter o seguinte instalado:

- Node.js (v18 or higher)
- npm (v10 ou superior)

### Uso

Para criar um novo projeto React usando o script `react-starter`, siga estes passos:

1. Clone o repositório:

    ```bash
    git clone https://github.com/seu-usuario/react-starter.git
    cd react-starter
    ```

2. Torne o script de configuração executável:

    ```bash
    chmod +x create_react.sh
    ```

3. Execute o script de configuração com o nome do projeto desejado e o template:

    ```bash
    ./create_react.sh nome_do_projeto [ts]
    ```

    Substitua `nome_do_projeto` pelo nome desejado para o projeto. Adicione `ts` para usar o template TypeScript.

### Exemplo

Para criar um projeto chamado `my-app` com suporte a TypeScript:

```bash
./create_react.sh my-app ts
```

Estrutura de Pastas
Após executar o script, seu projeto terá a seguinte estrutura de pastas:

```bash
my-app/
├── node_modules/
├── public/
├── src/
│   ├── assets/
│   │   ├── images/
│   │   │   └── logo.svg
│   │   └── styles/
│   │       ├── App.css
│   │       └── index.css
│   ├── components/
│   ├── infra/
│   ├── pages/
│   │   └── App.tsx or App.js
│   ├── services/
│   └── test/
│       ├── mocks/
│       └── src/
│           └── App.test.tsx or App.test.js
├── .gitignore
├── package.json
└── README.md
```

### Configuração

O script configura automaticamente o Babel e Jest para o seu projeto. Ele também atualiza o arquivo package.json para usar a configuração personalizada do Jest e scripts.

### Qualidade e Testes Unitários

O React Starter vem com uma configuração inicial de testes unitários usando Jest e React Testing Library. Testes unitários são essenciais para garantir a qualidade e a robustez do seu código. Eles ajudam a identificar bugs precocemente, facilitam a refatoração e asseguram que novas funcionalidades não quebrem o comportamento existente do aplicativo.

Os testes unitários também permitem que você mantenha um alto padrão de qualidade no seu código, proporcionando confiança na implementação e facilitando a colaboração entre desenvolvedores.

### Scripts

npm start: Inicia o servidor de desenvolvimento.
npm test: Executa os testes usando Jest.
npm run coverage: Gera um relatório de cobertura de testes.

### Contribuindo

Contribuições são bem-vindas! Se você tiver sugestões ou melhorias, sinta-se à vontade para enviar um pull request ou abrir uma issue.

### Licença

Este projeto é licenciado sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

### Agradecimentos

Este projeto foi inspirado pela necessidade de uma configuração de projeto React simplificada e organizada. Agradecimentos especiais às comunidades React e Jest por suas excelentes ferramentas e documentação.

For the English version of this README, click [here](README_EN.md).