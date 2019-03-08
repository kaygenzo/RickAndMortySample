//
//  DetailView.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 08/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func setup(_ character: Character) {
        characterImage.download(character.image)
        characterImage.layer.cornerRadius = characterImage.frame.height / 2
        characterImage.clipsToBounds = true
        nameLabel.text = character.name
        locationLabel.text = "Location: \(character.location.name)"
        originLabel.text = "Origin: \(character.origin.name)"
        specieLabel.text = character.species
        genderLabel.text = dataEmojiConverter(gender: character.gender)
        statusLabel.text = "Status: \(dataEmojiConverter(gender: character.status))"
    }
    
    func dataEmojiConverter(gender: String) -> String {
        switch gender {
        case "Dead": return "🧟‍♂️"
        case "Alive": return "😇"
        case "Male": return "💁‍♂️"
        case "Female": return "💁‍♀️"
        default:
            return "🤷🏽‍♂️"
        }
    }
    
    
    func loadXib() {
        backgroundColor = .clear
        let bundle = Bundle(for: type(of: self))
        if let xib = type(of: self).description().components(separatedBy: ".").last {
            let nib = UINib(nibName: xib, bundle: bundle)
            if let v = nib.instantiate(withOwner: self, options: nil).first as? UIView {
                view = v
                view?.frame = bounds
                if view != nil {
                    addSubview(view!)
                    view!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    view!.backgroundColor = .white
                    view!.layer.cornerRadius = 25
                }
            }
        }
    }

    @IBAction func closeDetails(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("close"), object: nil)
    }
}
