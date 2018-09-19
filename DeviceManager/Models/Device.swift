//
//  Device.swift
//  DeviceManager
//
//  Created by Spencer Curtis on 9/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

public enum Model: String, Codable {
    case iPhoneX = "iPhone X"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhone8 = "iPhone 8"
    case iPhone7Plus = "iPhone 7 Plus"
    case iPhone7 = "iPhone 7"
    case iPhone6SPlus = "iPhone 6S Plus"
    case iPhone6S = "iPhone 6S"
    case iPhoneSE = "iPhone SE"
    
    public static func members() -> [Model] {
        return [
            iPhoneX,
            iPhone8Plus,
            iPhone8,
            iPhone7Plus,
            iPhone7,
            iPhone6SPlus,
            iPhone6S,
            iPhoneSE,
        ]
    }
    
    public static func randomModel() -> Model {
        let members = self.members()
        let which = Int(arc4random_uniform(UInt32(members.count)))
        return members[which]
    }
}


struct Device: Codable {
    
    let uuid: String
    let model: Model
    
    init(uuid: String = UUID().uuidString, model: Model) {
        self.uuid = uuid
        self.model = model
    }
}
















