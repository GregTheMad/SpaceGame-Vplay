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

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 480
        height: 320

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

        Ship {
            id: playerShip

            x: parent.width/2
            y: parent.height/2
        }

        Asteroid{
            x: 20
            y: 20
        }

        Timer {
            id: timer
            interval: generateRandomInterval()
            running: true
            repeat: true

            onTriggered: {

                var rot = utils.generateRandomValueBetween(0,360)
                var rad = rot / 180 * Math.PI

                var direction = Qt.point(scene.width/2 * Math.sin(rad), -scene.width/2 * Math.cos(rad))


                entityManager.createEntityFromUrlWithProperties(
                            Qt.resolvedUrl("entities/Asteroid.qml"),
                            {"x": scene.width / 2 + direction.x, "y": scene.height / 2 +  direction.y, "rotation": rot + 180 + utils.generateRandomValueBetween(-10,10) })

                timer.interval = scene.generateRandomInterval()
                timer.restart()
            }
        }

        function generateRandomInterval(){
            return utils.generateRandomValueBetween(1000,3000)
        }

        focus: true
        Keys.forwardTo: [playerShip, playerShip.moveController,playerShip.rotationController]
    }
}
