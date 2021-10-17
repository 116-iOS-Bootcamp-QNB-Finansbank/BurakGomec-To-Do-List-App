//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 15.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
    }

    private func prepareNavigationBar(){
        navigationBar.topItem?.title = "Details"
        let leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelTheEditing))
        leftBarButtonItem.tintColor = .red
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        rightBarButtonItem.tintColor = .red
        
        self.navigationBar.topItem?.leftBarButtonItem = leftBarButtonItem
        self.navigationBar.topItem?.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func cancelTheEditing(){
        //
    }

}
