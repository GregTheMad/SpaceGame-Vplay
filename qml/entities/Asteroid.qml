import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: asteroid
    entityId: "entity"
    entityType: "customEntity"

    width: 30
    height: 30

    property real speedForce: 10000

    Component.onCompleted: {
        applyForwardImpuls()
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
    }

    function applyForwardImpuls(){
        var rad = asteroid.rotation / 180 * Math.PI

        var localForward = Qt.point(asteroid.speedForce * Math.sin(rad), -asteroid.speedForce * Math.cos(rad))
        collider.body.applyLinearImpulse(localForward, collider.body.getWorldCenter())
    }
}
