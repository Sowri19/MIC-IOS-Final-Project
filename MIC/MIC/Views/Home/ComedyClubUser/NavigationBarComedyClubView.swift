//
//  NavigationBarComedyClubView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI

struct NavigationBarComedyClubView: View {
    // MARK: - PROPERTIES
    @State private var isAnimated: Bool = false
    // MARK: - BODY

    var body: some View {
        HStack{
            Button(action: {}, label:{
                Image(systemName: "magnifyingglass")
                    .font(.title)
                    .foregroundColor(.black)
            }) //: Button
            Spacer()
            LogoView()
                .opacity(isAnimated ? 1 : 0)
                .offset(x: 0, y: isAnimated ? 0 : -25)
                .onAppear(perform: {
                    withAnimation(.easeOut(duration: 0.5)){
                        isAnimated.toggle()
                    }
                })
            Spacer()
            Button(action: {
                
            }, label:{
                ZStack {
                    Image(systemName: "person.circle")
                        .font(.title)
                    .foregroundColor(.black)
                }
            }) //: Button
        } //: HSTACK
    }
}

struct NavigationBarComedyClubView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarComedyClubView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
