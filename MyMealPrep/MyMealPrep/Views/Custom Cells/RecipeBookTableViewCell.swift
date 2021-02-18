//
//  RecipeBookTableViewCell.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/16/21.
//

import UIKit

class RecipeBookTableViewCell: UITableViewCell {
    
    static let identifier = "DropDownTableViewCell"

    private let recipeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let recipeImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()

    public func configure(with recipe: Recipe) {
        contentView.addSubview(recipeLabel)
        contentView.addSubview(recipeImageView)
        recipeLabel.text = recipe.label
        recipeLabel.textAlignment = .center
        guard let recipeImageName = recipe.image else {return}
        recipeImageView.image = UIImage(named: recipeImageName)
        recipeImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recipeImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        recipeLabel.frame = CGRect(x: 105, y: 5, width: contentView.frame.size.width - 105, height: 100)
    }
}
