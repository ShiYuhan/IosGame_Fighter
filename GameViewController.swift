//
//  GameViewController.swift
//  fighter
//
//  Created by 石宇涵 on 2018/11/18.
//  Copyright © 2018 石宇涵. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var spawnTime: TimeInterval = 0
    var game = GameHelper.sharedInstance
    var splashNodes: [String: SCNNode] = [:]

    
    override func viewDidLoad() {
        setupView()
        setupScene()
        setupCamera()
        //spawnShape()
        setupHUD()
        setupSplash()
        setupSounds()
        super.viewDidLoad()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as? SCNView
        // 1 showStatistics会在屏幕底部启动一个实时的统计面板.
       // scnView.showsStatistics = true
        // 2 allowsCameraControl能让你用手势(单指轻扫,双指轻扫,双指捏合,双击)控制摄像机的位置.
       // scnView.allowsCameraControl = false
        // 3 autoenablesDefaultLighting则创建一个泛光灯来照亮你的场景.
        scnView.autoenablesDefaultLighting = true
        scnView.delegate = self
        scnView.isPlaying = true
    }
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
        scnScene.background.contents = "GeometryFighter.scnassets/Textures/2.png"

    }
    func setupCamera() {
        // 1
        cameraNode = SCNNode()//创建一个空节点并赋值到cameraNode.
        // 2
        cameraNode.camera = SCNCamera() //创建一个新的SCNCamera对象,并赋值给cameraNode的camera属性.
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 10) //设置摄像机位置(x:0, y:5, z:10).
        // 4
        scnScene.rootNode.addChildNode(cameraNode) //添加cameraNode到场景中,作为场景根节点的一个子节点.
    }

    func spawnShape() {
        // 1 创建一个占位几何体,稍后会用到.
        var geometry:SCNGeometry
        // 2 定义一个switch语句来处理ShapeType.random()中返回的形状.暂时我们只添加一个立方体形状,其他的稍后添加.
        switch ShapeType.random() {
            // 3 创建一个SCNBox对象并储存在geometry中.
        case .box:
        geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        case .sphere:
        geometry = SCNSphere(radius: 0.5)
        case .pyramid:
        geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        case .torus:
        geometry = SCNTorus(ringRadius: 0.5, pipeRadius: 0.25)
        case .capsule:
        geometry = SCNCapsule(capRadius: 0.3, height: 2.5)
        case .cylinder:
        geometry = SCNCylinder(radius: 0.3, height: 2.5)
        case .cone:
        geometry = SCNCone(topRadius: 0.25, bottomRadius: 0.5, height: 1.0)
        case .tube:
        geometry = SCNTube(innerRadius: 0.25, outerRadius: 0.5, height: 1.0)
    }
       // geometry.materials.first?.diffuse.contents = UIColor.random()//随机颜色
        let color = UIColor.random()
        geometry.materials.first?.diffuse.contents = color
        // 4 创建一个SCNNode实例,命名为geometryNode.构造器使用geometry参数来自动创建一个节点并将几何体附加在上面.
        let geometryNode = SCNNode(geometry: geometry)
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)//shape传nil,会自动根据显示的形状创建一个物理形体.
        
        // 1 创建两个随机的浮点数代表力的x分量和y分量.用到的正是我们添加进项目中的工具类.
        let randomX = Float.random(min: -2, max: 2)
        let randomY = Float.random(min: 10, max: 18)
        // 2 用这些随机数来创建一个向量代表这个力.
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        // 3 创建另一个向量来表示力施加的位置.这个位置是故意稍微偏离中心一些的,这样就能让物体旋转起来.
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        // 4 通过调用applyForce(direction: at: asImpulse:)方法将力应用到geometryNode的物理形体上.
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
       // let trailEmitter = createTrail(color: color, geometry: geometry)
        //geometryNode.addParticleSystem(trailEmitter)
        
        if color == UIColor.black {
            geometryNode.name = "BAD"
            game.playSound(scnScene.rootNode, name: "SpawnBad")
        } else {
            geometryNode.name = "GOOD"
            game.playSound(scnScene.rootNode, name: "SpawnGood")

        }

        // 5 将节点添加到场景的根节点上.
        scnScene.rootNode.addChildNode(geometryNode)
    }
    
    //将不要的节点移除掉
    func cleanScene() {
        // 1 循环遍历场景的根节点.
        for node in scnScene.rootNode.childNodes {
            // 2 此时的position反应的是动画开始前的位置
            if node.presentation.position.y < -2 {
                // 3 presentation_position当前位置，让一个物体消失.
                node.removeFromParentNode()
            }
        }
        
    }
    
    // 1 定义一个方法createTrail(_: geometry:)接收color和geometry参数来创建粒子系统.
    func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        // 2 从先前创建的文件里加载粒子系统
        let trail = SCNParticleSystem(named: "Trail.scnp", inDirectory: nil)!
        // 3 根据传入的颜色修改粒子的颜色
        trail.particleColor = color
        // 4 用传入的几何体参数来指定发射器的形状.
        trail.emitterShape = geometry
        // 5 返回新创建的粒子系统.
        return trail
    }
    
    func setupHUD() {
        game.hudNode.position = SCNVector3(x: 0.0, y: 10.0, z: 0.0)
        scnScene.rootNode.addChildNode(game.hudNode)//从帮助文件库中调用的game.hudNode.
    }
