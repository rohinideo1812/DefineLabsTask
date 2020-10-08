//
//  TableViewCell.swift
//  Task
//
//  Created by Rohini Deo on 07/10/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //Mark:IBOutlets:
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.baseView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
