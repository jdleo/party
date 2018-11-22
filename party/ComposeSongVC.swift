//
//  ComposeSongVC.swift
//  party
//
//  Created by John Leonardo on 11/20/18.
//  Copyright © 2018 John Leonardo. All rights reserved.
//

import UIKit
import SpotifyLogin

class ComposeSongVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var songField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var songResults: [[String: String]] = []
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set text field delegate
        songField.delegate = self
        
        //set table view delegate + data source
        tableView.delegate = self
        tableView.dataSource = self
        
        //style card view
        //cardView.layer.masksToBounds = true
        cardView.roundCorners([.topRight, .topLeft], radius: 20)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(songField.text?.isEmpty)!, let song = songField.text {
            SpotifyLogin.shared.getAccessToken { (accessToken, error) in
                if error != nil {
                    
                } else {
                    let config = URLSessionConfiguration.default
                    let session = URLSession(configuration: config)
                    
                    let url = "https://api.spotify.com/v1/search"
                    let parameters = ["q": song, "type" : "track", "market": "us", "limit": "50"]
                    let headers = ["Authorization": "Bearer \(accessToken!)"]
                    
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
                        
                        // update UI using the response here
                        self.songResults = []
                        if let tracks = json["tracks"] {
                            let trackz = tracks as! [String: Any]
                            if let items = trackz["items"] as? NSArray {
                                for i in items {
                                    let item = i as! [String: Any]
                                    let trackName = item["name"]
                                    let preview = item["preview_url"]
                                    let artistInfo = item["artists"] as! [[String: Any]]
                                    let artist = artistInfo[0]["name"]
                                    let album = item["album"] as! [String: Any]
                                    let images = album["images"] as! [[String: Any]]
                                    let image = images[0]["url"]
                                    
                                
                                    self.songResults.append(["artist":artist as! String, "track":trackName as! String, "preview":preview as? String ?? "null", "image":image as! String])
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                    // execute the HTTP request
                    task.resume()
                    
                    self.songField.resignFirstResponder()
                }
            }
        } else {
            songField.resignFirstResponder()
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongPickCell", for: indexPath) as! SongPickCell
        
        cell.albumImg.image = nil
        cell.tag = indexPath.row
        cell.artistLbl.text = self.songResults[indexPath.row]["artist"]
        cell.trackLbl.text = self.songResults[indexPath.row]["track"]
        
        let url = URL(string: self.songResults[indexPath.row]["image"]!)
        
        if let cachedImage = imageCache.object(forKey: url?.absoluteString as! NSString) {
            cell.albumImg.image = cachedImage
        } else {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    if cell.tag == indexPath.row {
                        cell.albumImg.image = UIImage(data: data!)
                        self.imageCache.setObject(UIImage(data: data!)!, forKey: url?.absoluteString as! NSString)
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
