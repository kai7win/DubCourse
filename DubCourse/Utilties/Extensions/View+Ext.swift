//
//  View+Ext.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

extension View{
    func profileNameStyle() -> some View{
        self.modifier(ProfileNameText())
    }
    
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
