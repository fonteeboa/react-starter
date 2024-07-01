#!/bin/bash

# Function to show help
show_help() {
    echo "Usage: $0 project_name [ts]"
}

# Function to check and insert the line if needed
insert_if_needed() {
  FILE=$1
  if ! grep -q "^import React from 'react';" "$FILE" && ! grep -q '^import React from "react";' "$FILE"; then
    sed -i '1i import React from "react";' "$FILE"
    echo "Line 'import React from \"react\";' added to the beginning of the file $FILE"
  else
    echo "Line 'import React from \"react\";' is already present at the beginning of the file $FILE"
  fi
}

# Function to set up the React project
setup_react_project() {
    local project_name=$1
    local template=$2

    # Create a directory for projects and navigate to it
    mkdir -p "projects/$project_name" || exit
    cd "projects/$project_name" || exit

    # Create React project
    echo "Creating React project '$project_name' with template ${template:-default}..."
    npx create-react-app . $template
    
    # Create folder structure
    echo "Creating custom folder structure..."
    mkdir -p src/{components,pages,assets/{images,styles},infra,services,test/{src,mocks}}

    # Set up .gitignore
    echo "Setting up .gitignore..."
    echo "node_modules/" > .gitignore

    # Move and rename CSS and SVG files
    echo "Moving and renaming CSS and SVG files..."
    mv src/App.css src/assets/styles/App.css
    mv src/index.css src/assets/styles/index.css
    mv src/logo.svg src/assets/images/logo.svg

    # Move and rename test files and components
    echo "Moving and renaming test files and components..."
    if [ "$template" == "--template typescript" ]; then
        mv src/App.test.tsx src/test/src/App.test.tsx
        mv src/App.tsx src/pages/App.tsx
        mv src/setupTests.ts src/test/setupTests.ts
        INDEXFILE="src/index.tsx"
        TESTFILE="src/test/src/App.test.tsx"
        APPFILE="src/pages/App.tsx"
    else
        mv src/App.test.js src/test/src/App.test.js
        mv src/App.js src/pages/App.js
        mv src/setupTests.js src/test/setupTests.js
        INDEXFILE="src/index.js"
        TESTFILE="src/test/src/App.test.js"
        APPFILE="src/pages/App.js"
    fi

    # Update index.js file
    echo "Updating index.js file..."
    sed -i.bak "s|import App from './App';|import App from './pages/App';|g" $INDEXFILE
    sed -i.bak "s|import './index.css';|import './assets/styles/index.css';|g" $INDEXFILE
    echo "Updating test files..."
    sed -i.bak "s|import App from './App';|import App from '../../pages/App';|g" $TESTFILE
    echo "Updating App.js file..."
    sed -i.bak "s|import './App.css';|import '../assets/styles/App.css';|g" $APPFILE
    sed -i.bak "s|import logo from './logo.svg';|import logo from '../assets/images/logo.svg';|g" $APPFILE

    # Copy Jest and Babel configurations
    echo "Copying Jest and Babel configurations..."
    if [ "$template" == "--template typescript" ]; then
        cp ../../config/ts/babel.config.js .
        cp ../../config/ts/jest.config.js .
        cp ../../config/ts/tsconfig.json .
    else
        cp ../../config/js/babel.config.js .
        cp ../../config/js/jest.config.js .
    fi

    cp ../../config/fileTransformer.js .
    cp ../../config/jest.setup.js .
    cp ../../config/setupTests.ts .

    # Update package.json to use the custom Jest configuration
    echo "Updating package.json to use the custom Jest configuration and scripts..."
    sed -i.bak '/"scripts": {/a\
    \    "coverage": "jest --coverage",' package.json

    sed -i.bak 's/"test": "react-scripts test"/"test": "jest"/' package.json
    
    # Usando sed para inserir a linha no início do arquivo
    insert_if_needed $APPFILE
    insert_if_needed $TESTFILE

    # Install Jest and other testing dependencies
    echo "Installing Jest and other testing dependencies..."
    npm install --save-dev jest@29.7.0 babel-jest @testing-library/react @types/jest@^29.5.12 @testing-library/jest-dom identity-obj-proxy @babel/preset-env @babel/preset-react jest-environment-jsdom babel-plugin-transform-remove-console
 
    if [ "$template" == "--template typescript" ]; then
        npm install --save-dev @testing-library/user-event ts-jest @babel/preset-typescript
    fi

    # Remove backup files
    echo "Removing backup files..."
    rm -f src/*.bak
    rm -f package.json.bak
}

# Check if a project name was provided
if [ $# -eq 0 ] || [ -z "$1" ]; then
    show_help
    exit 1
fi

# Define project name and template
PROJECT_NAME=$1
TEMPLATE=""
if [ "$2" == "ts" ]; then
    TEMPLATE="--template typescript"
fi

# Set up the React project
setup_react_project "$PROJECT_NAME" "$TEMPLATE"

# Completion message
echo "React project '$PROJECT_NAME' successfully created with template ${TEMPLATE:-default} and custom folder structure applied."
