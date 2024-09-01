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
        Form {
            Section("Help & Support") {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "envolope")
                        Text ("Send an Email to Support")
                    })
                }
            }
        }
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

struct NewSupportCaseView: View {
    var body: some View {
        VStack {
            Text ("Contact Support")
                .font(.title)
        } //Page Header
        
        VStack {
            Text ("your UUID IS: UnitaryFigure")
        }
        Spacer()
    }
}
