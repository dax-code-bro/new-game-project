package com.animallife;

import com.mojang.logging.LogUtils;
import net.neoforged.bus.api.IEventBus;
import net.neoforged.fml.ModContainer;
import net.neoforged.fml.common.Mod;
import net.neoforged.fml.event.lifecycle.FMLCommonSetupEvent;
import org.slf4j.Logger;

@Mod(AnimalLife.MOD_ID)
public class AnimalLife {

    public static final String MOD_ID = "animallife";
    private static final Logger LOGGER = LogUtils.getLogger();

    public AnimalLife(IEventBus modEventBus, ModContainer modContainer) {
        modEventBus.addListener(this::commonSetup);

        AnimalLifeEntities.ENTITY_TYPES.register(modEventBus);
        AnimalLifeItems.ITEMS.register(modEventBus);
        AnimalLifeSounds.SOUND_EVENTS.register(modEventBus);
    }

    private void commonSetup(final FMLCommonSetupEvent event) {
        LOGGER.info("Animal Life initialized.");
    }
}
