//
//  Card.swift
//  Memory game
//
//  Created by Polina Guryeva on 19/06/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import Foundation
import UIKit

class Card: UIButton {
    
    var wasFounded: Bool = false
    
    func pairWasFounded() {
        self.wasFounded = true
    }
    
    init(image: UIImage, backgroundImage: UIImage) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.setBackgroundImage(backgroundImage, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
