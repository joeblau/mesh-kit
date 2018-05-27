<img src="https://cdn.rawgit.com/joeblau/mesh-kit/master/.github/mesh-kit.svg"/>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/swift-4.1-brightgreen.svg?style=flat-square"/></a>
  <a href="https://www.apple.com/ios/"><img src="https://img.shields.io/badge/platform-iOS%20•%20tvOS%20•%20macOS-brightgreen.svg?style=flat-square"/></a>
  <a href="https://circleci.com/gh/joeblau/mesh-kit"><img src="https://img.shields.io/circleci/project/github/joeblau/mesh-kit.svg?style=flat-square"/></a>
  <a href="https://codeclimate.com/github/joeblau/mesh-kit"><img src="https://img.shields.io/codeclimate/maintainability/joeblau/mesh-kit.svg?style=flat-square"/></a>
  <a href="https://codeclimate.com/github/joeblau/mesh-kit"><img src="https://img.shields.io/codeclimate/c/joeblau/mesh-kit.svg?style=flat-square"/></a>
  <a href="https://github.com/joeblau/mesh-kit/releases"><img src="https://img.shields.io/github/downloads/joeblau/mesh-kit/total.svg?style=flat-square"/></a>
  <a href="https://github.com/joeblau/mesh-kit/tags"><img src="https://img.shields.io/github/tag/joeblau/mesh-kit.svg?style=flat-square"/></a>
  <a href="https://github.com/joeblau/mesh-kit/blob/master/LICENSE"><img src="https://img.shields.io/github/license/joeblau/mesh-kit.svg?style=flat-square"/></a>
</p>

MeshKit is a cross platform iOS, tvOS, and macOS mesh networking API

## Installation

MeshKit works best with [Carthage](https://github.com/carthage/carthage).

```swift
github "joeblau/mesh-kit"
```


## Use

```swift
import MeshKit

struct MockMessage: Codable {
    var title: String
    var description: String
}

class NetworkController: MeshNetworkDelegate {
    
    let meshNetwork: MeshNetwork<MockMessage>
    
    init() {
        meshNetwork = MeshNetwork<MockMessage>(serviceType: "service type",
                                               delegate: mockMeshNetworkDelegate)
        meshNetwork.start()
    }
    
    // MARK: - MeshNetworkDelegate
    
    func update(message: MeshMessage) {
        // Handle incoming messages
    }
}

```

## Features

- Easy setup
- Encrypted
- Unit tested up to 20 devices (This number can probably go higher with real devices)
- Auto-reconnect
