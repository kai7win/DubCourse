//
//  CKAsset+Ext.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/24.
//

import CloudKit
import UIKit

extension CKAsset{
    
    func convertToUIImage(in dimension:ImageDimension) -> UIImage{
        let placeholder = ImageDimension.getPlaceholder(for: dimension)
        guard let fileUrl = self.fileURL else { return placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? placeholder
        }catch{
            print("Debug: get image fail \(error)")
            return placeholder
        }
        
    }
    
}
