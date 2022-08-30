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
    
    func embedInScrollView() -> some View{
        GeometryReader{ geometry in
            ScrollView{
                self.frame(minHeight:geometry.size.height,maxHeight: .infinity)
            }
            
        }
    }
    
    func dismissKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
