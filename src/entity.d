module entity;

import ids;
import util.parser;

abstract class Component {
    const static int ID = Id.UNKNOWN;

    void onInitialize(Entity entity);
    void onDeinitialize(Entity entity);
    void onUpdate(Entity entity);

    void setArguments(Argument[] arguments);
}

class Entity {
    Component[] components;

    void addComponent(Component component) {
        components ~= component;
    }
}

class EntityTemplate : Entity {
    // each of the components associated with an entity template
    // will be added to the entity upon instanciation

    // each component's onInitialize() will be called upon instanciation
    // of the entity

    Entity createInstance() {
        Entity e = new Entity;
        foreach(component; this.components) {
            e.addComponent(component);
        }

        return e;
    }
}
