import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: asteroid
    entityId: "entity"
    entityType: "customEntity"

    width: 30
    height: 30

    Image {
        anchors.fill: parent
        source: "../../assets/asteroid.png"
    }

    CircleCollider{
        id: circleCollider

        anchors.centerIn: parent
        radius: parent.width/2

        density: 0.1
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0
    }
}
