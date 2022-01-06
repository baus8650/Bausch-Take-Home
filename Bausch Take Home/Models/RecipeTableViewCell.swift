//
//  RecipeTableViewCell.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet var ingredientLabel: UILabel!
    @IBOutlet var measurementLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
