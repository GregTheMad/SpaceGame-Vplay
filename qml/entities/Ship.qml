import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: ship
    entityType: "customEntity"

    width: 40
    height: 60

    x: parent.width/2
    y: parent.height/2

    rotation: 45

    Image {
        anchors.fill: parent
        source: "../assets/ship.png"
    }

    TwoAxisController {
        id: twoAxisController

        onInputActionPressed: handleInputActions(actionName)

        inputActionsToKeyCode: {
            "forward" : Qt.Key_W
        }
    }

    CircleCollider{

    }

    function handleInputActions(action)
    {
        if (action === "forward")
        {
            ship.x += 10
        }
    }

}
