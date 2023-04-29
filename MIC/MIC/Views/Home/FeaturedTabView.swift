//
//  FeaturedTabView.swift
//  MIC
//
//  Created by Sowri on 4/20/23.
//

import SwiftUI
import Firebase

class HomeTileViewViewModel: ObservableObject {
    @AppStorage("uid") var userID: String = ""
    @Published var events: [Event] = []
    
    func loadEventData() {
        let db = Firestore.firestore()
        db.collection("events")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error retrieving documents: \(error.localizedDescription)")
                    return
                }
                var events: [Event] = []
                for document in querySnapshot!.documents {
                    let eventName = document.data()["eventName"] as? String ?? ""
                    let description = document.data()["description"] as? String ?? ""
                    let price = document.data()["price"] as? Int ?? 0
                    let date = document.data()["date"] as? String ?? ""
                    let comedianName = document.data()["comedian_name"] as? String ?? ""
                    let comedyClubID = document.data()["comedy_club_id"] as? String ?? ""
                    var picture: UIImage?
                    if let imageData = document.data()["picture"] as? Data {
                        picture = UIImage(data: imageData)
                    }
                    let event = Event(id: document.documentID, comedianID: self.userID, comedianName: comedianName, comedyClubID: comedyClubID, date: date, description: description, eventName: eventName, picture: picture, price: price)

                    events.append(event)
                }
                DispatchQueue.main.async {
                    self.events = events
                }
            }
    }

}
struct FeaturedTabView: View {
    @StateObject var viewModel = HomeTileViewViewModel() // Create a new instance of the view model
    
    var body: some View {
        TabView {
            ForEach(viewModel.events) { event in
                Button(action: {
                    // Handle button tap
                }, label: {
                    // Customize the appearance of the button tile
                    VStack(alignment: .center, spacing: 8) {
                        if let picture = event.picture {
                            ZStack(alignment: .bottomLeading) {
                                Image(uiImage: picture)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(20)
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(event.eventName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .lineLimit(1)
                                        .shadow(radius: 20)
                                    Text("Comedian: \(event.comedianName)")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(radius: 20)
                                        .lineLimit(1)
                                        .fontDesign(.rounded)
                                    Text("$\(event.price, specifier: "%.2f")")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .fontDesign(.rounded)
                                }
                                .padding(.bottom, 8)
                                .padding(.leading, 8)
                                .padding(.trailing, 8)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .padding(.leading, -8) // remove left padding
                    .padding(.trailing, -8) // remove right padding
                    .shadow(radius: 4)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.loadEventData()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .edgesIgnoringSafeArea(.all) // Ignore safe area to remove white spaces
    }



}

struct FeaturedTabView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedTabView()
            .previewDevice("iphone 14 pro")
            .background(Color.gray)
    }
}
