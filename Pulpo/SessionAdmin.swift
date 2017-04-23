//
//  SessionAdmin.swift
//  Pulpo
//
//  Created by David Vazquez on 4/20/17.
//  Copyright © 2017 davidfresh. All rights reserved.
//

import Foundation
class SessionAdmin {
// validate  register social
class func getLatitudTarget() -> Double    {
    let userDefaults = UserDefaults.standard
    guard let getKey = userDefaults.object(forKey: Constants.UserDefaults2.latitudTarget) as? Double else {
        return 0.0
    }
    return getKey
}

class func setLatititudTarget(attempts: Double )
{
    let userDefaults = UserDefaults.standard
    userDefaults.set(attempts, forKey:  Constants.UserDefaults2.latitudTarget)
}
    
    
    class func getLongitudTarget() -> Double    {
        let userDefaults = UserDefaults.standard
        guard let getKey = userDefaults.object(forKey: Constants.UserDefaults2.longitudTarget) as? Double else {
            return 0.0
        }
        return getKey
    }
    
    class func setLongitudTarget(attempts: Double )
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(attempts, forKey:  Constants.UserDefaults2.longitudTarget)
    }
    
    class func getIsTraking() -> Bool    {
        let userDefaults = UserDefaults.standard
        guard let getKey = userDefaults.object(forKey: Constants.UserDefaults2.isTracking) as? Bool else {
            return false
        }
        return getKey
    }
    
    class func setIsTraking(attempts: Bool )
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(attempts, forKey:  Constants.UserDefaults2.isTracking)
    }
    
    class func removeUserDesaults() {
        for key in Array(UserDefaults.standard.dictionaryRepresentation().keys) {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    class func setNotificationActive(attempts: Int )
    {
        let userDefaults = UserDefaults.standard
        userDefaults.set(attempts, forKey:  Constants.UserDefaults2.notificationActive)
    }
    
    class func getNotificationActive() -> Int    {
        let userDefaults = UserDefaults.standard
        guard let getKey = userDefaults.object(forKey: Constants.UserDefaults2.notificationActive) as? Int else {
            return 0
        }
        return getKey
    }

}
