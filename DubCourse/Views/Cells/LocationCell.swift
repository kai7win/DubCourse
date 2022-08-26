//
//  LocationCell.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

struct LocationCell:View {
    
    var location:DDGLocation
    
    var body: some View{
        HStack {
            Image(uiImage: location.createSquareImage())
                .resizable()
                .scaledToFit()
                .frame(width: 80,height: 80)
                .clipShape(Circle())
                .padding(.vertical,8)
            VStack(alignment: .leading) {
                HStack {
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    Spacer()
                }
                    
                HStack{
                    ForEach(0 ..< 5) { item in
                        AvatarView(image: PlaceholderImage.avatar, size: 35)
                    }
                }
            }
            .padding(.leading)
        }
        
    }
}


struct LocationCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationCell(location: DDGLocation(record: MockData.location))
    }
}
