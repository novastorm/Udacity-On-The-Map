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
        return UdacityParseClient.sharedInstance.studentInformationList
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
        cell.detailTextLabel?.text = "\(record.mediaURL!)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let student = studentInformationList[indexPath.row]
        
        guard let components = NSURLComponents(string: student.mediaURL!) else {
            showAlert(self, title: "Invalid URL components", message: student.mediaURL)
            return
        }

        components.scheme = components.scheme ?? "http"

        guard let url = components.URL else {
            showAlert(self, title: "Invalid URL", message: student.mediaURL)
            return
        }
            
        guard UIApplication.sharedApplication().openURL(url) else {
            showAlert(self, title: "Cannot open URL", message: "\(url)")
            return
        }
    }
    
    func updateStudentInformation() {
        self.tableView.reloadData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
