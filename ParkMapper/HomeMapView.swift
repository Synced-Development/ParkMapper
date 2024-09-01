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
                Spacer()
                if showClosestParksInfoSheet {
                    if !viewModel.closestParks.isEmpty {
                        VStack(alignment: .leading) {
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
                            } //Searchbar, location pin and filter icon
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
                   
                    if !viewModel.closestCPAs.isEmpty {
                        VStack(alignment: .leading) {
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
                            } //Searchbar, location pin and filter icon
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
                   
                    if !viewModel.closestRGs.isEmpty {
                        VStack(alignment: .leading) {
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
                            } //Searchbar, location pin and filter icon
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
            ChildrensPlayAreasDetailView(CPA: area)
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
    @State private var reviews: [String] = []
    @State private var parkApiResponse = ""
    @State private var writeReviewSheetPresented = false
    @State private var images: [String] = []
    
    var body: some View {
        VStack {
            Text(recreationGround.name)
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Distance: \(recreationGround.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            
            writeReviewButton
            averageRatingView
            imageScrollView
            amenitiesListView
            userReviewsSection
        }
        .padding()
        .onAppear(perform: onAppear)
        .sheet(isPresented: $writeReviewSheetPresented) {
            WriteaReviewforRecG(RecreationalGround: recreationGround)
        }
    }
    
    private var writeReviewButton: some View {
        Button(action: {
            writeReviewSheetPresented.toggle()
        }) {
            Text("Write a Rec Ground Review")
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke())
        }
    }
    
    private var averageRatingView: some View {
        VStack {
            Text("Average user rating")
            HStack {
                Text("\(averageReviewScore, specifier: "%.1f")")
                ForEach(1..<6) { star in
                    Image(systemName: "star.fill")
                        .foregroundColor(star <= Int(averageReviewScore) ? .yellow : .gray)
                }
            }
        }
        .padding(.vertical)
    }
    
    private var imageScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(images.prefix(3), id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var amenitiesListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amenities")
                .font(.headline)
            
            if parkApiResponse.contains("Swings") {
                Text("• Swings")
            }
            if parkApiResponse.contains("Toilets") {
                Text("• Toilets")
            }
            if parkApiResponse.contains("Picnic tables") {
                Text("• Picnic tables")
            }
            if parkApiResponse.contains("Water fountains") {
                Text("• Water fountains")
            }
            if parkApiResponse.contains("Parking") {
                HStack {
                    Text("• Vehicle Parking")
                    Image(systemName: "parkingsign.square.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical)
    }
    
    private var userReviewsSection: some View {
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
        .padding(.vertical)
    }
    
    private func onAppear() {
        Task {
            await getAverageReviewScore()
            await loadRecentReviews()
            fetchImages(for: recreationGround.name)
        }
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
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }
    
    @MainActor
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
            
            let sortedReviews = reviewContents.values.sorted { $0 < $1 }
            let recentReviews = sortedReviews.prefix(3)
            
            self.reviews = Array(recentReviews)
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }
    
    private func fetchImages(for query: String) {
        let apiKey = "YOUR_API_KEY"
        let searchEngineId = "YOUR_SEARCH_ENGINE_ID"
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
struct ChildrensPlayAreasDetailView: View {
    let CPA: ChildrensPlayAreas
    
    @State private var averageReviewScore: Double = 0.0
    @State private var reviews: [String] = []
    @State private var parkApiResponse = ""
    @State private var writeReviewSheetPresented = false
    @State private var images: [String] = []
    
    var body: some View {
        VStack {
            Text(CPA.name)
                .font(.title)
                .foregroundColor(.primary)
            
            Text("Distance: \(CPA.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            
            writeReviewButton
            averageRatingView
            imageScrollView
            amenitiesListView
            userReviewsSection
        }
        .padding()
        .onAppear(perform: onAppear)
        .sheet(isPresented: $writeReviewSheetPresented) {
            WriteaReviewforCPA(Childrensplayareas: CPA)
        }
    }
    
    private var writeReviewButton: some View {
        Button(action: {
            writeReviewSheetPresented.toggle()
        }) {
            Text("Review \(CPA.name)")
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke())
        }
    }
    
    private var averageRatingView: some View {
        VStack {
            Text("Average user rating")
            HStack {
                Text("\(averageReviewScore, specifier: "%.1f")")
                ForEach(1..<6) { star in
                    Image(systemName: "star.fill")
                        .foregroundColor(star <= Int(averageReviewScore) ? .yellow : .gray)
                }
            }
        }
        .padding(.vertical)
    }
    
    private var imageScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(images.prefix(3), id: \.self) { imageUrl in
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 200, height: 200)
                    }
                }
            }
        }
        .padding(.vertical)
    }
    
    private var amenitiesListView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Amenities")
                .font(.headline)
            
            if parkApiResponse.contains("Swings") {
                Text("• Swings")
            }
            if parkApiResponse.contains("Toilets") {
                Text("• Toilets")
            }
            if parkApiResponse.contains("Picnic tables") {
                Text("• Picnic tables")
            }
            if parkApiResponse.contains("Water fountains") {
                Text("• Water fountains")
            }
            if parkApiResponse.contains("Parking") {
                HStack {
                    Text("• Vehicle Parking")
                    Image(systemName: "parkingsign.square.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical)
    }
    
    private var userReviewsSection: some View {
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
        .padding(.vertical)
    }
    
    private func onAppear() {
        Task {
            await getAverageReviewScore(for: CPA)
            await loadRecentCPAReviews()
            fetchImages(for: CPA.name)
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
        } catch {
            print("Error fetching or updating document: \(error.localizedDescription)")
        }
    }
    
    @MainActor
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
            
            self.reviews = Array(recentReviews)
        } catch {
            print("Error fetching recent reviews: \(error.localizedDescription)")
        }
    }
    
    private func fetchImages(for query: String) {
        let apiKey = "YOUR_API_KEY"
        let searchEngineId = "YOUR_SEARCH_ENGINE_ID"
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
    @State private var reviews: [String] = []
    @State private var writeaparkreview = false
    @State private var images: [String] = []
    @State private var amenities: [String] = []  // State variable to store amenities

    let api = ChatGPTAPI(apiKey: "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")
    
    var body: some View {
        VStack {
            Text(park.name)
                .font(.title)
                .foregroundColor(.primary)
            Text("Distance: \(park.distance, specifier: "%.2f") miles")
                .font(.subheadline)
            

            
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
            }
            
            VStack(alignment: .leading) {
                Text("Amenities")
                    .font(.headline)
                    .padding(.top)
                
                if amenities.isEmpty {
                    Text("Loading amenities...")
                        .padding(.top)
                } else {
                    ForEach(amenities, id: \.self) { amenity in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(amenity)
                        }
                        .padding(.vertical, 2)
                    }
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
                HStack {
                    Button(action: {
                        writeaparkreview.toggle()
                    }) {
                        Text("Review \(park.name)")
                    }
                    .sheet(isPresented: $writeaparkreview) {
                        WriteaReviewforPark(park: park)
                    }
                }
            } //Current user reviews and review (park.name)
        }
        .padding()
        .onAppear {
            Task {
                await fetchChatGPTParkResponse()
                await getAverageReviewScore()
                await loadRecentReviews()
                fetchImages(for: park.name)
            }
        }
    }

    @MainActor
    private func fetchChatGPTParkResponse() async {
        do {
            var fullResponse = ""
            let stream = try await api.sendMessageStream(text: "Give me a bullet point list of what amenities are available at \(park.name), its coordinates are \(park.coordinate). Be as efficient as you can limiting your response to 75 words")
            for try await line in stream {
                fullResponse += line
            }
            // Split the response into bullet points
            let amenityList = fullResponse.components(separatedBy: "\n").filter { !$0.isEmpty }
            self.amenities = amenityList
        } catch {
            print(error.localizedDescription)
        }
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
            
            let sortedReviews = reviewContents.values.sorted { $0 < $1 }
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
        VStack(alignment: .leading) {
            Text("Review \(park.name)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            TextEditor(text: $reviewContent)
                .frame(height: 150)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.bottom, 10)
                .overlay(
                    Text(reviewContent.isEmpty ? "What's your thoughts on \(park.name)?" : "")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10),
                    alignment: .topLeading
                )

            Text("Rate this park:")
                .font(.headline)
                .padding(.bottom, 5)

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade - 1])
                }
            }
            .padding(.bottom, 20)

            Button(action: {
                Task {
                    await uploadParkReviewDataToFirebase()
                }
            }) {
                Text("Publish Review")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)

            if let averageReviewScore = averageReviewScore {
                Text("Average Score: \(String(format: "%.2f", averageReviewScore))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            } else {
                Text("Calculating average score...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .padding()
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
                starReview = grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected.wrappedValue ? .yellow : .gray)
                .scaleEffect(isSelected.wrappedValue ? 1.1 : 1.0)
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
                try await docRef.updateData(reviewData)
            } else {
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

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
}
struct WriteaReviewforRecG: View {
    @MainActor
    let RecreationalGround: RecreationGround

    @State private var starReview = 0
    @State private var reviewContent = ""
    @State private var reviewStarGrades = [false, false, false, false, false]
    @State private var averageReviewScore: Double?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Review \(RecreationalGround.name)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            TextEditor(text: $reviewContent)
                .frame(height: 150)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.bottom, 10)
                .overlay(
                    Text(reviewContent.isEmpty ? "What's your thought's on \(RecreationalGround.name)?" : "")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10),
                    alignment: .topLeading
                )

            Text("Rate this recreational ground:")
                .font(.headline)
                .padding(.bottom, 5)

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade - 1])
                }
            }
            .padding(.bottom, 20)

            Button(action: {
                Task {
                    await uploadRecreationalGroundReviewDataToFirebase()
                }
            }) {
                Text("Publish Review")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)

            if let averageReviewScore = averageReviewScore {
                Text("Average Score: \(String(format: "%.2f", averageReviewScore))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            } else {
                Text("Calculating average score...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .padding()
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
                starReview = grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected.wrappedValue ? .yellow : .gray)
                .scaleEffect(isSelected.wrappedValue ? 1.1 : 1.0)
        }
    }

    private func updateStarGrades(for grade: Int) {
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
            let reviewID = UUID().uuidString
            
            var reviewData: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1)),
                "reviewcontent.\(reviewID)": reviewContent
            ]

            if document.exists {
                try await docRef.updateData(reviewData)
            } else {
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

            await getAverageReviewScore()

        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }

    @MainActor
    func getAverageReviewScore() async {
        let db = Firestore.firestore()
        let docRef = db.collection("RecG-Reviews").document(RecreationalGround.name)
        
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
            self.averageReviewScore = averageReviewScore

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
}
struct WriteaReviewforCPA: View {
    let Childrensplayareas: ChildrensPlayAreas

