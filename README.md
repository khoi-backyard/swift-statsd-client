# swift-statsd-client

[![CircleCI](https://circleci.com/gh/zalora/swift-statsd-client.svg?style=svg)](https://circleci.com/gh/zalora/swift-statsd-client)

A Statsd Client written in Swift that is transport protocol agnostic. UDP and HTTP are supported out of the box.

- [Requirements](#requirements)
- [Usage](#usage)
- [Installation](#installation)
- [FAQ](#faq)
- [Contributing](#contributing)
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

TCPClient
```swift
let statsD = StatsD(transport: TCPTransport(host: "localhost", port: 2003))
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

Sending metrics
```swift
statsD.write(metric: Counting(name: "counting", value: 1))
statsD.write(metric: Sets(name: "uniques", value: "765"))
statsD.write(metric: Timing(name: "glork", value: 320))
statsD.write(metric: Gauge(name: "gaugor", value: 333))
```

Sending metrics in batch - Keep in mind of your network's MTU [Ref](https://github.com/etsy/statsd/blob/master/docs/metric_types.md#multi-metric-packets)

There are helper functions so you don't have to create metric models.
```swift
statsD.increment("foo") # Increment 'foo' by 1
statsD.increment("foo", by: 10) # Increment 'foo' by 10
statsD.set("uniques", value: "someUniqueValue") # Add 'someUniqueValue' to the set
statsD.timing("api.foo.bar", value: 320) # Set time for api.foo.bar
statsD.gauge("gaugor", value: 10) # Set gauge to 10
statsD.gauge("gaugor", delta: -10) # Decrement gauge by 10
```

And if you want to send raw metric data
```
statsD.write(payload: "foo:1|c") 
```

### Accessing

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate StatsD into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "zalora/swift-statsd-client"
```

The project is currently configured to build for iOS, tvOS and Mac. After building with carthage the resultant frameworks will be stored in:

* `Carthage/Build/iOS/StatsdClient.framework`
* `Carthage/Build/tvOS/StatsdClient.framework`
* `Carthage/Build/Mac/StatsdClient.framework`

Select the correct framework(s) and drag it into your project.

## FAQ

## Contributing

See [Contributing](https://github.com/zalora/swift-statsd-client/blob/master/CONTRIBUTING.md).

## License

swift-statsd-client is released under the MIT license. See [LICENSE](https://github.com/zalora/swift-statsd-client/blob/master/LICENSE) for details.
