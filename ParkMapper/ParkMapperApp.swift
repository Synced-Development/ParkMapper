//
//  ParkMapperApp.swift
//  ParkMapper
//
//  Created by Jacob Peacey on 8/19/24.
//

import SwiftUI
import Aptabase
import FirebaseCore
import ChatGPTSwift

@main
struct ParkMapperApp: App {
    @AppStorage ("UserhasBeenIdentifed") var UserhasBeenIdentifed = false
    @State private var showClosestParksInfoSheet: Bool = false
    @State private var showClosestChildrensPlayAreasInfoSheet: Bool = false
    @State private var showClosestRecreationalGroundInfoSheet: Bool = false
    @State private var reviewContent: String = ""
    init() {
        FirebaseApp.configure()
        Aptabase.shared.initialize(appKey: "A-EU-9927707438") // 👈 this is where you enter your App Key
        
    }

    var body: some Scene {
        WindowGroup {
            HomeMapView(
                showClosestParksInfoSheet: $showClosestParksInfoSheet, reviewContent: $reviewContent,
                showClosestChildrensPlayAreasInfoSheet: $showClosestChildrensPlayAreasInfoSheet,
                showClosestRecreationalGroundInfoSheet: $showClosestRecreationalGroundInfoSheet
            )
            .onAppear {
                Aptabase.shared.trackEvent("New session")
            }
        }
    }
}


