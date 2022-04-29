# Flexi Tooltip View
![Issues](https://img.shields.io/github/issues/mark-kebo/FlexiTooltipView) ![Forks](https://img.shields.io/github/forks/mark-kebo/FlexiTooltipView) ![Stars](https://img.shields.io/github/stars/mark-kebo/FlexiTooltipView) ![License](https://img.shields.io/github/license/mark-kebo/FlexiTooltipView) 

Package for custom tooltips in your application

![Example3](_Images/Example3.png =250x444) ![Example4](_Images/Example4.png =250x444) ![Example5](_Images/Example5.png =250x444)

## Installing
Flexi Tooltip View support [Swift Package Manager](https://www.swift.org/package-manager/).

### Swift Package Manager
``` swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "YourTestProject",
  platforms: [
       .iOS(.v12),
  ],
  dependencies: [
    .package(name: "FlexiTooltipView", url: "https://github.com/mark-kebo/FlexiTooltipView", from: "1.0.0")
  ],
  targets: [
    .target(name: "YourTestProject", dependencies: ["FlexiTooltipView"])
  ]
)
```
And then import wherever needed: ```import FlexiTooltipView```

#### Adding it to an existent iOS Project via Swift Package Manager

1. Using Xcode 11 go to File > Swift Packages > Add Package Dependency
2. Paste the project URL: https://github.com/mark-kebo/FlexiTooltipView
3. Click on next and select the project target
4. Don't forget to set `DEAD_CODE_STRIPPING = NO` in your `Build Settings` (https://bugs.swift.org/plugins/servlet/mobile#issue/SR-11564)

If you have doubts, please, check the following links:

[How to use](https://developer.apple.com/videos/play/wwdc2019/408/)

[Creating Swift Packages](https://developer.apple.com/videos/play/wwdc2019/410/)

After successfully retrieved the package and added it to your project, just import `FlexiTooltipView` and you can get the full benefits of it.

## Usage example

Setup configuration and show tooltip controller:

``` swift
import FlexiTooltipView

let tooltipItems: [FlexiTooltipItemProtocol] = [
                    FlexiTooltipImageItem(image: UIImage(named: "test-image"), 
                                          imageSize: CGSize(width: 64, height: 64)),
                    FlexiTooltipTextItem(text: attributtedTitle(text: "Test", weight: .light), 
                                         image: UIImage(named: "test-image")),
                    FlexiTooltipActionsItem(firstAction: FlexiTooltipActionItem(title: attributtedTitle(text: "cancel", weight: .regular),
                                                                                backgroundColor: .systemYellow,
                                                                                completion: { [weak self] in
                                                                                    //Some action
                                                                                }),
                                            secondAction: nil,
                                            alignment: .trailing)
]
var config = FlexiTooltipConfiguration()
config.arrowHeight = 16
config.isNeedShadow = true
config.isTooltipClosable = true
config.topAction = FlexiTooltipActionItem(title: attributtedTitle(text: "Close", weight: .regular),
                                          backgroundColor: .gray) { [weak self] in
    //Some top action
}
config.highlightedViews = [button1, button]
let controller = FlexiTooltipViewController(params: FlexiTooltipParams(tooltipItems: tooltipItems,
                                                                       targetView: button,
                                                                       configuration: config))
controller.present(in: navigationController)

```
### Important

You must to set `targetView` in `FlexiTooltipParams`. This is exactly the view to which the tooltip will be attached.
Also if you need highlight some views, you can use `highlightedViews` in `FlexiTooltipConfiguration`.
