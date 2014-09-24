//
//  MoviesViewController.swift
//  rottentomatoes
//
//  Created by Anuj Goyal on 9/21/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary] = []
    var mid: String = ""
    var refreshControl:UIRefreshControl!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // set navigation bar controller
        // http://stackoverflow.com/questions/24687238/changing-navigation-bar-colour-in-swift
        //self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        //self.tabBarController?.tabBar.tintColor = UIColor.yellowColor()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        /*http://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
        var alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.Alert)
        //alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                println("default")
                
            case .Cancel:
                println("cancel")
                
            case .Destructive:
                println("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)*/
        
        // get data from network
        getData()
        
        //
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.orangeColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: "getData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    
    }
    
    func getData() {
        NSLog("getData called")
        var apiKey = "689574fmabnjswrkutgjhvrx"
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey="+apiKey+"&limit=20&country=us"
        var request = NSURLRequest(URL: NSURL(string: url))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue() ) {
            (response: NSURLResponse!, urlData: NSData!, error: NSError!) -> Void in
            
            if urlData != nil {
                var err: NSError?
                if let object = (NSJSONSerialization.JSONObjectWithData(urlData, options: nil, error: &err) as? NSDictionary) {
                    self.movies = object["movies"] as [NSDictionary]
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                // network error
                
            }
            //println("object = \(object)")
        }
    }
    
    /* http://stackoverflow.com/questions/24622960/swift-uiapplication-setstatusbarstyle-doesnt-work
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return movies.count;
    }
    
    // main function that builds up a cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        println(__FUNCTION__ + " row \(indexPath.row), section: \(indexPath.section)")
        
        // get movie cell
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        // fill labels
        var movie = movies[indexPath.row]
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        //cell.movieTitleLabel.text = "Title"
        //cell.synopsisLabel.text = "Synopsis"
        //var cell = UITableViewCell()
        //cell.textLabel!.text = "Hello I'm at row: \(indexPath.row), section: \(indexPath.section)"

        // get poster image
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))

        // turn off arrow; http://stackoverflow.com/questions/24266467/swift-tableview-cell-set-accessory-type
        cell.accessoryType = UITableViewCellAccessoryType.None
        // set selectionStyle
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
        return cell
    }

    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        var movie = movies[indexPath.row]
        self.mid = movie["id"] as String
//        NSLog("["+__FUNCTION__ + "] cell #\(indexPath.row) mid: " + self.mid)
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("["+__FUNCTION__ + "] cell #\(indexPath.row)")
//        var movie = movies[indexPath.row]
//        self.mid = movie["id"] as String
//        println("[didSelectRowAtIndexPath] mid: " + self.mid)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MovieDetailSegue" {
            let vc = segue.destinationViewController as MovieDetailViewController
            vc.movieID = self.mid
            NSLog("["+__FUNCTION__+"] mid: " + self.mid)
        }
    }
    
}
