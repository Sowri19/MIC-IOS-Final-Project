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
    
    @State private var showCCProfileView: Bool = false
    @State private var selectedClub: ComedyClub? // Add a @State variable to keep track of the selected comedian
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridLayout, alignment: .center, spacing: columnSpacing, pinnedViews: []) {
                Section(
                    header: SectionView(rotateClockwise: false),
                    footer: SectionView(rotateClockwise: true)
                ) {
                    ForEach(viewModel.comedyClubs) { comedyClub in
                        Button(action: {
                            self.showCCProfileView = true
                            self.selectedClub = comedyClub
                        }, label: {
                            HStack(alignment: .center, spacing: 6){
                                // Show the comedy club's picture
                                Image(systemName: "theatermasks.circle.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                // Show the comedy club's first name
                                Text(comedyClub.firstName)
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                            } //: HStack
                            .frame(width: 150) // Set a fixed width for the HStack
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1)
                            )
                            .background(
                                Color.purple
                                    .brightness(0.8)
                                    .saturation(0.9)
                                    .cornerRadius(12)
                            )
                            .frame(width: 200, height: 50) // Set a fixed size for the button
                        }) //: Button
                        .sheet(isPresented: $showCCProfileView){
                            ComedyClubProfileView1(clubName: comedyClub.firstName, emailAddress: comedyClub.pointOfContact, address: comedyClub.location, businessType: comedyClub.genre, rating: 5)
                        }
                    }
                }
            }
            .frame(height: 140)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .onAppear {
                viewModel.loadData()
            }
        }.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            .padding(.bottom, 15)
    }
}

struct ComedyClubProfileView1: View {
    
    let clubName: String
    let emailAddress: String
    let address: String
    let businessType: String
    let rating: Int
    
    var body: some View {
        VStack {
            ZStack {
                Color(red: 0.95, green: 0.27, blue: 0.27)
                    .ignoresSafeArea()
                VStack {
                    Text(clubName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    Image("laugh_factory_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, 20)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Email Address:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.horizontal, 10)
                    Spacer()
                }
                Text(emailAddress)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 2)
            )
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Address:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.horizontal, 10)
                    Spacer()
                }
                Text(address)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Business Type:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.horizontal, 10)
                    Spacer()
                }
                Text(businessType)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.green, lineWidth: 2)
            )
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Rating:")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .padding(.horizontal, 10)
                    Spacer()
                }
                Text(String(rating))
                    .font(.subheadline)
                    .padding(.horizontal, 10)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.yellow, lineWidth: 2)
            )
            .padding(.horizontal, 20)
            
            Spacer()
            
            Rectangle()
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Text("About Us")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(.top, 10)
            
            Text("The Laugh Factory has been a staple of the comedy scene since it opened its doors in 1979. It has hosted some of the biggest names in comedy and continues to be a premier destination for both performers and audiences alike.")
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.98))
        .edgesIgnoringSafeArea(.all)
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
