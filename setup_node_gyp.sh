#!/bin/bash

# Exit on any error
set -e

# Step 1: Install nvm if not already installed
if ! command -v nvm &> /dev/null; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    source ~/.nvm/nvm.sh
fi

# Step 2: Use the latest LTS version of Node.js
echo "Using Node.js LTS version..."
nvm install --lts
nvm use --lts

# Step 3: Install node-gyp globally
echo "Installing node-gyp globally..."
npm install -g node-gyp

# Step 4: Create a new directory for the project
PROJECT_NAME="my-node-gyp-project"
echo "Creating project directory: $PROJECT_NAME"
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Step 5: Initialize a new Node.js project
echo "Initializing a new Node.js project..."
npm init -y

 
# Step 6: Create C++ source file
echo "Creating C++ source file (hello.cpp)..."
cat <<EOL > hello.cpp
#include <node.h>

namespace demo {

using v8::FunctionCallbackInfo;
using v8::Isolate;
using v8::Local;
using v8::Object;
using v8::String;
using v8::Value;
using v8::FunctionTemplate;

void Method(const FunctionCallbackInfo<Value>& args) {
    Isolate* isolate = args.GetIsolate();
    args.GetReturnValue().Set(String::NewFromUtf8(isolate, "Hello from C++!").ToLocalChecked());
}

void Initialize(Local<Object> exports) {
    exports->Set(String::NewFromUtf8(Isolate::GetCurrent(), "hello").ToLocalChecked(),
                 FunctionTemplate::New(Isolate::GetCurrent(), Method)->GetFunction());
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)

}  // namespace demo
EOL
EOL

# Step 7: Create binding.gyp file
echo "Creating binding.gyp file..."
cat <<EOL > binding.gyp
{
  "targets": [
    {
      "target_name": "hello",
      "sources": [ "hello.cpp" ]
    }
  ]
}
EOL

# Step 8: Build the module
echo "Building the module..."
node-gyp configure
node-gyp build

# Step 9: Create a test JavaScript file
echo "Creating test file (index.js)..."
cat <<EOL > index.js
const addon = require('./build/Release/hello');

console.log(addon.hello()); // Outputs: Hello from C++!
EOL

# Step 10: Run the test
echo "Running the test..."
node index.js

echo "Node-gyp project setup and test completed successfully!"
