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

        guard let fileUrl = self.fileURL else { return dimension.placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.placeholder
        }catch{
            print("Debug: get image fail \(error)")
            return dimension.placeholder
        }
        
    }
    
}
