//
//  TaskTableViewCell.swift
//  TODOList
//
//  Created by Dmitry Karpinsky on 05.05.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titileTask: UILabel!
    @IBOutlet weak var descriptionTask: UILabel!
    @IBOutlet weak var isDoneTaskButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
