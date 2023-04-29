//
//  ComedianView.swift
//  MIC
//
//  Created by Sowri on 4/21/23.
//

import SwiftUI
import Firebase

class ComedianGViewViewModel: ObservableObject {
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
struct ComedianView: View {
    // MARK: - PROPERTY
    @StateObject var viewModel = ComedianGViewViewModel()
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15)
            ], spacing: 15) {
                ForEach(viewModel.comedians) { comedian in
                    Button(action: {}, label: {
                        VStack(alignment: .center, spacing: 10) {
                            // Show the comedian's picture
                            ZStack {
                                Image(uiImage: comedian.picture ?? UIImage(systemName: "person.circle.fill")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                                    .shadow(radius: 5)
                                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                            }
                            // Show the comedian's name
                            Text(comedian.firstName)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        } //: VStack
                        .padding()
                        .background(Color(hex: "fae7b6"))
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                    }) //: Button
                    .buttonStyle(PlainButtonStyle())
                }
            } //: LazyVGrid
            .padding(.top, 15)
            .onAppear {
                viewModel.loadComediansData()
            }
        } //: ScrollView

    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        self.init(
            .sRGB,
            red: Double((rgbValue >> 16) & 0xff) / 255,
            green: Double((rgbValue >> 08) & 0xff) / 255,
            blue: Double((rgbValue >> 00) & 0xff) / 255,
            opacity: 1
        )
    }
}

struct ComedianView_Previews: PreviewProvider {
    static var previews: some View {
        ComedianView()
            .previewLayout(.fixed(width: 200, height: 300))
            .padding()
            .background(colorBackground)
    }
}
//                // PHOTO
//                    ZStack {
//                        Image("appstore")
//                            .resizable()
//                            .scaledToFit()
//                            .padding(10)
//                } //: ZStack
//        //            .background(Color(red: ))
//                    .cornerRadius(12)
//
//                    //NAME
//                    Text("Comdedian")
//                        .font(.title3)
//                        .fontWeight(.black)
//                    //PRICE
//                    Text("Price")
//                        .fontWeight(.semibold)
//                        .foregroundColor(.gray)
//                })
//            }
