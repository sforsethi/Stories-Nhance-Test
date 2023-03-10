//
//  StoriesVC.swift
//  Stories
//
//  Created by Admin on 01/03/23.
//

import UIKit

class StoriesVC: UIViewController {
    
    let firstColor = UIColor(red: 199/255, green: 255/255, blue: 211/255, alpha: 1)
    let secondColor = UIColor(red: 0, green: 123/255, blue: 161/255, alpha: 1)
    let thirdColor = UIColor(red: 59/255, green: 88/255, blue: 161/255, alpha: 1)
    let grayColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1)
    
    var retailerLogos = ["logo-1", "logo-2", "logo-3", "logo-4", "logo-5"]
    var retailerNames = ["HM", "Nike", "PVR", "Starbucks", "ZARA"]
    var storyItems = ["hm", "nike", "pvr", "starbucks", "zara"]
    
    var storiesCount = [1, 3, 10, 15, 20]
    var numSize = 0
    
    @IBOutlet weak var storiesCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        storiesCV.delegate = self
        storiesCV.dataSource = self
        storiesCV.register(UINib(nibName: "StoriesCVCell", bundle: nil), forCellWithReuseIdentifier: "StoriesCVCell")
    }
}

extension StoriesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storiesCount.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCVCell", for: indexPath) as! StoriesCVCell
        cell.retailerLogoImage.image = UIImage(named: retailerLogos[indexPath.row])
        
        numSize = storiesCount[indexPath.row]
        cell.outerView.layer.cornerRadius = cell.outerView.frame.height / 2
        cell.outerView.clipsToBounds = true
        
        cell.storiesView.layer.cornerRadius = cell.storiesView.frame.height / 2
        cell.storiesView.clipsToBounds = true
    
        let shape = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: cell.storiesView.bounds.width, height: cell.storiesView.bounds.height))
        var segments: [CAShapeLayer] = []
        let segmentAngle: CGFloat = 1.0 / CGFloat(numSize)
        
        for i in 0..<numSize {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = shape.cgPath
            shapeLayer.strokeStart = segmentAngle * CGFloat(i)
//            shapeLayer.strokeStart = segmentAngle * CGFloat(numSize - (i + 1))
            
            if numSize == 1 {
                let gapSize: CGFloat = 0
                shapeLayer.strokeEnd = shapeLayer.strokeStart + segmentAngle - gapSize
                shapeLayer.lineWidth = 4
            }
            else {
                let gapSize: CGFloat = 0.008
                shapeLayer.strokeEnd = shapeLayer.strokeStart + segmentAngle - gapSize
                shapeLayer.lineWidth = 4
            }
            
            if i == 0 {
                shapeLayer.strokeColor = grayColor.withAlphaComponent(0.1).cgColor
//                shapeLayer.strokeColor = UIColor.clear.cgColor
            }
            else {
                shapeLayer.strokeColor = thirdColor.cgColor
            }
            
            shapeLayer.fillColor = UIColor.clear.cgColor
            segments.insert(shapeLayer, at: i)
            cell.storiesView.layer.addSublayer(segments[i])
            
            //MARK: Gradient Segment Color
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(origin: CGPoint.zero, size: cell.storiesView.frame.size)
            gradient.colors = [firstColor.cgColor, secondColor.cgColor, thirdColor.cgColor]
            gradient.mask = shapeLayer
            cell.storiesView.layer.addSublayer(gradient)
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 1)
        }
        
        UIView.performWithoutAnimation {
//            cell.storiesView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cell.storiesView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 3/2))
            cell.retailerLogoImage.transform = cell.storiesView.transform.inverted()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoryPreviewVC") as! StoryPreviewVC
        vc.totalStoryIndex = storiesCount[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
