import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // VARIABLE LIST
    
    //talk about raindrops
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var rainDrops: [CCSprite] = []
    weak var rainDrop: CCSprite!
    weak var sand: CCSprite!
    var interval: Double = 0
    var dropsCollected: Int = 0 {
        didSet{
            if dropsCollected % 10 == 0 && dropsCollected > 0 {
                unschedule("spawnNewRainDrop")
                if interval > 0.25 {
                    interval -= interval/20
                }
                schedule("spawnNewRainDrop", interval: interval)
            }
        }
    }
    let firstRainDropPosition : CGFloat = 280
    let distanceBetweenRainDrops : CGFloat = 160
    
    //talk about bucket
    var isTouchingBucket = false
    weak var bucket: Bucket!
    
    //control gameplay
    var gameOver = false
    var counter = 0
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var scoreLabel: CCLabelTTF!
    weak var restartButton : CCButton!
    
    
    // FUNCTIONS
    
    //RUNS AT BEGINNING OF PROGRAM
    
    func didLoadFromCCB() {
        println("Jorrie the tallest")
        interval = 1
        gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        
        spawnNewRainDrop()
    }
    override func onEnter() {
        super.onEnter()
        println(interval)
        schedule("spawnNewRainDrop", interval: interval)
    }
    
    //    // TRIGGERS GAME OVER
    //    func triggerGameOver() {
    //        if (gameOver == true) {
    //            println("Todo: gameover")
    //        }
    //    }
    
    //CALLED WHEN YOU TOUCH THE SCREEN
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var touchLocation = touch.locationInWorld()
        bucket.position.x = touchLocation.x
        if (gameOver == false) {
            bucket.physicsBody.applyImpulse(ccp(0, 400))
            bucket.physicsBody.applyAngularImpulse(10000)
            //            sinceTouch = 0
        }
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
        
        var randomXPosition = CGFloat (arc4random_uniform(UInt32(screenSize.width - CGFloat(rainDrop.scale) * rainDrop.contentSize.width * 2)))
        rainDrop.position = ccp ( randomXPosition + CGFloat(rainDrop.scale) * rainDrop.contentSize.width, UIScreen.mainScreen().bounds.height-20)
        //        rainDrop.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * CGFloat(CCRANDOM_0_1()), y: CCDirector.sharedDirector().viewSize().height) //y value of screen
        //
        gamePhysicsNode.addChild(rainDrop)
        rainDrops.append(rainDrop)
        
    }
    
    // UPDATE FUNCTION ~ CALLED EVERY SINGLE FRAME
    
    
    override func update (delta: CCTime){
        if gameOver == false {
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
                if rainDrops.count > 1 {
                    //rainDrops.removeLast()
                }
            }
        }
    }
    
    
    //COLLISION TESTING
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bucket: Bucket!, raindrop: RainDrop!) -> Bool {
        raindrop.removeFromParent()
        dropsCollected++
        scoreLabel.string = String(dropsCollected)
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, sand: CCSprite!, raindrop: RainDrop!) -> Bool {
        triggerGameOver()
        if raindrop != nil { raindrop.removeFromParent() }
        print ("HI")
        return true
    }
    
    func restart() {
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func triggerGameOver() {
        if (gameOver == false) {
            gameOver = true
            restartButton.visible = true
            for raindrop in rainDrops {
                raindrop.removeFromParent()
            }
            unschedule("spawnRainDrop")
            unschedule("spawnNewRainDrop")
            isTouchingBucket = false
            
            // just in case
            //            rainDrop.stopAllActions()
            
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}
