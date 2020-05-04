//
//  ViewController.swift
//  YZImagePicker
//
//  Created by Vipul Patel on 04/30/2020.
//  Copyright (c) 2020 Vipul Patel. All rights reserved.
//

import UIKit
import YZImagePicker

class ViewController: UIViewController, YZImagePickerDelegate {
    @IBOutlet weak var imgVw: UIImageView!
    var objImagePicker: YZImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        initImagePicker()
    }

    func initImagePicker() {
        if objImagePicker == nil {
            let yzImageCropConfig = YZImagePickerCropConfig(120, leadingSpace: 20, bottomSpace: 120, trailingSpace: 20, cornerRadius: 5)
            let yzImagePickerConfig = YZImagePickerConfig(.custom, cropConfig: yzImageCropConfig)
            objImagePicker = YZImagePicker(self, delegate: self, imagePickerConfig: yzImagePickerConfig)
        }
    }
    
    @IBAction func onTap(_ sender: UIButton) {
        objImagePicker.takePhoto()
    }
    
    func imagePickerDidSelected(image: UIImage?, anyObject: Any?) {
        imgVw.image = image
    }
    
    func imagePickerDidCancel(anyObject: Any?) {
        print(#function + " Cancelled.")
    }
    
    func imagePickerPermissionDidChanged(status: Int, isGranted: Bool, anyObject: Any?) {
        print(#function + " Status : " + status.description + " isGranted : \(isGranted)")
    }
}

