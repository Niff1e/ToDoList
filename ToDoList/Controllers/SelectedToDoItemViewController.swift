//
//  SelectedToDoItemViewController.swift
//  ToDoList
//
//  Created by Pavel Maal on 25.11.24.
//

import UIKit

protocol DidTapObjectsDelegate: AnyObject {
    func blurViewDidTapped()
    func deleteButtonTapped(model: ToDoListItem, index: IndexPath)
    func editButtonTapped(model: ToDoListItem, index: IndexPath)
}

class SelectedToDoItemViewController: UIViewController {
    
    private var toDoItemView: SelectedToDoItemViewable
    private var model: ToDoListItem
    private var index: IndexPath
    private var buttonsView = ButtonsView()
    
    weak var delegate: DidTapObjectsDelegate?

    // MARK: - Init
    
    init(model: ToDoListItem, view: SelectedToDoItemView, index: IndexPath) {
        self.model = model
        self.toDoItemView = view
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.isOpaque = false
        
        setPositionOfSubviews()
        toDoItemView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.distribution = .fillEqually
        buttonsView.axis = .vertical
        buttonsView.spacing = 1.0
        buttonsView.layer.cornerRadius = 20
        buttonsView.clipsToBounds = true
        buttonsView.delegate = self
        toDoItemView.setDataToView(data: model)
        addTupGestureRecongnizer()
    }
    
    // MARK: - Position of Subviews
    
    private func setPositionOfSubviews() {
        view.addSubview(toDoItemView)
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            toDoItemView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toDoItemView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toDoItemView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40.0),
            
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: toDoItemView.bottomAnchor, constant: 10.0),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -120.0),
            buttonsView.heightAnchor.constraint(equalToConstant: 120.0)
        ])
    }
    
    // MARK: - Gesture Recognizer
    
    private func addTupGestureRecongnizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Objc
    
    @objc private func tapGestureRecognizerAction() {
        delegate?.blurViewDidTapped()
        dismiss(animated: true, completion: nil)
    }
}

extension SelectedToDoItemViewController: DeleteButtonTappedDelegate {
    func editButtonTapped() {
        delegate?.editButtonTapped(model: model, index: index)
        dismiss(animated: true, completion: nil)
    }
    
    func deleteButtonTapped() {
        delegate?.deleteButtonTapped(model: model, index: index)
        dismiss(animated: true, completion: nil)
    }
}
