//
//  ComedyClubDetailView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//

import SwiftUI

struct ComedyClubDetailView: View {
    // MARK: - PREVIEW
    
    @AppStorage("uid") var userID: String = ""
    @State var title: String
    @State var events: [[String: Any]] = []
//    @State var filteredEvents: [[String: Any]] = []
    
    init(title: String, events: [[String: Any]]) {
        self._title = State(initialValue: title)
        self._events = State(initialValue: events)
    }
    
    
    // MARK: - BODY

    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .onAppear() {
                    fetchEvents { (data, error) in
                        if let data = data {
                            for event in data {
                                events.append(event)
                            }
                            for event in events {
                                if(event["comedy_club_id"] as! String == userID){
                                    filteredEvents.append(event)
                                }
                            }
                        } else if let error = error {
                            // Handle the error
                        }
                    }
                }
            if let filteredEvents = filteredEvents.first?["event_name"] as? String {
                Text(filteredEvents)
            } else {
                Text("No events found")
            }
            Spacer()
        }
    }
}

//struct ComedyClubDetailView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        ComedyClubDetailView(title: "Your Events", events: events)
//            .previewLayout(.sizeThatFits)
//            .background(colorBackground)
//            .preferredColorScheme(.dark)
//    }
//}
