import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var vm = FrontendMapViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $vm.cameraPosition){
                ForEach(vm.users) { user in
                    Annotation(user.name, coordinate: user.coordinate, anchor: .bottom){
                        AvatarMarkerView(
                            name: user.name,
                            color: colorForUser(id: user.id),
                            isYou: user.id == "you"
                        )
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat))
            .ignoresSafeArea()
            
            HStack(spacing: 10) {
                Text(vm.simulationRunning ? "Simulation: ON" : "Simulation: OFF")
                Text("Users: \(vm.users.count)")
            }
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.thinMaterial)
            .clipShape(Capsule())
            .padding(.top, 12)
        }
        
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                Button("Start") { vm.startSimulation()}
                    .buttonStyle(.borderedProminent)
                
                Button("Stop") { vm.stopSimulation()}
                    .buttonStyle(.bordered)
                
//                Button("Recenter") { vm.recenterOnYou()}
//                    .buttonStyle(.bordered)
            }
            .padding(12)
            .background(.ultraThinMaterial)
        }
        .onAppear(perform: vm.startSimulation)
        .onDisappear(perform: vm.stopSimulation)
    }
    private func colorForUser(id: String) -> Color {
        if id == "you" {return .blue }
        
        var hasher = Hasher()
        hasher.combine(id)
        let hash = abs(hasher.finalize())
        let hue = Double(hash % 360) / 360.0
        return Color(hue: hue, saturation: 0.75, brightness: 0.92)
        
    }
}

#Preview {
    ContentView()
}
