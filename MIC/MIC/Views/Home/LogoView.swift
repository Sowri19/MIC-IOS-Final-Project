//
//  LogoView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack(spacing: 4){
            Text("MIC".uppercased())
                .font(.title3)
                .fontWeight(.black)
                .foregroundColor(.black)
            Image("appstore")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
