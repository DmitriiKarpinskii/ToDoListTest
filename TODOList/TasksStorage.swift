//
//  TasksStorage.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//

import Foundation

struct TasksStorage {
    
    var tasks : [TaskStruct] = {
        
        let result = [
            TaskStruct(title: "Купить продукты", description: "мясо,хлеб,яйцомясо,хлеб", isDone: false),
            TaskStruct(title: "Позвонить Ире", description: "в 13:00", isDone: false),
            TaskStruct(title: "Встреча в Пятницу", description: "взять блокнот и ручку", isDone: false),
            TaskStruct(title: "Отвезти ба в аэропорт", description: nil, isDone: true),
            TaskStruct(title: "Купить билет", description: "кино в восркресенье", isDone: false),
            TaskStruct(title: "На английский", description: nil, isDone: false)
        ]
        
        return result
    }()
    
    func getTasks() -> [TaskStruct] {
        return tasks
    }
}
