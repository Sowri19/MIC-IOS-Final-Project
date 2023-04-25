//
//  ComedianProfileView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI

struct ComedianProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content:{
            
        }) //: SCROLL
        Spacer()
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            // Button label
            Text("Go Back")
                .foregroundColor(.black)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow))
                .padding(.horizontal)
        } //: Button
        
    }
}
struct ComedianProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianProfileView()
    }
}
