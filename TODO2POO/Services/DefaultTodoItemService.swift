//
//  DefaultTodoItemService.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import Foundation

struct ItemWrapper: Decodable {
    var items: [TODOItem]
}

class DefaultTodoItemService: TodoItemService {
    
    private var items: [TODOItem] {
        didSet {
            UserDefaults.standard.setStruct(value: items, key: "todoList")
        }
    }

    var presentableItems: PresentableTodoItems {
        get {
            let completed = items.filter { $0.completed == true }
            let today = items.filter { item in
                let todayDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
                let itemDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: item.dueDate)
                if todayDateComponents == itemDateComponents && item.completed == false {
                    return true
                }
                return false
            }
            let tomorrow = items.filter { item in
                let todayDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: Date())
                var itemDateComponents = Calendar.current.dateComponents([.day,.month,.year], from: item.dueDate)
                itemDateComponents.day! -= 1
                if todayDateComponents == itemDateComponents && item.completed == false {
                    return true
                }
                return false
            }
            return PresentableTodoItems(completedItems: completed, todayItems: today, tomorrowItems: tomorrow)
        }
    }
    
    init() {
        self.items = UserDefaults.standard.getStruct(value: [TODOItem].self, key: "todoList") ?? []
    }
    
    func addItem(item: TODOItem) {
        items.append(item)
        sortItems()
    }
    
    func updateItem(item: TODOItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            print("No item for index")
            return
        }
        
        items[index] = item
    }
    
    func removeAtOffsets(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func toggleItemCompletion(id: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            print("No item for index")
            return
        }
        
        items[index].completed.toggle()
    }
    
    private func sortItems() {
        items.sort(by: { $0.dueDate < $1.dueDate })
    }
}
