import VPlay 2.0
import QtQuick 2.0

import "../items"

EntityBase {
    id: ship
    entityType: "ship"

    width: 40
    height: 60

    rotation: 45

    property real thrusterForce: 10000

    property alias moveController: moveController
    property alias rotationController: rotationController
    property alias health: health
    property alias collider: collider

    Health{
        id: health
        maxHealth: 50
        objectName: "health"
    }

    Image {
        id: image
        anchors.fill: parent
        source: "../../assets/ship.png"

        property list<Item> imagePoints:[Item{x: image.width/2; y: -20}]
    }

    TwoAxisController {
        id: moveController
        objectName: "moveController"

        inputActionsToKeyCode: {
            "up" : Qt.Key_S,
                    "down": Qt.Key_W,
                    "left": Qt.Key_A,
                    "right": Qt.Key_D
        }
    }

    //FIXME: Make this a 1DController of sorts, or find a use for the second axis
    TwoAxisController{
        id: rotationController
        objectName: "rotationController"

        inputActionsToKeyCode: {
            "left": Qt.Key_Q,
            "right": Qt.Key_E
        }
    }

    BoxCollider{
        id: collider

        anchors.fill: parent

        density: 0.1
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0

        force: Qt.point(moveController.xAxis*thrusterForce,moveController.yAxis*thrusterForce)

        torque: rotationController.xAxis * thrusterForce * ship.height/4

        body.onPositionChanged:
        {
            //TODO: reduce calculations and replace them with properties

            if (ship.x < -ship.height)
                ship.x += scene.width + ship.height

            if (ship.x > scene.width + ship.height)
                ship.x -= scene.width + ship.height

            if (ship.y < -ship.height)
                ship.y += scene.height + ship.height

            if (ship.y > scene.height + ship.height)
                ship.y -= scene.height + ship.height
        }

        fixture.onBeginContact:{
            var fixture = other
            var body = other.getBody()
            var otherEntity = body.target

            var collidingType = otherEntity.entityType

            if (collidingType === "asteroid")
            {
                var health = otherEntity.getComponent("health")

                if (health !== "unfined")
                {
                    health.applyDamage(10)
                }
            }
            return
        }
    }

    //TODO: Implement better version with thrusters instead of simple dampening
    Keys.onPressed: {
        if (event.key === Qt.Key_Space)
        {
            collider.linearDamping = 1
            collider.angularDamping = 1
        }

        if (event.key === Qt.Key_Tab)
        {
            fireProjectile()
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Space)
        {
            collider.linearDamping = 0
            collider.angularDamping = 0
        }
    }

    onVisibleChanged: {
        moveController.enabled = false
        rotationController.enabled = false
        collider.enabled = false
    }

    function fireProjectile()
    {
        var imagePointInWorldCoord = mapToItem(scene, image.imagePoints[0].x, image.imagePoints[0].y)

        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Projectile.qml"),
                    {"x": imagePointInWorldCoord.x, "y": imagePointInWorldCoord.y, "rotation": ship.rotation })
    }

}
