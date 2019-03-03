
[![Build Status](https://travis-ci.org/mayckonx/MBSPasswordView.svg?branch=master)](https://travis-ci.org/mayckonx/MBSPasswordView) [![Coverage Status](https://coveralls.io/repos/github/mayckonx/MBSPasswordView/badge.svg?branch=master)](https://coveralls.io/github/mayckonx/MBSPasswordView?branch=master) [![Platform](https://img.shields.io/cocoapods/p/MBSPasswordView.svg?style=flat)](http://cocoapods.org/pods/MBSPasswordView)

**MBSPasswordView** is a custom view that provides an easy way to use a block-screen password using TouchID/FaceID and 4-Digit Password.

## Support
iOS 11.0+

## Features
- [X] Pure Swift 4 🔨
- [X] Support 4 digits validation 🔒
- [X] TouchID and FaceID 🤳🏻
- [X] Light touch impact ♒︎
- [X] Shakable view 💥
- [X] Custom animation 💫
- [X] Easy to use. 🤟🏻


## Success Case
<img src="success.gif" width="300">

## Invalid Case
<img src="invalid.gif" width="300">

## Installation

### CocoaPods
```
pod 'MBSPasswordView'
```

### Carthage

MBSPasswordView is available through [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Cartfile:
```
github "mayckonx/MBSPasswordView"
```

## How to Use
1. Import the framework
```
import MBSPasswordView
```

2. Go to your Storyboard/XIB -> Identity Inspector and change your class and module to:
```
MBSPasswordView
```

3. Create an outlet and link it to your view as a MBSPasswordView.
```
@IBOutlet weak var passwordView: MBSPasswordView!
```

4. Implement the protocol to get the password result.
```
extension ViewController: MBSPasswordDelegate {
func password(_ result: [String]) {
print("Password:\(result)")
}
func passwordFromBiometrics(_ result: Result<[String]>) {
print("Result:\(result)")
}
}
```

5. Set the delegate in your viewDidLoad
```
override func viewDidLoad() {
super.viewDidLoad()

passwordView?.delegate = self
passwordView?.titleToRequestAuthentication = "Please, identify your self!"
passwordView?.start(enableBiometrics: true)
}
```

That's it. If you enable biometrics, you get the password and automatically request the TouchID/FaceID every time. You just need to pass enableBiometrics: true on the start method.😎

It's done brah! 

You can customize the view. In the sample you can see how to access the properties and change it to your preferences. 

## Next improvments
1. Support 6 digits
2. Different kind of animations

## Suggestions or feedback?

Feel free to create a pull request, open an issue or find [me on Twitter](https://twitter.com/mayckonx).
