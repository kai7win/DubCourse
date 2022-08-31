//
//  LocationDetailView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var viewModel: LocationDetailViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        
        ZStack{
            VStack(spacing:16) {
                BannerImageView(image:viewModel.location.bannerImage)
                AddressHStack(address: viewModel.location.address)
                DescriptionView(text: viewModel.location.description)
                ActionButtonHStack(viewModel: viewModel)
                GridHeaderTextView(number:viewModel.checkedInProfiles.count)
                AvatarGridView(viewModel: viewModel)
                Spacer()
            }//VStack END
            .accessibilityHidden(viewModel.isShowingProfileModal)
            
            if viewModel.isShowingProfileModal{
                FullScreenBlackTransparencyView()
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal, profile: viewModel.selectedProfile!)
            }
            
        }
        
        .task{
            viewModel.getCheckedInProfiles()
            viewModel.getCheckedInStatus()
        }
        .sheet(isPresented: $viewModel.isShowingProfileSheet){
            NavigationView {
                ProfileSheetView(profile: viewModel.selectedProfile!)
                    .toolbar {
                        Button("Dismiss") {
                            viewModel.isShowingProfileSheet = false
                        }
                    }
            }
        }
        .alert(item:$viewModel.alertItem){ $0.alert }
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LocationDetailView(viewModel: LocationDetailViewModel(location: DDGLocation(record: MockData.chipotle)))
            
        }
        
    }
}

fileprivate struct LocationActionButton: View {
    
    var color:Color
    var imageName:String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60,height: 60)
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22,height: 22)
        }
    }
}


fileprivate struct FirstNameAvatarView:View{
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var profile:DDGProfile
    
    var body: some View {
        VStack{
            AvatarView(image: profile.avatarImage,
                       size: dynamicTypeSize >= .accessibility3 ? 150 : 64)
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Show's \(profile.firstName) profile pop up."))
        .accessibilityLabel(Text("\(profile.firstName)  \(profile.lastName)"))
    }
}

fileprivate struct BannerImageView: View {
    
    var image:UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .clipped()
            .accessibilityHidden(true)
    }
}

fileprivate struct AddressHStack: View {
    var address:String
    var body: some View {
        
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
            .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}

fileprivate struct DescriptionView: View {
    
    var text:String
    
    var body: some View {
        Text(text)
            .minimumScaleFactor(0.75)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}

fileprivate struct GridHeaderTextView: View {
    
    var number:Int
    
    var body: some View {
        Text("Who's Here")
            .bold()
            .font(.title2)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("Who's Here \(number) checked in")
            .accessibilityHint(Text("Bottom section is scrollable"))
    }
}

fileprivate struct GridEmptyStateTextView: View {
    var body: some View {
        Text("Nobody's Here ~")
            .bold()
            .font(.title2)
            .foregroundColor(.secondary)
            .padding(.top,30)
    }
}

fileprivate struct FullScreenBlackTransparencyView: View {
    var body: some View {
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.9)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .zIndex(1)
            .accessibilityHidden(true)
    }
}

struct ActionButtonHStack: View {
    
    @ObservedObject var viewModel:LocationDetailViewModel
    
    var body: some View {
        
        HStack (spacing:20){
            Button {
                viewModel.getDirectionToLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, imageName: "location.fill")
            }
            .accessibilityLabel(Text("Get direction"))
            
            Link(destination: URL(string:viewModel.location.websiteURL)!) {
                LocationActionButton(color: .brandPrimary, imageName: "network")
            }
            .accessibilityRemoveTraits(.isButton)
            .accessibilityLabel(Text("Go to Website"))
            
            Button {
                viewModel.callLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, imageName: "phone.fill")
            }
            .accessibilityLabel(Text("Call location"))
            
            if let _ = CloudKitManager.shared.profileRecordID{
                Button {
                    viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                } label: {
                    LocationActionButton( color:viewModel.buttonColor, imageName:viewModel.buttonImageTitle
                    )
                    
                }
                .accessibilityLabel(Text(viewModel.buttonA11yText))
                .disabled(viewModel.isLoading)
            }
            
            
            
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

fileprivate struct AvatarGridView: View {
    
    @ObservedObject var viewModel:LocationDetailViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack{
            if viewModel.checkedInProfiles.isEmpty{
                GridEmptyStateTextView()
            }else{
                ScrollView {
                    LazyVGrid(columns:viewModel.determineColumns(for: dynamicTypeSize)) {
                        
                        ForEach(viewModel.checkedInProfiles) { profile in
                            FirstNameAvatarView(profile: profile)
                                .onTapGesture {
                                    withAnimation { viewModel.show(profile, in: dynamicTypeSize) }
                                }
                        }
                    }
                }
            }
            if viewModel.isLoading{LoadingView()}
            
        }
    }
}
