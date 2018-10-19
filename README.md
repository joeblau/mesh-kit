# MeshKit

[![](https://img.shields.io/badge/swift-5-brightgreen.svg?style=flat-square)](https://swift.org)
[![](https://img.shields.io/badge/platform-iOS%20•%20tvOS%20•%20macOS-brightgreen.svg?style=flat-square)](https://www.apple.com/ios/)
[![](https://img.shields.io/circleci/project/github/joeblau/mesh-kit.svg?style=flat-square)](https://circleci.com/gh/joeblau/mesh-kit)
[![](https://img.shields.io/github/license/joeblau/mesh-kit.svg?style=flat-square)](https://github.com/joeblau/mesh-kit/blob/master/LICENSE)

MeshKit is a cross platform iOS, tvOS, and macOS mesh networking API.

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

class NetworkController {
    
    private var meshNetwork: MeshNetwork<MockMessage>?
    
    init() {
        meshNetwork = MeshNetwork<MockMessage>.init(serviceType: "Test") { (peerID, message) in
            // handle message receipt
        }
        meshNetwork?.start()
    }
    
}
```

## Features

- Easy setup
- Encrypted
- Unit tested up to 20 devices (This number can probably go higher with real devices)
- Auto-reconnect
