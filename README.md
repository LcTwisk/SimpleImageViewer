
[![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)


## Install

### Carthage

```ruby
github "aFrogleap/SimpleImageViewer" "development"
```

## Sample Usage

```swift
let configuration = ImageViewerConfiguration { config in
    config.imageView = someImageView
}

let imageViewerController = ImageViewerController(configuration: configuration)

present(imageViewerController, animated: true)

```

## License

t.b.a.

Copyright (c) 2017 aFrogleap
