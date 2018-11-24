//
//  ComposePhotoVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import YPImagePicker
import Firebase
import SwiftMessages

class ComposePhotoVC: UIViewController {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectPhotoBtn: UIButton!
    @IBOutlet weak var pendingPhoto: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    var didSelectPhoto = false
    
    var imagePicker = YPImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //at first upload btn is hidden
        uploadBtn.isHidden = true
        
        //style select photo btn
        selectPhotoBtn.layer.cornerRadius = 10
        
        //style progress view
        progressView.layer.cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 8
        progressView.subviews[1].clipsToBounds = true
        
        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
        
        //style photo view
        pendingPhoto.layer.cornerRadius = 10
        pendingPhoto.clipsToBounds = true
        
        
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
                    self.pendingPhoto.image = photo.image
                    self.didSelectPhoto = true
                    self.uploadBtn.isHidden = false
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        self.imagePicker = picker
    }
    
    @IBAction func upload(_ sender: Any) {
        //only if user selected a photo to be posted
        if didSelectPhoto, let image = self.pendingPhoto.image, let uid = Auth.auth().currentUser?.uid {
            //create firestore db reference
            let db = Firestore.firestore()
            
            //get new write batch
            let batch = db.batch()
            
            //create reference to this user
            let userRef = db.collection("users").document(uid)
            
            //create reference to this user's posts
            let postRef = db.collection("posts").document(uid).collection("posts").document()
            
            //create reference to photoId by pulling from the auto-generated child ID
            let photoId = postRef.documentID
            
            //get current timestamp
            let timestamp = Timestamp.init()
            
            //update status data in user document
            batch.setData(["status": "📷 Photo", "lastStatus": timestamp], forDocument: userRef, merge: true)
            
            //update post data in user posts document
            batch.setData(["type": "photo", "photoId": photoId, "created_at": timestamp], forDocument: postRef)
            
            //create storage ref
            let storage = Storage.storage().reference().child("photos/\(uid)/\(photoId)")
            
            //create jpeg image data (with 0.7 compression ratio)
            let imageData = image.jpegData(compressionQuality: 0.25)
            
            //attempt to upload image data to Firebase Storage
            let uploadTask = storage.putData(imageData!, metadata: nil) { (meta, error) in
                if error != nil {
                    //error, handle
                    self.presentError(message: error?.localizedDescription ?? "Something went wrong.")
                } else {
                    //success, now commit batch to Firestore database
                    batch.commit(completion: { (err) in
                        if err != nil {
                            //error, handle
                            self.presentError(message: err?.localizedDescription ?? "Something went wrong.")
                        } else {
                            //success
                            let view = MessageView.viewFromNib(layout: .centeredView)
                            view.configureTheme(.success)
                            view.configureDropShadow()
                            view.button?.isHidden = true
                            view.configureContent(title: "Success", body: "Your photo was posted!", iconText:"🎉")
                            view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                            var config = SwiftMessages.Config()
                            config.presentationStyle = .center
                            config.duration = .seconds(seconds: 2)
                            SwiftMessages.show(config: config, view: view)
                            Constants().updatePostCount(uid: uid, value: 1)
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
            
            uploadTask.observe(.progress) { snapshot in
                // Upload reported progress
                let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount)
                    / Float(snapshot.progress!.totalUnitCount)
                
                self.progressView.setProgress(percentComplete, animated: true)
            }
        }
    }
    
    
    @IBAction func openPhotoPicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //helper function to present error
    func presentError(message: String) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: "Oops", body: message, iconText:"🙃")
        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        var config = SwiftMessages.Config()
        config.presentationStyle = .center
        config.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: config, view: view)
    }

}
