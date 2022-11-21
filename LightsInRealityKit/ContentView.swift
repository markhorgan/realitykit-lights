// Copyright (c) 2022 Mark Horgan
//
// This source code is for individual learning purposes only. You may not copy,
// modify, merge, publish, distribute, create a derivative work or sell copies
// of the software in any work that is intended for pedagogical or
// instructional purposes.


import SwiftUI

struct ContentView: View {
    @State private var lightType: LightType = .none
    
    var body: some View {
        VStack {
            ARViewContainer(lightType: $lightType).edgesIgnoringSafeArea([.top, .leading, .trailing])
            Menu {
                Button("Point") {
                    lightType = .point
                }
                Button("Spot") {
                    lightType = .spot
                }
                Button("Directional") {
                    lightType = .directional
                }
                Button("Image") {
                    lightType = .image
                }
            } label: {
                Text("Light Type")
                    .frame(height: 44)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var lightType: LightType
    
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
        uiView.setLight(lightType)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
