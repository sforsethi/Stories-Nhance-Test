//
//  StoriesCVCell.swift
//  Stories
//
//  Created by Admin on 01/03/23.
//

import UIKit

class StoriesCVCell: UICollectionViewCell {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var retailerLogoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        outerView.addBorderGradient(to: retailerLogoImage, lineWidth: 3) //, lineDashPattern: [0,0])
    }
}
