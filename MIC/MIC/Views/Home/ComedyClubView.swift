//
//  ComedyClubView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct ComedyClubView: View {
    // MARK: - Property
    
    // MARK: - Body

    var body: some View {
        Button(action: {}, label: {
            HStack(alignment: .center, spacing: 6){
                Image("appstore")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(.gray)
                Spacer()
                
            } //: HStack
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
        }) //: Button
    }
}

struct ComedyClubView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyClubView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(colorBackground)
    }
}
