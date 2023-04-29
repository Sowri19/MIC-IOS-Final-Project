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
    @State private var showComedianProfile: Bool = false
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15)
            ], spacing: 15) {
                ForEach(viewModel.comedians) { comedian in
                    Button(action: {
                        self.showComedianProfile = true
                    }, label: {
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
                    .sheet(isPresented: $showComedianProfile) {
                        ComedianProfileView1(firstName: comedian.firstName, lastName: comedian.lastName, rating: 5, genre: comedian.genre, bio: comedian.bio, profileImage: comedian.picture ?? UIImage())
                }
                
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

struct ComedianProfileView1: View {
    
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
