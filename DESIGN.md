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

### Wallet System
- Money is never a loose item — always stored in a physical **Wallet** item
- Retrieved from the **Mayor's stash** at the start of the game
- **Death-proof** — survives death even without keep inventory
- Hold out the Wallet to see current balance at the bottom of the screen
- **Right click** to withdraw a specific amount
- Can be stored back in the Mayor's stash for safekeeping
- Loose money left in chests CAN be stolen by bandits — always keep money in the Wallet

---

## Animal Lifecycle Stages
All animals progress through five stages (exact day ranges vary per species):

1. **Baby** — Small and fragile, depends on mother, prime imprint window
2. **Juvenile** — Growing strong, learning herd behavior, imprint fading
3. **Sub Adult** — Nearly full size, partial production yield
4. **Adult** — Fully mature, maximum yield, breeding capable
5. **Elder** — Lives indefinitely with perfect condition management (all four pillars maxed at all times)

---

## Rancher Unlock Chart
1. **Heat Management I** — Basic heat survival introduction
2. **Heat Management II** — Improved heat resistance
3. **Heat Management III** — Advanced heat resistance
4. **Gentle Presence I** — Calming spooked animals 10% easier
5. **Gentle Presence II** — Calming spooked animals 15% easier
6. **Gentle Presence III** — Calming spooked animals 20% easier
7. **Imprint Master** — All imprinting bonds form 45% faster permanently
8. **Lasso** — Unlocks the Lasso item for catching and restraining animals/bandits
9. **Home Defense** — When bandits raid your property: +10% speed, +10% health, Strength II
10. **Home Defense Sweeper** — Unlocks the pump-action shotgun
    - Shell types: 12 Gauge, Buckshot, Birdshot, Explosive (5 TNT equivalent damage, no property damage)
    - Range: 60 damage point blank, 15 damage mid range, no hit beyond mid range
11. **Little Helper** — Unlocks ability to buy a dog (15 real-world breeds)
12. **Big Helper** — Unlocks ability to buy a horse (15 real-world breeds)
    - Dogs and horses have their own bonding/imprint system

### Rancher Starting Items
- Basic Survival Axe
- Pocket Knife
- $500 (in Wallet)

---

## Animal Importer Profession

### Overview
Transport animals across Texas and between continents via truck and aircraft.

### Vehicles
- **Truck** — ground transport for same-continent deliveries; upgradeable, multiple models available
- **Cargo Helicopter / Planes** — intercontinental transport; upgradeable, multiple models available
- All vehicles have **full physical hitboxes** — walkable interiors, openable doors, interactive buttons
- Plane interior: side door opens, feed/water stations in back, animal crate area

### Contract Tiers
| Tier | Legality | Animals | Complications |
|------|----------|---------|---------------|
| Level 1 | Legal | Small animals (ducks, chickens) | None |
| Level 2 | Legal, regulated | Medium to large animals | Border patrol inspection required |
| Level 3 | Fully illegal | Diseased, feral, wild, exceptionally large, aggressive animals | Must fight/flee if caught |

### Level 3 Transport — Animal Management
Four meters to manage during transport:
1. **Food meter** — must stay maxed or Sleep and Boredom drain rapidly
2. **Water meter** — must stay maxed or Sleep and Boredom drain rapidly
3. **Sleep meter** — maintained via tranquilizer dart injections (refillable)
4. **Boredom meter** — maintained by interacting/playing with animal through the crate

**If animal fully wakes with all meters empty:** triggers escape cutscene — animal breaks free, stands behind oblivious player, screen cuts to black, death screen appears.

### Crew System
- Recruit up to **5 crew members**
- Hundreds of available contractors to choose from
- All have realistic Minecraft-appropriate skins (no anime or out-of-place characters)
- Each crew member has: randomized name, full bio, date of birth, birthplace
- Birthplace determines **combat trait:**

| Origin | Trait | Effect |
|--------|-------|--------|
| Mexico | Vaquero's Aim | Increased projectile damage and accuracy |
| Asia | Way of the Blade | High attack speed and dodge chance |
| Africa | Apex Hunter | Faster movement speed and tracking |
| North America | Ironclad Industry | Higher armor toughness and knockback resistance |
| South America | Jungle Vitality | Poison resistance and regeneration in foliage |
| Australia | Outback Hardness | Thorns effect and heat immunity |

- Assignable roles: Point Man, Rear Guard, Explosive Man, and others
- Can be fired, switched out, reassigned as unlocks expand
- **Dialogue:** White text bubble above head, situation-aware randomized dialogue, reacts to long service and deaths
- **Morale:** High casualties increase quit chance
- **If downed and revived:** guaranteed to quit after the mission
- **If killed:** permanently dead, gone forever

### Weapons & Attachments (Unlocked at Level 15)
**Weapon:** M16

**Ammo Types:**
- M16 Tracer Rounds
- Armor Piercing Rounds

**Attachments** (compatible with other weapons too):
- Suppressor
- Short Range Scope
- Mid Range Scope
- Long Range Scope

### Animal Importer Achievements
| Achievement | How to Unlock |
|-------------|--------------|
| **First Pickup** | Complete your first Level 1 contract |
| **Going the Distance** | Complete your first cross-continent delivery |
| **Clean Delivery** | Deliver an animal with all condition meters maxed |
| **Hired Help** | Recruit your first crew member |
| **Full Squad** | Have a full crew of 5 active members |
| **World Roster** | Hire crew members from at least 4 different continents |
| **Baptism by Fire** | Survive your first Level 3 contract |
| **Ghost Run** | Complete a Level 3 contract without being detected by border patrol |
| **Last Stand** | Fight off border patrol and escape with your full crew alive |
| **No Man Left Behind** | Complete 10 Level 3 contracts without losing a single crew member |
| **The Hard Way** | Complete a Level 3 contract solo with no crew |
| **Veteran Bond** | Work with the same crew member for 50 contracts |
| **Moment of Silence** | Lose a crew member on a contract |
| **They Knew the Risk** | Lose 3 crew members in a single run |
| **Walked Away** | Have a crew member quit after being revived |
| **New Blood** | Replace a lost crew member and complete a contract |
| **Needle in Time** | Successfully re-sedate a waking Level 3 animal before it fully wakes |
| **Too Close** | Survive an animal that reached 0 on all four meters without escaping |
| **Upgrade Hungry** | Purchase your first vehicle upgrade |
| **Fleet Owner** | Own multiple trucks and aircraft simultaneously |
| **Century Mark** | Complete 100 contracts total |
| **The Importer** | Complete at least 25 contracts from each of the three tiers |
| **Sharpshooter** | Unlock the M16 at Level 15 |
| **Fully Loaded** | Use all four M16 ammo types and all four attachments |

---
