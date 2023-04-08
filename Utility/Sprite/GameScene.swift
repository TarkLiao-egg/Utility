import SpriteKit


class GameScene: SKScene {
    let label = SKLabelNode(text: "test")
    let floor = SKSpriteNode(imageNamed: "default")
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        print("sceneDidLoad")
        backgroundColor = SKColor(0xff0000)
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        print("didMove")
        addChild(label)
        print(view.frame)
        size = view.frame.size
        position = view.frame.origin
        anchorPoint = CGPoint(x: 0, y: 0)
        print(self.anchorPoint)
        print(frame)
        
        label.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        floor.position = .zero
        floor.anchorPoint = .zero
        floor.size = CGSize(width: view.frame.width, height: 100)
        addChild(floor)
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        print("willMove")
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        print("didChangeSize")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
    }
}
