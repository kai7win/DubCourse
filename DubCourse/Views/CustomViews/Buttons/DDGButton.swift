//
//  DDGButton.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

struct DDGButton: View {
    
    var title:String
    var color:Color = .brandPrimary
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width:280,height: 44)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct DDGButton_Previews: PreviewProvider {
    static var previews: some View {
        DDGButton(title: "Test Button")
    }
}
