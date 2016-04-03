//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var studentInformationList: [StudentInformation] {
        return UdacityParseClient.sharedInstance().studentInformationList
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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc = storyboard!.instantiateViewControllerWithIdentifier("StudentInformationDetailView")
    }
}
