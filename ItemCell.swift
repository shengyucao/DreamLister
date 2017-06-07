//
//  ItemCell.swift
//  DreamLister
//
//  Created by Shengyu Cao on 6/3/17.
//  Copyright © 2017 Shengyu Cao. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
        
        title.text = item.title
        price.text = "$\(item.price)"
        details.text = item.detail
        thumb.image = item.toImage?.image as? UIImage
        
    }
    
    
    
}
