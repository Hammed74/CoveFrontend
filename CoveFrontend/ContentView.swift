import SwiftUI
import CoreLocation
import MapboxMaps

struct UserPin: Identifiable {
    let id: String
    let name: String
    var coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @State private var viewport: Viewport = .camera(
        center: CLLocationCoordinate2D(latitude: 39.96170877260263, longitude: -75.14682905841208),
        zoom: 13,
        bearing: 0,
        pitch: 0
    )
        @State private var users: [UserPin] = [
            UserPin(id: "you", name: "You", coordinate: CLLocationCoordinate2D(latitude: 39.96170877260263, longitude: -75.14682905841208)),
            UserPin(id: "mia", name: "mia", coordinate: CLLocationCoordinate2D(latitude: 39.96270877260263, longitude: -75.14782905841208)),
            UserPin(id: "leo", name: "leo", coordinate: CLLocationCoordinate2D(latitude: 39.96370877260263, longitude: -75.14582905841208))
        ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(viewport: $viewport) {
                ForEvery(users) { user in
                    MapViewAnnotation(coordinate: user.coordinate) {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(user.id == "you" ? .blue : .orange)
                                .frame(width: user.id == "you" ? 26 : 22, height: user.id == "you" ? 26 : 22)
                            Text(user.name).font(.caption2).padding(4).background(.thinMaterial).clipShape(Capsule())
                        }
                    }
                }
            }
            .mapStyle(.standard(
                lightPreset: .day,
                showPointOfInterestLabels: false,
                showTransitLabels: false,
                showPlaceLabels: false,
                showRoadLabels: true
                )
            )
            .ignoresSafeArea()
            
            Button("Recenter") {recenterOnYou()}
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 30)
        }
        
    }
    
    private func recenterOnYou() {
        guard let you = users.first(where: {$0.id == "you"}) else { return }
        withViewportAnimation(.easeIn(duration: 0.35)) {
            viewport = .camera(center: you.coordinate, zoom: 14, bearing: 0, pitch: 0)
        }
    }
}

#Preview {
    ContentView()
}
