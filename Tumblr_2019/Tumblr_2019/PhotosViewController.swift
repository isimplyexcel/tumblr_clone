//
//  PhotosViewController.swift
//  Tumblr_2019
//
//  Created by Paul Min on 10/12/19.
//  Copyright © 2019 Paul Min. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var posts: [[String: Any]] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data,
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
              print(dataDictionary)
              
            // Get the dictionary from the response key
            let responseDictionary = dataDictionary["response"] as! [String: Any]
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary["posts"] as! [[String: Any]]
            self.tableView.reloadData()
          }
        }
        task.resume()
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
    }
      
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    let post = posts[indexPath.row]
    
    if let photos = post["photos"] as? [[String: Any]]{
        let photo = photos[0]
        let originalSize = photo["original_size"] as! [String: Any]
        let urlString = originalSize["url"] as! String
        let url = URL(string: urlString)
        cell.photoImageView.af_setImage(withURL: url!)
    }
    return cell
   }
    
    

}
