import SwiftUI
import ARKit
import RealityKit

struct ContentView: View {
    @State private var selectedMustache = "mustache1" // Default mustache model name

    let mustacheStyles = ["mustache1", "mustache2", "mustache3"] // Add your mustache model names here

    var body: some View {
        VStack {
            ARViewContainer(selectedMustache: $selectedMustache)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(mustacheStyles, id: \.self) { mustache in
                        Button(action: {
                            selectedMustache = mustache
                        }) {
                            Text(mustache)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedMustache: String

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Create an AR session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face Tracking is not supported on this device.")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Start AR session
        arView.session.run(configuration)

        // Add coordinator to handle updates
        context.coordinator.setupARView(arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.updateMustache(to: selectedMustache)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        private var arView: ARView?
        private var mustacheAnchor: AnchorEntity?

        func setupARView(_ arView: ARView) {
            self.arView = arView
            mustacheAnchor = AnchorEntity(.face)
            arView.scene.addAnchor(mustacheAnchor!)
        }

        func updateMustache(to mustacheName: String) {
            guard let mustacheAnchor = mustacheAnchor else { return }
            
            mustacheAnchor.children.forEach { $0.removeFromParent() }
            
            if let mustacheEntity = try? Entity.loadModel(named: mustacheName) {
                mustacheEntity.scale = SIMD3<Float>(0.05, 0.05, 0.05) // Scale the mustache model
                mustacheEntity.position = SIMD3<Float>(0, -0.02, 0.05) // Adjust the position of the mustache
                mustacheAnchor.addChild(mustacheEntity)
            }
        }
    }
}
