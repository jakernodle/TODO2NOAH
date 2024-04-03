//
//  ContentView.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import SwiftUI

struct MainListView: View {
    let todoItemServie: TodoItemService
    @State var presentableItems: PresentableTodoItems
    @State var selectedItem: TODOItem? = nil
    @State var showAddNewItem: Bool = false
    
    init() {
        self.todoItemServie = DefaultTodoItemService()
        self._presentableItems = State(wrappedValue: todoItemServie.presentableItems)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(content: {
                    ListSection(showOverdueStatus: false, items: $presentableItems.completedItems, todoService: todoItemServie, update: updateItems)
                }, header: {
                    Text("Completed")
                        .bold()
                })
                
                Section(content: {
                    ListSection(items: $presentableItems.todayItems, todoService: todoItemServie, update: updateItems)
                }, header: {
                    Text("Today")
                        .bold()
                })
                
                Section(content: {
                    ListSection(items: $presentableItems.tomorrowItems, todoService: todoItemServie, update: updateItems)
                }, header: {
                    Text("Tomorrow")
                        .bold()
                })
            }.toolbar(content: {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                
                ToolbarItem {
                    Button(action: {
                        showAddNewItem = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            })
        }
        .sheet(item: $selectedItem) {
            updateItems()
        } content: { item in
            AddListItemView(item: item, todoService: todoItemServie)
        }
        .sheet(isPresented: $showAddNewItem, onDismiss: {
            updateItems()
        }, content: {
            AddListItemView(todoService: todoItemServie)
        })

    }
    
    func updateItems() {
        presentableItems = todoItemServie.presentableItems
    }
    
    func addItem() {
        let testItem = TODOItem(name: "test2", dueDate: Date(), completed: false)
        todoItemServie.addItem(item: testItem)
        updateItems()
        
        print(todoItemServie.presentableItems)
        print(presentableItems)
    }
}


struct ListSection: View {
    var showOverdueStatus = true
    @Binding var items: [TODOItem]
    var todoService: TodoItemService
    var update: (()-> Void)
    
    var body: some View {
        ForEach(items, id: \.self) { item in
            HStack {
                Button {
                    todoService.toggleItemCompletion(id: item.id)
                    update()
                } label: {
                    if item.completed {
                        Image(systemName: "checkmark.circle")
                    }else {
                        Image(systemName: "circle")
                    }
                }

                
                Text(item.name)
                if item.isOverdue() && showOverdueStatus {
                    Text("Overdue!")
                        .foregroundColor(.red)
                }
            }
        }
        .onDelete(perform: { offsets in
            todoService.removeAtOffsets(indexSet: offsets)
            update()
        })
    }
}


#Preview {
    MainListView()
}
