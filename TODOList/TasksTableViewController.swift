//
//  NodesTableViewController.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//  added main view controller, detail view controller, segue to dvc and unwind segue, custom cell for table view, custom placeholder text view, editting style for main view controller 

import UIKit

class TasksTableViewController: UITableViewController {
    
    var myTasks = TasksStorage().getTasks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    private func addTaskToMyTasks(task : Task) {
        myTasks.append(task)
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
            let descriptionNewTask = vc.descriptionTask.text!
            let isDoneNewTask = vc.isDoneButton.isOn
            let newTask = Task(title: titleNewTask, description: descriptionNewTask, isDone: isDoneNewTask)
            
            if vc.title == "Новая задача" {
                addTaskToMyTasks(task: newTask)
            } else {
                myTasks[vc.index] = newTask
            }
            
            tableView.reloadData()
            
        }
        
    }
}
