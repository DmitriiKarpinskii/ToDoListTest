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
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var currentTask : Task?
    var index : Int?
    
    @IBOutlet weak var titleTask: UITextField!
    @IBOutlet weak var descriptionTask: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var isDoneButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTask.delegate = self
        descriptionTask.delegate = self
        setupStyleBatItemButtons()
        
        title  = "Новая задача"
        isDoneButton.setOn(false, animated: true)
        
        if let currentTask = currentTask {
            title = "Изменить задачу"
            titleTask.text = currentTask.title
            descriptionTask.text = currentTask.descriptionTask
            isDoneButton.setOn(currentTask.isDone, animated: true)
        }
        
        if currentTask?.descriptionTask == nil || currentTask?.descriptionTask == "" {
            descriptionTask.text = "Введите описание"
            descriptionTask.textColor = UIColor.lightGray
        }
        
        titleTask.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        saveButton.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        print("save pressed")
    }
    
    @IBAction func isDonePressed(_ sender: UISwitch) {
        let newValue = isDoneButton.isOn
        print(newValue)
        isDoneButton.setOn(newValue, animated: false)
        textFieldsChanged()
    }
    
    private func setupStyleBatItemButtons() {
        if let barItemFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 22) {
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                NSAttributedString.Key.font: barItemFont
            ],
            for: .normal)
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.4792027417, green: 0.4844020563, blue: 0.5, alpha: 1),
                NSAttributedString.Key.font: barItemFont
            ],
            for: .disabled)
        }
    }
}

extension DetailTaskViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldsChanged() {
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
    
    func textViewDidChange(_ textView: UITextView) {
        textFieldsChanged()
    }
}