    @State private var starReview = 0
    @State private var reviewContent = ""
    @State private var reviewStarGrades = [false, false, false, false, false]
    @State private var averageReviewScore: Double?

    var body: some View {
        VStack(alignment: .leading) {
            Text("Review \(Childrensplayareas.name)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            TextEditor(text: $reviewContent)
                .frame(height: 150)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding(.bottom, 10)
                .overlay(
                    Text(reviewContent.isEmpty ? "What's your thought's on \(Childrensplayareas.name)?" : "")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10),
                    alignment: .topLeading
                )

            Text("Rate \(Childrensplayareas.name)")
                .font(.headline)
                .padding(.bottom, 5)

            HStack {
                ForEach(1...5, id: \.self) { grade in
                    starButton(grade: grade, isSelected: $reviewStarGrades[grade - 1])
                }
            }
            .padding(.bottom, 20)

            Button(action: {
                Task {
                    await uploadCPAReviewDatatoFirebase()
                }
            }) {
                Text("Publish Review")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(8)
            }
            .padding(.bottom, 10)

            if let averageReviewScore = averageReviewScore {
                Text("Average Score: \(String(format: "%.2f", averageReviewScore))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            } else {
                Text("Calculating average score...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .padding()
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
                starReview = grade
                updateStarGrades(for: grade)
            }
        }) {
            Image(systemName: isSelected.wrappedValue ? "star.fill" : "star")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected.wrappedValue ? .yellow : .gray)
                .scaleEffect(isSelected.wrappedValue ? 1.1 : 1.0)
        }
    }

    private func updateStarGrades(for grade: Int) {
        for i in 0..<5 {
            reviewStarGrades[i] = i < grade
        }
    }

    @MainActor
    func uploadCPAReviewDatatoFirebase() async {
        let db = Firestore.firestore()
        let docRef = db.collection("CPA-Reviews").document(Childrensplayareas.name)

        do {
            let document = try await docRef.getDocument()
            let reviewID = UUID().uuidString
            
            var reviewData: [String: Any] = [
                "star-rating": FieldValue.increment(Int64(starReview)),
                "review-number": FieldValue.increment(Int64(1)),
                "reviewcontent.\(reviewID)": reviewContent
            ]

            if document.exists {
                try await docRef.updateData(reviewData)
            } else {
                reviewData["star-rating"] = starReview
                reviewData["review-number"] = 1
                reviewData["reviewcontent"] = [reviewID: reviewContent]
                
                try await docRef.setData(reviewData)
            }

            await getAverageReviewScore()

        } catch {
            print("Error updating Firestore: \(error.localizedDescription)")
        }
    }

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
            self.averageReviewScore = averageReviewScore

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
}
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
