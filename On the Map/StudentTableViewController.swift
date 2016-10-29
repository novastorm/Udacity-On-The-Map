//
//  StudentTableViewController.swift
//  On the Map
//
//  Created by Adland Lee on 4/2/16.
//  Copyright © 2016 Adland Lee. All rights reserved.
//

import UIKit

// MARK: StudentTableViewController: UITableViewController

class StudentTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // simplify the declaration of a read-only computed property by removing the get keyword and its braces
    var studentInformationList: [StudentInformation] {
        return StudentInformation.list
    }
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentInformation), name: .studentInformationUpdated, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    // MARK: Table view configuration

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "StudentInformationTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        let record = studentInformationList[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image = UIImage(named: "marker pin")
        cell.textLabel?.text = "\(record.firstName!) \(record.lastName!)"
        cell.detailTextLabel?.text = "\(record.mediaURL!)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let student = studentInformationList[(indexPath as NSIndexPath).row]
        
        guard var components = URLComponents(string: student.mediaURL!) else {
            showAlert(self, title: "Invalid URL components", message: student.mediaURL)
            return
        }

        components.scheme = components.scheme ?? "http"

        guard let url = components.url else {
            showAlert(self, title: "Invalid URL", message: student.mediaURL)
            return
        }
        
        guard UIApplication.shared.canOpenURL(url)  else {
            showAlert(self, title: "Cannot open URL", message: "\(url)")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: Helper Utilities
    
    func updateStudentInformation() {
        self.tableView.reloadData()
    }
    
    
    // MARK: Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
