//
//  NoteListViewController.swift
//  CoreNotes
//
//  Created by 1 on 14/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit

class NoteListViewController: UITableViewController {
    
    //MARK: Properties
    
    var notes = [Note]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateNotes()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["Time", "Title"]
        searchController.searchBar.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.noteListCell, for: indexPath) as! NoteListViewCell

        let note = notes[indexPath.row]
        
        cell.titleLabel.text = note.title
        cell.bodyLabel.text = note.body

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let note = notes[indexPath.row]
            CoreDataHelper.delete(note: note)
            updateNotes()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case Constants.Segues.createNote:
            print("segue add note")
        case Constants.Segues.editNote:
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let note = notes[indexPath.row]
            guard let destination = segue.destination as? EditNoteViewController else { return }
            destination.note = note
        default:
            print("unexpected segue identifier")
        }
    }
    
    @IBAction func unwindToLst(sender: UIStoryboardSegue) {
        updateNotes()
    }
    
    //MARK: functions
    func updateNotes(filter: Int = 0) {
        notes = CoreDataHelper.getNotes(searchText: searchController.searchBar.text, filter: filter)
    }
}

extension NoteListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateNotes()
    }
}

extension NoteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateNotes(filter: selectedScope)
    }
}
