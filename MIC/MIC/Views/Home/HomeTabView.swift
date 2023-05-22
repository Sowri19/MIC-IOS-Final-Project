//
//  HomeTabView.swift
//  MIC
//
//  Created by Sowri on 5/6/23.
//

import SwiftUI

struct HomeTabView: View {
    @State private var selection = 0
       
       var body: some View {
           VStack {
               Picker("", selection: $selection) {
                   Text("Comedians").tag(0)
                   Text("Comedy Genres").tag(1)
                   Text("Your Bookings").tag(2)
               }
               .pickerStyle(SegmentedPickerStyle())
               .padding()
               
               switch selection {
               case 0:
//                   TitleView(title: "Comedians")
                   ComedianView()
               case 1:
//                   TitleView(title: "Comedy Genres")
                   ComedyCategoryGridView()
               case 2:
                   Text("Content for Tab 3")
                   
               default:
                   Text("Invalid Tab")
               }
               
               Spacer()
           }
       }
}
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
