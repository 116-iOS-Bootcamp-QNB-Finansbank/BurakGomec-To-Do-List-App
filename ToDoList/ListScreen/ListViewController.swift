//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 14.10.2021.
//

import UIKit

class ListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareSearchController()
    }
    
    private func prepareNavigationBar(){
        self.title = "To Do List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        
    
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle")!, style: .done, target: self, action: nil)
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewToDoItem))
//        
//        rightBarButtonItem.tintColor = .red
//        leftBarButtonItem.tintColor = .red
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func prepareSearchController(){
        let searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
    }
    
    
    
    @objc func addNewToDoItem(){
        self.present(DetailViewController(), animated: true, completion: nil)
    }
    

}

extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Burak"
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(DetailViewController(), animated: true, completion: nil)
    }
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//    }
}
