#!/bin/bash

# Function to show help
show_help() {
    echo "Usage: $0 project_name [-t] [-s sonar_project_key] [-o sonar_organization]"
    echo
    echo "Arguments:"
    echo "  project_name            The name of the React project to create."
    echo
    echo "Options:"
    echo "  -t, --template          Use the TypeScript template for the React project."
    echo "  -s, --sonar-key         The SonarQube project key."
    echo "  -o, --organization      The SonarQube organization key. If provided, the script will generate SonarQube configuration files."
    echo
    echo "Example:"
    echo "  $0 my-react-project -t -o my-sonar-organization -s my-sonar-project-key"
    echo
    echo "Description:"
    echo "  This script creates a React project with a custom folder structure and optional SonarQube configuration."
    echo "  - The project_name is mandatory and specifies the name of the React project."
    echo "  - The -t or --template option is optional and uses the TypeScript template."
    echo "  - The -s or --sonar-key option is optional and specifies the SonarQube project key."
    echo "  - The -o or --organization option is optional and specifies the SonarQube organization key."
    echo "    If the organization key is provided, SonarQube configuration files will be generated."
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

# Function to create the React project
create_react_project() {
    local project_name=$1
    local template=$2
    
    # Create a directory for projects and navigate to it
    echo "Creating React project '$project_name' with template ${template:-default}..."

    mkdir -p "projects/$project_name" || exit
    cd "projects/$project_name" || exit
    npx create-react-app . $template
}

# Function to create the custom folder structure
create_folder_structure() {
    echo "Creating custom folder structure..."
    mkdir -p src/{components,pages,assets/{images,styles},infra,services,test/{src,mocks}}
}

# Function to set up .gitignore
setup_gitignore() {
    echo "Setting up .gitignore..."
    echo "node_modules/" > .gitignore
}

# Function to move and rename files
move_and_rename_files() {
    local template=$1
    echo "Moving and renaming CSS and SVG files..."
    mv src/App.css src/assets/styles/App.css
    mv src/index.css src/assets/styles/index.css
    mv src/logo.svg src/assets/images/logo.svg

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
}

# Function to update import paths
update_import_paths() {
    echo "Updating import paths..."
    sed -i.bak "s|import App from './App';|import App from './pages/App';|g" $INDEXFILE
    sed -i.bak "s|import './index.css';|import './assets/styles/index.css';|g" $INDEXFILE
    sed -i.bak "s|import App from './App';|import App from '../../pages/App';|g" $TESTFILE
    sed -i.bak "s|import './App.css';|import '../assets/styles/App.css';|g" $APPFILE
    sed -i.bak "s|import logo from './logo.svg';|import logo from '../assets/images/logo.svg';|g" $APPFILE
}

# Function to copy configuration files
copy_config_files() {
    local template=$1
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
}

# Function to update package.json
update_package_json() {
    echo "Updating package.json to use the custom Jest configuration and scripts..."
    sed -i.bak '/"scripts": {/a\
    \    "coverage": "jest --coverage",' package.json
    sed -i.bak 's/"test": "react-scripts test"/"test": "jest"/' package.json
}

# Function to install dependencies
install_dependencies() {
    local template=$1
    echo "Installing Jest and other testing dependencies..."
    npm install --save-dev jest@29.7.0 babel-jest @testing-library/react @types/jest@^29.5.12 @testing-library/jest-dom identity-obj-proxy @babel/preset-env @babel/preset-react jest-environment-jsdom babel-plugin-transform-remove-console
    if [ "$template" == "--template typescript" ]; then
        npm install --save-dev @testing-library/user-event ts-jest @babel/preset-typescript
    fi
}

# Function to remove backup files
remove_backup_files() {
    echo "Removing backup files..."
    rm -f src/*.bak
    rm -f package.json.bak
}

# Function to create SonarQube configuration
create_sonar_config() {
    local sonar_organization=$1
    local project_name=$2
    local sonar_project_key=$3

    if [ -z "$sonar_project_key" ]; then
        sonar_project_key="${sonar_organization}_${project_name}"
    fi

    echo "$sonar_project_key" "$sonar_organization" "$project_name"

    if [ -n "$sonar_project_key" ] && [ -n "$sonar_organization" ]; then
        echo "Creating sonar-project.properties file..."
        cat <<EOL > sonar-project.properties
# Required project properties
sonar.projectKey=${sonar_project_key}
sonar.projectName=${project_name}
sonar.projectVersion=1.0
sonar.organization=${sonar_organization}
sonar.sources=src
sonar.javascript.lcov.reportPaths=coverage/lcov.info
sonar.sourceEncoding=UTF-8
sonar.exclusions=src/test
sonar.tests=src/test
sonar.test.inclusions=**/*Test.tsx, **/*Test.ts, **/__tests__/**
sonar.coverage.exclusions=**/*Test.*,**/*Tests.*, src/test/**/*, src/assets/**/*, src/i18n/**/*, dist/**/*, .github/**/*
sonar.host.url=https://sonarcloud.io
EOL
        echo "SonarQube configuration added to sonar-project.properties file."
        # Copy .github directory
        echo "Copying .github directory..."
        cp -r ../../config/sonar/.github .
    fi
}

# Main function to set up the React project
setup_react_project() {
    local project_name=$1
    local template=$2
    local sonar_project_key=$3
    local sonar_organization=$4

    create_react_project "$project_name" "$template"
    create_folder_structure
    setup_gitignore
    move_and_rename_files "$template"
    update_import_paths
    copy_config_files "$template"
    update_package_json
    insert_if_needed "$APPFILE"
    insert_if_needed "$TESTFILE"
    install_dependencies "$template"
    remove_backup_files
    create_sonar_config "$sonar_organization" "$project_name" "$sonar_project_key"
}

# Check if a project name was provided
if [ $# -lt 1 ]; then
    show_help
    exit 1
fi

# Parse command-line arguments
PROJECT_NAME=""
TEMPLATE=""
SONAR_ORGANIZATION=""
SONAR_PROJECT_KEY=""

for arg in "$@"
do
    case $arg in
        -o|--organization)
        SONAR_ORGANIZATION="$2"
        shift # Remove argument name from processing
        shift # Remove argument value from processing
        ;;
        -s|--sonar-key)
        SONAR_PROJECT_KEY="$2"
        shift # Remove argument name from processing
        shift # Remove argument value from processing
        ;;
        -t|--template)
        TEMPLATE="--template typescript"
        shift # Remove argument name from processing
        ;;
        *)
        if [ -z "$PROJECT_NAME" ]; then
            PROJECT_NAME="$arg"
            shift
        fi
        ;;
    esac
done

if [ -z "$PROJECT_NAME" ]; then
    show_help
    exit 1
fi

# Set up the React project
setup_react_project "$PROJECT_NAME" "$TEMPLATE" "$SONAR_PROJECT_KEY" "$SONAR_ORGANIZATION"

# Completion message
echo "React project '$PROJECT_NAME' successfully created with template ${TEMPLATE:-default}, custom folder structure, and optional SonarQube configuration applied."