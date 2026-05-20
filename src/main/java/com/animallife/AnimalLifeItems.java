package com.animallife;

import net.minecraft.core.registries.Registries;
import net.minecraft.world.item.Item;
import net.neoforged.neoforge.registries.DeferredRegister;

public class AnimalLifeItems {

    public static final DeferredRegister<Item> ITEMS =
            DeferredRegister.create(Registries.ITEM, AnimalLife.MOD_ID);

    // Register custom items here, e.g.:
    // public static final DeferredHolder<Item, Item> MY_ITEM =
    //     ITEMS.register("my_item", () -> new Item(new Item.Properties()));
}
