//
//  MovieDetailViewController.swift
//  rottentomatoes
//
//  Created by Anuj Goyal on 9/22/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movieID: String? = ""
    //var movieTitle: String!
    //var mpaa_rating: String!
    //var synopsis: String!
    var runtime: Int!
    //var year: Int!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var mpaaRating: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // http://stackoverflow.com/questions/26008536/text-icons-above-navigationbar-are-not-changing-color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var apiKey: String = "689574fmabnjswrkutgjhvrx"
        var url: String = "http://api.rottentomatoes.com/api/public/v1.0/movies/"+movieID!+".json?apikey="+apiKey
        NSLog("url = \(url)")
        //http://developer.rottentomatoes.com/docs/read/Home
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue() ) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in

            var err: NSError?
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &err) as NSDictionary
            NSLog("object = \(object)")
//            self.year.text = (object["year"] as? Int)._bridgeToObjectiveC(NSString )
//            self.runtime = object["runtime"] as? Int
            self.movieTitle.text = object["title"] as? String
            self.title = self.movieTitle.text
            
            self.synopsis.text = object["synopsis"] as? String
            self.mpaaRating.text = object["mpaa_rating"] as? String
            NSLog("year: \(self.year)")
            NSLog("runtime: \(self.runtime)")
            NSLog("title: \(self.movieTitle)")
            NSLog("synopsis: \(self.synopsis)")
            NSLog("mpaaRating: \(self.mpaaRating)")
            
            //var genres = object["genres"] as? String
            //NSLog("genres: \(genres)")
            var ratings = object["ratings"] as? NSDictionary
            var posters = object["posters"] as? NSDictionary
            NSLog("ratings: \(ratings)")
            NSLog("posters: \(posters)")
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
