
//
//  ComedianUserDetailView.swift
//  MIC
//
//  Created by Sowri on 4/24/23.
//
import SwiftUI
import Firebase

class ComedianTileViewViewModel: ObservableObject {
    @AppStorage("uid") var userID: String = ""
    @Published var events: [Event] = []
    
    func loadEventData() {
        let db = Firestore.firestore()
        db.collection("events")
            .whereField("comedian_id", isEqualTo: userID)
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
struct ComedianUserDetailView: View {
    // MARK: - PREVIEW
    
    @StateObject var viewModel = ComedianTileViewViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            // Display each event in a button tile
            ForEach(viewModel.events) { event in
                Button(action: {
                    // Handle button tap
                }, label: {
                    // Customize the appearance of the button tile
                    // Customize the appearance of the button tile
                    HStack(alignment: .center, spacing: 8) {
                        if let picture = event.picture {
                            Image(uiImage: picture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .padding(.leading, 8)
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Event Name:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(event.eventName)
                                .font(.headline)
                            Text("Comedian:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                            Text(event.comedianName)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Price:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$\(event.price, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        LinearGradient(
                                    gradient: Gradient(colors: [Color.red, Color.yellow]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                    )
                    .cornerRadius(8)
                    .shadow(radius: 4)
                })
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            viewModel.loadEventData()
        }
    }
}


//struct ComedianUserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComedianUserDetailView(title: "Your Events")
//            .previewLayout(.sizeThatFits)
//            .background(colorBackground)
//    }
//}
