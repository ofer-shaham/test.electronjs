#!/bin/bash

# Function to create a file with content
create_file() {
    local file_path="$1"
    local content="$2"
    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
}

# Create project directory
project_name="my-electron-app"
mkdir "$project_name"
cd "$project_name"

# Create package.json
create_file "package.json" '{
  "name": "my-electron-app",
  "version": "1.0.0",
  "description": "An Electron app for Red Hat",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "build": "electron-builder --linux rpm",
    "package": "electron-packager . app --platform linux --arch x64 --out dist/",
    "rpm": "electron-installer-redhat --src dist/app-linux-x64/ --dest dist/installers/ --arch x86_64"
  },
  "author": "Your Name",
  "license": "MIT",
  "devDependencies": {
    "electron": "^latest",
    "electron-builder": "^latest",
    "electron-packager": "^latest",
    "electron-installer-redhat": "^latest"
  },
  "build": {
    "appId": "com.example.myapp",
    "productName": "My Electron App",
    "linux": {
      "target": ["rpm"],
      "category": "Utility"
    }
  }
}'

# Create main.js
create_file "main.js" "const { app, BrowserWindow } = require('electron')

function createWindow () {
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true
    }
  })

  win.loadFile('index.html')
}

app.whenReady().then(createWindow)

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})"

# Create index.html
create_file "index.html" '<!DOCTYPE html>
<html>
  <head>
    <title>Electron App for Red Hat</title>
  </head>
  <body>
    <h1>Hello Red Hat!</h1>
    <p>This is an Electron app running on Red Hat.</p>
  </body>
</html>'

# Create README.md
create_file "README.md" "# Electron App for Red Hat

This is a simple Electron application packaged for Red Hat Linux.

## Development

To install dependencies:

\`\`\`
pnpm install
\`\`\`

To run the app:

\`\`\`
pnpm start
\`\`\`

## Building for Red Hat

To build the app:

\`\`\`
pnpm run package
pnpm run rpm
\`\`\`

The RPM package will be available in the \`dist/installers/\` directory."

echo "Electron app structure created successfully!"
echo "To set up and build the project, run the following commands:"
echo "cd $project_name"
echo "pnpm install"
echo "pnpm start     # To run the app"
echo "pnpm run package  # To package the app"
echo "pnpm run rpm      # To create the RPM package"
