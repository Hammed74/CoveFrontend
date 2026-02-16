import Foundation
import SwiftUI
import MapKit
import Combine

@MainActor
final class FrontendMapViewModel: ObservableObject {
    @Published var cameraPosition: MapCameraPosition
    @Published var users: [MapUser] = []
    @Published var simulationRunning: Bool = false
    
    private var timer: Timer?
    
    init() {
        let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
        cameraPosition = .region(
            MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
        
            users = [
                MapUser(id: "you", name: "You", latitude: center.latitude, longitude: center.longitude),
                MapUser(id: "mia", name: "Mia", latitude: center.latitude + 0.0020, longitude: center.longitude - 0.0025),
                MapUser(id: "leo", name: "Leo", latitude: center.latitude - 0.0015, longitude: center.longitude + 0.0018),
                MapUser(id: "zoe", name: "Zoe", latitude: center.latitude + 0.0012, longitude: center.longitude + 0.0022)
            ]
    }
    
    func startSimulation() {
        guard timer == nil else { return }
        simulationRunning = true

        // Schedule the timer on the main run loop so the callback runs on the main thread
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            // Hop to the main actor explicitly to satisfy actor isolation
            Task { @MainActor in
                self.moveMockUsers()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopSimulation() {
        timer?.invalidate()
        timer = nil
        simulationRunning = false
    }
    
    private func moveMockUsers() {
        withAnimation(.linear(duration: 1.0)) {
            for index in users.indices where users[index].id != "you"{
                users[index].latitude += Double.random(in: -0.00025...0.00025)
                users[index].longitude += Double.random(in: -0.00025...0.00025)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}


