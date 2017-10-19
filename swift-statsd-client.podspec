Pod::Spec.new do |s|
  s.name         = "swift-statsd-client"
  s.version      = "0.1"
  s.summary      = "A Statsd Client written in Swift"
  s.description  = <<-DESC
    A Statsd Client written in Swift that is transport protocol agnostic. UDP and HTTP are supported out of the box.
  DESC
  s.homepage     = "https://github.com/khoiln/swift-statsd-client"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Khoi Lai" => "email@address.com" }
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/khoiln/swift-statsd-client.git", :tag => "#{s.version}" }
  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
  s.dependency "CocoaAsyncSocket", "~> 7.6"
end
