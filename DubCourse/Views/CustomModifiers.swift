//
//  CustomModifiers.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

struct ProfileNameText:ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32,weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .disableAutocorrection(true)
    }
}

