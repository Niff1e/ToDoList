//
//  SelectedToDoItemViewable.swift
//  ToDoList
//
//  Created by Pavel Maal on 25.11.24.
//

import Foundation
import UIKit

protocol SelectedToDoItemViewable: UIView {
    func setDataToView(data: ToDoListItem)
}
