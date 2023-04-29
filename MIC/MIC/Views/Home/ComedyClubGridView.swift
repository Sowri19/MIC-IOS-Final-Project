import SwiftUI
import Firebase

class ComedyClubGridViewViewModel: ObservableObject {
    @Published var comedyClubs: [ComedyClub] = []
    
    func loadData() {
        let db = Firestore.firestore()
        db.collection("users").whereField("isComedyClub", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error retrieving documents: \(error.localizedDescription)")
                return
            }
            var clubs: [ComedyClub] = []
            for document in querySnapshot!.documents {
                let firstName = document.data()["firstName"] as? String ?? ""
                let lastName = document.data()["lastName"] as? String ?? ""
                let location = document.data()["location"] as? String ?? ""
                let pointOfContact = document.data()["pointOfContact"] as? String ?? ""
                let bio = document.data()["bio"] as? String ?? ""
                let genre = document.data()["genre"] as? String ?? ""
                let isComedyClub = document.data()["isComedyClub"] as? Bool ?? false
                var picture: UIImage?
                if let imageData = document.data()["picture"] as? Data {
                    picture = UIImage(data: imageData)
                }
                let comedyClub = ComedyClub(firstName: firstName, lastName: lastName, location: location, pointOfContact: pointOfContact, bio: bio, genre: genre, isComedyClub: isComedyClub, picture: picture)
                clubs.append(comedyClub)
            }
            DispatchQueue.main.async {
                self.comedyClubs = clubs
            }
        }
    }
}

struct ComedyClubGridView: View {
    @StateObject var viewModel = ComedyClubGridViewViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: []) {
                Section(
                    header: SectionView(rotateClockwise: false),
                    footer: SectionView(rotateClockwise: true)
                ) {
                    ForEach(viewModel.comedyClubs) { comedyClub in
//                        Button(action: {
//                            // Handle button tap here
//                        }) {
//                            VStack(alignment: .leading) {
//                                Image(uiImage: comedyClub.picture ?? UIImage())
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 150, height: 150)
//                                    .cornerRadius(10)
//                                Text(comedyClub.firstName + " " + comedyClub.lastName)
//                                    .font(.headline)
//                                Text(comedyClub.location)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
//                        }
//                        .buttonStyle(PlainButtonStyle())
                        Button(action: {}, label: {
                            HStack(alignment: .center, spacing: 6){
                                // Show the comedy club's picture
                                Image(uiImage: comedyClub.picture ?? UIImage(systemName: "person.circle.fill")!)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                // Show the comedy club's first name
                                Text(comedyClub.firstName)
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                            } //: HStack
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                        }) //: Button
                    }
                }
            }
            .frame(height: 140)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .onAppear {
                viewModel.loadData()
            }
        }.background(Color(hex: "b96f39"))

    }
}

//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        scanner.currentIndex = hex.startIndex
//        var rgbValue: UInt64 = 0
//        scanner.scanHexInt64(&rgbValue)
//
//        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
//        let g = Double((rgbValue & 0xff00) >> 8) / 255.0
//        let b = Double(rgbValue & 0xff) / 255.0
//
//        self.init(red: r, green: g, blue: b)
//    }
//}



struct ComedyClubGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyClubGridView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(colorBackground)
    }
}
