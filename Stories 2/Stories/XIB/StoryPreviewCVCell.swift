//
//  StoryPreviewCVCell.swift
//  Stories
//
//  Created by Admin on 03/03/23.
//

import UIKit

class StoryPreviewCVCell: UICollectionViewCell {
    
    var timer = Timer()
    var poseDuration = 30
    var indexProgressBar = 0
    var currentPoseIndex = 0
    
    @IBOutlet weak var progressBarView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        progressBarView.progress = 0.0
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func setProgressBar() {
        if indexProgressBar == poseDuration {
            indexProgressBar = 0
        }
        progressBarView.progress = Float(indexProgressBar) / Float(poseDuration - 1)
        indexProgressBar += 1
    }
}
