import VPlay 2.0
import QtQuick 2.0

Item {
    id: health

    property real maxHealth: 10
    property real currentHealth: maxHealth

    onCurrentHealthChanged: {
        if (currentHealth <= 0)
        {
            //TODO: Kill the parent in a dynamic, parent controlled manner.
            console.debug("parent type: " + parent)
            parent.removeEntity()
        }
    }

    function applyDamage(damage){
        currentHealth -= damage
    }
}
