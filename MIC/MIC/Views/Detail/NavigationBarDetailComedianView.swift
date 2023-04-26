//
//  NavigationBarDetailView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI

struct NavigationBarComedianDetailView: View {
    // MARK: - PROPERTY
    
    // MARK: - BODY
    


    var body: some View {
        HStack{
            Button(action: {}, label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.white)
            })
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "cart")
                    .font(.title)
                    .foregroundColor(.white)
            })
        } //: HSTACK
    }
}

struct NavigationBarComedianDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBarComedianDetailView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray)
    }
}
