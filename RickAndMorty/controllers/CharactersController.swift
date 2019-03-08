//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 07/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

class CharactersController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailView: DetailView!
    
    var nextPage = ""
    var characters: [Character] = []
    
    var cellImageFrame = CGRect()
    var detailImageFrame = CGRect()
    var transitionImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getCharacter(string: APIHelper().urlCharacter)
        detailView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: Notification.Name("close"), object: nil)
    }
    
    func animateIn(character: Character) {
        
        detailImageFrame = detailView.characterImage.convert(detailView.characterImage.bounds, to: view)
        detailView.setup(character)
        
        transitionImage = UIImageView(frame: cellImageFrame)
        transitionImage.download(character.image)
        transitionImage.layer.cornerRadius = 25
        transitionImage.contentMode = .scaleAspectFill
        transitionImage.clipsToBounds = true
        view.addSubview(transitionImage)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transitionImage.frame = self.detailImageFrame
            self.transitionImage.layer.cornerRadius = self.detailImageFrame.height / 2
            self.collectionView.alpha = 0
        }) { (success) in
            self.detailView.alpha = 1
        }
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transitionImage.frame = self.cellImageFrame
            self.transitionImage.layer.cornerRadius = 25
            self.collectionView.alpha = 1
            self.detailView.alpha = 0
        }) { (success) in
            self.transitionImage.removeFromSuperview()
        }
    }
    
    func getCharacter(string: String) {
        APIHelper().getCharacter(string) { (next, characters, error) in
            if next != nil {
                print(next!)
                self.nextPage = next!
            }
            
            if error != nil {
                print(error!)
            }
            
            if characters != nil {
                self.characters.append(contentsOf: characters!)
                print(self.characters.count)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let layout = collectionView.layoutAttributesForItem(at: indexPath) else { return }
        let frame = collectionView.convert(layout.frame, to: collectionView.superview)
        cellImageFrame = CGRect(x: frame.minX, y: frame.minY + 50, width: frame.width, height: frame.height - 50)
        
        let character = characters[indexPath.item]
        animateIn(character: character)
    }
}

