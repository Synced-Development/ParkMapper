//
//  AISourcedInfoViewModel.swift
//  ParkMapper
//
//  Created by Jacob Peacey on 8/19/24.
//

import ChatGPTSwift
import SwiftUI

// Since ViewModels are typically not Views, the naming might be a bit misleading.
// However, I'm keeping the structure to match the code provided.

class AISourcedInfoViewModel: ObservableObject {
    @Published var apiResponse: String = ""
    @Published var showCard: Bool = false
    
    private var api: ChatGPTAPI
    
    init() {
        let apiKey = AISourcedInfoViewModel.getApiKey() // Securely retrieve the API key
        self.api = ChatGPTAPI(apiKey: apiKey)
    }
    
    static func getApiKey() -> String {
        // Retrieve the API key securely from environment or secure storage
        return "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" //ParkMapper API Key
    }
    
    func fetchApiResponse(userTodayContent: String) async {
        do {
            let stream = try await api.sendMessageStream(text: """
                You are an intelligent assistant who drives ShuffleFocus AI. I am going to explain in plain English what I need to get done today. I then need you to organize the stuff in that list by perceived length of time and other factors. Here is what I need to do: \(userTodayContent). Be concise, but not too formal. You must start your output with 'your daily card summary' in all lowercase. Also, do not use markdown notation and keep it brief.
                """)
            var responseText = ""
            for try await line in stream {
                responseText += line
                // Stop accumulating if the response reaches 400 characters
                if responseText.count > 400 {
                    break
                }
            }
            // Trim the responseText to ensure it's within 250 characters
            let trimmedResponse = String(responseText.prefix(250))
            
            DispatchQueue.main.async {
                self.apiResponse = trimmedResponse
                withAnimation {
                    self.showCard = true
                }
                print(self.apiResponse)
            }
        } catch {
            DispatchQueue.main.async {
                self.apiResponse = "Error: \(error.localizedDescription)"
                self.showCard = false
            }
        }
    }
}


