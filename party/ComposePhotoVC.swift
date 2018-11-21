//
//  ComposePhotoVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import YPImagePicker

class ComposePhotoVC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    
    var imagePicker = YPImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //style select photo btn
        selectPhotoBtn.layer.cornerRadius = 10
        
        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
        
        
        //configure ypimagepicker
        var config = YPImagePickerConfiguration()
        config.libraryMediaType = .photo
        config.maxNumberOfItems = 1
        config.albumName = "Party"
        config.screens = [.library, .photo]
        
        //build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        
        //did finish
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        self.imagePicker = picker
    }
    
    @IBAction func openPhotoPicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
