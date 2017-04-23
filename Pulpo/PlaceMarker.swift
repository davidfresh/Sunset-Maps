//
//  PlaceMarker.swift
//  Pulpo
//
//  Created by David Vazquez on 4/20/17.
//  Copyright © 2017 davidfresh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlaceMarker: GMSMarker {
    let potition: CLLocation
    
    init(potition: CLLocation) {
        self.potition = potition
        super.init()
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}


