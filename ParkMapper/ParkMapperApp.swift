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
    @AppStorage ("hassavedkey") var hassavedkey = false
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
                if !hassavedkey {
                    storeAPIKey()
                }
                Aptabase.shared.trackEvent("New session")
            }
        }
    }
}


// Manually run this code once to store the API key
func storeAPIKey() {
    @AppStorage ("hassavedkey") var hassavedkey = false
    let apiKey = "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"  // Replace with your actual API key
    Config.saveAPIKey(apiKey)
    hassavedkey = true
}