//==========================Splash_part===============================================//
    func createSplash(name: String, imageFileName: String) -> SCNNode {
        let plane = SCNPlane(width: 5, height: 11)
        let splashNode = SCNNode(geometry: plane)
        splashNode.position = SCNVector3(x: 0, y: 5, z: 2)
        splashNode.name = name
        splashNode.geometry?.materials.first?.diffuse.contents = imageFileName
        scnScene.rootNode.addChildNode(splashNode)
        return splashNode
    }
    func showSplash(splashName: String) {
        for (name,node) in splashNodes {
            if name == splashName {
                node.isHidden = false
            } else {
                node.isHidden = true
            }
        }
    }
    func setupSplash() {
        splashNodes["TapToPlay"] = createSplash(name: "TAPTOPLAY",
                                                imageFileName: "GeometryFighter.scnassets/Textures/Pasted Graphic 1.png")
        splashNodes["GameOver"] = createSplash(name: "GAMEOVER",
                                               imageFileName: "GeometryFighter.scnassets/Textures/Pasted Graphic 2.png")
        showSplash(splashName: "TapToPlay")
    }
//===========================Splash_part Over===========================================//
//===========================Sound_part=================================================//
    func setupSounds() {
        game.loadSound("ExplodeGood",
                       fileNamed: "GeometryFighter.scnassets/Sounds/ExplodeGood.wav")
        game.loadSound("SpawnGood",
                       fileNamed: "GeometryFighter.scnassets/Sounds/SpawnGood.wav")
        game.loadSound("ExplodeBad",
                       fileNamed: "GeometryFighter.scnassets/Sounds/ExplodeBad.wav")
        game.loadSound("SpawnBad",
                       fileNamed: "GeometryFighter.scnassets/Sounds/SpawnBad.wav")
        game.loadSound("GameOver",
                       fileNamed: "GeometryFighter.scnassets/Sounds/GameOver.wav")
    }
