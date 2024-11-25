//
//  ToDoItemCollectionViewCell.swift
//  ToDoList
//
//  Created by Pavel Maal on 21.11.24.
//

import UIKit

final class ToDoItemTableViewCell: UITableViewCell {
    
    static let identifier = "ToDoItemTableViewCell"
    private var isCompleted: Bool = false {
        didSet {
            checkmarkImageView.image = isCompleted ? UIImage(
                systemName: "checkmark",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 10.0)
            ) : nil
            checkmarkImageView.layer.borderColor = isCompleted ? UIColor.yellow.cgColor : UIColor.gray.cgColor
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.numberOfLines = 3
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24.0
        return imageView
    }()
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        self.addSubview(checkmarkImageView)
        let checkmarkSize = CGSize(width: 30, height: 30)
                
        NSLayoutConstraint.activate([
            checkmarkImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            checkmarkImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10.0),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: checkmarkSize.width + 18.0),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: checkmarkSize.height + 18.0),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10.0),
            dateLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 10.0),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12.0),
        ])
    }
    
    // MARK: - Configure content
    
    func configure(with model: ToDoListItem) {
        titleLabel.text = model.name
        descriptionLabel.text = model.descriptions
        guard let date = model.createdAt else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let formattedDate = dateFormatter.string(from: date)
        dateLabel.text = formattedDate
        isCompleted = model.isCompleted
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        isCompleted = false
        checkmarkImageView.image = nil
        checkmarkImageView.layer.borderColor = nil
        checkmarkImageView.layer.borderWidth = 0
    }
    
    func setBorderForCheckmark() {
        checkmarkImageView.layer.borderColor = UIColor.gray.cgColor
        checkmarkImageView.layer.borderWidth = 2.0
        checkmarkImageView.tintColor = .yellow
    }
}
