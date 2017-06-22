
[![Swift 3.1](https://img.shields.io/badge/Swift-3.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SimpleImageViewer.svg?style=flat)](http://cocoadocs.org/docsets/SimpleImageViewer)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

A snappy image viewer with zoom and interactive dismissal transition. 

![Single image view](https://github.com/aFrogleap/SimpleImageViewer/blob/development/Documentation/example.gif)



## Get started!

### Carthage
```ruby
github "aFrogleap/SimpleImageViewer" "development"
```

### Cocoapods
```ruby
pod 'SimpleImageViewer', :git => 'https://github.com/aFrogleap/SimpleImageViewer.git', :branch => 'development'
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
