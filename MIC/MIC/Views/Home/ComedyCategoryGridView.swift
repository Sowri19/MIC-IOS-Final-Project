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

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridLayout, spacing: columnSpacing, pinnedViews: []) {
                    ForEach(viewModel.comedians) { comedian in
                        Button(action: {}, label: {
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



struct ComedyCategoryGridView_Previews: PreviewProvider {
    static var previews: some View {
        ComedyCategoryGridView()
            .previewLayout(.sizeThatFits)
            .background(colorBackground)
    }
}
