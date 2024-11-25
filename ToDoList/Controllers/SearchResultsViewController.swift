//
//  SearchResultsViewController.swift
//  ToDoList
//
//  Created by Pavel Maal on 23.11.24.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.register(ToDoItemTableViewCell.self, forCellReuseIdentifier: ToDoItemTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    private var toDoItems: [ToDoListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupPositionOfSubview()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(with results: [ToDoListItem]) {
        toDoItems = results
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    
    // MARK: - Position of Subviews
    
    private func setupPositionOfSubview() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
}


extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Delegate and Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = toDoItems[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoItemTableViewCell.identifier, for: indexPath) as? ToDoItemTableViewCell else {
            return UITableViewCell()
        }
        cell.setBorderForCheckmark()
        cell.configure(with: toDoItem)
        return cell
    }
    
}
