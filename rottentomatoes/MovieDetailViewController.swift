//
//  MovieDetailViewController.swift
//  rottentomatoes
//
//  Created by Anuj Goyal on 9/22/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // movieID gets filled from parent controller
    var movieID: String? = ""
    var runtime: Int!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var mpaaRating: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rotRating: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // http://stackoverflow.com/questions/26008536/text-icons-above-navigationbar-are-not-changing-color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        //self.navigationController?.navigationBar.translucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // Do any additional setup after loading the view.

        // get movie from rotten tomatoes movies API
        // http://developer.rottentomatoes.com/docs/read/Home
        var apiKey: String = "689574fmabnjswrkutgjhvrx"
        var url: String = "http://api.rottentomatoes.com/api/public/v1.0/movies/"+movieID!+".json?apikey="+apiKey
        //NSLog("url = \(url)")
        var request = NSURLRequest(URL: NSURL(string: url))
        
        // setup HUD; https://github.com/jdg/MBProgressHUD
        var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDModeIndeterminate
        hud.labelText = "Loading...";
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue() ) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            var err: NSError?
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
            //NSLog("object = \(object)")
            
            if let yearInt = object["year"] as? Int {
                self.year.text = String(yearInt)
            }
            //if let runtimeInt = object["runtime"] as? Int {
            //    self.runtime.text = String(runtimeInt)
            //}
            
            self.title = object["title"] as? String
            self.movieTitle.text = self.title
            
            self.synopsis.text = object["synopsis"] as? String
            self.mpaaRating.text = object["mpaa_rating"] as? String
            
            // setup ratings
            var ratings = object["ratings"] as NSDictionary
            NSLog("ratings: \(ratings)")
            var audRating = ratings["audience_rating"] as? String
            var audScore = ratings["audience_score"] as? Int
            NSLog("audRating: \(audRating!)")
            NSLog("audScore: \(audScore!)")
            var criRating = ratings["critics_rating"] as? String
            var criScore = ratings["critics_score"] as? Int
            NSLog("audRating: \(criRating!)")
            NSLog("audScore: \(criScore!)")
            self.rotRating.text = "Audience: \(audScore!)%, Critics: \(criScore!)%"
            
            // setup background picture
            var posters = object["posters"] as NSDictionary
            var posterUrl = posters["thumbnail"] as String
            var image = UIImageView()
            image.setImageWithURL(NSURL(string: posterUrl))
            image.contentMode = UIViewContentMode.ScaleAspectFill
            // http://stackoverflow.com/questions/24109114
            // http://stackoverflow.com/questions/185652/how-to-scale-a-uiimageview-proportionally?rq=1 (good)
            self.scrollView.backgroundColor = UIColor.clearColor()
            self.scrollView.addSubview(image)
            self.scrollView.scrollEnabled = true
            //self.scrollView.alpha = 1
            
            // stop the hud
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
