//
//  Constants.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import UIKit

enum RecordType{
    static let location = "DDGLocation"
    static let profile = "DDGProfile"
}

enum PlaceholderImage{
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimension{
    case square,banner
    
    static func getPlaceholder(for dimension:ImageDimension) -> UIImage{
        switch dimension {
        case .square:
            return PlaceholderImage.square
        case .banner:
            return PlaceholderImage.banner
        }
    }
}
