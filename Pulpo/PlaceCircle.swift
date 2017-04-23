//
//  PlaceCircle.swift
//  Pulpo
//
//  Created by David Vazquez on 4/23/17.
//  Copyright © 2017 davidfresh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlaceCirle: GMSCircle{  
  init(potition: CLLocationCoordinate2D, radio: Double, color: UIColor) {
    super.init()
    position = potition
    radius = radio
    fillColor = color
  }
  override init() {
    super.init()
  }
}
