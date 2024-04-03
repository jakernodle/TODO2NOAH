//
//  TODOItem.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import Foundation

struct TODOItem: Codable, Hashable, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var dueDate: Date
    var completed: Bool
}

extension TODOItem {
    func isOverdue() -> Bool {
        return dueDate < Date()
    }
}
