# FeedbackMan

[![Version](https://img.shields.io/cocoapods/v/FeedbackMan.svg?style=flat)](http://cocoapods.org/pods/FeedbackMan)
[![License](https://img.shields.io/cocoapods/l/FeedbackMan.svg?style=flat)](http://cocoapods.org/pods/FeedbackMan)
[![Platform](https://img.shields.io/cocoapods/p/FeedbackMan.svg?style=flat)](http://cocoapods.org/pods/FeedbackMan)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/hsylife/SwiftyPickerPopover)

A feedback tool for iOS developers, which can send a lot of information with simple operation.


## Requirements

- iOS 9.0+
- Xcode 8.3.3

## GIF Animation

### Screen Capture

![capture](https://github.com/recruit-lifestyle/FeedbackMan/blob/master/Example/media/capture.gif)

### Edit Image

![edit](https://github.com/recruit-lifestyle/FeedbackMan/blob/master/Example/media/edit.gif)

### Send Feedback

![send](https://github.com/recruit-lifestyle/FeedbackMan/blob/master/Example/media/send.gif)

## Installation

### CocoaPods

FeedbackMan is available through [CocoaPods](http://cocoapods.org).
If you have not installed CocoaPods, run the following command:

```
$ gem install cocoapods
```

then, add the following line to your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'FeedbackMan'
```

To import FeedbackMan into your project, run the following command:

```
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.
To install FeedbackMan through Carthage, simply add the following line to your `Cartfile`:

```
github "recruit-lifestyle/FeedbackMan"
```

then, run the following command:

```
$ carthage update --platform iOS
```

## Usage

### Requirements

Please get your Slack API token.
You can create token at the following page: https://api.slack.com/custom-integrations/legacy-tokens

To activate FeedbackMan, add the following line to `AppDelegate.swift` in your project:

```swift
import FeedbackMan

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FeedbackManManager.APIConstants.token = "xoxp-xxxxxxxxxx-xxxxxxxxxx"     // Your Slack API token.
    FeedbackManManager.APIConstants.channel = "feedback-channel"      // Your Slack channel to which you want to send feedback data.
    window?.makeKeyAndVisible()
    FeedbackManManager.sharedInstance.showDebugBtn()
    return true
}
```

That's all. You can use this library and post your feedback immediately!

### Enable Debug mode

If you want to activate FeedbackMan only in Debug build, write in `AppDelegate.swift` as follows:

```swift
import FeedbackMan

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FeedbackManManager.APIConstants.token = "xoxp-xxxxxxxxxx-xxxxxxxxxx"
    FeedbackManManager.APIConstants.channel = "feedback-channel"
    window?.makeKeyAndVisible()
    #if DEBUG
        FeedbackManManager.sharedInstance.showDebugBtn()
    #endif
    return true
}
```

then, set the property **Swift Compiler - Custom Flags** at **Build Settings** as following image:

![custom_flags](https://github.com/recruit-lifestyle/FeedbackMan/blob/master/Example/media/custom_flags.png)

### Customize

You can launch FeedbackMan in any kind of way as you like. (other button, widget, shake, etc.)
To launch this library, please call the following method in your app:

```swift
FeedbackManManager.sharedInstance.showModal()
```

## Credits

FeedbackMan is owned and maintained by [RECRUIT LIFESTYLE CO., LTD.](http://www.recruit-lifestyle.co.jp/)

FeedbackMan was originally created by [Naomichi Okada](https://github.com/nb6u7) and [Masafumi Hayashi](https://github.com/SShayashi).


## License

```
Copyright 2017 RECRUIT LIFESTYLE CO., LTD.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
