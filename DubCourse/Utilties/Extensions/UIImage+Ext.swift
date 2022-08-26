//
//  UIImage+Ext.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/26.
//

import CloudKit
import UIKit

extension UIImage{
    
    func convertToCKAsset() -> CKAsset?{
        
        //get our apps base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        //Append some unique identifier for our profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        
        //Write the image data to the location the address points to
        guard let imageData = self.jpegData(compressionQuality: 0.25) else { return nil }
        
        //Create our CKAsset with that fileURL
        do {
            try imageData.write(to: fileUrl)
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
    }
    
}
