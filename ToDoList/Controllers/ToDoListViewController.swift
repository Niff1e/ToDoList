//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Pavel Maal on 20.11.24.
//

import UIKit

protocol ToDoListViewControllerDelegate: AnyObject {
    func didTapCell()
}

class ToDoListViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Search"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
        return tableView
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.effect = UIBlurEffect(style: .systemMaterial)
        view.alpha = 0
        return view
    }()
    
    private var models: [ToDoListItem] = []
    private var viewModels: [ToDoItemCollectionViewCellViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Задачи"
        
        setupSearchController()
        setupPositionOfSubview()
        getAllItems()
        tableView.delegate = self
        tableView.dataSource = self
        ApiCaller.shared.getListOfToDoItems { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.viewModels = model.todos.compactMap ({
                        ToDoItemCollectionViewCellViewModel(
                            title: $0.todo,
                            description: $0.todo,
                            date: Date(),
                            isCompleted: $0.completed
                        )
                    })
                    if self.models.isEmpty {
                        for model in self.viewModels {
                            self.createItem(byModel: model)
                        }
                    }
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Core Data
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func createItem(byModel model: ToDoItemCollectionViewCellViewModel) {
        let newItem = ToDoListItem(context: context)
        newItem.name = model.title
        newItem.descriptions = model.description
        newItem.isCompleted = model.isCompleted
        newItem.createdAt = Date()
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func updateItem(at indexPath: IndexPath, byNewItem newItem: ToDoListItem) {
        models[indexPath.row] = newItem
        
        do {
            try context.save()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Search Controller Setup
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    // MARK: - Position of Subviews
    
    private func setupPositionOfSubview() {
        self.view.addSubview(tableView)
        view.addSubview(visualEffectView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier, for: indexPath) as? ToDoItemTableViewCell
        else {
            return UITableViewCell()
        }
        cell.setBorderForCheckmark()
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        
        let vc = SelectedToDoItemViewController(model: model, view: SelectedToDoItemView(), index: indexPath)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        visualEffectView.alpha = 1
        navigationController?.navigationBar.isHidden = true
        present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Completed") { [weak self] action, view, completed in
            guard let strongSelf = self else {
                return
            }
            let item = strongSelf.models[indexPath.row]
            item.isCompleted = !item.isCompleted
            strongSelf.updateItem(at: indexPath, byNewItem: item)
            completed(true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}


extension ToDoListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    //MARK: - Search Controller Delegate Methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchModels: [ToDoListItem] = []
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController, let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        for model in self.models {
            guard let name = model.name else {
                return
            }
            if name.range(of: query, options: .caseInsensitive) != nil {
                searchModels.append(model)
            }
        }
        
        DispatchQueue.main.async {
            resultsController.update(with: searchModels)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.update(with: [])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        resultsController.update(with: [])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension ToDoListViewController: DidTapObjectsDelegate {
    func editButtonTapped(model: ToDoListItem, index: IndexPath) {
        visualEffectView.alpha = 0
        let vc = ToDoItemViewController(model: model, index: index)
        vc.title = "ЗАДАЧА"
        vc.delegate = self
        navigationController?.navigationBar.isHidden = false
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteButtonTapped(model: ToDoListItem, index: IndexPath) {
        deleteItem(item: model)
        navigationController?.navigationBar.isHidden = false
        visualEffectView.alpha = 0
    }
    
    func blurViewDidTapped() {
        navigationController?.navigationBar.isHidden = false
        visualEffectView.alpha = 0
    }
}

extension ToDoListViewController: ToDoItemViewControllerDelegate {
    func modelDidChange(model: ToDoListItem, index: IndexPath) {
        updateItem(at: index, byNewItem: model)
    }
}

