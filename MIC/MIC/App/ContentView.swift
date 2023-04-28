//
//  ContentView.swift
//  MIC
//
//  Created by Sowri on 4/18/23.
//

import SwiftUI
import FirebaseAuth

import Firebase

struct ContentView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var Bookings: Bookings
    
    // MARK: - BODY

//    @ObservedObject var userViewModel = UserViewModel()
    @AppStorage("uid") var userID: String = ""
    @AppStorage("isComedian") var isComedian: Bool = false
    @AppStorage("isComedyClub") var isComedyClub: Bool = false
    @State private var CreateEvent: Bool = false // New state variable
    
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
                        
                        // Login ID and Sign out Button
                        Text("Logged In! \nYour user id is \(userID)")
                        Button(action: {
                            let firebaseAuth = Auth.auth()
                            do {
                                try firebaseAuth.signOut()
                                withAnimation{
                                    userID = ""
                                }
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }){
                            Text("Sign Out")
                        } // :Login ID and Sign out Button
                        
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                FeaturedTabView()
                                    .padding(.vertical, 20)
                                ComedyClubGridView()
                                TitleView(title: "Comedians")
                                LazyVGrid(columns: gridLayout, spacing: 15, content: {
                                    //                                ForEach(<#T##data: Range<Int>##Range<Int>#>, content: <#T##(Int) -> View#>)
                                    ComedianView()
                                        .onTapGesture {
                                            withAnimation(.easeOut){
                                                //                                                Bookings.selectedBooking = ComedianModel
                                                Bookings.showingBooking = true
                                            }
                                        }
                                }) //:Grid
                                .padding(15)
                                TitleView(title: "Comedy Categories")
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
                        
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                ComedianUserDetailView(title: "Your Events")
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
                        
                        ScrollView(.vertical, showsIndicators: false, content:{
                            VStack(spacing: 0){
                                ComedyClubDetailView(title: "Your Events")
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
    @State private var Price: Int?
    @State var date = Date()
    @State var ComedianName: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
//    @State private var users: String
    @State private var alertMessageUsers = [String]()
    @State var events: [[String: Any]] = []
    

    let comedians = ["Dave Chappelle", "Trevor Noah", "Ellen DeGeneres", "Amy Schumer"]
    @State private var selectedComedian = "Dave Chappelle"

    @AppStorage("uid") var userID: String = ""
    @AppStorage("isComedian") var isComedian: Bool = false
    @AppStorage("isComedyClub") var isComedyClub: Bool = false
    @AppStorage("isDocumentID") var isDocumentID: String = ""
    @AppStorage("profileImage") var profileImage: String = ""
    
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
                    }
                    .padding()
                    .padding(.top)
                    .onAppear(){
                        fetchEventsData { (data, error) in
                            if let data = data {
//                                for user in data {
//                                    users.append(user)
//                                }
//
//                                for (i, user) in users.enumerated() {
//                                    if let isComedian = user["isComedian"] as? Bool, isComedian == false {
//                                        users.remove(at: i)
//                                    }
//                                }
                                
                                for event in data {
                                    events.append(event)
                                }
                                
                                for (i, event) in events.enumerated() {
                                    if(event["comedy_club_id"] as! String != userID){
                                        events.remove(at: i)
                                    }
                                }
                                
                                
                                
                            } else if let error = error {
                                // Handle the error
                            }
                        }
                     }
                    
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
                    .foregroundColor(.white)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    .padding()
                    
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        TextField("price", value: $Price, formatter: NumberFormatter())
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
                    
                    //                    HStack {
                    //                        Image(systemName: "person.crop.circle.dashed")
                    //                            .foregroundColor(.black)
                    //                        TextField("Comedian Name", text: $ComedianName)
                    //                    }
                    //                    .foregroundColor(.white)
                    //                    .padding()
                    //                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                    //                    .padding()
                    HStack {
                        HStack {
                            Text("Comedians")
                            Spacer()
                        }
                        .padding(.leading)
                        
                        
                        
                        Picker(selection: $selectedComedian, label: Text("")) {
                            ForEach(comedians, id: \.self) { color in
                                Text(color)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.black))
                        .frame(height: 20)
                        .colorScheme(.dark)
                    }.padding()
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
                        
                        do {
                            let body = [
                                "id": UUID().uuidString,
                                "comedy_club_id": userID,
                                "comedian_id": selectedComedian,
                                "event_name": EventName,
                                "date": date.formatted(),
                                "price": Price,
                                "description": Description,
//                                "picture": selectedImage
                            ] as [String : Any]
                            let jsonData = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                            let jsonString = String(data: jsonData, encoding: .utf8)!
                            guard let url = URL(string: "http://localhost:8080/events/create") else {
                                return
                            }
                            
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                            request.httpBody = jsonString.data(using: .utf8)
                            
                            let session = URLSession.shared
                            
                            let task = session.dataTask(with: request){ data, response, error in
                                guard let data = data, error == nil else {
                                    print(error?.localizedDescription ?? "Unknown error")
                                    return
                                }
                                if let httpResponse = response as? HTTPURLResponse {
                                    if (200...299).contains(httpResponse.statusCode) {
                                        do {
                                            let responseData = String(data: data, encoding: .utf8)!
                                            DispatchQueue.main.async {
                                                alertMessage = responseData
                                                showAlert = true
                                            }
                                        } catch {
                                            print("Error decoding JSON: \(error.localizedDescription)")
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 Pro")
            .environmentObject(Bookings())
            .preferredColorScheme(.dark)
    }
}
