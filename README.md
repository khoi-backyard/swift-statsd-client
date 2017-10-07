# swift-statsd-client

[![CircleCI](https://circleci.com/gh/khoiln/swift-statsd-client.svg?style=svg)](https://circleci.com/gh/khoiln/swift-statsd-client)

A Statsd Client written in Swift that is transport protocol agnostic. UDP and HTTP are supported out of the box.

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

### Initializing the client

UDP Client
```swift
let statsD = StatsD(transport: UDPTransport(host: "localhost", port: 2003))
```

HTTP CLient
```swift
let statsD = StatsD(transport: HTTPTransport(endpoint: URL(string: "https://localhost:8888/statsd")!)
```

And if you want to customize your HTTP request
```swift
let statsD: StatsD = {
    let configuration = URLSessionConfiguration()
    configuration.httpAdditionalHeaders = ["token": "Some Super Secret Token"]
    return StatsD(transport: HTTPTransport(endpoint: URL(string: "https://localhost:8888/statsd")!,
                                      configuration: configuration))
}()
```

### Sending Data

```swift
statsD.increment("foo") # Increment 'foo' by 1
statsD.increment("foo", by: 10) # Increment 'foo' by 10
statsD.set("uniques", value: "someUniqueValue") # Add 'someUniqueValue' to the set
statsD.timing("api.foo.bar", value: 320) # Set time for api.foo.bar
statsD.gauge("gaugor", value: 10) # Set gauge to 10
statsD.gauge("gaugor", delta: -10) # Decrement gauge by 10
```

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate StatsD into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "khoiln/swift-statsd-client"
```

The project is currently configured to build for iOS, tvOS and Mac. After building with carthage the resultant frameworks will be stored in:

* `Carthage/Build/iOS/StatsdClient.framework`
* `Carthage/Build/tvOS/StatsdClient.framework`
* `Carthage/Build/Mac/StatsdClient.framework`

Select the correct framework(s) and drag it into your project.

## FAQ

## License

swift-statsd-client is released under the MIT license. See [LICENSE](https://github.com/khoiln/swift-statsd-client/blob/master/LICENSE) for details.
