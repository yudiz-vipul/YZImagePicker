//
//  YZImagePicker.swift
//  YZImagePicker
//
//  Created by Vipul Patel on 21/04/20.
//

import UIKit
import AVKit
import Photos
import RSKImageCropper

//MARK: - Global(s)
fileprivate typealias YZPermissionStatus = (_ status: Int, _ isGranted: Bool) -> ()

//MARK: - Protocol YZImagePickerDelegate
@objc public protocol YZImagePickerDelegate: class {
    @objc optional func imagePickerDidSelected(image: UIImage?, anyObject: Any?)
    @objc optional func imagePickerDidCancel(anyObject: Any?)
    @objc optional func imagePickerPermissionDidChanged(status: Int, isGranted: Bool, anyObject: Any?)
}

//MARK: - Class YZImagePicker
public class YZImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private var anyObject: Any?
    private weak var presentationController: UIViewController?
    private weak var delegate: YZImagePickerDelegate?
    private var imagePickerConfig: YZImagePickerConfig?
    
    /// It will initialise `YZImagePicker` class with given parameters.
    /// - Parameters:
    ///   - presentationController: `UIViewController` type object to present `YZImagePicker`.
    ///   - delegate: `YZImagePickerDelegate` type protocol to provide delegate events.
    ///   - imagePickerConfig: `YZImagePickerConfig` type object to configure `YZImagePicker` properties, while using image cropping features. Default value is **nil**.
    public init(_ presentationController: UIViewController, delegate: YZImagePickerDelegate, imagePickerConfig: YZImagePickerConfig? = nil) {
        pickerController = UIImagePickerController()
        pickerController.modalPresentationStyle = .overFullScreen
        super.init()
        weak var weakSelf: YZImagePicker? = self
        weakSelf?.presentationController = presentationController
        weakSelf?.delegate = delegate
        weakSelf?.imagePickerConfig = imagePickerConfig
        pickerController.delegate = weakSelf
    }
    
    /// It is fileprivate method.
    /// - Parameters:
    ///   - image: `UIImage` type object.
    ///   - controller: 'UIImagePickerController' type object.
    fileprivate func didSelected(_ image: UIImage?, controller: UIImagePickerController) {
        DispatchQueue.main.async {[weak self] in
            guard let weakSelf = self else{return}
            if let image = image, let imagePickerConfig = weakSelf.imagePickerConfig {
                controller.dismiss(animated: true) {weakSelf.showCropViewWith(image, cropMode: imagePickerConfig.cropMode)}
            }else{
                controller.dismiss(animated: true) {
                    weakSelf.delegate?.imagePickerDidSelected?(image: image, anyObject: weakSelf.anyObject)
                }
            }
        }
    }
    
    /// It is fileprivate method.
    /// - Parameters:
    ///   - image: `UIImage` type object.
    ///   - cropMode: `RSKImageCropMode` type object to define image cropping modes.
    fileprivate func showCropViewWith(_ image: UIImage, cropMode: RSKImageCropMode) {
        let vcImageCropper = RSKImageCropViewController(image: image, cropMode: cropMode)
        vcImageCropper.delegate = self
        if cropMode == .custom {vcImageCropper.dataSource = self}
        vcImageCropper.avoidEmptySpaceAroundImage = true
        vcImageCropper.maskLayerLineWidth = 1
        vcImageCropper.modalPresentationStyle = .overFullScreen
        presentationController?.present(vcImageCropper, animated: true, completion: nil)
    }
}

