#!/bin/bash

# Exit on any error
set -e

# Step 1: Install node-gyp globally
echo "Installing node-gyp globally..."
npm install -g node-gyp

# Step 2: Create a new directory for the project
PROJECT_NAME="my-node-gyp-project"
echo "Creating project directory: $PROJECT_NAME"
mkdir $PROJECT_NAME
cd $PROJECT_NAME

# Step 3: Initialize a new Node.js project
echo "Initializing a new Node.js project..."
npm init -y

# Step 4: Create C++ source file
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

# Step 5: Create binding.gyp file
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

# Step 6: Build the module
echo "Building the module..."
node-gyp configure
node-gyp build

# Step 7: Create a test JavaScript file
echo "Creating test file (index.js)..."
cat <<EOL > index.js
const addon = require('./build/Release/hello');

console.log(addon.hello()); // Outputs: Hello from C++!
EOL

# Step 8: Run the test
echo "Running the test..."
node index.js

echo "Node-gyp project setup and test completed successfully!"