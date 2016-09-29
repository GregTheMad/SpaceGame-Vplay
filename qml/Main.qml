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

        ParallaxItem {
            id: parallxBackgroung

            ratio: Qt.point(0.1, 0.1)

            Image{
                source: "../assets/starfield.jpg"
            }
        }

        property alias playerShip: playerShip

        Ship {
            id: playerShip

            x: parent.width/2
            y: parent.height/2
        }

        //Healthbar:

        Rectangle{
            id: healthbarBorder
            x:9
            y:9
            width: 102
            height: 12
            color: "white"
        }

        Rectangle{
            id: healthbarBackground
             x: 10
             y: 10
             width:100
             height:10
             color: "black"

        }

        Rectangle{
            id: healthbar
            x: 10
            y: 10
            width: (playerShip.health.currentHealth / playerShip.health.maxHealth) * 100
            height: 10
            color: "green"
        }

        //Asteroid Spawner:

        property real asteroidCounter: 0

        Timer {
            id: timer
            interval: generateRandomInterval()
            running: true
            repeat: true

            onTriggered: {

                parent.asteroidCounter += 1

                var rot = utils.generateRandomValueBetween(0,360)
                var rad = rot / 180 * Math.PI

                var direction = Qt.point(scene.width/2 * Math.sin(rad), -scene.width/2 * Math.cos(rad))


                entityManager.createEntityFromUrlWithProperties(
                            Qt.resolvedUrl("entities/Asteroid.qml"),
                            {"x": scene.width / 2 + direction.x,
                             "y": scene.height / 2 +  direction.y,
                             "rotation": rot + 180 + utils.generateRandomValueBetween(-30,30),
                            "entityId": "asteroid-" + parent.asteroidCounter})

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
    }
}
