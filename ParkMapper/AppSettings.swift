//
//  AppSettings.swift
//  ParkMapper
//
//  Created by Jacob Peacey on 8/26/24.
//

import SwiftUI

struct AppSettings: View {
    var body: some View {
        VStack {
            HStack {
                Text ("Settings")
                Spacer()
            }
        } //Page Title
        Spacer()
        HStack {
            Text ("Current app version: \(getAppVersion())")
                .font(.footnote)
        } //Current app version
    }
}
func getAppVersion() -> String {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return appVersion
    }
    return "Unknown"
} //Gets current application version from dictionary
