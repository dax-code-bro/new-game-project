# Animal Life Mod — Design Document

## Overview
A NeoForge 1.21.4 Minecraft mod set in a grounded, realistic world with no enchantments, no diamond armor, no Nether, and no magic. The world is survival-focused with real animal husbandry, temperature management, and economy systems.

---

## World / Continents
Four playable continents (Texas is the starting focus):
- **Texas** — ranges from Arizona-style desert heat to lush forests
- **Antarctica** — extreme cold environment
- **Africa** — to be designed later
- **Fourth continent** — to be named later

Terrain generation to be designed later.

---

## Profession Selection
On first spawn, a menu appears letting the player choose a profession:
- Rancher
- Vet
- Animal Importer
- Butcher
- Animal Seller

---

## Rancher Profession

### Starting Out
- Player starts with **$500**
- Purchase a plot of land using starting money (small ranch)
- The **Town Mayor NPC** gives you: Axe, Saw, Crafting Table
- Gather resources and build your house (standard Minecraft building/crafting system)

### Fence Tiers
Three tiers of fencing (behavior/stats to be designed later):
1. Standard Fence
2. Reinforced Barbed Wire
3. Electric Fence

### Earning Money
- **Animal shows** — enter animals in shows, judged on real-world criteria
- **Sell animals** — direct sales
- **Bounty system** — tie up bandits alive and deliver them to the sheriff for a cash reward

---

## Animal Systems

### Farm Animal Species (real-world breeds)
All animals have realistic 3D models (not flat/blocky), with sexual dimorphism (males and females look different).

| Animal   | Species Count |
|----------|--------------|
| Sheep    | 40           |
| Cows     | 30           |
| Pigs     | 50           |
| Chickens | 30           |
| Ducks    | 60           |
| Quail    | 15           |
| Wild/Other Birds | 60   |
| **Total** | **285**     |

### Lifecycle
- **Juvenile phase:** ~200 Minecraft days (~83 real hours) to grow to adult
- **Adult phase:** ~800 Minecraft days (~333 real hours) default lifespan
- **Total default lifespan:** 1000 Minecraft days (~416 real hours / ~17.4 real days)
- **Elder phase:** Animals CAN live indefinitely past 1000 days if all four condition pillars are maxed out continuously
- **Baby condition matters:** How well the animal was cared for as a baby directly influences lifespan potential

### Condition System
Four pillars that must all be maintained (must be maxed at all times during elder phase):
1. **Shelter**
2. **Water**
3. **Food**
4. **Energy**

Condition must progressively improve as the animal grows or it risks early death.

### Feeding & Watering
- **Food troughs** and **water troughs** — animals automatically walk up and feed/drink on their own
- **Hay bales** left in open fields — animals will graze on them naturally
- Player does not need to manually feed every animal

### Herd Behavior (AI)
- Animals naturally group together over time
- Herds travel, eat, and drink together
- **Herd leaders** emerge organically
- **Dominance fights** occur between males
- One dominant male leads breeding in a herd

### Male Management (Real Ranching Technique)
- Only one male should be active in the herd at a time to prevent constant dominance fights
- Keep additional males in **separate pens**
- To rotate males:
  1. Put a leash on the current male OR whistle for him if he's bonded/imprinted
  2. Lead him back to his pen
  3. Shut the gate
  4. Bring out the next male and introduce him to the herd

### Breeding & Genetics
- Males and females look different (sexual dimorphism)
- **Males are genetically dominant** — their traits have stronger influence on offspring
- **Gestation:** Female carries for 8 game days
- **Growth to adult:** ~200 Minecraft days
- **Genetics are complex** — hidden genetic values passed down through generations
- Selective breeding over generations can improve traits in a bloodline

### Animal Show Judging Criteria (Genetics-driven)
Primary factors that affect show score:
- Straight back (conformation/structure)
- Groomed (presentation — active player effort before show)
- Good quality hide (coat/wool/skin quality)
- Good handling (temperament)
- Muscle (build/muscling)

All factors are primarily influenced by genetics.

### Imprinting & Bonding
- Hand-feeding or spending time near a baby animal builds a bond
- Imprinting is strongest during the baby phase and fades as the animal matures
- **If not built during the baby window, the bond is much harder to form**
- A bonded/imprinted animal will follow the player and respond to a whistle
- Bond level built during youth persists into adulthood but requires ongoing maintenance or it continues to decay

---

## Temperature System
No magic protection — survival depends on real environmental management.

### Heat (Texas)
- Prolonged exposure causes damage/debuffs
- **Mitigations:**
  - Shelter
  - Campfires (cold protection)
  - Swimming — soaked body stays cooler for longer
  - **Wet Bandit Scarf** — dip in water, wear it, provides continuous cooling; refillable whenever it dries out

### Frost (Antarctica / cold regions)
- Being wet in cold weather accelerates frost damage
- Mitigations: layered clothing, campfires, shelter (to be expanded)

---

## No Magic Rule
The following vanilla Minecraft systems **do not exist** in this mod:
- Enchantments
- Diamond armor (or any magical gear progression)
- The Nether
- Any magical mechanics

Gear progression is grounded in real-world materials (leather, iron, steel, etc.).

---

## Enemies

### Natural Predators
Target livestock, especially at night. Fence tier determines containment effectiveness.
- Coyotes
- Wolves
- Foxes
- Bobcats

### Ladrón de Animales Gang (Bandit Gang)
- NOT re-skinned Pillagers — fully custom realistic player-like character models
- **Behavior:** Act like real players — crouch carefully, open gates, shut gates behind them, appear to talk and plan with each other, laugh
- **Goal:** Secretly steal your animals and take them to an off-map camp
- **Leader:** Wears a large brown cowboy hat — easily spottable
- **Regular members:** Typically wear small black hats

#### Bandit Loot Drops
| Item | Source |
|------|--------|
| Bandit Scarf | Regular bandits |
| Bandit Shirt | Regular bandits |
| Bandit Leggings | Regular bandits |
| Bandit Boots | Regular bandits |
| Legendary Bandit Leader Hat | Leader only |

#### Bandit Clothing — Special Properties
- Provides **exclusive protection against Texas heat**
- **Bandit Scarf** — can be dipped in water; provides continuous cooling effect while wet; refillable

---

## Economy
- Starting currency: **$500** (Rancher)
- Currency used to buy land, animals, supplies
- Income sources: animal shows, animal sales, bandit bounties (deliver alive to sheriff)
