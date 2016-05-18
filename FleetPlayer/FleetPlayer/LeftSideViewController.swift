//
//  LeftSideViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/18/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit
import MMDrawerController

class LeftSideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let tapArrays = ["视频文件", "音乐文件"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        
        return tapArrays.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TapCell")

        cell!.textLabel?.text = tapArrays[indexPath.item]
        
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController") as? HomeViewController
//            
//            let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideViewController") as? LeftSideViewController
//            
//            let leftSideNav = UINavigationController(rootViewController: leftViewController!)
            let centerNav = UINavigationController(rootViewController: centerViewController!)
            
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNav
            appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        case 1:
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let centerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MusicHomeViewController") as? MusicHomeViewController
//            
//            let leftViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LeftSideViewController") as? LeftSideViewController
//            
//            let leftSideNav = UINavigationController(rootViewController: leftViewController!)
            let centerNav = UINavigationController(rootViewController: centerViewController!)
            
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.centerContainer?.centerViewController = centerNav
            appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
