# Network tools for dart apps

## Features

| Feature |
| - |
| Ignore development domain certificates to not deal with self signed certs |
| Setup a proxy in Android and IOS emulator expecting it to be on the development amchine. |

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
