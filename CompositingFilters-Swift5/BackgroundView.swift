//
//  GradientView.swift
//  CompositingFilters
//
//  Created by Arthur Schiller on 19.11.16.
//  Copyright © 2016 arthurschiller. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
