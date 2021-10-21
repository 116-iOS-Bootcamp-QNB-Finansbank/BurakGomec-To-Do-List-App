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
    private var filteredTodoArray: [TodoEntity] = []
    private var searchBarControl = false

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareSearchController()
        presenter?.viewDidLoad()
        createNotificationObserver()
    }

    private func createNotificationObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateTodoList), name: .updateTodoList, object: nil)
    }
    
    @objc func updateTodoList(){
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
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .red
    }
    
    @objc func addNewToDoItem(){
        self.presenter?.addNewToDoItem()
    }
    
    private func removeTodoObserver(){
        NotificationCenter.default.removeObserver(self, name: .updateTodoList, object: nil)
    }
    
    deinit {
        print("\(self) deinit")
        
    }
}

//MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarControl == false ? todoArray.count : filteredTodoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchBarControl == false ? todoArray[indexPath.row].title : filteredTodoArray[indexPath.row].title
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(todo: todoArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
            self.presenter?.deleteTodo(todo: self.todoArray[indexPath.row])
            self.todoArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        action.image = UIImage(systemName: "trash.fill") //SF Symbols icon
        let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [action])
        return swipeActionConfiguration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        
        if text?.trimmingCharacters(in: .whitespaces) == ""{
            searchBarControl = false
            tableView.reloadData()
        }
        else {
            searchBarControl = true
            guard let searchText = searchController.searchBar.text else { return }
            filteredTodoArray = todoArray.filter { (todo) in
                return todo.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            tableView.reloadData()
        }
    }
}
