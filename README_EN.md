# React Starter

React Starter is a boilerplate project designed to help you quickly set up a React application with a customizable folder structure, TypeScript support, and pre-configured testing setup using Jest and React Testing Library. This project aims to simplify the initial setup process and provide a robust foundation for building React applications.

## Features

- Create a React project with or without TypeScript support.
- Customizable folder structure for better project organization.
- Initial unit test configuration using Jest and React Testing Library.
- Easy setup of Babel and Jest configurations.
- Automatic insertion of React import statements if missing.

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Node.js (v18 or higher)
- npm (v10 or higher)

### Usage

To create a new React project using the `react-starter` script, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/react-starter.git
    cd react-starter
    ```

2. Make the setup script executable:

    ```bash
    chmod +x create_react.sh
    ```

3. Run the setup script with the desired project name and template:

    ```bash
    ./create_react.sh project_name [ts]
    ```

    Replace `project_name` with your desired project name. Add `ts` to use the TypeScript template.

### Example

To create a project named `my-app` with TypeScript support:

```bash
./create_react.sh my-app ts
```

### Folder Structure
After running the script, your project will have the following folder structure:

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

### Configuration

The script automatically configures Babel and Jest for your project. It also updates the package.json file to use the custom Jest configuration and scripts.

### Quality and Unit Tests

The React Starter comes with an initial unit test configuration using Jest and React Testing Library. Unit tests are essential for ensuring the quality and robustness of your code. They help identify bugs early, facilitate refactoring, and ensure that new features do not break existing functionality.

Unit tests also enable you to maintain a high standard of code quality, providing confidence in implementation and making collaboration among developers easier.

### Scripts

npm start: Starts the development server.
npm test: Runs the tests using Jest.
npm run coverage: Generates a test coverage report.

### Contributing

Contributions are welcome! If you have any suggestions or improvements, please feel free to submit a pull request or open an issue.

### License

This project is licensed under the MIT License. See the LICENSE file for details.

### Acknowledgements

This project was inspired by the need for a streamlined and organized React project setup. Special thanks to the React and Jest communities for their excellent tools and documentation.

Para a versão em português deste README, clique [aqui](README.md).