//===========================Sound_part Over===========================================//
//===========================touch_part================================================//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.state == .GameOver {
            return
        }
        
        if game.state == .TapToPlay {
            game.reset()
            game.state = .Playing
            showSplash(splashName: "")
            return
        }
        // 1 拿到可用的touch.此处如果玩家用了多根手指就会有多个touch.
        let touch = touches.first!
        // 2 从屏幕坐标转换到scnView的坐标.
        let location = touch.location(in: scnView)
        // 3 hitTest(_: options:)返回一个SCNHitTestResult对象数组,代表着从用户触摸点发出的射线碰到的所有物体.
        let hitResults = scnView.hitTest(location, options: nil)
        // 4 检查第一个结果是否可用.
        if let result = hitResults.first {
            // 5 将第一个碰到的节点传递给触摸处理方法,它可以计算增加分数或减少生命值.
            // handleTouchFor(node: result.node)
            if result.node.name == "HUD" || result.node.name == "GAMEOVER" || result.node.name == "TAPTOPLAY" {
                return
            } else if result.node.name == "GOOD" {
                handleGoodCollision()
            } else if result.node.name == "BAD" {
                handleBadCollision()
            }
            
            createExplosion(geometry: result.node.geometry!,
                            position: result.node.presentation.position,
                            rotation: result.node.presentation.rotation)
            
            result.node.removeFromParentNode()
            
        }
    }
    func handleGoodCollision() {
        game.score += 1
        game.playSound(scnScene.rootNode, name: "ExplodeGood")
    }
    
    func handleBadCollision() {
        game.lives -= 1
        game.playSound(scnScene.rootNode, name: "ExplodeBad")
        game.shakeNode(cameraNode)
        
        if game.lives <= 0 {
            game.saveState()
            showSplash(splashName: "GameOver")
            game.playSound(scnScene.rootNode, name: "GameOver")
            game.state = .GameOver
            scnScene.rootNode.runAction(SCNAction.waitForDurationThenRunBlock(5) { (node:SCNNode!) -> Void in
                self.showSplash(splashName: "TapToPlay")
                self.game.state = .TapToPlay
            })
        }
    }
    


//
//    func handleTouchFor(node: SCNNode) {
//
//        if node.name == "GOOD" {
//            createExplosion(geometry: node.geometry!,  position: node.presentation.position,rotation: node.presentation.rotation)
//            game.score += 1
//            node.removeFromParentNode()
//        } else if node.name == "BAD" {
//            createExplosion(geometry: node.geometry!,  position: node.presentation.position,rotation: node.presentation.rotation)
//            game.lives -= 1
//            node.removeFromParentNode()
//        }
//    }

  
    
    // 1 createExplosion(_: position: rotation:)接收三个参数:geometry定义了粒子效果的形状,position和rotation帮助放置爆炸效果到场景中.
    func createExplosion(geometry: SCNGeometry, position: SCNVector3,rotation: SCNVector4) {
        // 2 加载Explode.scnp,将其用作发射器.发射器使用geometry作为emitterShape,这样粒子就可以从形状的表面发射出来.
        let explosion = SCNParticleSystem(named: "Explode.scnp", inDirectory:nil)!
        explosion.emitterShape = geometry
        explosion.birthLocation = .surface
        // 3 创建旋转矩阵和平移矩阵,相乘得到复合变换矩阵.
        let rotationMatrix = SCNMatrix4MakeRotation(rotation.w, rotation.x,rotation.y, rotation.z)
        let translationMatrix = SCNMatrix4MakeTranslation(position.x, position.y,position.z)
        let transformMatrix = SCNMatrix4Mult(rotationMatrix, translationMatrix)
        // 4 调用addParticleSystem(_: wtihTransform)将爆炸效果添加到场景中.
        scnScene.addParticleSystem(explosion, transform: transformMatrix)
    }
    
    
}
    
//    //转屏设置
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//}
// 1
extension GameViewController: SCNSceneRendererDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer,updateAtTime time: TimeInterval) {
        // 3
        // 1 检查time(当前系统的时间),如果大于spawnTime就产生一个新的形状,否则,什么也不做.
        if time > spawnTime {
            spawnShape()
            // 2 创建一个物体后,更新spawnTime来决定下一次创建的时机.下一次创建时间应该是在当前时间上增加一个随机量.
            spawnTime = time + TimeInterval(Float.random(min: 0.2, max: 1.5))
        }
        cleanScene()
        game.updateHUD()
    }
    
}


