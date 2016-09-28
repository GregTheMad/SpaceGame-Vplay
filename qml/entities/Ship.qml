import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: ship
    entityType: "customEntity"

    width: 40
    height: 60

    rotation: 45

    property real thrusterForce: 5000

    property alias moveController: moveController
    property alias rotationController: rotationController

    Image {
        id: image
        anchors.fill: parent
        source: "../../assets/ship.png"

        property list<Item> imagePoints:[Item{x: image.width/2+30}]
    }

    TwoAxisController {
        id: moveController

        onInputActionPressed: handleInputActions(actionName)

        inputActionsToKeyCode: {
            "up" : Qt.Key_S,
                    "down": Qt.Key_W,
                    "left": Qt.Key_A,
                    "right": Qt.Key_D
        }
    }

    TwoAxisController{
        id: rotationController

        inputActionsToKeyCode: {
            "left": Qt.Key_Q,
            "right": Qt.Key_E
        }
    }

    BoxCollider{
        id: boxCollider

        anchors.fill: parent

        density: 0.1
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0

        force: Qt.point(moveController.xAxis*thrusterForce,moveController.yAxis*thrusterForce)
        torque: rotationController.xAxis * thrusterForce * ship.height/4
    }

    //TODO: Implement better version with thrusters instead of simple dampening
    Keys.onPressed: {
        if (event.key === Qt.Key_Space)
        {
            boxCollider.linearDamping = 1
            boxCollider.angularDamping = 1
        }

        if (event.key === Qt.Key_Tab)
        {
            fireProjectile()
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Space)
        {
            boxCollider.linearDamping = 0
            boxCollider.angularDamping = 0
        }
    }

    function fireProjectile()
    {
        var imagePointInWorldCoord = mapToItem(scene, image.imagePoints[0].x, image.imagePoints[0].y)

        entityManager.createEntityFromUrlWithProperties(
                    Qt.resolvedUrl("Projectile.qml"),
                    {"x": imagePointInWorldCoord.x, "y": imagePointInWorldCoord.y, "rotation": ship.rotation })
    }

}
