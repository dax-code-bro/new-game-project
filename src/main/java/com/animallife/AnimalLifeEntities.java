package com.animallife;

import net.neoforged.neoforge.registries.DeferredRegister;
import net.minecraft.core.registries.Registries;
import net.minecraft.world.entity.EntityType;

public class AnimalLifeEntities {

    public static final DeferredRegister<EntityType<?>> ENTITY_TYPES =
            DeferredRegister.create(Registries.ENTITY_TYPE, AnimalLife.MOD_ID);

    // Register custom entity types here, e.g.:
    // public static final DeferredHolder<EntityType<?>, EntityType<MyAnimal>> MY_ANIMAL =
    //     ENTITY_TYPES.register("my_animal", () -> EntityType.Builder.of(...).build(...));
}
