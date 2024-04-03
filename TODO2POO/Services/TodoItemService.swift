//
//  TodoItemService.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import Foundation

protocol TodoItemService {
    var presentableItems: PresentableTodoItems { get }

    func addItem(item: TODOItem)
    func removeAtOffsets(indexSet: IndexSet)
    func toggleItemCompletion(id: String)
    func updateItem(item: TODOItem)
}
