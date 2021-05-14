//
//  NodesTableViewController.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//  added main view controller, detail view controller, segue to dvc and unwind segue, custom cell for table view, custom placeholder text view, editting style for main view controller 

import UIKit
import CoreData

class TasksTableViewController: UITableViewController {
    
    var myTasks = [TaskStruct]()//TasksStorage().getTasks()
    var tasks : [Task]!
    var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasks = getTasks()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
            
        if let barItemFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 24) {
            
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
    
    private func getAvailableTask() -> Int {
        
        var count = 0
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title != nil")
        do {
            count = try context.count(for: fetchRequest)
            print("count of task \(count)")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return count
    }
    
    private func getTasks() -> [Task] {
        
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
    
    
    private func deleteTask() {
        
        let index = tableView.indexPathForSelectedRow
        tasks.remove(at: index!.row)
        
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    private func updateTask(task: Task) {
        
        
    }
    
    private func saveTask() {
        
    }
    
    
    
    
    private func addTaskToMyTasks(taskStruct : TaskStruct) {
        myTasks.append(taskStruct)
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let task = NSManagedObject(entity: entity!, insertInto: context) as! Task
        
        task.title = taskStruct.title
        task.descriptionTask = taskStruct.description
        task.isDone = taskStruct.isDone
        task.date = Date()
        
        do  {
            try context.save()
            print("task added to db")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myTasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        
        cell.titileTask.text = myTasks[indexPath.row].title
        cell.isDoneTaskButton.isEnabled = myTasks[indexPath.row].isDone
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
        if let description = myTasks[indexPath.row].description {
            cell.descriptionTask.text = description
        } else {
            cell.descriptionTask.text = ""
        }
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
            myTasks.remove(at: indexPath.row)
            //            tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movingTask = myTasks.remove(at: sourceIndexPath.row)
        myTasks.insert(movingTask, at: destinationIndexPath.row)
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, boolValue) in
//            self.myTasks.remove(at: indexPath.row)
            
            //            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteTask()
        }
        let trailingSwipe = UISwipeActionsConfiguration(actions: [action])
        
        return trailingSwipe
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isDoneTask = self.myTasks[indexPath.row].isDone
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, complition) in
            self.myTasks[indexPath.row].isDone.toggle()
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
        if segue.identifier == "showTaskSegue"  {
            let detailTaskVC = segue.destination as! DetailTaskViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let selectedTask = myTasks[indexPath.row]
            detailTaskVC.currentTask = selectedTask
            detailTaskVC.index = indexPath.row
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        if let vc = segue.source as? DetailTaskViewController {
            let titleNewTask = vc.titleTask.text!
            let descriptionNewTask = vc.descriptionTask.text! != "Введите описание" ? vc.descriptionTask.text! : ""
            
            let isDoneNewTask = vc.isDoneButton.isOn
            let newTask = TaskStruct(title: titleNewTask, description: descriptionNewTask, isDone: isDoneNewTask)
            
            if vc.title == "Новая задача" {
                addTaskToMyTasks(taskStruct: newTask)
            } else {
                myTasks[vc.index] = newTask
            }
            
            tableView.reloadData()
            
        }
        
    }
}
