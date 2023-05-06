//
//  ContentView.swift
//  MIC
//
//  Created by Sowri on 4/18/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

class ClubEventViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var genre: String = ""
    @Published var bio: String = ""
    @Published var picture: UIImage?
    
    private let db = Firestore.firestore()
    private var userRef: DocumentReference?
    
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    @AppStorage("uid") var userID: String = ""
    
    init(documentID: String?) {
        if let documentID = documentID {
            userRef = db.collection("events").document(documentID)
            fetchData()
        } else {
            userRef = db.collection("events").document()
        }
    }
    
    func fetchData() {
        userRef?.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstName = data?["firstName"] as? String ?? ""
                self.lastName = data?["lastName"] as? String ?? ""
                self.genre = data?["genre"] as? String ?? ""
                self.bio = data?["bio"] as? String ?? ""
                if let imageData = data?["picture"] as? Data {
                    self.picture = UIImage(data: imageData)
                }
            } else {
                print("Error retrieving user document: \(error?.localizedDescription ?? "unknown error")")
            }
        }
    }
    
    func saveData(picture: String) {
        userRef?.setData([
            "firstName": firstName,
            "lastName": lastName,
            "genre": genre,
            "bio": bio,
            "picture": picture
        ]) { error in
            if let error = error {
                print("Error saving user document: \(error.localizedDescription)")
            } else {
                print("User document saved successfully.")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(selectedImage: $selectedImage, presentationMode: presentationMode)
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        let presentationMode: Binding<PresentationMode>
        
        init(selectedImage: Binding<UIImage?>, presentationMode: Binding<PresentationMode>) {
            _selectedImage = selectedImage
            self.presentationMode = presentationMode
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            selectedImage = uiImage
            presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
struct ContentView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var Bookings: Bookings
    
    // MARK: - BODY

//    @ObservedObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isComedian") var isComedian: Bool = false
    @AppStorage("isComedyClub") var isComedyClub: Bool = false
    @State private var CreateEvent: Bool = false // New state variable
    @State private var EventName: String = ""
    
    func fetchEvents(completion: @escaping (String?, Error?) -> Void) {
        
        do {
            guard let url = URL(string: "http://localhost:8080/users/get/\(userID)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let jsonString = ""
//            request.httpBody = jsonString.data(using: .utf8)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request){ data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    if (200...299).contains(httpResponse.statusCode) {
                        let responseData = String(data: data, encoding: .utf8)!
                        DispatchQueue.main.async {
//                            alertMessage = responseData
//                            showAlert = true
                            completion(responseData, nil)
                        }
                    } else {
                        print("Server Error: \(httpResponse.statusCode)")
                    }
                }
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        ZStack {
            if Bookings.showingBooking == false && Bookings.selectedBooking == nil {
                VStack(spacing: 0){
                    if userID == "" {
                        AuthView()
                    } else if !(isComedian || isComedyClub) {
                        // Navigation Bar View -- from here
                        NavigationBarView()
                            .padding(.horizontal, 15)
                            .padding(.bottom)
                            .padding(.top, UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows.first?.safeAreaInsets.top ?? 0)
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                        // : Navigation Bar -- till here
                                                
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                FeaturedTabView()
                                ComedyClubGridView()
                                TitleView(title: "Comedians")
                                ComedianView()
                                
                                TitleView(title: "Comedy Genres")
                                ComedyCategoryGridView()
                                FooterView()
                                    .padding(.horizontal)
                            } //:VStack
                        }) //: SCROLL
                        
                    } else if isComedian {
                        // Navigation Bar View -- from here
                        NavigationBarComedianView()
                            .padding(.horizontal, 15)
                            .padding(.bottom)
                            .padding(.top, UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows.first?.safeAreaInsets.top ?? 0)
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                        // : Navigation Bar -- till here
                        Text("Your Events")
                                .fontWeight(.bold)
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                ComedianUserDetailView()
                                FooterView()
                                    .padding(.horizontal)
                            } //:VStack
                        }) //: SCROLL
                        
                        
                        
                    } else if isComedyClub {
                        // Navigation Bar View -- from here
                        NavigationBarComedyClubView()
                            .padding(.horizontal, 15)
                            .padding(.bottom)
                            .padding(.top, UIApplication.shared.connectedScenes
                                .compactMap { $0 as? UIWindowScene }
                                .first?.windows.first?.safeAreaInsets.top ?? 0)
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)
                        // : Navigation Bar -- till here
                        Text("Your Events")
                            .foregroundColor(.black)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                
                                ComedyClubDetailView()
                                FooterView()
                                    .padding(.horizontal)
                            } //:VStack
                        }) //: SCROLL
                        Button(action: {
                            CreateEvent = true // Set the state variable to true to show the view

                            

                        }, label: {
                            // Button label
                            Text("Create Event")
                                .foregroundColor(.black)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.yellow))
                                .padding(.horizontal)


                        })
                        Spacer()
                    } //: VSTACK
                }
                .sheet(isPresented: $CreateEvent) {
                    // Present the ProfileView modally
                    ComClubCreateEventView()
                }
                .background(colorBackground.ignoresSafeArea(.all, edges: .all))
            } else {
                ComedianDetailView()
            }
        } //: ZSTACK
        .ignoresSafeArea(.all, edges: .top)
    }
    // MARK: - <#placeholder#>

}
struct ComClubCreateEventView: View {
    
