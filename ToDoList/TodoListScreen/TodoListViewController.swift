//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Burak on 14.10.2021.
//

import UIKit

//Reference to Presenter

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func showTodoList(with todos: [TodoEntity])
    func showTodoList(with error: Error)
}

class TodoListViewController: UIViewController, AnyView {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: AnyPresenter?
    private var todoArray : [TodoEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareLeftBarButtonItem()
        prepareRightBarButtonItem()
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
    
    func showTodoList(with todos: [TodoEntity]) {
        DispatchQueue.main.async {
            self.todoArray = []
            self.todoArray = todos
            self.tableView.reloadData()
        }
    }
    
    func showTodoList(with error: Error) {
        self.showBasicAlert(title: "Error", message: "An error occurred while retrieving the todo list")
    }
    
    private func prepareNavigationBar(){
        self.title = "To Do List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
    }
    
    private func prepareRightBarButtonItem(){
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewToDoItem))
        rightBarButtonItem.tintColor = .red
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func prepareLeftBarButtonItem(){
        let earliestFirstSortAction = UIAction(title: "Sort by latest first edit date", image: UIImage(systemName: "arrowtriangle.up.fill")) { [weak self] (action) in
            guard let self = self else { return }
            self.presenter?.sortTodoListByLatestFirst()
        }
        
        let latestFirstSortAction = UIAction(title: "Sort by earliest first edit date", image: UIImage(systemName: "arrowtriangle.down.fill")) {[weak self] (action) in
            guard let self = self else { return }
            self.presenter?.sortTodoListByEarliestFirst()   
        }
        
        let deleteAllTodoAction = UIAction(title: "Delete all To Do", image: UIImage(systemName: "xmark.bin")) {[weak self] (action) in
            guard let self = self else { return }
            self.presenter?.deleteAllTodo()
        }
        
        let menu = UIMenu(options: .displayInline, children: [earliestFirstSortAction, latestFirstSortAction, deleteAllTodoAction])
        
        let leftBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle")!, menu: menu )
        
        leftBarButtonItem.tintColor = .red
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
        removeTodoObserver()
    }
}

//MARK: - UITableViewDataSource
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
            presenter?.getSavedTodoList()
        }
        else {
            guard let searchText = searchController.searchBar.text else { return }
            presenter?.filterTodoListBySearchText(searchText: searchText)
        }
    }
}
