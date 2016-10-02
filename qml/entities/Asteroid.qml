import VPlay 2.0
import QtQuick 2.0

import "../items"

EntityBase {
    id: asteroid
    entityId: "asteroidEntity"
    entityType: "asteroid"

    width: 30
    height: 30

    property real speedForce: 10000

    property alias health: health

    Component.onCompleted: {
        applyForwardImpuls()
    }

    Health{
        id: health
        maxHealth: 10
        objectName: "health"
    }

    Image {
        anchors.fill: parent
        source: "../../assets/asteroid.png"
    }

    CircleCollider{
        id: collider

        anchors.centerIn: parent
        radius: parent.width/2

        density: 0.5
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0

        fixture.onBeginContact:{
            var fixture = other
            var body = other.getBody()
            var otherEntity = body.target

            var collidingType = otherEntity.entityType

            if (collidingType === "ship")
            {
                var health = otherEntity.getComponent("health")

                if (health !== "unfined")
                    health.applyDamage(10)
            }
        }

        property real margine: scene.sceneDiagonla * 2

        body.onPositionChanged: {
            if (asteroid.x < margine ||
                asteroid.x > scene.width + margine ||
                    asteroid.y < margine ||
                    asteroid.y > scene.height + margine)
                asteroid.removeEntity()

        }
    }

    onVisibleChanged: {
        asteroid.removeEntity()
    }

    function applyForwardImpuls(){
        var rad = asteroid.rotation / 180 * Math.PI

        var localForward = Qt.point(asteroid.speedForce * Math.sin(rad), -asteroid.speedForce * Math.cos(rad))
        collider.body.applyLinearImpulse(localForward, collider.body.getWorldCenter())
    }
}
