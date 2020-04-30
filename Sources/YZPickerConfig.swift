//
//  YZPickerConfig.swift
//  YZImagePicker
//
//  Created by Vipul Patel on 21/04/20.
//

import UIKit
import RSKImageCropper

//MARK: - Class YZImagePickerConfig
// It will use to configure `YZImagePicker` object.
public class YZImagePickerConfig: NSObject {
    internal var cropMode: RSKImageCropMode
    internal var cropConfig: YZImagePickerCropConfig?
    
    public init(_ cropMode: RSKImageCropMode, cropConfig: YZImagePickerCropConfig? = nil) {
        self.cropMode = cropMode
        self.cropConfig = cropConfig
    }
}

//MARK: - Class YZImagePickerConfig
/// It will configure image cropping visible layout
public class YZImagePickerCropConfig: NSObject {
    fileprivate var vTopSpace: CGFloat
    fileprivate var hLeadingSpace: CGFloat
    fileprivate var hTrailingSpace: CGFloat
    fileprivate var vBottomSpace: CGFloat
    fileprivate var cornerRadius: CGFloat
    fileprivate var width: CGFloat {
        return UIScreen.main.bounds.width - (hLeadingSpace + hTrailingSpace)
    }
    fileprivate var height: CGFloat {
        return UIScreen.main.bounds.height - (vTopSpace + vBottomSpace)
    }
    internal var cgRect: CGRect {
        return CGRect(x: hLeadingSpace, y: ((UIScreen.main.bounds.height/2) - (height/2)), width: width, height: height)
    }
    internal var bezierPath: UIBezierPath {
        return UIBezierPath(roundedRect: cgRect, cornerRadius: cornerRadius)
    }

    /// It will initialize properties of `YZImagePickerCropConfig` as per given parameter values.
    /// - Parameters:
    ///   - topSpace: Add `topSpace` for visible crop view from super view.
    ///   - leadingSpace: Add `leadingSpace` for visible crop view from super view.
    ///   - bottomSpace: Add `bottomSpace` for visible crop view from super view.
    ///   - trailingSpace: Add `trailingSpace` for visible crop view from super view.
    ///   - cornerRadius: Add `cornerRadius` for visible crop view.
    public init(_ topSpace: CGFloat, leadingSpace: CGFloat, bottomSpace: CGFloat, trailingSpace: CGFloat, cornerRadius: CGFloat = .leastNonzeroMagnitude) {
        vTopSpace = topSpace
        hLeadingSpace = leadingSpace
        vBottomSpace = bottomSpace
        hTrailingSpace = trailingSpace
        self.cornerRadius = cornerRadius
    }
}
