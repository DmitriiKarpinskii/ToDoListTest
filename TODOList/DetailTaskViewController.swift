//
//  DetailTaskViewController.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//

import UIKit

class DetailTaskViewController: UIViewController {
    
    deinit {
        print("deinit dvc")
    }

    var currentTask : Task = Task(title: "", description: nil, isDone: false)
    var index : Int!
    
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var descriptionTask: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var isDoneButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
        titleTask.delegate = self
        descriptionTask.delegate = self
        
        if let barItemFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 22) {
            
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                NSAttributedString.Key.font: barItemFont
                ],
            for: .normal)
          
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.5697843442, green: 0.6008883249, blue: 0.5683646403, alpha: 1),
                NSAttributedString.Key.font: barItemFont
                ],
            for: .disabled)
        }

        title =  currentTask.title == "" ? "Новая задача" : "Изменить задачу"
        titleTask.text = currentTask.title
        descriptionTask.text = currentTask.description
        isDoneButton.setOn(currentTask.isDone, animated: true)
//        saveButton.isEnabled = !titleTask.text!.isEmpty
        saveButton.isEnabled = false
        titleTask.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        // Do any additional setup after loading the view.
        
        if let description = currentTask.description {
            descriptionTask.text = description
        } else {
            descriptionTask.text = "Введите описание"
            descriptionTask.textColor = UIColor.lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        print(sender.self)
        currentTask.title = titleTask.text!
        currentTask.description = descriptionTask.text!
        print(descriptionTask.text!)// null pointer exception
    }
    
    @IBAction func isDonePressed(_ sender: UISwitch) {
        let newValue = isDoneButton.isOn
        print(newValue)
        isDoneButton.setOn(newValue, animated: false)
        currentTask.isDone = isDoneButton.isOn
    }
}

extension DetailTaskViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func textFieldChanged() {
        if titleTask.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension DetailTaskViewController : UITextViewDelegate {
  
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            print("call textFieldDidBeginEditing")
            textView.text = ""
            textView.textColor = UIColor.black
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("call textFieldDidEndEditing")
        if textView.text!.isEmpty {
            textView.text = "Введите описание"
            textView.textColor = UIColor.lightGray
          }

    }
    
}
