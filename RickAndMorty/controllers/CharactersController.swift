//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Karim Yarboua on 07/03/2019.
//  Copyright © 2019 Karim Yarboua. All rights reserved.
//

import UIKit

enum TypeQuery {
    case all
    case query
}

class CharactersController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailView: DetailView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var nextPage = ""
    var characters: [Character] = []
    
    var charactersQuery: [Character] = []
    var nextPageQuey = ""
    
    var cellImageFrame = CGRect()
    var detailImageFrame = CGRect()
    var transitionImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getCharacter(string: APIHelper().urlCharacter, type: .all)
        detailView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(animateOut), name: Notification.Name("close"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nextPageQuey = ""
        charactersQuery = []
        getCharacter(string: APIHelper().urlWithParam(), type: .query)
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
    
    func getCharacter(string: String, type: TypeQuery) {
        APIHelper().getCharacter(string) { (next, characters, error) in
            if next != nil {
                switch type {
                case .all: self.nextPage = next!
                case .query: self.nextPageQuey = next!
                }
            }
            
            if error != nil {
                print(error!)
            }
            
            if characters != nil {
                switch type {
                case .all: self.characters.append(contentsOf: characters!)
                case .query: self.charactersQuery.append(contentsOf: characters!)
                }
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
        
        switch segmentView.selectedSegmentIndex {
        case 0:
            animateIn(character: characters[indexPath.item])
        case 1:
            animateIn(character: charactersQuery[indexPath.item])
        default:
            break
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        collectionView.reloadData()
    }
}

extension CharactersController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(segmentView.selectedSegmentIndex == 0) {
            return characters.count
        }
        else {
            return charactersQuery.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let character = segmentView.selectedSegmentIndex == 0 ? characters[indexPath.item] : charactersQuery[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCell {
            cell.setupCell(character)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 2 - 20
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = segmentView.selectedSegmentIndex == 0 ? characters.count : charactersQuery.count
        if indexPath.item == count - 1 {
            if segmentView.selectedSegmentIndex == 0 && nextPage != "" {
                getCharacter(string: nextPage, type: .all)
            }
            else if segmentView.selectedSegmentIndex == 1 && nextPageQuey != "" {
                getCharacter(string: nextPage, type: .query)
            }
        }
    }
}


