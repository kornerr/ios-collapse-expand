
# Overview

This is a sample iOS application to implement collapse / expansion animation.

# Preview

This is what the app looks like:

![Preview][preview]

# Collapse / expansion animation

The are several entities at play:

* `LayoutReportingView`
    * a simple `UIView` derivative to report when `UIView` instance gets `layoutSubviews()` call
* `MainVC.storyboard`
    * provides `DetailsView`, which is `LayoutReportingView`
    * constraints `DetailsView` to the collapsed state with a fixed height constraint
        * height: 100
        * priority: 750
    * expands `DetailsView` to the top of the superview
        * priority: 1000
* `CollapseExpansionController`
    * accepts height range available for expansion
    * installs `UIPanGestureRecognizer` into tracked view
    * reports new `height` values each pan gesture
    * reports final `height` value once pan gesture is finished
* `AppDelegate`
    * creates `CollapseExpansionController`
        * only does so once height range of `DetailsView` becomes available
        * provides `DetailsView` as tracked view
    * sets `DetailsView` height to the `height` while panning (`heightChanged` callback)
    * animates `DetailsView` height to the `height` after panning (`completeHeightChange` callback)

**Note**: [XcodeGen][xcodegen] was used to generate Xcode project

[preview]: preview.gif
[xcodegen]: https://github.com/yonaskolb/XcodeGen

