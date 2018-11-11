//
//  TbleCell.swift
//  MemeApp
//
//  Created by vasu on 05/11/18.
//  Copyright © 2018 Vasu. All rights reserved.
//

import UIKit

class TbleCell: UITableViewCell {

    @IBOutlet weak var mImage: UIImageView!
    @IBOutlet weak var mTitle :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(image :UIImage , memeText :String)  {
        mImage.image = image
        mTitle.text  = memeText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
