import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    
    // VARIABLE LIST
    
    //talk about raindrops
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var rainDrops: [CCSprite] = []
    var geol: [Geo] = []
    weak var geo: CCSprite!
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
    var bugsCollected: Int = 0 {
        didSet{
            if bugsCollected % 10 == 0 && bugsCollected > 0 {
                unschedule("spawnNewGeo")
                if interval > 0.25 {
                    interval -= interval/20
                }
                schedule("spawnNewGeo", interval: interval)
            }
        }
    }
    let firstRainDropPosition : CGFloat = 280
    let firstGeoDropPosition : CGFloat = 450
    let distanceBetweenGeos : CGFloat = 600
    let distanceBetweenRainDrops : CGFloat = 160
    
    //talk about bucket
    var isTouchingBucket = false
    weak var bucket: Bucket!
    
    //control gameplay
    var gameOver = false
    var counter = 0
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var scoreLabell: CCLabelTTF!
    weak var scoreLabel: CCLabelTTF!
    weak var restartButton : CCButton!
    weak var deleteButton : CCButton!
    weak var highScoreLabel: CCLabelTTF!
    
    // FUNCTIONS
    
    //RUNS AT BEGINNING OF PROGRAM
    
    func didLoadFromCCB() {
        interval = 1
//        gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        spawnNewGeo()
        spawnNewRainDrop()
    }
    override func onEnter() {
        super.onEnter()
        println(interval)
        schedule("spawnNewRainDrop", interval: interval)
    }
    
    
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
        println("HiYa There")
        let rainDrop = CCBReader.load("RainDrop") as! RainDrop
        var randomXPosition = CGFloat (arc4random_uniform(UInt32(screenSize.width - CGFloat(rainDrop.scale) * rainDrop.contentSize.width * 2)))
        rainDrop.position = ccp ( randomXPosition + CGFloat(rainDrop.scale) * rainDrop.contentSize.width, UIScreen.mainScreen().bounds.height-20)
        //        rainDrop.position = CGPoint(x: CCDirector.sharedDirector().viewSize().width * CGFloat(CCRANDOM_0_1()), y: CCDirector.sharedDirector().viewSize().height) //y value of screen
        //
        gamePhysicsNode.addChild(rainDrop)
        rainDrops.append(rainDrop)
        println(rainDrop.position)

    }
    
    //Spawns a random bug
    func spawnNewGeo() {
        println("hello")
        var gern = CCBReader.load("Geo") as! Geo
        
        var randomXPosition = CGFloat (arc4random_uniform(UInt32(screenSize.width - CGFloat(gern.scale) * gern.contentSize.width * 2)))
        gern.position = ccp ( randomXPosition + CGFloat(gern.scale) * gern.contentSize.width, UIScreen.mainScreen().bounds.height-20)
        gamePhysicsNode.addChild(gern)
        geol.append(gern)
    }
    
//    func spawnNewEcoli(){
//        
//        var coliferm = CCBReader.load("geo") as! EColi
//        var randomXPosition = CGFloat(arc4random_uniform(UInt32(screenSize.width)))
//        coliferm.position = ccp( randomXPosition, UIScreen.mainScreen().bounds.height-20)
//        coliferm.scale = 0.040
//        gamePhysicsNode.addChild(coliferm)
//    }
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
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bucket: Bucket!, raindrop: RainDrop!) -> ObjCBool {
        raindrop.removeFromParent()
        dropsCollected++
        scoreLabell.string = String(dropsCollected)
        scoreLabel.string = String(dropsCollected)
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, sand: CCSprite!, raindrop: RainDrop!) -> ObjCBool {
        triggerGameOver()
        if raindrop != nil { raindrop.removeFromParent() }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, sand: CCSprite!, geo: Geo!) -> ObjCBool {
        geo.removeFromParent()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bucket: Bucket!, geo: Geo!) -> ObjCBool {
        geo.removeFromParent()
        self.animationManager.runAnimationsForSequenceNamed("hitBug")
        unschedule("spawnNewRainDrop")
        isTouchingBucket = false
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
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var highscore = defaults.integerForKey("highScoreLabel")

            highScoreLabel.string = String(highscore)
            if dropsCollected > highscore {
  
                
                println(highscore)
                defaults.setInteger(dropsCollected, forKey: "highScoreLabel")
                highScoreLabel.string = String(dropsCollected)
                

            }

            
            self.animationManager.runAnimationsForSequenceNamed("GameOver")
            unschedule("spawnNewRainDrop")
            isTouchingBucket = false
            
            // just in case
            // rainDrop.stopAllActions()
            
            let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            let moveBack = CCActionEaseBounceOut(action: move.reverse())
            let shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}
