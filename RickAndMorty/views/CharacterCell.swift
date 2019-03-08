//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 08/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet weak var nameCharacter: UILabel!
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var viewHolder: UIView!
    
    var character: Character!
    
    func setupCell(_ character: Character) {
        self.character = character
        self.nameCharacter.text = self.character.name
        self.imageCharacter.download(self.character.image)
        viewHolder.layer.cornerRadius = 25
        viewHolder.clipsToBounds = true
    }
}
