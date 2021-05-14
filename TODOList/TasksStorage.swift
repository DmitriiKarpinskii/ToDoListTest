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
            Task(title: "Купить продукты", descriptionn: "мясо,хлеб,яйцомясо,хлеб", isDone: false),
            Task(title: "Позвонить Ире", descriptionn: "в 13:00", isDone: false),
            Task(title: "Встреча в Пятницу", descriptionn: "взять блокнот и ручку", isDone: false),
            Task(title: "Отвезти ба в аэропорт", descriptionn: nil, isDone: true),
            Task(title: "Купить билет", descriptionn: "кино в восркресенье", isDone: false),
            Task(title: "На английский", descriptionn: nil, isDone: false)
        ]
        
        return result
    }()
    
    func getTasks() -> [Task] {
        return tasks
    }
}
