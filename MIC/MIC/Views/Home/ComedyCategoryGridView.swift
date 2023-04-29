//
//  ComedyCategoryGridView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//
import SwiftUI
import Firebase

class ComedianGridViewViewModel: ObservableObject {
    @Published var comedians: [Comedians] = []
    
    func loadComediansData() {
        let db = Firestore.firestore()
        db.collection("users").whereField("isComedian", isEqualTo: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error retrieving documents: \(error.localizedDescription)")
                return
            }
            var comedians: [Comedians] = []
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
                let comedian = Comedians(firstName: firstName, lastName: lastName, location: location, pointOfContact: pointOfContact, bio: bio, genre: genre, isComedyClub: isComedyClub, picture: picture)
                comedians.append(comedian)
            }
            DispatchQueue.main.async {
                self.comedians = comedians
            }
        }
    }

}

struct ComedyCategoryGridView: View {
    @StateObject var viewModel = ComedianGridViewViewModel()
    @State private var showComedianProfile: Bool = false
    @State private var selectedComedian: Comedians? // Add a @State variable to keep track of the
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridLayout, spacing: columnSpacing, pinnedViews: []) {
                ForEach(viewModel.comedians) { comedian in
                    Button(action: {
                        self.selectedComedian = comedian
                        self.showComedianProfile = true
                    }, label: {
                        VStack(alignment: .center, spacing: 6){
                            // Show the comedian's picture
                            Image(uiImage: comedian.picture ?? UIImage(systemName: "person.circle.fill")!)
                                .resizable()
                                .scaledToFit()
                                .padding(20) // increase padding size to make image bigger
                                .background(Color.white.cornerRadius(12))
                                .background(
                                    RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                            // Show the comedian's first name
                            Text(comedian.genre)
                                .fontWeight(.light)
                                .foregroundColor(.purple)
                        } //: HStack
                        .padding()
                    }) //: Button
                    .sheet(isPresented: $showComedianProfile) {
                        if let comedian = selectedComedian {
                            ComedianProfileView1(firstName: comedian.firstName, lastName: comedian.lastName, rating: 5, genre: comedian.genre, bio: comedian.bio, profileImage: comedian.picture ?? UIImage())
                        }
                    }
                }
            } //: GRID
            .frame(height: 200)
            .padding(15)
            .onAppear {
                viewModel.loadComediansData() // call the correct method name here
            }
        } //:SCROLL
        .background(Color(hex: "2d9abf"))
    }
}


struct ComedianProfileView2: View {
    
    let firstName: String
    let lastName: String
    let rating: Int
    let genre: String
    let bio: String
    let profileImage: UIImage
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 255/255, green: 128/255, blue: 128/255), Color(red: 255/255, green: 224/255, blue: 0)]),
                startPoint: .top,
                endPoint: .bottom
            )
            VStack {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                Text("\(firstName) \(lastName)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Rating: \(rating)")
                    .font(.headline)
                    .foregroundColor(.white)
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.white)
                    Text(genre)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.top)
                Text(bio)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}



struct ComedyCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyCategoryGridView()
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
