//
//  NoteListViewCell.swift
//  CoreNotes
//
//  Created by 1 on 14/05/2018.
//  Copyright © 2018 av. All rights reserved.
//

import UIKit

class NoteListViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
