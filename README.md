![SimpleImageViewer](https://github.com/aFrogleap/SimpleImageViewer/raw/development/Documentation/banner.png)
[![CI Status](https://travis-ci.org/aFrogleap/SimpleImageViewer.svg?branch=master)](https://travis-ci.org/aFrogleap/SimpleImageViewer)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/SimpleImageViewer.svg?style=flat)](http://cocoadocs.org/docsets/SimpleImageViewer)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)

A snappy image viewer with zoom and interactive dismissal transition. 

![SimpleImageViewer](https://github.com/aFrogleap/SimpleImageViewer/raw/development/Documentation/example.gif)

## Features

- [x] Double tap to zoom in/out
- [x] Interactive dismissal transition
- [x] Animate in from thumbnail image or fade in
- [x] Show activity indicator until image block is returned with new image
- [x] Animate from thumbnail image view with all kinds of [content modes](https://developer.apple.com/documentation/uikit/uiviewcontentmode)

## Get started!

### Carthage

To install SimpleImageViewer into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "aFrogleap/SimpleImageViewer" ~> 2.0.0
```

### Cocoapods

To install SimpleImageViewer into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:

```ruby
pod 'SimpleImageViewer', '~> 2.0.0'
```

### Swift Package Manager

To install SimpleImageViewer into your Xcode project using [Swift Package Manager](https://swift.org/package-manager), specify it in your `Package.swift` file:

```swift
dependencies: [
    .Package(url: "https://github.com/aFrogleap/SimpleImageViewer.git", majorVersion: 1)
]
```

## Sample Usage

See the example app to find out about how to customise things like background colour, how to hide the close button and how to interact with the view controller to switch images.

### Create programmatically
```swift
let configuration = ImageViewerConfiguration { config in
    config.imageView = someImageView
}

let imageViewerController = ImageViewerController.imageViewController(configuration: configuration)

present(imageViewerController, animated: true)

```
### Create from storyboard
First step is to place a new storyboard reference on your app's storyboard using "ImageViewerController" as `Storyboard` and "ImageViewerController" as `Referenced ID`. After that, you can connect your segue to that reference (either directly or using `embed` segues for container views).

![Storyboard](https://raw.githubusercontent.com/swesteme/SimpleImageViewer/master/Documentation/storyboard.png)

To configure your new view controller you then simply add the following code (using your segue's ID as a constant):

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == "showSingleImage") {
        let destination = segue.destination as! ImageViewerController
        let configuration = ImageViewerConfiguration { config in
            config.image = UIImage(named: "2")
        }
        configuration.showCloseButton = false
        destination.configuration = configuration
    }
}

```
Storyboard references need a deployment target of at least iOS 9.

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Apps Using SimpleImageViewer

- [Toeppersee](https://itunes.apple.com/de/app/toeppersee/id793480458?mt=8) by Sebastian Westemeyer

## License

SimpleImageViewer is available under the MIT license. See the LICENSE file for more info.

Copyright (c) 2017 aFrogleap