//MARK: UIImagePickerController
extension YZImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// It will use to capture image from device camera.
    public func takePhoto() {
        checkCameraPermission {[weak self](status, isGranted: Bool) in
            guard let weakSelf = self else{return}
            if AVAuthorizationStatus.authorized.rawValue == status && isGranted {
                weakSelf.pickerController.sourceType = .camera
                weakSelf.pickerController.cameraDevice = .rear
                weakSelf.pickerController.cameraCaptureMode = .photo
                DispatchQueue.main.async {
                    weakSelf.presentationController?.present(weakSelf.pickerController, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    weakSelf.delegate?.imagePickerPermissionDidChanged?(status: status, isGranted: isGranted, anyObject: weakSelf.anyObject)
                }
            }
        }
    }
    
    /// It will use to choose image from device photos library.
    public func chooseFromLibrary() {
        checkPhotosPermission {[weak self](status: Int, isGranted: Bool) in
            guard let weakSelf = self else{return}
            if PHAuthorizationStatus.authorized.rawValue == status && isGranted {
                weakSelf.pickerController.sourceType = .photoLibrary
                DispatchQueue.main.async {
                    weakSelf.presentationController?.present(weakSelf.pickerController, animated: true, completion: nil)
                }
            }else{
                DispatchQueue.main.async {
                    weakSelf.delegate?.imagePickerPermissionDidChanged?(status: status, isGranted: isGranted, anyObject: weakSelf.anyObject)
                }
            }
        }
    }

    /// It is `UIImagePickerControllerDelegate` method, call when user capture or choose image from camera or photos library.
    /// - Parameters:
    ///   - picker: `UIImagePickerController` type object.
    ///   - info: `Dictionary`type object, to contains image information.
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[.originalImage] as? UIImage else {
            return didSelected(nil, controller: picker)
        }
        didSelected(originalImage, controller: picker)
    }
    
    /// It is `UIImagePickerControllerDelegate` method, call when user canceling capture or choose image.
    /// - Parameter picker: `UIImagePickerController` type object.
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.delegate?.imagePickerDidCancel?(anyObject: self.anyObject)
        }
    }
}

//MARK: RSKImageCropViewController
extension YZImagePicker: RSKImageCropViewControllerDataSource, RSKImageCropViewControllerDelegate {
    
    public func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return imagePickerConfig?.cropConfig?.cgRect ?? .zero
    }
    
    public func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return imagePickerConfig?.cropConfig?.bezierPath ?? UIBezierPath(roundedRect: .zero, cornerRadius: .leastNonzeroMagnitude)
    }
    
    public func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return imagePickerConfig?.cropConfig?.cgRect ?? .zero
    }
    
    public func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        controller.dismiss(animated: true) {
            self.delegate?.imagePickerDidSelected?(image: croppedImage, anyObject: self.anyObject)
        }
    }
    
    public func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        controller.dismiss(animated: true) {
            self.delegate?.imagePickerDidCancel?(anyObject: self.anyObject)
        }
    }
}

//MARK: YZImagePicker Permission(s)
extension YZImagePicker {

    /// It will check camera premission given or not.
    /// - Parameter block: `YZPermissionStatus` block with `AVAuthorizationStatus` and `Bool` value
    fileprivate func checkCameraPermission(block: @escaping YZPermissionStatus) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                DispatchQueue.main.async {block(AVAuthorizationStatus.authorized.rawValue, true)}
            case .denied:
                DispatchQueue.main.async {block(AVAuthorizationStatus.denied.rawValue, false)}
            case .restricted:
                DispatchQueue.main.async {block(AVAuthorizationStatus.restricted.rawValue, false)}
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (grant) in
                    if grant {
                        DispatchQueue.main.async {block(AVAuthorizationStatus.authorized.rawValue, grant)}
                    }else{
                        DispatchQueue.main.async {block(AVAuthorizationStatus.denied.rawValue, grant)}
                    }
                })
            @unknown default:
                fatalError("SOMETHING WRONG.")
            }
        }else{
            DispatchQueue.main.async {block(AVAuthorizationStatus.restricted.rawValue, false)}
        }
    }
    
    /// It will check camera premission given or not.
    /// - Parameter block: `YZPermissionStatus` block with `AVAuthorizationStatus` and `Bool` value
    fileprivate func checkPhotosPermission(block: @escaping YZPermissionStatus) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                DispatchQueue.main.async {block(PHAuthorizationStatus.authorized.rawValue, true)}
            case .denied:
                DispatchQueue.main.async {block(PHAuthorizationStatus.denied.rawValue, false)}
            case .restricted:
                DispatchQueue.main.async {block(PHAuthorizationStatus.restricted.rawValue, false)}
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (grant) in
                    switch grant {
                    case .authorized:
                        DispatchQueue.main.async {block(PHAuthorizationStatus.authorized.rawValue, true)}
                    default:
                        DispatchQueue.main.async {block(PHAuthorizationStatus.denied.rawValue, false)}
                    }
                })
            @unknown default:
                fatalError("SOMETHING WRONG.")
            }
        }else{
            DispatchQueue.main.async {block(PHAuthorizationStatus.restricted.rawValue, false)}
        }
    }
}
