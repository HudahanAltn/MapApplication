//
//  TableViewCellList.swift
//  MapApplication
//
//  Created by Hüdahan Altun on 17.12.2022.
//

import UIKit

class TableViewCellList: UITableViewCell {

    @IBOutlet weak var listLabel: UILabel! //name
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
