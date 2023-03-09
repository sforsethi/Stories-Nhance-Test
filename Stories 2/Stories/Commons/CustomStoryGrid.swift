//
//  CustomStoryGrid.swift
//  Stories
//
//  Created by Raghav Sethi on 09/03/23.
//

import UIKit

class CustomStoryGrid: UIView {

    func getGridFrame(for index: Int) -> CGRect?   {
        switch index    {
        case 0:
            return CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width/2, height: self.frame.height/3)
        case 1:
            return CGRect(x: self.frame.origin.x+self.frame.width/2, y: self.frame.origin.y, width: self.frame.width/2, height: self.frame.height/3)
        case 2:
            return CGRect(x: self.frame.origin.x, y: self.frame.origin.y+self.frame.height/3, width: self.frame.width/2, height: self.frame.height/3)
        case 3:
            return CGRect(x: self.frame.origin.x+self.frame.width/2, y: self.frame.origin.y+self.frame.height/3, width: self.frame.width/2, height: self.frame.height/3)
        case 4:
            return CGRect(x: self.frame.origin.x, y: self.frame.origin.y+(2*self.frame.height/3), width: self.frame.width/2, height: self.frame.height/3)
        case 5:
            return CGRect(x: self.frame.origin.x+self.frame.width/2, y: self.frame.origin.y+(2*self.frame.height/3), width: self.frame.width/2, height: self.frame.height/3)
//        case 6:
//            return CGRect(x: self.frame.origin.x+(3*self.frame.height/3), y: self.frame.origin.y, width: self.frame.width/2, height: self.frame.height/3)
        default:
            print("Cannot find index to generate frame")
            return nil
        }
    }
    
}


