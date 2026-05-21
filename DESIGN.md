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

## Law & Order System

### Causing a Ruckus in Town
- Sheriff's office floods with cops in waves immediately
- Tracking dogs assist in hunting down the player
- Once caught — arrested and taken to jail

### Jail Penalties
- **25 real minutes** served in physical jail (player is actually inside the jail cell)
- **1/5 of total money** permanently removed
- **3 game day ban** from that town upon release

### Breaking the Ban
- Entering the banned town during the 3-day ban = instant wanted status
- The **Sheriff himself** personally comes out
- The **Sheriff is completely invincible** — cannot be killed, only outrun

---

## Towns of Texas

### Town of Rust
- **Location:** Dead center of the Texas map — the main central hub
- **Known for:** Rabbit and quail hunting grounds

### Town of Foxboro
- **Status:** Poor and struggling
- **Problem:** Foxes constantly killing their livestock — NPCs are sick and depressed
- **Quest:** Exterminate 15 fox nests around the town
- **After Quest:** Town visibly transforms — becomes lively, NPCs recover, atmosphere brightens

### Town of Yellowstone
- **Notable character:** A friendly white bison named **Tundra** lives at a camp near the town
- White bison are exceptionally rare and significant
- Tundra is the same bison encountered later in the "I See Ends" mission

---

## House Requirements
Every profession starts with or builds a house. A structure only counts as a house if it contains all three:
1. **Crafting Station**
2. **Bed**
3. **Locker**

### The Locker
The locker is the player's personal management hub. Used to:
- Store items
- Change out active Buddy
- Browse and take on new jobs
- Manage equipment

---

## Buddy System
Three unique named companions, each with their own backstory and special abilities. Far more powerful and unique than regular dogs or horses. Only one active Buddy at a time. Managed through the Locker.

Available Buddies:
- **Tundra**
- **Crimson Archer**
- **Bulldozer**

---

### Tundra (White Bison)
**How to Unlock:** Complete the mission **"I See Ends"**
- Travel to Antarctica to tranquilize an animal
- Mission goes wrong — Tundra is found trapped in barbed wire
- Free her and complete the mission
- Boss lets you keep Tundra as a reward AND pays the full mission reward
- Note: Tundra is the same white bison seen at the Town of Yellowstone — the player meets her before the mission

**Traits:**
- Larger than a standard bison
- Albino (pure white)
- Heightened durability

**Abilities:**
- **The Wall** — Tundra physically positions her body between the player and incoming gunfire or a predator, absorbing all hits
- **Forager** — Activates a tracking ability that leads the player to the nearest food source, berries, or edible plants

### Crimson — Legendary Red Golden Retriever
**Backstory:** Retired Green Beret service dog after 5 years of active duty. His military training has fundamentally rewired his retriever instincts — mission-critical gear comes before ducks.

**Traits:**
- Legendary red golden retriever (rare coloring)
- Legendary combat skills from Green Beret service

**Abilities:**
- **Retriever Instinct** — Can still fetch birds and ducks during hunting like a normal golden retriever
- **Gear Run** — Fetches equipment, ammo, and supplies from fallen enemies or the environment and delivers them directly to the player (inspired by Boom Boom from Far Cry 5)
- Elite combat capability far beyond a normal dog

---

### Archer — Human Companion
**Backstory:**
- Born into and raised by a Native American tribe
- Tribe was forcibly displaced by the military
- Led a **Native American revolution in Paris** in his mid 20s
- Fell in love with and married the **daughter of the Paris leader**
- The **President discovered the marriage**, had them separated, and declared Archer dead
- Survived his own execution and escaped — now lives off the grid as a ghost to the world
- Currently in his **early 40s**

**How to Unlock:**
- Travel to Asia
- Discover a broken down abandoned facility — Archer's former execution site
- Environmental clues inside:
  - Photo of a woman on the ground
  - A Glock lying nearby
  - Rows of chairs
  - Document reading *"The execution of the outlaw known as Archer"*
