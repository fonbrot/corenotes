//
//  EditNoteViewController.swift
//  CoreNotes
//
//  Created by 1 on 14/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController {
    
    //MARK: Properties
    
    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        setSaveButton()
    }
    
    //MARK: VC Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            titleTextField.text = note.title
            bodyTextView.text = note.body
        }
        setSaveButton()
    }
    
    //MARK: functions
    
    private func saveNote() {
        if note == nil {
            note = CoreDataHelper.newNote()
        }
        note?.title = titleTextField.text
        note?.body = bodyTextView.text
        note?.created = Date()
        
        CoreDataHelper.saveNote()
    }
    
    func setSaveButton() {
        let text = titleTextField.text ?? ""
        if text.isEmpty {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == Constants.Segues.save {
            saveNote()
        }
    }
}

extension EditNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
