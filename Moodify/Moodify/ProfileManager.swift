import Foundation

class ProfileManager: ObservableObject {
    @Published var profiles: [Profile] = []
    @Published var currentProfile: Profile? = nil

    private let profilesKey = "savedProfiles"

    init() {
        loadProfiles()
    }

    // Create a new profile
    func createProfile(name: String, dateOfBirth: Date, favoriteGenres: [String], hasAgreedToTerms: Bool) {
        let newProfile = Profile(name: name, dateOfBirth: dateOfBirth, favoriteGenres: favoriteGenres, hasAgreedToTerms: hasAgreedToTerms)
        profiles.append(newProfile)
        saveProfiles()
        selectProfile(newProfile)  // Immediately select the new profile
    }

    // Update an existing profile
    func updateProfile(profile: Profile, name: String, dateOfBirth: Date, favoriteGenres: [String], hasAgreedToTerms: Bool) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index].name = name
            profiles[index].dateOfBirth = dateOfBirth
            profiles[index].favoriteGenres = favoriteGenres
            profiles[index].hasAgreedToTerms = hasAgreedToTerms
            
            // Save profiles and trigger view update
            saveProfiles()
            selectProfile(profiles[index])  // Reassign currentProfile to trigger view update
        }
    }

    // Select a profile
    func selectProfile(_ profile: Profile) {
        currentProfile = profile
    }

    // Delete a profile
    func deleteProfile(profile: Profile) {
        profiles.removeAll { $0.id == profile.id }
        saveProfiles()
        if currentProfile?.id == profile.id {
            currentProfile = nil
        }
    }

    private func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: profilesKey)
        }
    }

    func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: profilesKey),
           let decodedProfiles = try? JSONDecoder().decode([Profile].self, from: data) {
            profiles = decodedProfiles
        }
    }
}

