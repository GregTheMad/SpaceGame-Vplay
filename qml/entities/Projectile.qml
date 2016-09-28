import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: projectile
    entityId: "entity"
    entityType: "projectile"

    width: 10
    height: 10

    property real speed: 10000

    Component.onCompleted: {
        applyForwardImpuls()
    }

    Rectangle{
        anchors.fill: parent
        color: "red"
    }

    CircleCollider{
        id: collider
        anchors.centerIn: parent
        radius: parent.width/2

        density: 0.1
        friction: 0
        restitution: 0
        body.linearDamping: 0
        body.angularDamping: 0

        fixture.onBeginContact:{
            var fixture = other
            var body = other.getBody()
            var otherEntity = body.target

            var collidingType = otherEntity.entityType

            projectile.removeEntity()
            return
        }
    }

    function applyForwardImpuls() {
        var rad = projectile.rotation / 180 * Math.PI

        var localForward = Qt.point(projectile.speed * Math.sin(rad), -projectile.speed * Math.cos(rad))
        collider.body.applyLinearImpulse(localForward, collider.body.getWorldCenter())
    }
}
