//
//  ToDoItemViewController.swift
//  ToDoList
//
//  Created by Pavel Maal on 25.11.24.
//

import UIKit

protocol ToDoItemViewControllerDelegate: AnyObject {
    func modelDidChange(model: ToDoListItem, index: IndexPath)
}

class ToDoItemViewController: UIViewController {
    
    weak var delegate: ToDoItemViewControllerDelegate?
    
    private let titleTextView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        
        textField.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        return textField
    }()
    
    private let dateTextView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.textColor = .secondaryLabel
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        title = "ЗАДАЧА"
        setupPositionOfSubviews()
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        dateTextView.delegate = self
        
        setDataToView()
    }
    
    private var model: ToDoListItem
    private var index: IndexPath
    
    // MARK: - Init
    
    init(model: ToDoListItem, index: IndexPath) {
        self.model = model
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        delegate?.modelDidChange(model: model, index: index)
    }
    
    // MARK: - Position of Subviews
    
    private func setupPositionOfSubviews() {
        view.addSubview(titleTextView)
        view.addSubview(descriptionTextView)
        view.addSubview(dateTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleTextView.heightAnchor.constraint(equalToConstant: 200.0),
            
            dateTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            dateTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dateTextView.heightAnchor.constraint(equalToConstant: 50.0),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateTextView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 400.0)
        ])
    }
    
    private func setDataToView() {
        titleTextView.text = model.name
        descriptionTextView.text = model.descriptions
        guard let date = model.createdAt else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let formattedDate = dateFormatter.string(from: date)
        dateTextView.text = formattedDate
    }
}

extension ToDoItemViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == titleTextView {
            model.name = textView.text
        } else if textView == descriptionTextView {
            model.descriptions = textView.text
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            guard let formattedDate = dateFormatter.date(from: dateTextView.text) else { return }
            model.createdAt = formattedDate
        }
    }
}
