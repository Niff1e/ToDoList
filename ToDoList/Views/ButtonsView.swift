//
//  ButtonsView.swift
//  ToDoList
//
//  Created by Pavel Maal on 25.11.24.
//

import Foundation
import UIKit

protocol DeleteButtonTappedDelegate: AnyObject {
    func deleteButtonTapped()
    func editButtonTapped()
}

final class ButtonsView: UIStackView {
    
    weak var delegate: DeleteButtonTappedDelegate?
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Редактировать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets.left = 12
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Поделиться", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets.left = 12
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets.left = 12
        return button
    }()
    
    private let editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "square.and.pencil")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "square.and.arrow.up")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let deleteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "trash")
        imageView.tintColor = .red
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        positionSubviews()
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Position of Subviews
    
    private func positionSubviews() {
        self.addArrangedSubview(editButton)
        self.addArrangedSubview(shareButton)
        self.addArrangedSubview(deleteButton)
        
        editButton.addSubview(editImageView)
        shareButton.addSubview(shareImageView)
        deleteButton.addSubview(deleteImageView)
        
        NSLayoutConstraint.activate([
            editImageView.trailingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: -12),
            editImageView.centerYAnchor.constraint(equalTo: editButton.centerYAnchor),
            
            shareImageView.trailingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: -12),
            shareImageView.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor),
            
            deleteImageView.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: -12),
            deleteImageView.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor),
        ])
    }
    
    // MARK: - Objc
    
    @objc private func deleteButtonTapped() {
        delegate?.deleteButtonTapped()
    }
    
    @objc private func editButtonTapped() {
        delegate?.editButtonTapped()
    }
}
