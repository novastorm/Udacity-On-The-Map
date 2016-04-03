//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
//    var studentInformationList: [StudentInformation] {
//        get {
//            return UdacityParseClient.sharedInstance().studentInformationList
//        }
//    }

    // simplify the declaration of a read-only computed property by removing the get keyword and its braces
    var studentInformationList: [StudentInformation] {
        return UdacityParseClient.sharedInstance().studentInformationList
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateStudentInformation), name: StudentInformationUpdatedNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentInformationTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        let record = studentInformationList[indexPath.row]
        
        cell.imageView?.image = UIImage(named: "marker pin")
        cell.textLabel?.text = "\(record.firstName!) \(record.lastName!)"
        cell.detailTextLabel?.text = "\(record.createdAt!) \(record.updatedAt!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("StudentInformationDetailView") as! StudentDetailViewController
        
        vc.student = studentInformationList[indexPath.row]
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func updateStudentInformation() {
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
