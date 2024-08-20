import SwiftUI
import MapKit
import ChatGPTSwift
import CoreLocation
import Aptabase


struct HomeMapView: View {
    @StateObject private var viewModel = HomeMapViewModel()
    @State private var searchQuery = ""
    @State private var selectedPark: Park?
    @State private var selectedRecreationalGround: RecreationGround?
    @State private var selectedChildrensPlayArea: ChildrensPlayAreas?
    @State private var showClosestParksInfoSheet = false
    @State private var showClosestChildrensPlayAreasInfoSheet = false
    @State private var showClosestRecreationalGroundInfoSheet = false
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.parks) { park in
                MapAnnotation(coordinate: park.coordinate) {
                    Button(action: {
                        selectedPark = park
                    }) {
                        Image(systemName: "park")
                            .foregroundColor(.green)
                            .font(.title)
                    }
                }
            }
            .overlay(
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.recreationalGrounds) { ground in
                    MapAnnotation(coordinate: ground.coordinate) {
                        Button(action: {
                            selectedRecreationalGround = ground
                        }) {
                            Image(systemName: "building.2.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                    }
                }
            )
            .overlay(
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.childrensPlayAreas) { area in
                    MapAnnotation(coordinate: area.coordinate) {
                        Button(action: {
                            selectedChildrensPlayArea = area
                        }) {
                            Image(systemName: "playground")
                                .foregroundColor(.purple)
                                .font(.title)
                        }
                    }
                }
            )
            .ignoresSafeArea()
            
            VStack {
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
                
                Spacer()
                
                if showClosestParksInfoSheet {
                    if !viewModel.closestParks.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Nearest Parks")
                                .font(.headline)
                                .padding(.leading)
                            
                            List(viewModel.closestParks.prefix(5), id: \.id) { park in
                                Button(action: {
                                    selectedPark = park
                                }) {
                                    HStack {
                                        Text(park.name)
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
                            Text("Nearest Children's Play Areas")
                                .font(.headline)
                                .padding(.leading)
                            
                            List(viewModel.closestCPAs.prefix(5), id: \.id) { area in
                                Button(action: {
                                    selectedChildrensPlayArea = area
                                }) {
                                    HStack {
                                        Text(area.name)
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
                            Text("Nearest Recreational Grounds")
                                .font(.headline)
                                .padding(.leading)
                            List(viewModel.closestRGs.prefix(5), id: \.id) { ground in
                                Button(action: {
                                    selectedRecreationalGround = ground
                                }) {
                                    HStack {
                                        Text(ground.name)
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
            RecreationGroundDetailView(recreationalGround: ground)
        }
        .sheet(item: $selectedChildrensPlayArea) { area in
            ChildrensPlayAreasDetailView(childrensPlayAreas: area)
        }
    }
}


























struct ParkDetailView: View {
    let park: Park
    @State private var parkapiresponse = ""
    let api = ChatGPTAPI(apiKey: "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")
    var body: some View {
        VStack {
            Text("Park Details")
                .font(.largeTitle)
            Text("Name: \(park.name)")
            Text("Distance: \(park.distance, specifier: "%.2f") miles")
            
            Spacer()
        }
        .padding()
        .onAppear() {
            makeapiCallWithParkData()
        }
        
    }
    private func makeapiCallWithParkData() {
        Task {
            Aptabase.shared.trackEvent("Api Calls Made")
            do {
                var stream = try await api.sendMessageStream(text: "tell me about \(park.name) at \(park.coordinate). Limit your response to 100 characters, including only the most crucial information, such as what amenities the park has to offer. Ensure you include a list of the play equipment.")
                
                for try await line in stream {
                    parkapiresponse += line
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                parkapiresponse = "Failed to retrieve information."
            }
        }
    }
    
}
struct RecreationGroundDetailView: View {
    let recreationalGround: RecreationGround
    @State private var recreationalgroundapiresponse = ""
    let api = ChatGPTAPI(apiKey: "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")
    var body: some View {
        VStack {
            Text("Recreational Ground Details")
                .font(.largeTitle)
            Text("Name: \(recreationalGround.name)")
            Text("Distance: \(recreationalGround.distance, specifier: "%.2f") miles")
            
            Spacer()
        }
        .padding()
        .onAppear() {
            makeapiCallWithRecrerationalGroundData()
        }
    }
    private func makeapiCallWithRecrerationalGroundData() {
        Task {
            Aptabase.shared.trackEvent("Api Calls Made")
            do {
                var stream = try await api.sendMessageStream(text: "tell me about \(recreationalGround.name) at \(recreationalGround.coordinate). Limit your response to 100 characters, including only the most crucial information, such as what amenities the park has to offer. Ensure you include a list of the play equipment.")
                
                for try await line in stream {
                    recreationalgroundapiresponse += line
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                recreationalgroundapiresponse = "Failed to retrieve information."
            }
        }
    }
}
struct ChildrensPlayAreasDetailView: View {
    @State private var childrensplayareaapiresponse = ""
    let childrensPlayAreas: ChildrensPlayAreas
    let api = ChatGPTAPI(apiKey: "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")
    
    var body: some View {
        VStack {
            Text("Children's Play Area Details")
                .font(.largeTitle)
            Text("Name: \(childrensPlayAreas.name)")
            Text("Distance: \(childrensPlayAreas.distance, specifier: "%.2f") miles")
            Text("About this play area: \(childrensplayareaapiresponse)")
            Spacer()
        }
        .padding()
        .onAppear {
            makeApiCallWithChildrensPlayAreaData()
        }
    }
    private func makeApiCallWithChildrensPlayAreaData() {
        Task {
            Aptabase.shared.trackEvent("Api Calls Made")
            do {
                var stream = try await api.sendMessageStream(text: "tell me about \(childrensPlayAreas.name) at \(childrensPlayAreas.coordinate). Limit your response to 100 characters, including only the most crucial information, such as what amenities the park has to offer. Ensure you include a list of the play equipment.")
                
                for try await line in stream {
                    childrensplayareaapiresponse += line
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                childrensplayareaapiresponse = "Failed to retrieve information."
            }
        }
    }
}
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
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func centerOnUserLocation() {
        guard let location = userLocation else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.fetchParks(near: location)
            self.fetchRecreationalGrounds(near: location)
            self.fetchChildrensPlayAreas(near: location)
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
            self.parks = mapItems.map { item in
                let distance = location.distance(from: item.placemark.location!) / 1609.34
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
            self.recreationalGrounds = mapItems.map { item in
                let distance = location.distance(from: item.placemark.location!) / 1609.34
                return RecreationGround(name: item.name ?? "Unknown Recreation Ground", coordinate: item.placemark.coordinate, distance: distance)
            }
            
            self.closestRGs = self.recreationalGrounds.sorted { $0.distance < $1.distance }
        }
    }
    
    private func fetchChildrensPlayAreas(near location: CLLocation) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Children's play areas"
        request.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for Children's play areas: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let mapItems = response.mapItems
            self.childrensPlayAreas = mapItems.map { item in
                let distance = location.distance(from: item.placemark.location!) / 1609.34
                return ChildrensPlayAreas(name: item.name ?? "Unknown Children's play area", coordinate: item.placemark.coordinate, distance: distance)
            }
            
            self.closestCPAs = self.childrensPlayAreas.sorted { $0.distance < $1.distance }
        }
    }
}
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
