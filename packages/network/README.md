# Network tools for dart apps

## Features

| Feature |
| - |
| Ignore development domain certificates in debug in order to not have to deal with self signed certs |
| Configure a proxy  for Flutter in Android and IOS emulator. Defaults to localhost if activated. |

## Getting started

Other information _in the future_

## Usage

```dart
    if (!kIsWeb && kDebugMode) {
      HttpOverrides.global = DevelopmentHttpConfig(domains: ['mydomain.com'], proxyPort 8080);
    }
```

## Additional information

Other information _in the future_
