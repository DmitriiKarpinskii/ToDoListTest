//
//  TasksStorage.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//

import Foundation

struct TasksStorage {
    
    var tasks : [Task] = {
        
        let result = [
            Task(title: "Купить продукты", description: "мясо,хлеб,яйцомясо,хлеб,яйцомясо,хлеб,яйцомясо,хлеб,яйцо", isDone: false),
            Task(title: "Позвонить Ире---", description: "в 13:00", isDone: false),
            Task(title: "Встреча в Пятницу", description: "взять блокнот и ручку", isDone: false),
            Task(title: "Купить зарядку", description: "номер заказа Z-D1399", isDone: true)
        ]
        
        return result
    }()
    
    func getTasks() -> [Task] {
        return tasks
    }
}
