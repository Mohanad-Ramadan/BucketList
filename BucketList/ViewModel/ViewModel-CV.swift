//
//  ViewModel-CV.swift
//  BucketList
//
//  Created by Mohanad Ramdan on 31/08/2023.
//

import LocalAuthentication
import Foundation
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var locations : [Location]
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addNewLocation() {
            let newLocation = Location(name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let selectedPlace = selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            // check whether biometric authentication is possible
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // it's possible, so go ahead and use it
                let reason = "We need to unlock your data."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    Task{ @MainActor in
                        if success {
                            // authenticated successfully
                            self.isUnlocked = true
                        } else {
                            // 
                        }
                    }
                }
            } else {
                // no biometrics
            }
        }
        
    }
}
