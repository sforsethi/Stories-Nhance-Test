//
//  StoryOptionsBottomVC.swift
//  Stories
//
//  Created by Admin on 09/03/23.
//

import UIKit
import PanModal

class StoryOptionsBottomVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension StoryOptionsBottomVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(180)
    }
    
    var longFormHeight: PanModalHeight  {
        return .contentHeight(250)
    }
}
