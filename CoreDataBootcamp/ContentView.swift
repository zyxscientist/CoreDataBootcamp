//
//  ContentView.swift
//  CoreDataBootcamp
//
//  Created by PeterZ on 2022/9/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // 建立 FetchRequest 实例
    @FetchRequest(entity: FruitEntity.entity(),
                  // 语句支持对Fetch的数据进行一个简单排序↓
                  sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    var fruits: FetchedResults<FruitEntity>
    
    @State var textFiledOfText: String = ""

    var body: some View {
        NavigationView {
           VStack{
               HStack{
                   TextField("Enter some fruit", text: $textFiledOfText)
                       .keyboardType(.decimalPad) // 调用键盘类型
                       .padding()
                       .background(Color.gray.opacity(0.1))
                       .font(.headline)
                       .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                   
                   Button {
                       addItem()
                   } label: {
                       Text("Save")
                           .font(.system(size: 20, weight: .bold, design: .rounded))
                           .padding(.vertical, 15)
                           .padding(.horizontal)
                           .background(.blue)
                           .foregroundColor(.white)
                           .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                   }
               }.padding()
               
               List {
                   ForEach(fruits) { fruits in
                       Text("\(fruits.name!)")
                           .onTapGesture {
                               editItem(fruits: fruits)
                           }
                   }
                   .onDelete(perform: deleteItems)
               }
            }
            .navigationTitle(Text("Fruits"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    // 编辑功能
    private func editItem(fruits: FruitEntity){
        let currentName = fruits.name ?? ""
        fruits.name = currentName + "!"
        saveItem()
    }
    
    // 添加功能
    private func addItem() {
        withAnimation {
            if textFiledOfText != "" {
                let newItem = FruitEntity(context: viewContext)
                newItem.name = textFiledOfText
                
                // 保存操作，将上面的操作结果存到CoreData中
                saveItem()
                textFiledOfText = ""
            }
        }
    }
    
    // 删除功能
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else {return}
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            
            // 有点小复杂所以改写成上方方案
            // offsets.map { fruits[$0] }.forEach(viewContext.delete)
            
            // 保存操作，将上面的操作结果存到CoreData中
            saveItem()
        }
    }
    
    // 存入CoreData
    private func saveItem(){
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
