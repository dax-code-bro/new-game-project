package com.animallife;

import net.minecraft.core.registries.Registries;
import net.minecraft.sounds.SoundEvent;
import net.neoforged.neoforge.registries.DeferredRegister;

public class AnimalLifeSounds {

    public static final DeferredRegister<SoundEvent> SOUND_EVENTS =
            DeferredRegister.create(Registries.SOUND_EVENT, AnimalLife.MOD_ID);

    // Register custom sounds here, e.g.:
    // public static final DeferredHolder<SoundEvent, SoundEvent> MY_ANIMAL_AMBIENT =
    //     SOUND_EVENTS.register("entity.my_animal.ambient",
    //         () -> SoundEvent.createVariableRangeEvent(ResourceLocation.fromNamespaceAndPath(AnimalLife.MOD_ID, "entity.my_animal.ambient")));
}
