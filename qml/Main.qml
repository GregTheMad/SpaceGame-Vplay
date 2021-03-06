import VPlay 2.0
import QtQuick 2.0

import "entities"

GameWindow {
    id: gameWindow

    activeScene: scene

    screenWidth: 960
    screenHeight: 640

    EntityManager{
        id: entityManager
        entityContainer: scene
    }

    Scene {
        id: scene

        width: 480
        height: 320

        //Initializing PhysicsWorld
        PhysicsWorld{
            id: world
            updatesPerSecondForPhysics: 60
        }

        Image{
            anchors.fill: parent
            source: "../assets/starfield.jpg"
        }

        property alias playerShip: playerShip

        Ship {
            id: playerShip

            x: parent.width/2
            y: parent.height/2

            onVisibleChanged: {
                if (playerShip.visible == false)
                    scene.showDeadMessage = true
            }
        }

        //GameOver Message

        property bool showDeadMessage: false

        Rectangle{

            visible: scene.showDeadMessage

            width: 200
            height: 100

            x: (scene.width/2) - (width/2)
            y: (scene.height/2) - (height/2)
            z: 0.9

            Text{
             anchors.centerIn: parent

             horizontalAlignment: Text.AlignHCenter

             text: "You died.\nYour highscore was: " + scene.playerScore
            }
        }

        //Score:

        property int playerScore: 0

        Rectangle{
            id: scoreBackground
            x: parent.width - 9 - width
            y: 9
            z: 0.9

            width: 32
            height: 12

            color: "dark grey"
        }

        Text{
            id: scoreText
            x: parent.width - 10 - width
            y: 10

            z: 1

            font.pixelSize: 10

            horizontalAlignment: Text.AlignRight

            color: "black"

            text: scene.playerScore
        }

        function increaseScore(value){
            playerScore += value

            console.log("score: " + playerScore)
        }

        //Healthbar:

        Rectangle{
            id: healthbarBorder
            x:9
            y:9
            z: 0.8
            width: 102
            height: 12
            color: "white"
        }

        Rectangle{
            id: healthbarBackground
             x: 10
             y: 10
             z: 0.9
             width:100
             height:10
             color: "black"

        }

        Rectangle{
            id: healthbar
            x: 10
            y: 10
            z: 1
            width: (playerShip.health.currentHealth / playerShip.health.maxHealth) * 100
            height: 10
            color: "green"
        }

        //Asteroid Spawner:

        property real asteroidCounter: 0
        property real sceneDiagonal: Math.sqrt(scene.width*scene.width + scene.height*scene.height)

        Timer {
            id: timer
            interval: scene.generateRandomInterval()
            running: true
            repeat: true

            onTriggered: {

                parent.asteroidCounter += 1

                var rot = utils.generateRandomValueBetween(0,360)
                var rad = rot / 180 * Math.PI

                var direction = Qt.point(scene.sceneDiagonal * Math.sin(rad), -scene.sceneDiagonal * Math.cos(rad))


                entityManager.createEntityFromUrlWithProperties(
                            Qt.resolvedUrl("entities/Asteroid.qml"),
                            {"x": scene.width / 2 + direction.x,
                             "y": scene.height / 2 +  direction.y,
                             "rotation": rot + 180 + utils.generateRandomValueBetween(-10,10),
                             "entityId": "asteroid-" + parent.asteroidCounter,
                            "speedForce": 9000 + utils.generateRandomValueBetween(0,2000)})

                timer.interval = scene.generateRandomInterval()
                timer.restart()
            }
        }

        function generateRandomInterval(){
            return utils.generateRandomValueBetween(1000,3000)
        }

        //Handing the Key-Input to the playerShip

        focus: true

        Keys.forwardTo: [playerShip, playerShip.moveController,playerShip.rotationController]

        //HUD

        SimpleButton{
            id: fireButton
            text: "Fire"

            width: 50
            height: 50
            x: scene.width - width - 10
            y: scene.height - height - 10

            onClicked: playerShip.fireProjectile()
        }

        property variant playerRotController: scene.playerShip.getComponent("rotationController")

        SimpleButton{
            id: turnLeftButton
            text: "Left"

            width: 50
            height: 50
            x: 10
            y: scene.height - height - 10 - 100

            onPressedChanged: {
                if (pressed) scene.playerRotController.xAxis = -1
                    else scene.playerRotController.xAxis = 0
            }
        }

        SimpleButton{
            id: turnRightButton
            text: "Right"

            width: 50
            height: 50
            x: width + 20
            y: scene.height - height - 10 - 100

            onPressedChanged: {
                if (pressed) scene.playerRotController.xAxis = 1
                    else scene.playerRotController.xAxis = 0
            }
        }

        SimpleButton{
            id: brakeButton
            text: "Brake"

            width: 50
            height: 50
            x: 110
            y: scene.height - height - 10

            onPressedChanged: {
                if (pressed) playerShip.brake()
                else playerShip.releaseBrake()
            }
        }
    }

    JoystickControllerHUD{
        anchors.bottom: parent.bottom

        joystickRadius: 100

        source: "../assets/HUD/circle.png"
        thumbSource: "../assets/HUD/circle2.png"

        property variant playerTwoxisController: scene.playerShip.getComponent("moveController")
        onControllerXPositionChanged: playerTwoxisController.xAxis = controllerXPosition;
        onControllerYPositionChanged: playerTwoxisController.yAxis = -controllerYPosition;
    }
}
