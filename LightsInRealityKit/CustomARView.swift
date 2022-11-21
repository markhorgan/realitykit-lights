//  Copyright (c) 2022 Mark Horgan
//
// This source code is for individual learning purposes only. You may not copy, 
// modify, merge, publish, distribute, create a derivative work or sell copies 
// of the software in any work that is intended for pedagogical or 
// instructional purposes.

import RealityKit
import ARKit

enum LightType {
    case none
    case point
    case spot
    case directional
    case image
}

class CustomARView: ARView {
    private var anchorEntity: AnchorEntity!
    private var light: Entity?
    
    required init(frame: CGRect) {
        super.init(frame: frame, cameraMode: .nonAR, automaticallyConfigureSession: true)
        
        anchorEntity = AnchorEntity(world: [0, 0, 0])
        scene.addAnchor(anchorEntity)
        
        let planeMesh = MeshResource.generatePlane(width: 10, depth: 10)
        let planeMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
        anchorEntity.addChild(planeEntity)

        let sphereMesh = MeshResource.generateSphere(radius: 1.5)
        let sphereMaterial = SimpleMaterial(color: .white, roughness: 0.5, isMetallic: true)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [sphereMaterial])
        sphereEntity.position = [0, 2, -5]
        anchorEntity.addChild(sphereEntity)

        let camera = PerspectiveCamera()
        camera.position =  [0, 1, 2]
        anchorEntity.addChild(camera)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLight(_ lightType: LightType) {
        switch lightType {
        case .none: break
        case .point: addPointLight()
        case .spot: addSpotLight()
        case .directional: addDirectionalLight()
        case .image: addImageLight()
        }
    }
    
    private func addPointLight() {
        let pointLight = PointLight()
        pointLight.light.intensity = 1000000
        pointLight.light.color = .blue
        pointLight.light.attenuationRadius = 5
        pointLight.position = [0, 0.2, 0]
        
        addLight(pointLight)
    }
    
    private func addSpotLight() {
        let spotLight = SpotLight()
        spotLight.light.color = .green
        spotLight.light.intensity = 1000000
        spotLight.light.innerAngleInDegrees = 40
        spotLight.light.outerAngleInDegrees = 60
        spotLight.light.attenuationRadius = 10
        spotLight.shadow = SpotLightComponent.Shadow()
        spotLight.look(at: [1, 0, -4], from: [0, 5, -5], relativeTo: nil)
        
        addLight(spotLight)
    }
    
    private func addDirectionalLight() {
        let directionalLight = DirectionalLight()
        directionalLight.light.color = .red
        directionalLight.light.intensity = 1000000
        directionalLight.shadow?.maximumDistance = 5
        directionalLight.shadow?.depthBias = 1
        directionalLight.look(at: [1, 0, 1], from: [0, 1, 0], relativeTo: nil)
        
        addLight(directionalLight)
    }
    
    private func addImageLight() {
        environment.lighting.resource = try! .load(named: "dreifaltigkeitsberg_2k.hdr")
        environment.lighting.intensityExponent = 1
    }
    
    private func addLight(_ newLight: Entity) {
        if let light = light {
            light.removeFromParent()
        }
        anchorEntity.addChild(newLight)
        light = newLight
    }
}
