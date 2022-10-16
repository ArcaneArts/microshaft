Get logged in to a minecraft account quickly without all of the boilerplate of dancing with microsoft, xbox and mojang servers, maintining a cache for expiring tokens and whatnot. You now also need a client ID to provide launching services, there is one included in here for laziness though I recommend you use your own.

## Features

This package can log into minecraft. Read above.

## Getting started

This package is deigned for dart commandline based applications, We are using Dart IO, so this will not work on dart2js / web.

## Usage

```dart
MicroshaftClient(storage: FileStorage.load("tokens.dat"))
    .authenticate((url, code) {
  print("Go to $url");
  print("Enter: $code");
}).then((Shafted value) {
  // THE MOJANG TOKEN
  value.mojangToken;

  // THE MINECRAFT USERNAME
  value.profileName;

  // THE REAL UUID
  value.uuid;
});
```