- Find a piece of paper with his location
- Track him down to complete the unlock

**Combat:**
- Primary weapons: **Compound bow and crossbow**
- Arrow types: Fire arrows, explosive arrows, and wide variety of others
- Sidearm: **Glock** (a concession to his years in hiding — still prefers the bow)
- Rides his horse **Wild** — brown with white stripes

---

### Bulldozer — Tiger/Black Panther Hybrid
**Appearance:**
- Mixed tiger and black panther coloring
- Severely overweight and visually massive
- Retains agility and stealth despite his size

**Stats:**
- Extra weight significantly boosts health and defense — essentially a tank
- Still capable of stealth approach before combat

**How to Unlock:**
- Travel to an **illegal animal breeding facility**
- Access a computer containing **20 files total**
- Most players will open scary-sounding files (which do contain dangerous animals) or delete all files to complete the quest
- **File P037** — unassuming name, easy to miss among 19 other files
- Opening P037 reveals Bulldozer's file
- Player character has a spontaneous change of heart and decides to rescue him
- Completely optional, no quest marker, no hints — pure player-driven discovery

**Special Ability — The Maul:**
- Does not pounce and wrestle like a normal big cat
- Slaps enemies into ragdoll physics with brute force
- Bites and throws enemies — pure power over technique
- His size means enemies don't get mauled, they get launched

---

## 100% Completion Reward

### The Sunset Cutscene
Triggers automatically upon completing every achievement and job in the mod:
- Every hired crew member and named NPC appears
- Every named animal that died appears as a **ghost**
- All gathered together watching a sunset
- A quiet, emotional memorial for the entire journey

### Completion Gear
- **Full black gunslinger outfit**
- **Custom golden revolver**

---

## Animal Hunter Profession

### Overview
The most expensive class in the game. Built around high-stakes guided hunts with massive entry fees that require serious grinding to afford. Introduces hunting mechanics, taxidermy, and a wide arsenal of weapons.

### Hunt Tiers & Pricing
| Hunt | Price | Animals |
|------|-------|---------|
| Texas Hunt | $25,000 | Local Texas wildlife |
| Standard Africa Tour | $10,000 | Small African animals |
| Premium Africa Hunt | $25,000 | Medium African animals |
| Elite Africa Hunt | $100,000 | Record-sized animals (massive water buffalo, etc.) |

Note: **$10,000 is exceptionally hard to earn** — the $100,000 elite hunt is a true endgame milestone just to afford entry.

### Hunting Zones & Hunting Pressure
- Each continent has defined **hunting zones**
- **Hunting pressure system:** Hunt an area too much and animals will begin avoiding it
- Pressured animals relocate to different **feeding and sleeping zones**
- Animals arrive at specific **times of day** — timing matters for a successful hunt
- Forces players to rotate zones and hunt responsibly

### Taxidermy System
- Unlocks the **Taxidermy Tool**
- Requires a **truck** — animal must be loaded onto the truck bed
- Transport the animal back to the **hunting lodge**
- Taxidermy the animal realistically at the lodge
- Choose between:
  - **Head mount**
  - **Full body mount**

### Trophy Rating System
Animals are rated as trophies. Known trophy animals include:
- Red Deer
- Mule Deer
- Water Buffalo (record-sized available in Elite tier)
- Aggressive Hyenas
- (More to be defined)

### Animal Hunter Weapons
- Blowgun
- Compound Bow
- Elephant Rifle
- .308
- .243
- Many additional firearms (to be expanded)

---

## Global Systems & Standards

### Auto-Breeding (Applies to All Animals)
- Animals do **not** require the player to manually initiate breeding
- Breeding happens automatically when conditions are right
- Players CAN still manually breed for genetic selection purposes
- This applies to all animal species across all professions

### Visual & Technical Standards
- **No blind or flat textures** on any item — everything must be realistic and clean
- All item models must be detailed and polished
- **Realistic shaders** applied globally to improve atmosphere and immersion
- These standards apply to every single asset in the mod — no exceptions

---
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
