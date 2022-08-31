//
//  ProfileModalView.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/28.
//

import SwiftUI

struct ProfileModalView: View {
    
    @Binding var isShowingProfileModal:Bool
    var profile:DDGProfile
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 60)
                
                Text(profile.firstName + " " + profile.lastName)
                    .bold()
                    .font(.title2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal)
                
                Text(profile.companyName)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(Text("Works at \(profile.companyName)"))
                    .padding(.horizontal)
                
                Text(profile.bio)
                    .lineLimit(3)
                    .padding()
                    .accessibilityLabel(Text("Bio, \(profile.bio)"))
            }
            .frame(width: 300, height: 230)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .overlay(alignment: .topTrailing){
                Button{
                    withAnimation { isShowingProfileModal = false }
                } label: {
                    XDismissButton()
                }
            }
            Image(uiImage: profile.avatarImage)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 100)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                .offset(y: -120)
                .accessibilityHidden(true)
        }
        .transition(.opacity.combined(with: .slide))
        .zIndex(2)
    }
}

struct ProfileModelView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(isShowingProfileModal: .constant(true), profile: DDGProfile(record: MockData.profile))
    }
}
