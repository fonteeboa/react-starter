#!/bin/bash

# Function to show help
show_help() {
    echo "Usage: $0 project_name [ts]"
}

# Function to set up the React project
setup_react_project() {
    local project_name=$1
    local template=$2

    # Create a directory for projects and navigate to it
    mkdir -p "projects/$project_name" || exit
    cd "projects/$project_name" || exit

    # Create React project
    npx create-react-app . $template

    # Create folder structure
    mkdir -p src/{components,pages,assets/{images,styles},infra,services,test/{src,mocks}}

    # Set up .gitignore
    echo "node_modules/" > .gitignore

    # Move and rename CSS and SVG files
    mv src/App.css src/assets/styles/App.css
    mv src/index.css src/assets/styles/index.css
    mv src/logo.svg src/assets/images/logo.svg

    # Move and rename test files and components
    if [ "$template" == "--template typescript" ]; then
        mv src/App.test.tsx src/test/src/App.test.tsx
        mv src/App.tsx src/pages/App.tsx
        mv src/setupTests.ts src/test/setupTests.ts
    else
        mv src/App.test.js src/test/src/App.test.js
        mv src/App.js src/pages/App.js
        mv src/setupTests.js src/test/setupTests.js
    fi
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
