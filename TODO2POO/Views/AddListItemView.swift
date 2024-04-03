//
//  AddListItemView.swift
//  TODO2POO
//
//  Created by JohnAnge Kernodle on 4/3/24.
//

import SwiftUI

struct AddListItemView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var item: TODOItem
    var isEditPage: Bool
    var todoService: TodoItemService
    
    init(item: TODOItem? = nil, todoService: TodoItemService) {
        if let item = item {
            self._item = State(wrappedValue: item)
            isEditPage = true
        }else {
            let placeholderItem = TODOItem(name: "", dueDate: Date(), completed: false)
            self._item = State(wrappedValue: placeholderItem)
            isEditPage = false
        }
        self.todoService = todoService
    }
    var body: some View {
        VStack {
            Text(isEditPage ? "Edit Item" : "Add Item")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            TextField("Task", text: $item.name)
                .padding()
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
            DatePicker("Time", selection: $item.dueDate, displayedComponents: [.hourAndMinute])
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
            DatePicker("Date", selection: $item.dueDate, displayedComponents: [.date])
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                )
            
            Button {
                if isEditPage {
                    todoService.updateItem(item: item)
                }else {
                    todoService.addItem(item: item)
                }
                dismiss()
            } label: {
                Text(isEditPage ? "Update" : "Create")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer()

        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AddListItemView(todoService: DefaultTodoItemService())
}
