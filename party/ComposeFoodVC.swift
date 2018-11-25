//
//  ComposeFoodVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftMessages
import Firebase

class ComposeFoodVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uploadBtn: UIButton!
    
    //empty array for business results (from Yelp <3)
    var businessResults: [[String: Any]] = []
    
    var selectedIndex = -1
    
    let imageCache = NSCache<NSString, UIImage>()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //upload btn hidden by default
        uploadBtn.isHidden = true
        
        //tableview setup
        tableView.delegate = self
        tableView.dataSource = self
        
        //instantiate location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        
        //set text field delegate
        foodTextField.delegate = self
        
        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //first check if location services are enabled
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //check for empties
            if !(foodTextField.text?.isEmpty)!, let Q = foodTextField.text {
                uploadBtn.isHidden = true
                self.businessResults = []
                self.selectedIndex = -1
                textField.resignFirstResponder()
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                
                let url = "https://api.yelp.com/v3/businesses/search"
                let parameters = ["term": Q, "limit": "20", "categories": "Food", "latitude": "\(locationManager.location!.coordinate.latitude)", "longitude": "\(locationManager.location!.coordinate.longitude)"]
                let headers = ["Authorization": "Bearer \(Constants().yelpApiKey())"]
                
                var urlComponents = URLComponents(string: url)
                
                var queryItems = [URLQueryItem]()
                for (key, value) in parameters {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
                
                urlComponents?.queryItems = queryItems
                
                var request = URLRequest(url: (urlComponents?.url)!)
                request.httpMethod = "GET"
                
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                let task = session.dataTask(with: request) { data, response, error in
                    
                    // ensure there is no error for this HTTP response
                    guard error == nil else {
                        print ("error: \(error!)")
                        return
                    }
                    
                    // ensure there is data returned from this HTTP response
                    guard let content = data else {
                        print("No data")
                        return
                    }
                    
                    // serialise the data / NSData object into Dictionary [String : Any]
                    guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                        print("Not containing JSON")
                        return
                    }
                    
                    if let businesses = json["businesses"] as? [[String:Any]] {
                        for business in businesses {
                            if let name = business["name"] as? String, let image_url = business["image_url"] as? String, let rating = business["rating"] as? Double, let review_count = business["review_count"] as? Int {
                                self.businessResults.append(["name": name, "image_url": image_url, "rating": rating, "review_count": review_count])
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        //reload tableview data
                        self.tableView.reloadData()
                    }
                }
                
                // execute the HTTP request
                task.resume()
                
            } else {
                textField.resignFirstResponder()
            }
        } else {
            self.presentError(message: "In order to search for local restaurants, Party needs access to your location. You can enable this in Settings -> Privacy -> Location Services")
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        
        //style card view
        cell.accessoryCardView.layer.cornerRadius = 10
        cell.accessoryCardView.backgroundColor = UIColor(red:0.83, green:0.14, blue:0.14, alpha:1.0)
        cell.yelpImg.image = UIImage(named: "Yelp")
        
        //STYLE business img
        //style album img
        cell.businessImg.layer.cornerRadius = 10
        cell.businessImg.clipsToBounds = true
        
        cell.businessImg.image = nil
        cell.tag = indexPath.row
        cell.nameLbl.text = self.businessResults[indexPath.row]["name"] as! String
        cell.numRatingsLbl.text = "Based on \(self.businessResults[indexPath.row]["review_count"]!) ratings"
        
        let url = URL(string: self.businessResults[indexPath.row]["image_url"] as! String)
        
        if let cachedImage = imageCache.object(forKey: url?.absoluteString as! NSString) {
            cell.businessImg.image = cachedImage
        } else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row {
                        cell.businessImg.image = UIImage(data: data!)
                        self.imageCache.setObject(UIImage(data: data!)!, forKey: url?.absoluteString as! NSString)
                    }
                }
            }
        }
        
        if let rating = self.businessResults[indexPath.row]["rating"] as? Double {
            if rating == 0 {
                cell.ratingsImg.image = UIImage(named: "extra_large_0")
            } else if rating == 1 {
                cell.ratingsImg.image = UIImage(named: "extra_large_1")
            } else if rating == 1.5 {
                cell.ratingsImg.image = UIImage(named: "extra_large_1_half")
            } else if rating == 2 {
                cell.ratingsImg.image = UIImage(named: "extra_large_2")
            } else if rating == 2.5 {
                cell.ratingsImg.image = UIImage(named: "extra_large_2_half")
            } else if rating == 3 {
                cell.ratingsImg.image = UIImage(named: "extra_large_3")
            } else if rating == 3.5 {
                cell.ratingsImg.image = UIImage(named: "extra_large_3_half")
            } else if rating == 4 {
                cell.ratingsImg.image = UIImage(named: "extra_large_4")
            } else if rating == 4.5 {
                cell.ratingsImg.image = UIImage(named: "extra_large_4_half")
            } else {
                cell.ratingsImg.image = UIImage(named: "extra_large_5")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uploadBtn.isHidden = false
        self.selectedIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func upload(_ sender: Any) {
        //this tells us first that a cell HAS been selected
        if selectedIndex != -1 {
            if let uid = Auth.auth().currentUser?.uid {
                //reference to selected song in memory
                let selectedItem = businessResults[selectedIndex]
                
                //reference to Firestore database
                let db = Firestore.firestore()
                
                //reference to batch
                let batch = db.batch()
                
                //create reference to this user
                let userRef = db.collection("users").document(uid)
                
                //create reference to this user's posts
                let postRef = db.collection("posts").document(uid).collection("posts").document()
                
                //get current time as Timestamp type
                let timestamp = Timestamp.init()
                
                //create status string from business name
                let status = selectedItem["name"] as! String
                
                //update status data in user document
                batch.setData(["status": "🍽 " + status, "lastStatus": timestamp], forDocument: userRef, merge: true)
                
                //update post data in user posts document
                batch.setData([
                    "type": "food",
                    "name": selectedItem["name"] ?? "",
                    "image_url": selectedItem["image_url"] ?? "",
                    "review_count": selectedItem["review_count"] ?? "",
                    "rating": selectedItem["rating"] ?? "",
                    "created_at": timestamp
                    ], forDocument: postRef)
                
                //commit batch to database
                batch.commit { (error) in
                    if error != nil {
                        //error, handle
                        self.presentError(message: error?.localizedDescription ?? "Something went wrong.")
                    } else {
                        let view = MessageView.viewFromNib(layout: .centeredView)
                        view.configureTheme(.success)
                        view.configureDropShadow()
                        view.button?.isHidden = true
                        view.configureContent(title: "Success", body: "Your food post was sent!", iconText:"🎉")
                        view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                        var config = SwiftMessages.Config()
                        config.presentationStyle = .center
                        config.duration = .seconds(seconds: 2)
                        SwiftMessages.show(config: config, view: view)
                        Constants().updatePostCount(uid: uid, value: 1)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}
