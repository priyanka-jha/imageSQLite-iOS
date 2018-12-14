//
//  ImageTableCell.swift
//  imageSQLite-iOS
//
//  Created by Priyanka Jha on 12/12/18.
//  Copyright © 2018 Priyanka Jha. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var imageName: UILabel!
    
    @IBOutlet weak var listImage: UIImageView!
    
    @IBOutlet weak var imageValue: UILabel!
    
    @IBOutlet weak var imageDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
