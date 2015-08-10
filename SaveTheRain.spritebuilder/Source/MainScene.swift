import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    
//    weak var bucket = CCSprite!
    var isTouchingBucket = false
    var gameOver = false
    weak var sand: CCSprite!
    weak var rainDrop: CCSprite!
    weak var bucket: Bucket!
    var rainDrops: [RainDrop] = []
    let firstRainDropPosition : CGFloat = 280
    let distanceBetweenRainDrops : CGFloat = 160
    
    var counter = 0
    var dropsCollected: Int = 0
    
    weak var gamePhysicsNode: CCPhysicsNode!
    
    //RUNS AT BEGINNING OF PROGRAM
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        
        spawnNewRainDrop()
    }
    
    // TRIGGERS GAME OVER
    func triggerGameOver() {
        if (gameOver == true) {
            println("Todo: gameover")
        }
    }
    
    //CALLED WHEN YOU TOUCH THE SCREEN
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInWorld()
        bucket.position.x = touchLocation.x
    }
    
    //CALLED WHEN YOU DRAG YOUR FINGER ON THE SCREEN
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInWorld()
        bucket.position.x = touchLocation.x
        
    }
    
    //SPAWNS A NEW RAINDROP AT A RANDOM POSITION
    
    func spawnNewRainDrop() {
        
        println("spawned raindrop")
        
        let rainDrop = CCBReader.load("RainDrop") as! RainDrop
        
        rainDrop.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * CGFloat(CCRANDOM_0_1()), y: CCDirector.sharedDirector().viewSize().height) //y value of screen
        
        gamePhysicsNode.addChild(rainDrop)
        rainDrops.append(rainDrop)
        
    }
    
    // UPDATE FUNCTION ~ CALLED EVERY SINGLE FRAME
    
    
    override func update (delta: CCTime){
        counter++
        
        for rainDrop in rainDrops.reverse() {
            let rainDropWorldPosition = gamePhysicsNode.convertToWorldSpace(rainDrop.position)
            let rainDropScreenPosition = convertToNodeSpace(rainDropWorldPosition)
            
            // obstacle moved past bottom of screen?
            if rainDropScreenPosition.y < 0 {
               
                rainDrop.removeFromParent()
                rainDrops.removeAtIndex(find(rainDrops, rainDrop)!)
                
                // for each removed obstacle, add a new one
                spawnNewRainDrop()
            }
            
            if counter % 30 == 0 {
                spawnNewRainDrop()
            }
        }
    }
    
    
    //COLLISION TESTING
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bucket: Bucket!, raindrop: RainDrop!) -> Bool {
        raindrop.removeFromParent()
        dropsCollected++
        return false
    }
    
}
