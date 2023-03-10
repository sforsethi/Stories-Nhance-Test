//
//  StoryPreviewCollecionCell.swift
//  NhanceStories
//
//  Created by ashish painuly on 06/03/23.
//

import UIKit

class StoryPreviewCollecionCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomGradientIV: UIImageView!
    @IBOutlet weak var topGradientIV: UIImageView!
    @IBOutlet weak var previewImgView: UIImageView!
    @IBOutlet weak var storyLikeButton: UIButton!
    @IBOutlet weak var storyShareButton: UIButton!
    @IBOutlet weak var moreOptionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
