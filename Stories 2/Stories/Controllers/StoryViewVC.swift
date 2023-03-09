//
//  StoryViewVC.swift
//  Stories
//
//  Created by Admin on 01/03/23.
//

import UIKit

class StoryViewVC: UIViewController {
    
    var retailerLogos: String?
    var retailerNames: String?
    var storyItems: String?
    
    @IBOutlet weak var retailerLogoImage: UIImageView!
    @IBOutlet weak var retailerNameLabel: UILabel!
    @IBOutlet weak var storyPostedTimeLabel: UILabel!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "StoryPreviewCVCell", bundle: nil), forCellWithReuseIdentifier: "StoryPreviewCVCell")
        
        retailerLogoImage.image = UIImage(named: retailerLogos ?? "")
        retailerNameLabel.text = retailerNames
        storyImage.image = UIImage(named: storyItems ?? "")
        
        dismissButton.addTarget(self, action: #selector(toDismissStories), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSnap(_:)))
        tap.numberOfTapsRequired = 1
        retailerLogoImage.addGestureRecognizer(tap)
    }
    
    @objc func toDismissStories() {
        dismiss(animated: true)
    }
    
    @objc func didTapSnap(_ sender: UITapGestureRecognizer) {
        let touchLocation = sender.location(ofTouch: 0, in: self.retailerLogoImage)
    }
}

extension StoryViewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryPreviewCVCell", for: indexPath) as! StoryPreviewCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}