    @State private var EventName: String = ""
    @State private var Description: String = ""
    @State private var Price: Int? = 0
    @State var date = Date()
    @State var ComedianName: String = ""
    @State private var picture: UIImage?
    
    @State private var selectedComedian: String = ""
    @State private var comedianID: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
//    @State private var users: String
    @State private var alertMessageUsers = [String]()
    @State var events: [[String: Any]] = []
    
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isDocumentID") var isDocumentID: String = ""


    var body: some View {
        ZStack{
            Color.yellow.edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false, content:{
                VStack{
                    
                    HStack{
                        Text("Create New Event!")
                        
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .bold()
                        Spacer()
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                    .padding(.top)

                    HStack {
                        Image(systemName: "star")
                        TextField("Event Name", text: $EventName)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()
                    
                    HStack {
                        
                        Image(systemName: "chart.bar.doc.horizontal")
                            .foregroundColor(.black)
                        TextField("Description", text: $Description)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()
                    
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        TextField("price", text: Binding(
                            get: { Price.map(String.init) ?? "" },
                            set: { Price = Int($0) }
                        ))
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()

                    HStack {
                        Image(systemName: "list")
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()
                    
                    HStack {
                        Image(systemName: "star")
                        TextField("Comedian Name", text: $ComedianName)
                    }
                    .foregroundColor(.black)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()
                   
                    HStack{
                        Button(action: {
                            self.showImagePicker = true
                        }){
                            Text("Select Image")
                                .foregroundColor(.white)
                                .font(.title3)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black))
                                .padding(.horizontal)
                            
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                    }
                    Spacer()
            Button{
                       
                let db = Firestore.firestore()
                db.collection("users")
                    .whereField("isComedian", isEqualTo: true)
                    .whereField("firstName", isEqualTo: ComedianName)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            if let querySnapshot = querySnapshot, let document = querySnapshot.documents.first {
                                let comedianDocID = document.documentID
                                print("Comedian document ID: \(comedianDocID)")
                                
                                // Now search for the comedian's uid in the same document
                                self.comedianID = document.data()["uid"] as? String ?? ""
                                print("Comedian UID: \(comedianID)")
                                
                                // Use the comedianDocID and comedianUID as needed
                            } else {
                                print("Comedian not found")
                            }
                        }
                    }
            
                let documentRef = db.collection("events").document()
                let imageData = selectedImage?.jpegData(compressionQuality: 0.5)

                db.collection("users")
                    .whereField("isComedian", isEqualTo: true)
                    .whereField("firstName", isEqualTo: ComedianName)
                    .getDocuments { (querySnapshot, error) in
                        if let error = error {
                            print("Error getting documents: \(error)")
                        } else {
                            if let querySnapshot = querySnapshot, let document = querySnapshot.documents.first {
                                print(document.documentID)
                                let comedianID = (document.data()["uid"] as? String) ?? ""
                                print("Comedian UID: \(comedianID)")

                                documentRef.setData([
                                    "id": UUID().uuidString,
                                    "eventName": EventName,
                                    "description": Description,
                                    "price": Price ?? 0,
                                    "date": date.formatted(),
                                    "comedian_id": comedianID,
                                    "comedy_club_id": userID,
                                    "comedian_name": ComedianName,
                                    "picture": imageData ?? Data(),
                                    "last_fetched_uid": Timestamp(date: Date())
                                ], merge: true) { err in
                                    if let err = err {
                                        print("Error appending data: \(err)")
                                    } else {
                                        print("Data appended successfully!")
                                    }
                                }
                            } else {
                                print("Comedian not found")
                            }
                        }
                    }
                    }label: {
                        // Button label
                        Text("Create")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black))
                            .padding(.horizontal)
                    }
                }
            }) //:Scroll
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Response"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

//protocol MyDelegate {
//    func fetchEventsData() -> ([[String: Any]]?, Error?)
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
            .environmentObject(Bookings())
            .preferredColorScheme(.dark)
    }
}
