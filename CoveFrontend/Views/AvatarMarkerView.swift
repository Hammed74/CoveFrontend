import SwiftUI

struct AvatarMarkerView: View {
    let name: String
    let color: Color
    let isYou: Bool
    
    @State private var pulse = false
    @State private var bob = false
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: isYou ? 30 : 40, height: isYou ? 30 : 40)
                
                Circle()
                    .stroke(.white, lineWidth: 2)
                    .frame(width: isYou ? 30 : 24, height: isYou ? 30 : 24)
                
                if isYou {
                    Circle()
                        .fill(.white)
                        .frame(width: 6, height: 6)
                }
            }
            .scaleEffect(pulse ? 1.12 : 0.94)
            .offset(y: bob ? -2 : 2)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
            
            Text(name)
                .font(.caption2)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
        }
        .onAppear {
            pulse = true
            bob = true
        }
        .animation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true), value: pulse)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: bob)
    }
    
}

