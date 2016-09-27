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
        anchors.fill: parent
        source: "../../assets/ship.png"
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
            "right": Qt.Key_E,
            "down": Qt.Key_X
        }
    }

    BoxCollider{
        id: boxCollider

        anchors.fill: parent

        density: 0.02
        friction: 0
        restitution: 0
        body.linearDamping: rotationController.yAxis
        body.angularDamping: rotationController.yAxis

        force: Qt.point(moveController.xAxis*thrusterForce,moveController.yAxis*thrusterForce)
        torque: rotationController.xAxis * thrusterForce * 2
    }

    //TODO: Implement better version with thrusters instead of simple dampening
    Keys.onPressed: {
        if (event.key === Qt.Key_X)
        {
            boxCollider.linearDamping = 1
            boxCollider.angularDamping = 1
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_X)
        {
            boxCollider.linearDamping = 0
            boxCollider.angularDamping = 0
        }
    }

    function handleInputActions(action)
    {
    }

}
