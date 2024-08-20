//
//  ParkMapperApp.swift
//  ParkMapper
//
//  Created by Jacob Peacey on 8/19/24.
//

import SwiftUI
import Aptabase

@main
struct ParkMapperApp: App {
    init() {
        Aptabase.shared.initialize(appKey: "A-EU-9927707438") // 👈 this is where you enter your App Key
    }
    var body: some Scene {
        WindowGroup {
            HomeMapView()
                .onAppear() {
                    Aptabase.shared.trackEvent("New session")
                }
        }
        

    }
}
