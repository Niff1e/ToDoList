//
//  SelectedToDoItemView.swift
//  ToDoList
//
//  Created by Pavel Maal on 25.11.24.
//

import UIKit

final class SelectedToDoItemView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 3
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        self.layer.cornerRadius = 20
        setupPositionOfSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Position of Subviews
    
    private func setupPositionOfSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(dateLabel)
        
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10.0),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
        ])
    }
}

extension SelectedToDoItemView: SelectedToDoItemViewable {
    func setDataToView(data: ToDoListItem) {
        titleLabel.text = data.name
        descriptionLabel.text = data.descriptions
        guard let date = data.createdAt else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let formattedDate = dateFormatter.string(from: date)
        dateLabel.text = formattedDate
    }
}


