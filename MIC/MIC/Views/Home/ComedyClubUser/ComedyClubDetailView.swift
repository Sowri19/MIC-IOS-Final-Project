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
    @State var filteredEvents: [[String: Any]] = []
    
    init(title: String, events: [[String: Any]]) {
        self._title = State(initialValue: title)
        self._events = State(initialValue: events)
    }
    
    func fetchEventsData(completion: @escaping ([[String : Any]]?, Error?) -> Void) {
        do {
            guard let url = URL(string: "http://localhost:8080/events/getAll") else {
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request){ data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        do {
                            // make sure this JSON is in the format we expect
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                                // try to read out a string array
                                DispatchQueue.main.async {
                                    completion(json, nil)
                                }
                            }
                        } catch let error as NSError {
                            print("Failed to load: \(error.localizedDescription)")
                        }
                    } else {
                        print("Server Error: \(httpResponse.statusCode)")
                        DispatchQueue.main.async {
                            completion(nil, NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
                        }
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - BODY

    var body: some View {
        HStack{
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .onAppear() {
                    fetchEventsData { (data, error) in
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
