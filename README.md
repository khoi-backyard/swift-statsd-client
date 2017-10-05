# Statsd Swift Client

A Statsd Client written in Swift

- [Requirements](#requirements)
- [Usage](#usage)
- [Installation](#installation)
- [FAQ](#faq)
- [License](#license)

## Requirements

- iOS 9.0+ / macOS 10.11+ / tvOS 9.0+
- Xcode 9.0+
- Swift 4.0+

## Usage



## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate StatsD into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "khoiln/swift-statsd-client" ~> 1.3
```

The project is currently configured to build for iOS, tvOS and Mac. After building with carthage the resultant frameworks will be stored in:

* `Carthage/Build/iOS/StatsdClient.framework`
* `Carthage/Build/tvOS/StatsdClient.framework`
* `Carthage/Build/Mac/StatsdClient.framework`

Select the correct framework(s) and drag it into your project.

## FAQ

## License

swift-statsd-client is released under the MIT license. See [LICENSE](https://github.com/khoiln/swift-statsd-client/blob/master/LICENSE) for details.
