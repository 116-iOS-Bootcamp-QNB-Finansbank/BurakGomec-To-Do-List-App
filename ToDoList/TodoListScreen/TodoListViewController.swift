//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 14.10.2021.
//

import UIKit

//Reference to Presenter

protocol AnyView : AnyObject {
    var presenter: AnyPresenter? { get set }
    
    func getTodoList(with todos: [TodoEntity])
    func getTodoList(with error: Error)
}

class TodoListViewController: UIViewController, AnyView {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: AnyPresenter?
    private var todoArray : [TodoEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareSearchController()
        presenter?.viewDidLoad()
    }
    
    func getTodoList(with todos: [TodoEntity]) {
        DispatchQueue.main.async {
            self.todoArray = []
            self.todoArray = todos
            self.tableView.reloadData()
        }
    }
    
    func getTodoList(with error: Error) {
        self.showBasicAlert(title: "Error", message: "An error occurred while retrieving the todo list")
    }
    
    private func prepareNavigationBar(){
        self.title = "To Do List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
        
    
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle")!, style: .done, target: self, action: nil)
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewToDoItem))
       
        rightBarButtonItem.tintColor = .red
        leftBarButtonItem.tintColor = .red
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func prepareSearchController(){
        let searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
    }
    
    @objc func addNewToDoItem(){
        self.presenter?.addNewToDoItem()
    }
    
    deinit {
        print("\(self) deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewDidLoad()
    }
}

extension TodoListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = todoArray[indexPath.row].title
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(todo: todoArray[indexPath.row])
    }
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//      //TODO:
//    }
}
