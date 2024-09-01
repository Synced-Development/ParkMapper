import Foundation

class Config {
    private static let apiKeyKey = "API_KEY"

    // Fetch the API key from UserDefaults
    static func fetchAPIKey() -> String? {
        return UserDefaults.standard.string(forKey: apiKeyKey)
    }

    // Save the API key to UserDefaults
    static func saveAPIKey(_ apiKey: String) {
        UserDefaults.standard.set(apiKey, forKey: apiKeyKey)
    }
}

