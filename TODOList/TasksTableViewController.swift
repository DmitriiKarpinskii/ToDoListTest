//
//  NodesTableViewController.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//  added main view controller, detail view controller, segue to dvc and unwind segue, custom cell for table view, custom placeholder text view, editting style for main view controller 

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    var tasks : [Task]!
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBarButtonStye()
        showCountAvailableTask()
        tasks = getTasksFromStore()
        
    }
    
    private func showCountAvailableTask() {
        var count = 0
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title != nil")
        do {
            count = try context.count(for: fetchRequest)
            print("Count of task \(count)")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getTasksFromStore() -> [Task] {
        
        var result = [Task]()
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title != nil")
        
        do {
            result = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return result
    }
    
    private func deleteTaskFormeStore(index: Int) {
        
        let object = tasks[index] as NSManagedObject
        context.delete(object)
        tasks.remove(at: index)
        saveContex()
        showCountAvailableTask()
        
    }
    
    private func addTaskInStore(task: TaskStruct) {
        let taskObj = Task(context: context)
        taskObj.title = task.title
        taskObj.descriptionTask = task.description
        taskObj.isDone = task.isDone
        taskObj.date = Date()
        
        tasks.append(taskObj)
        saveContex()
        print("Добавлениа задача \(taskObj.title!)")
        showCountAvailableTask()

    }
    
    private func updateExistenTask(task: TaskStruct, withIndex index: Int) {
        
        let fetchTask: NSFetchRequest<Task> = Task.fetchRequest()
        let title = tasks[index].title!
        print("Ищем задачу \(task.title)")
        fetchTask.predicate = NSPredicate(format: "title = %@", title as String)
        let result = try! context.fetch(fetchTask)
        
        if result.count != 0 {
            let resultTask = result.first
            print("Найдена зачада \(resultTask?.title)")
            resultTask?.title = task.title
            resultTask?.descriptionTask = task.description
            resultTask?.isDone = task.isDone
            
            saveContex()
            print("Изменена задача \(task.title)")
        }
        showCountAvailableTask()
    }
    
    private func saveContex() {
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    private func setBarButtonStye() {
        if let barItemFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 24) {
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationItem.leftBarButtonItem = self.editButtonItem
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                NSAttributedString.Key.font: barItemFont
            ],
            for: .normal)
            
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.4792027417, green: 0.4844020563, blue: 0.5, alpha: 1),
                NSAttributedString.Key.font: barItemFont
            ],
            for: .disabled)
        }
    }
    
//
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        cell.titileTask.text = tasks[indexPath.row].title
        cell.isDoneTaskButton.isEnabled = tasks[indexPath.row].isDone
        if cell.isDoneTaskButton.isEnabled {
            cell.titileTask.textColor = #colorLiteral(red: 0.7235287119, green: 0.7235287119, blue: 0.7235287119, alpha: 1)
            cell.descriptionTask.textColor = #colorLiteral(red: 0.7235287119, green: 0.7235287119, blue: 0.7235287119, alpha: 1)
            cell.isDoneTaskButton.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.isDoneTaskButton.alpha = 1.0
        } else {
            cell.titileTask.textColor = .black
            cell.descriptionTask.textColor = .black
            cell.isDoneTaskButton.tintColor = .gray
            cell.isDoneTaskButton.alpha = 0
            
        }
        let description = tasks[indexPath.row].descriptionTask
        cell.descriptionTask.text = description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            myTasks.remove(at: indexPath.row)
            deleteTaskFormeStore(index: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingTask = tasks.remove(at: sourceIndexPath.row)
        tasks.insert(movingTask, at: destinationIndexPath.row)
        saveContex()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, boolValue) in
            self.deleteTaskFormeStore(index: indexPath.row)
            
        }
        let trailingSwipe = UISwipeActionsConfiguration(actions: [action])
        
        return trailingSwipe
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isDoneTask = self.tasks[indexPath.row].isDone
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, complition) in
            self.tasks[indexPath.row].isDone.toggle()
            //            tableView.reloadData()
            complition(true)
            tableView.reloadData()
        }
        
        action.backgroundColor = isDoneTask ? .systemGreen : .systemGray2
        
        action.image = UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate)
        let leadingSwipe =  UISwipeActionsConfiguration(actions: [action])
        return leadingSwipe
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskSegue" {
            let detailTaskVC = segue.destination as! DetailTaskViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedTask = tasks[indexPath.row]
            
            detailTaskVC.currentTask = selectedTask
            detailTaskVC.index = indexPath.row
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {

        if let vc = segue.source as? DetailTaskViewController {
            print("vc")
            showCountAvailableTask()
            
            let titleNewTask = vc.titleTask.text!
            let descriptionNewTask = vc.descriptionTask.text! != "Введите описание" ? vc.descriptionTask.text! : ""
            let isDoneNewTask = vc.isDoneButton.isOn
            
            let newTask = TaskStruct(title: titleNewTask, description: descriptionNewTask, isDone: isDoneNewTask)
            
            if vc.title == "Новая задача" {
                addTaskInStore(task: newTask)
                showCountAvailableTask()

            } else {
                guard let index = vc.index else { return}
                updateExistenTask(task: newTask, withIndex: index)
                showCountAvailableTask()
            }
        }
    }
}
