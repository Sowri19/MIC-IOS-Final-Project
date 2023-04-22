//
//  SectionView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct SectionView: View {
    // MARK: - property
    @State var rotateClockwise: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Comedy Clubs".uppercased())
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: rotateClockwise ? 90 : -90))
            
            Spacer()
        } //: VSTACK
        .background(colorGray.cornerRadius(12))
        .frame(width: 85)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(rotateClockwise: true)
            .previewLayout(.fixed(width: 120, height: 240))
            .padding()
            .background(colorBackground)
    }
}
