# YZImagePicker

[![CI Status](https://img.shields.io/travis/Vipul Patel/YZImagePicker.svg?style=flat)](https://travis-ci.org/Vipul Patel/YZImagePicker)
[![Version](https://img.shields.io/cocoapods/v/YZImagePicker.svg?style=flat)](https://cocoapods.org/pods/YZImagePicker)
[![License](https://img.shields.io/cocoapods/l/YZImagePicker.svg?style=flat)](https://cocoapods.org/pods/YZImagePicker)
[![Platform](https://img.shields.io/cocoapods/p/YZImagePicker.svg?style=flat)](https://cocoapods.org/pods/YZImagePicker)


## Requirements

- iOS 12.0+
- Xcode 11+
- Swift 5.0+

**Notes:**

To use this library it required following keys in `info.plist` file.
* `NSCameraUsageDescription` - Privacy - Camera Usage Description.
* `NSPhotoLibraryUsageDescription` - Privacy - Photo Library Usage Description.

## Features

- [x] Used to choose image from device camera or photos library using `UIImagePickerController`. 
- [x] In built, image cropping feature by using [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper) library.


## Usage

### 1. YZImagePickerConfig Class

`YZImagePickerConfig` is used to configure `YZImagePicker` object. It will initialize `cropMode` and `cropConfig` properties.

**Properties:**
*  `cropMode` - Configure image cropping mode, possible values for this property is `.circle`, `.square` and `.custom`.
* `cropConfig` - It is used to configure croping property, to check in more details follow **YZImagePickerCropConfig**. 

**Initialisation:**
```
let objImagePickerConfig = YZImagePickerConfig(.circle)
```

### 2. YZImagePickerCropConfig Class

`YZImagePickerCropConfig` is used to configure `YZImagePickerConfig` object when you apply `cropMode = .custom`. It will initialize following properties.

**Properties:**
*  `vTopSpace` - It is used to configure top veritcal space of crop rect layout.
*  `hLeadingSpace` - It is used to configure leading horizontal space of crop rect layout.
*  `hTrailingSpace` - It is used to configure trailing horizontal space of crop rect layout.
*  `vBottomSpace` - It is used to configure bottom vertical space of crop rect layout.
*  `cornerRadius` - It is used to configure crop rect layout corner radius. Default value is `.leastNonzeroMagnitude`.
*  `width` - It is used to calculate width based on provided  `hLeadingSpace` and `hTrailingSpace`. 
*  `height` - It is used to calculate height based on provided  `vTopSpace` and `vBottomSpace`.
*  `cgRect` - It is used to calculate `CGRect` based on provided `vTopSpace`, `hLeadingSpace`, `vBottomSpace` and `hTrailingSpace`.

**Initialisation:**
```
let objImageCropConfig = YZImagePickerCropConfig(100, leadingSpace: 30, bottomSpace: 100, trailingSpace: 30, cornerRadius: 8)
let objImagePickerConfig = YZImagePickerConfig(.custom, cropConfig: objImageCropConfig)
```

### 3. YZImagePicker Class

`YZImagePicker` is used to capture image from device camera or choose image from photo library, based on provided properties. 

**Properties:**
*  `presentationController` - It is used to present `UIImagePickerController` and `RSKImageCropViewController`.
*  `anyObject` - It is used to store `Any` type object to pass value.
*  `delegate` - It is used to handle event like user choosed image or cancel process.
*  `imagePickerConfig` - It is used to store `YZImagePickerConfig`.

**Initialisation:**
```
import YZImagePicker

class ViewController: UIViewController, YZImagePickerDelegate {
    var objImagePicker: YZImagePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        if objImagePicker == nil {
            objImagePicker = YZImagePicker(self, delegate: self) //It will initialize object without Cropping features.
        }
    }
}

class ViewController: UIViewController, YZImagePickerDelegate {
    var objImagePicker: YZImagePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        if objImagePicker == nil {
            let yzImageCropConfig = YZImagePickerCropConfig(120, leadingSpace: 20, bottomSpace: 120, trailingSpace: 20, cornerRadius: 5)
            let yzImagePickerConfig = YZImagePickerConfig(.custom, cropConfig: yzImageCropConfig)
            objImagePicker = YZImagePicker(self, delegate: self, imagePickerConfig: yzImagePickerConfig) //It will initialize object with Cropping features.
        }
    }
}

```

**Methods:**
* `takePhoto()` - It is used to take a photo from device camera.
* `chooseFromLibrary()` - It is used to choose a photo from device photos library.


**YZImagePickerDelegate**

* `@objc optional func imagePickerDidSelected(image: UIImage?, anyObject: Any?)` - Delegate method call when user choosed or captured image.
* `@objc optional func imagePickerDidCancel(anyObject: Any?)` - Delegate method call when user cancelled choose or capture image process.
* `@objc optional func imagePickerPermissionDidChanged(status: Int, isGranted: Bool, anyObject: Any?)` - Delegate method call when user change device camera or photo library permission changed.


## Installation

YZImagePicker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YZImagePicker', '~> 0.1.1'
```

## Author

Vipul Patel (Yudiz Solutions Pvt. Ltd.), vipul.p@yudiz.in

## License

YZImagePicker is available under the MIT license. See the LICENSE file for more info.
