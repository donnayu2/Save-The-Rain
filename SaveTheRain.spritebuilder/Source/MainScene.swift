import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    var gameOver = false
    weak var sand: CCSprite!
    weak var rainDrop: CCSprite!
    var rainDrops: [RainDrop] = []
    let firstRainDropPosition : CGFloat = 280
    let distanceBetweenRainDrops : CGFloat = 160
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        for i in 0...2 {
            spawnNewRainDrop()
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {

    }
    
    func spawnNewRainDrop() {
        
        println("spawned raindrop")
        
        let rainDrop = CCBReader.load("RainDrop") as! RainDrop
        rainDrop.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * CGFloat(CCRANDOM_0_1()), y: CCDirector.sharedDirector().viewSize().height) //y value of screen
        gamePhysicsNode.addChild(rainDrop)
        rainDrops.append(rainDrop)
        
        for rainDrop in rainDrops.reverse() {
            let rainDropWorldPosition = gamePhysicsNode.convertToWorldSpace(rainDrop.position)
            let rainDropScreenPosition = convertToNodeSpace(rainDropWorldPosition)
            
            // obstacle moved past left side of screen?
            if rainDropScreenPosition.x < (-rainDrop.contentSize.width) {
                rainDrop.removeFromParent()
//                rainDrop.removeAtIndex(find(rainDrop, drop)!)
                
                // for each removed obstacle, add a new one
                spawnNewRainDrop()
            }
        }
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, level: CCNode!) -> Bool {
        println("TODO: handle Game Over")
        return true
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func triggerGameOver() {
        if (gameOver == false) {
            println("Todo: gameover")
        }
    }
}
