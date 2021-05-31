//
//  ToDoListCell.swift
//  Todoey
//
//  Created by Artem Chouliak on 4/14/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import ChameleonFramework

class TodoItemCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with item: Item, color: String, percentage: CGFloat) {
        // configure cell based if user checked done
        if item.done {
            textLabel?.attributedText = textLabel?.crossedOutString(text: item.title)
            accessoryType = .checkmark
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = item.title
            accessoryType = .none
        }
        
        // configure color of cell
        if let color = UIColor(hexString: color)?.darken(byPercentage: percentage) {
            backgroundColor = color
            tintColor = ContrastColorOf(color, returnFlat: true)
            textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
    }
}
