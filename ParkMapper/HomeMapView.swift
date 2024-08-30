import SwiftUI
import MapKit
import ChatGPTSwift
import ChatGPTSwift
import CoreLocation
import Aptabase
import Firebase

struct HomeMapView: View {
    @StateObject private var viewModel = HomeMapViewModel()
    @State private var searchQuery = ""
    @State private var images: [String] = []
    @State private var selectedPark: Park?
    @State private var selectedRecreationalGround: RecreationGround?
    @State private var selectedChildrensPlayArea: ChildrensPlayAreas?
    @Binding  var showClosestParksInfoSheet: Bool
    @Binding var reviewContent: String
    @Binding  var showClosestChildrensPlayAreasInfoSheet: Bool
    @Binding  var showClosestRecreationalGroundInfoSheet: Bool
    var body: some View {
        ZStack {
            if showClosestParksInfoSheet {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.parks) { park in
                    MapAnnotation(coordinate: park.coordinate) {
                        Button(action: {
                            selectedPark = park
                        }) {
                            MapAnnotationViewMarker(showClosestParksInfoSheet: $showClosestParksInfoSheet, showClosestChildrensPlayAreasInfoSheet: $showClosestChildrensPlayAreasInfoSheet, showClosestRecreationalGroundInfoSheet: $showClosestRecreationalGroundInfoSheet)
                        }
                    }
                }
            }
            if showClosestRecreationalGroundInfoSheet {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.recreationalGrounds) { ground in
                    MapAnnotation(coordinate: ground.coordinate) {
                        Button(action: {
                            selectedRecreationalGround = ground
                        }) {
                            MapAnnotationViewMarker(showClosestParksInfoSheet: $showClosestParksInfoSheet, showClosestChildrensPlayAreasInfoSheet: $showClosestChildrensPlayAreasInfoSheet, showClosestRecreationalGroundInfoSheet: $showClosestRecreationalGroundInfoSheet)
                        }
                    }
                }
            }
            if showClosestChildrensPlayAreasInfoSheet {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.childrensPlayAreas) { area in
                    MapAnnotation(coordinate: area.coordinate) {
                        Button(action: {
                            selectedChildrensPlayArea = area
                        }) {
                            MapAnnotationViewMarker(showClosestParksInfoSheet: $showClosestParksInfoSheet, showClosestChildrensPlayAreasInfoSheet: $showClosestChildrensPlayAreasInfoSheet, showClosestRecreationalGroundInfoSheet: $showClosestRecreationalGroundInfoSheet)
                        }
                    }
                }
            }
            VStack {
                if showClosestParksInfoSheet {
                    HStack {
                        TextField("Search for an address", text: $searchQuery, onCommit: {
                            viewModel.searchLocation(searchQuery: searchQuery)
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        Button(action: {
                            viewModel.centerOnUserLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Menu ("", systemImage: "line.3.horizontal.decrease.circle", content: {
                            Button(action: {
                                showClosestParksInfoSheet = true
                                showClosestRecreationalGroundInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Parks")
                            })
                            
                            Button(action: {
                                showClosestRecreationalGroundInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Recreational Grounds")
                            })
                            
                            Button(action: {
                                showClosestChildrensPlayAreasInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestRecreationalGroundInfoSheet = false
                            }, label: {
                                Text("Childrens Play areas")
                            })
                        })
                    }
                    if !viewModel.closestParks.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Nearby Parks")
                                .font(.headline)
                                .padding(.leading)
                            
                            List(viewModel.closestParks.prefix(5), id: \.id) { park in
                                Button(action: {
                                    selectedPark = park
                                }) {
                                    HStack {
                                        Text(park.name)
                                            .bold()
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                        Text("\(park.distance, specifier: "%.2f") miles")
                                    }
                                }
                            }
                            .frame(height: 200)
                        }
                        .background(Color.white)
                    }
                } else if showClosestChildrensPlayAreasInfoSheet {
                    HStack {
                        TextField("Search for an address", text: $searchQuery, onCommit: {
                            viewModel.searchLocation(searchQuery: searchQuery)
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        Button(action: {
                            viewModel.centerOnUserLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Menu ("", systemImage: "line.3.horizontal.decrease.circle", content: {
                            Button(action: {
                                showClosestParksInfoSheet = true
                                showClosestRecreationalGroundInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Parks")
                            })
                            
                            Button(action: {
                                showClosestRecreationalGroundInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Recreational Grounds")
                            })
                            
                            Button(action: {
                                showClosestChildrensPlayAreasInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestRecreationalGroundInfoSheet = false
                            }, label: {
                                Text("Childrens Play areas")
                            })
                        })
                    }
                    if !viewModel.closestCPAs.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Nearby Children's Play Areas")
                                .font(.headline)
                                .padding(.leading)
                            
                            List(viewModel.closestCPAs.prefix(5), id: \.id) { area in
                                Button(action: {
                                    selectedChildrensPlayArea = area
                                }) {
                                    HStack {
                                        Text(area.name)
                                            .bold()
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                        Text("\(area.distance, specifier: "%.2f") miles")
                                    }
                                }
                            }
                            .frame(height: 200)
                        }
                        .background(Color.white)
                    }
                } else if showClosestRecreationalGroundInfoSheet {
                    HStack {
                        TextField("Search for an address", text: $searchQuery, onCommit: {
                            viewModel.searchLocation(searchQuery: searchQuery)
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        
                        Button(action: {
                            viewModel.centerOnUserLocation()
                        }) {
                            Image(systemName: "location.fill")
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Menu ("", systemImage: "line.3.horizontal.decrease.circle", content: {
                            Button(action: {
                                showClosestParksInfoSheet = true
                                showClosestRecreationalGroundInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Parks")
                            })
                            
                            Button(action: {
                                showClosestRecreationalGroundInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestChildrensPlayAreasInfoSheet = false
                            }, label: {
                                Text("Recreational Grounds")
                            })
                            
                            Button(action: {
                                showClosestChildrensPlayAreasInfoSheet = true
                                showClosestParksInfoSheet = false
                                showClosestRecreationalGroundInfoSheet = false
                            }, label: {
                                Text("Childrens Play areas")
                            })
                        })
                    }
                    if !viewModel.closestRGs.isEmpty {
                        VStack(alignment: .leading) {
                            Text("nearby Recreational Grounds")
                                .font(.headline)
                                .padding(.leading)
                            List(viewModel.closestRGs.prefix(5), id: \.id) { ground in
                                Button(action: {
                                    selectedRecreationalGround = ground
                                }) {
                                    HStack {
                                        Text(ground.name)
                                            .bold()
                                            .foregroundStyle(Color.primary)
                                        Spacer()
                                        Text("\(ground.distance, specifier: "%.2f") miles")
                                    }
                                }
                            }
                            .frame(height: 200)
                            HStack {
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    Text("Report a problem")
                                })
                            }
                        }
                        .background(Color.white)
                    }
                }
                
            }
        }
        .ignoresSafeArea()
        .onAppear {
            
            viewModel.requestLocationPermission()
            showClosestParksInfoSheet = true
            showClosestRecreationalGroundInfoSheet = false
            showClosestChildrensPlayAreasInfoSheet = false
        } //This is only called if the location was not initally given
        
        //Below is shown based off of filter option
        .sheet(item: $selectedPark) { park in
            ParkDetailView(park: park)
        }
        .sheet(item: $selectedRecreationalGround) { ground in
            RecreationGroundDetailView(recreationGround: ground)
        }
        .sheet(item: $selectedChildrensPlayArea) { area in
            ChildrensPlayAreasDetailView(CPA: area, reviewContent: $reviewContent)
        }

    }
    private func createUserID() async {
        let userID: String
        let api = ChatGPTAPI(apiKey: "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")
            Aptabase.shared.trackEvent("API Calls Made")
            do {
                let stream = try await api.sendMessageStream(text: "Create a random user ID")
                var response = ""
                for try await line in stream {
                    response += line
                }
                userID = response
                print(userID)
            } catch {
                print("Error making API call: \(error.localizedDescription)")
            }
        }
}
struct RecreationGroundDetailView: View {
    let recreationGround: RecreationGround
    
    @State private var averageReviewScore: Double = 0.0
    @State private var reviews: [String] = [] // Array to store reviews
    @State private var parkApiResponse = ""
    @State private var writeAReviewForRecG = false
    @State private var images: [String] = []
    
    // Function to load recent reviews
    private func loadRecentReviews() async {
        let db = Firestore.firestore()
        let docRef = db.collection("RecG-Reviews").document(recreationGround.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let reviewContents = data["reviewcontent"] as? [String: String] else {
                print("No reviews found for \(recreationGround.name)")
                return
            }
            
            // Sort and limit reviews to the 3 most recent
            let sortedReviews = reviewContents.values.sorted { $0 < $1 }
            let recentReviews = sortedReviews.prefix(3)
            
            DispatchQueue.main.async {
                self.reviews = Array(recentReviews)
            }
            
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            Text(recreationGround.name)
                .font(.title)
                .foregroundColor(.primary)
            Text("Distance: \(recreationGround.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            
            HStack {
                Button(action: {
                    writeAReviewForRecG.toggle()
                }) {
                    Text("Write a Rec Ground review")
                }
                .sheet(isPresented: $writeAReviewForRecG) {
                    WriteaReviewforRecG(RecreationalGround: recreationGround)
                }
            } // Button to review the specific Park
            
            VStack {
                Text("Average user rating")
                VStack {
                    HStack {
                        Text("\(averageReviewScore, specifier: "%.1f")")
                        ForEach(1..<6) { star in
                            Image(systemName: "star.fill")
                                .foregroundColor(star <= Int(averageReviewScore) ? .yellow : .gray)
                        }
                    }
                } // Manages displaying the star graphic
            } // Average user rating numerical & Graphic
            
            ScrollView {
                ForEach(images.prefix(3), id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
            } // Shows images sourced from Google Custom Search
            
            VStack {
                if parkApiResponse.contains("\(recreationGround.name) has been called for") {
                    Text("A valid resource call has been made for \(recreationGround.name)")
                }
                if parkApiResponse.contains("Swings") {
                    RoundedRectangle(cornerRadius: 25)
                        .overlay {
                            VStack {
                                Text("Swings - YES")
                                if parkApiResponse.contains("Toilets") { Text("Toilets - YES") }
                                if parkApiResponse.contains("Picnic tables") { Text("Picnic tables - YES") }
                                if parkApiResponse.contains("Water fountains") { Text("Water Fountains - YES") }
                                if parkApiResponse.contains("Parking") {
                                    HStack {
                                        Text("Vehicle Parking")
                                        Image(systemName: "parkingsign.square.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .opacity(0.2)
                }
            } // Displays park amenities from the API
            
            VStack {
                Text("User Reviews")
                    .bold()
                
                if reviews.isEmpty {
                    Text("Loading reviews...")
                        .padding()
                } else {
                    ForEach(reviews, id: \.self) { review in
                        Text(review)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .padding(.bottom, 4)
                    }
                }
            } // Shows the 3 most recent user reviews
        }
        .padding()
        .onAppear {
            Task {
                await getAverageReviewScore() // Obtain the average rating
                await loadRecentReviews() // Fetch and display recent reviews
                fetchImages(for: recreationGround.name) // Fetches images from Google Custom Search
            }
        } // Important functions that run when the ParkDetailView is shown
    }

    @MainActor
    private func getAverageReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("RecG-Reviews").document(recreationGround.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(recreationGround.name)")
                return
            }
            
            self.averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            
            print("Average review score for \(recreationGround.name) is \(averageReviewScore)")
            
            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])
            
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    func fetchImages(for query: String) {
        let apiKey = "AIzaSyCI4SnMVmTLu5AnP4OAc7hL2q0wZzLGVdU"
        let searchEngineId = "11a7a6286e5584772"
        let urlString = "https://www.googleapis.com/customsearch/v1?q=\(query)&cx=\(searchEngineId)&searchType=image&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let imageUrls = items.compactMap { $0["link"] as? String }
                    DispatchQueue.main.async {
                        self.images = imageUrls
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
} // View that shows the Individual Recreational Grounds data (name, distance, user-contributed rating, Photos, Amenities, The ability to leave a review)
struct ChildrensPlayAreasDetailView: View {
    let CPA: ChildrensPlayAreas
    @Binding var reviewContent: String
    @State private var averageReviewScore: Double = 0.0
    @State private var reviews: [String] = []
    @State private var parkApiResponse = ""
    @State private var WriteaReviewforRecG = false
    @State private var images: [String] = []
    @State private var WriteaReviewforCPA = false
    // Ensure to store API keys securely and not in the code directly
    let api = ChatGPTAPI(apiKey: "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")
    
    private func loadRecentCPAReviews() async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(CPA.name)
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let reviewContents = data["reviewcontent"] as? [String: String] else {
                print("No reviews found for \(CPA.name)")
                return
            }
            
            let sortedReviews = reviewContents.values.sorted { $0 < $1 }
            let recentReviews = sortedReviews.prefix(3)
            
            DispatchQueue.main.async {
                self.reviews = Array(recentReviews)
            }
            
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            Text(CPA.name)
                .font(.title)
                .foregroundColor(.primary)
            Text("Distance: \(CPA.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            
            HStack {
                Button(action: {
                    WriteaReviewforCPA.toggle()
                }) {
                    Text("Write a Playground review")
                }
                .sheet(isPresented: $WriteaReviewforCPA) {
                    ParkMapper.WriteaReviewforCPA(Childrensplayareas: CPA, reviewContent: $reviewContent)
                }
            }
            
            VStack {
                Text("Average user rating")
                VStack {
                    HStack {
                        Text("\(averageReviewScore, specifier: "%.1f")")
                        ForEach(1..<6) { star in
                            Image(systemName: "star.fill")
                                .foregroundColor(star <= Int(averageReviewScore) ? .yellow : .gray)
                        }
                    }
                }
            }
            
            ScrollView {
                ForEach(images.prefix(3), id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
            
            VStack {
                if parkApiResponse.contains("\(CPA.name) has been called for") {
                    Text("A valid resource call has been made for \(CPA.name)")
                }
                if parkApiResponse.contains("Swings") {
                    RoundedRectangle(cornerRadius: 25)
                        .overlay {
                            VStack {
                                Text("Swings - YES")
                                if parkApiResponse.contains("Toilets") { Text("Toilets - YES") }
                                if parkApiResponse.contains("Picnic tables") { Text("Picnic tables - YES") }
                                if parkApiResponse.contains("Water fountains") { Text("Water Fountains - YES") }
                                if parkApiResponse.contains("Parking") {
                                    HStack {
                                        Text("Vehicle Parking")
                                        Image(systemName: "parkingsign.square.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .opacity(0.2)
                }
            }
            
            VStack {
                Text("User Reviews")
                    .bold()
                
                if reviews.isEmpty {
                    Text("Loading reviews...")
                        .padding()
                } else {
                    ForEach(reviews, id: \.self) { review in
                        Text(review)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .padding(.bottom, 4)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await getAverageReviewScore(for: CPA)
                await loadRecentCPAReviews()
                fetchImages(for: CPA.name)
            }
        }
    }

    @MainActor
    private func getAverageReviewScore(for CPA: ChildrensPlayAreas) async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(CPA.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(CPA.name)")
                return
            }
            
            self.averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            
            print("Average review score for \(CPA.name) is \(averageReviewScore)")
            
            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])
            
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func loadRecentRecGReviews(for CPA: ChildrensPlayAreas) async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(CPA.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let reviewContents = data["reviewcontent"] as? [String: String] else {
                print("No reviews found for \(CPA.name)")
                return
            }
            
            let sortedReviews = reviewContents.sorted { $0.key < $1.key }
            let recentReviews = sortedReviews.prefix(3).map { $0.value }
            
            DispatchQueue.main.async {
                self.reviews = Array(recentReviews)
            }
            
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }

    private func fetchImages(for query: String) {
        let apiKey = "AIzaSyCI4SnMVmTLu5AnP4OAc7hL2q0wZzLGVdU"
        let searchEngineId = "11a7a6286e5584772"
        let urlString = "https://www.googleapis.com/customsearch/v1?q=\(query)&cx=\(searchEngineId)&searchType=image&key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let imageUrls = items.compactMap { $0["link"] as? String }
                    DispatchQueue.main.async {
                        self.images = imageUrls
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
struct ParkDetailView: View {
    let park: Park
    
    @State private var averageReviewScore: Double = 0.0
    @State private var reviews: [String] = [] // Array to store reviews
    @State private var line = ""
    @State private var writeaparkreview = false
    @State private var images: [String] = []
    
    // Initialize the ChatGPT API (Remember to store API keys securely)
    let api = ChatGPTAPI(apiKey: "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")
    
    var body: some View {
        VStack {
            Text(park.name)
                .font(.title)
                .foregroundColor(.primary)
            Text("Distance: \(park.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            
            HStack {
                Button(action: {
                    writeaparkreview.toggle()
                }) {
                    Text("Write a park review")
                }
                .sheet(isPresented: $writeaparkreview) {
                    WriteaReviewforPark(park: park)
                }
            } // Button to review the specific Park
            
            VStack {
                Text("Average user rating")
                VStack {
                    HStack {
                        Text("\(averageReviewScore, specifier: "%.1f")")
                        ForEach(1..<6) { star in
                            Image(systemName: "star.fill")
                                .foregroundColor(star <= Int(averageReviewScore) ? .yellow : .gray)
                        }
                    }
                } // Manages displaying the star graphic
            } // Average user rating numerical & Graphic
            
                ScrollView {
                    HStack {
                        ForEach(images.prefix(3), id: \.self) { imageUrl in
                            AsyncImage(url: URL(string: imageUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                } // Shows images sourced from Google Custom Search
             //GCSE Image Viewer
            VStack {
                if line.contains("\(park.name) has been called for") {
                    Text("A valid resource call has been made for \(park.name)")
                }
                if line.contains("Swings") {
                    RoundedRectangle(cornerRadius: 25)
                        .overlay {
                            VStack {
                                Text("Swings - YES")
                                if line.contains("Toilets") { Text("Toilets - YES") }
                                if line.contains("Picnic tables") { Text("Picnic tables - YES") }
                                if line.contains("Water fountains") { Text("Water Fountains - YES") }
                                if line.contains("Parking") {
                                    HStack {
                                        Text("Vehicle Parking")
                                        Image(systemName: "parkingsign.square.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .opacity(0.2)
                }
            } // Displays park amenities from the API
            
            VStack {
                Text("User Reviews")
                    .bold()
                
                if reviews.isEmpty {
                    Text("Loading reviews...")
                        .padding()
                } else {
                    ForEach(reviews, id: \.self) { review in
                        Text(review)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke())
                            .padding(.bottom, 4)
                    }
                }
            } // Shows the 3 most recent user reviews
        }
        .padding()
        .onAppear {
            Task {
                await fetchChatGPTParkResponse()
                await getAverageReviewScore() // Obtain the average rating
                await loadRecentReviews() // Fetch and display recent reviews
                fetchImages(for: park.name) // Fetches images from Google Custom Search
            }
        } // Important functions that run when the ParkDetailView is shown
    }

    @MainActor

   
    
    private func fetchChatGPTParkResponse() async {
        Task {
            do {
                let stream = try await api.sendMessageStream(text: "Give me a bullet point list of wwhat amenties are available at \(park.name), its coordinates are \(park.coordinate)")
                for try await line in stream {
                    print(line)
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        // Construct the prompt
    }






    private func getAverageReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("Park-Reviews").document(park.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(park.name)")
                return
            }
            
            self.averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            
            print("Average review score for \(park.name) is \(averageReviewScore)")
            
            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])
            
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func loadRecentReviews() async {
        let db = Firestore.firestore()
        let docRef = db.collection("Park-Reviews").document(park.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let reviewContents = data["reviewcontent"] as? [String: String] else {
                print("No reviews found for \(park.name)")
                return
            }
            
            // Sort reviews by keys or timestamps if available
            let sortedReviews = reviewContents.values.sorted { $0 < $1 } // Modify sorting if needed
            let recentReviews = sortedReviews.prefix(3)
            
            DispatchQueue.main.async {
                self.reviews = Array(recentReviews)
            }
            
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }

    func fetchImages(for query: String) {
        let apiKey = "AIzaSyCI4SnMVmTLu5AnP4OAc7hL2q0wZzLGVdU"
        let searchEngineId = "11a7a6286e5584772"
        let urlString = "https://www.googleapis.com/customsearch/v1?q=\(query)&cx=\(searchEngineId)&searchType=image&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    let imageUrls = items.compactMap { $0["link"] as? String }
                    DispatchQueue.main.async {
                        self.images = imageUrls
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
struct WriteaReviewforPark: View {
    @MainActor
    let park: Park

    @State private var starReview = 0
    @State private var reviewContent = ""
    @State private var reviewStarGrades = [false, false, false, false, false]
    @State private var averageReviewScore: Double?

    var body: some View {
        VStack {
            Text("Review \(park.name)")
                .font(.headline)
                .padding()

            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray)
                .opacity(0.8)
                .overlay {
                    TextField("What's your thoughts on \(park.name)?", text: $reviewContent)
                        .frame(height: 100)
                        .padding()
                }
                .padding()

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade-1])
                }
            }
            .padding()

            Button {
                Task {
                    await uploadParkReviewDataToFirebase()
                }
            } label: {
                Text("Publish review")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if let averageReviewScore = averageReviewScore {
                Text("Average Score: \(String(format: "%.2f", averageReviewScore))")
                    .padding()
            } else {
                Text("Calculating average score...")
                    .padding()
            }
        }
        .onAppear {
            Task {
                await getAverageParkReviewScore()
            }
        }
    }

    @ViewBuilder
    func starButton(grade: Int, isSelected: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation {
                starReview = isSelected.wrappedValue ? grade - 1 : grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
    }

    private func updateStarGrades(for grade: Int) {
        for i in 0..<5 {
            reviewStarGrades[i] = i < grade
        }
    }

    @MainActor
    func uploadParkReviewDataToFirebase() async {
        let db = Firestore.firestore()
        let docRef = db.collection("Park-Reviews").document(park.name)

        do {
            let document = try await docRef.getDocument()
            let reviewID = UUID().uuidString
            
            var reviewData: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1)),
                "reviewcontent.\(reviewID)": reviewContent
            ]

            if document.exists {
                // Update existing document
                try await docRef.updateData(reviewData)
            } else {
                // Create new document
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

            // Reload average review score after updating
            await getAverageParkReviewScore()

        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }
    func uploadRecGReviewDatatoFirebase() async {
        let db = Firestore.firestore()
        let docRef = db.collection("RecG-Reviews").document(park.name)

        do {
            let document = try await docRef.getDocument()
            let reviewID = UUID().uuidString
            
            var reviewData: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1)),
                "reviewcontent.\(reviewID)": reviewContent
            ]

            if document.exists {
                // Update existing document
                try await docRef.updateData(reviewData)
            } else {
                // Create new document
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

            // Reload average review score after updating
            await getAverageParkReviewScore()

        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }
    @MainActor
    func getAverageParkReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("Park-Reviews").document(park.name)

        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(park.name)")
                return
            }

            let averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            self.averageReviewScore = averageReviewScore

            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])

        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    func getAverageRecGReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("Park-Reviews").document(park.name)

        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(park.name)")
                return
            }

            let averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            self.averageReviewScore = averageReviewScore

            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])

        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }
}
struct WriteaReviewforRecG: View {
    @MainActor
    func getAverageReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("ParkMapper-User-Reviews").document(RecreationalGround.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(RecreationalGround.name)")
                await setInitialValues(for: docRef)
                return
            }
            
            let averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            print("Average review score for \(RecreationalGround.name) is \(averageReviewScore)")
            
            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])
            
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func setInitialValues(for docRef: DocumentReference) async {
        do {
            try await docRef.setData([
                "star-rating": 0,
                "review-number": 1,
                "reviewcontent": "",
                "averagereviewscore": 0.0
            ])
        } catch {
            print("Error setting initial values: \(error.localizedDescription)")
        }
    }

    let RecreationalGround: RecreationGround

    @State var starReview = 0
    @State private var reviewContent = ""
    @State private var reviewStarGrades = [false, false, false, false, false]
    let numberOfReviews = 0
    
    var body: some View {
        VStack {
            Text("Review \(RecreationalGround.name)")
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray)
                .opacity(0.8)
                .overlay {
                    TextField("What's your thought's on \(RecreationalGround.name)", text: $reviewContent)
                        .frame(width: 300, height: 300)
                }

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade-1])
                }
            }

            Button {
                Task {
                    await uploadRecreationalGroundReviewDataToFirebase()
                }
            } label: {
                Text("Publish review")
            }
        }
        .onAppear {
            Task {
                await getAverageReviewScore()
            }
        }
    }
    
    @ViewBuilder
    func starButton(grade: Int, isSelected: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation {
                starReview = isSelected.wrappedValue ? grade - 1 : grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
    }

    func updateStarGrades(for grade: Int) {
        for i in 0..<5 {
            reviewStarGrades[i] = i < grade
        }
    }

    @MainActor
    func uploadRecreationalGroundReviewDataToFirebase() async {
        let db = Firestore.firestore()
        let docRef = db.collection("RecG-Reviews").document(RecreationalGround.name)

        do {
            let document = try await docRef.getDocument()
            let data: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1)),
                "reviewcontent": reviewContent
            ]
            
            if document.exists {
                try await docRef.updateData(data)
            } else {
                try await docRef.setData(data)
            }
            
        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }
} //View to compile a review for the specific Recreation Ground
struct WriteaReviewforCPA: View {
    @MainActor
    func getAverageReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(Childrensplayareas.name)
        
        do {
            let document = try await docRef.getDocument()
            guard let data = document.data(),
                  let numberOfReviews = data["review-number"] as? Int,
                  numberOfReviews > 0,
                  let totalScore = data["star-rating"] as? Int else {
                print("No valid reviews found for \(Childrensplayareas.name)")
                await setInitialValues(for: docRef)
                return
            }
            
            let averageReviewScore = Double(totalScore) / Double(numberOfReviews)
            print("Average review score for \(Childrensplayareas.name) is \(averageReviewScore)")
            
            try await docRef.updateData([
                "averagereviewscore": averageReviewScore
            ])
            
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func setInitialValues(for docRef: DocumentReference) async {
        do {
            try await docRef.setData([
                "star-rating": 0,
                "review-number": 1,
                "reviewcontent": reviewContent,
                "averagereviewscore": 0.0
            ])
        } catch {
            print("Error setting initial values: \(error.localizedDescription)")
        }
    }

    let Childrensplayareas: ChildrensPlayAreas

    @State var starReview = 0
    @Binding var reviewContent: String
    @State private var reviewStarGrades = [false, false, false, false, false]
    let numberOfReviews = 0
    
    var body: some View {
        VStack {
            Text("Review \(Childrensplayareas.name)")
            
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray)
                .opacity(0.8)
                .overlay {
                    TextField("What's your thought's on \(Childrensplayareas.name)", text: $reviewContent)
                        .frame(width: 300, height: 300)
                }

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade-1])
                }
            }

            Button {
                Task {
                    do {
                        await uploadCPAReviewDatatoFirebase(for: Childrensplayareas, starReview: 0, reviewContent: "")
                    }
                }
            } label: {
                Text("Publish review")
            }
        }
        .onAppear {
            Task {
                await getAverageReviewScore()
            }
        }
    }
    
    @ViewBuilder
    func starButton(grade: Int, isSelected: Binding<Bool>) -> some View {
        Button(action: {
            withAnimation {
                starReview = isSelected.wrappedValue ? grade - 1 : grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
    }

    func updateStarGrades(for grade: Int) {
        for i in 0..<5 {
            reviewStarGrades[i] = i < grade
        }
    }
    private func uploadCPAReviewDatatoFirebase(for CPA: ChildrensPlayAreas, starReview: Int, reviewContent: String) async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(CPA.name)
        
        do {
            let document = try await docRef.getDocument()
            let reviewID = UUID().uuidString

            // The basic data to increment star rating and review count
            var reviewData: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1))
            ]

            if document.exists {
                // Update existing document by adding the new review content under a unique ID
                try await docRef.updateData([
                    "reviewcontent.\(reviewID)": reviewContent
                ])
                
                // Also update the star-rating and review-number
                try await docRef.updateData(reviewData)
            } else {
                // Create a new document with the review content as a dictionary
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

            // Reload average review score after updating
            await getAverageCPAReviewScore(for: CPA)

        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }

} //View to compile a review for the specific Playground
func getAverageCPAReviewScore(for CPA: ChildrensPlayAreas) async {
    let db = Firestore.firestore()
    let docRef = db.collection("CPA-Reviews").document(CPA.name)

    do {
        let document = try await docRef.getDocument()
        guard let data = document.data(),
              let numberOfReviews = data["review-number"] as? Int,
              numberOfReviews > 0,
              let totalScore = data["star-rating"] as? Double else {
            print("No valid reviews found for \(CPA.name)")
            return
        }

        var averageReviewScore = totalScore / Double(numberOfReviews)
        try await docRef.updateData([
            "averagereviewscore": averageReviewScore
        ])

    } catch {
        print("Error fetching or updating document: \(error.localizedDescription)")
    }
}
//REVIEW CONTENT
//Random review ID - 12 Character String
//Star rating as determined by user.  {{Will need to be added in the back end and divide by total number of reviews to show an average}}
//Free text opinion - pending moderation to comply with ARG

final class HomeMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: -120), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @Published var parks: [Park] = []
    @Published var recreationalGrounds: [RecreationGround] = []
    @Published var childrensPlayAreas: [ChildrensPlayAreas] = []
    @Published var closestParks: [Park] = []
    @Published var closestCPAs: [ChildrensPlayAreas] = []
    @Published var closestRGs: [RecreationGround] = []
    
    private var userLocation: CLLocation?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        DispatchQueue.main.async {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        }
    }
    
     func centerOnUserLocation() {
        guard let location = userLocation else {
            print("userLocation is nil")
            return
        }
        DispatchQueue.main.async {
            do {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                try self.fetchParks(near: location)
                try self.fetchRecreationalGrounds(near: location)
                try self.fetchChildrensPlayAreas(near: location)
            } catch {
                print("Error: \(error.localizedDescription)")
                // Handle error appropriately
            }
        }
    }
    
    func searchLocation(searchQuery: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchQuery) { placemarks, error in
            guard let placemark = placemarks?.first,
                  let location = placemark.location else { return }
            
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                self.fetchParks(near: location)
                self.fetchRecreationalGrounds(near: location)
                self.fetchChildrensPlayAreas(near: location)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        userLocation = latestLocation
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.fetchParks(near: latestLocation)
            self.fetchRecreationalGrounds(near: latestLocation)
            self.fetchChildrensPlayAreas(near: latestLocation)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    private func fetchParks(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "park"
        request.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for parks: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            self.parks = mapItems.compactMap { item in
                guard let itemLocation = item.placemark.location else {
                    print("Error: Park location is nil")
                    return nil
                }
                let distance = location.distance(from: itemLocation) / 1609.34
                return Park(name: item.name ?? "Unknown Park", coordinate: item.placemark.coordinate, distance: distance)
            }
            
            self.closestParks = self.parks.sorted { $0.distance < $1.distance }
        }
    }
    
    private func fetchRecreationalGrounds(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Recreation Grounds"
        request.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for Recreation Grounds: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            self.recreationalGrounds = mapItems.compactMap { item in
                guard let itemLocation = item.placemark.location else {
                    print("Error: Recreation Ground location is nil")
                    return nil
                }
                let distance = location.distance(from: itemLocation) / 1609.34
                return RecreationGround(name: item.name ?? "Unknown Recreation Ground", coordinate: item.placemark.coordinate, distance: distance)
            }
            
            self.closestRGs = self.recreationalGrounds.sorted { $0.distance < $1.distance }
        }
    }
    
    private func fetchChildrensPlayAreas(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Playgrounds"
        request.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for Children's play areas: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            self.childrensPlayAreas = mapItems.compactMap { item in
                guard let itemLocation = item.placemark.location else {
                    print("Error: Children's play area location is nil")
                    return nil
                }
                let distance = location.distance(from: itemLocation) / 1609.34
                return ChildrensPlayAreas(name: item.name ?? "Unknown Children's play area", coordinate: item.placemark.coordinate, distance: distance)
            }
            
            self.closestCPAs = self.childrensPlayAreas.sorted { $0.distance < $1.distance }
        }
    }
}

//Data used with MK
struct Park: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    var coordinate: CLLocationCoordinate2D
    var distance: Double
    
    static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.distance == rhs.distance
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(distance)
    }
}
struct RecreationGround: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    var coordinate: CLLocationCoordinate2D
    var distance: Double
    
    static func == (lhs: RecreationGround, rhs: RecreationGround) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.distance == rhs.distance
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(distance)
    }
}
struct ChildrensPlayAreas: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    var coordinate: CLLocationCoordinate2D
    var distance: Double
    
    static func == (lhs: ChildrensPlayAreas, rhs: ChildrensPlayAreas) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude &&
        lhs.distance == rhs.distance
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(distance)
    }
}
