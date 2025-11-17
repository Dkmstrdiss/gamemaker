# Roadmap GameMaker – Cling TCG

## 1. Foundations
- [x] Create GMS2 project  
- [x] Define enums (`CardType`, `Zone`, `Phase`)  
- [x] Implement `Player_Create()` struct  
- [x] Define starting values (life, board arrays, final breath flags)

## 2. Card Data Model
- [x] Create global card database (`global.card_db`)  
- [x] Define base attributes (id, name, type, stats, flags, effect_id)  
- [x] Implement `CardInstance_Create()`  
- [x] Choose storage format (GML scripts → JSON later)

## 3. Game Controller
- [ ] Create `oGameController`  
- [ ] Initialize players  
- [ ] Build + shuffle decks  
- [ ] Draw opening hands + Mulligan  
- [ ] Implement phase state machine  
- [ ] Define phase transitions (DRAW → MAIN → ATTACK → DEFENSE → RESOLUTION → END)

## 4. Board Representation (UI)
- [ ] Create `oCardDisplay`  
- [ ] Create `oBoardSlot`  
- [ ] Implement board layout (attack/defense lines, action column)  
- [ ] Link logic ↔ visuals (card struct ↔ slot object)  
- [ ] Rotation / exhausted visualization

## 5. Player Interaction
- [ ] Implement card selection system  
- [ ] Implement placement rules (costs, restrictions, lines)  
- [ ] Implement attack declaration  
- [ ] Implement defense selection  
- [ ] Implement “no defense” option  
- [ ] Detect valid targets and highlight them

## 6. Combat & Parade (PRD)
- [ ] Implement combat resolution (offensive vs offensive)  
- [ ] Implement defensive interception logic  
- [ ] Implement PRD reduction rules  
- [ ] Implement Essoufflement (exhaustion) states  
- [ ] Implement PRD cooldown (3 turns to recharge)  
- [ ] Implement restrictions on position changes (swap only)

## 7. Effect System
- [ ] Create central `Card_ResolveEffect()`  
- [ ] Define triggers (`ON_PLAY`, `ON_ATTACK`, `ON_DEATH`, etc.)  
- [ ] Implement simple effects (stat boosts, draw, banish)  
- [ ] Implement intermediate effects (swap stats, double attack…)  
- [ ] Implement fusion/legendary logic  
- [ ] Implement synergy effects between specific card IDs

## 8. Special Rules
- [ ] Legendary summoning (sacrifices required)  
- [ ] Legendary uniqueness (1 copy per field per player)  
- [ ] Fusion conditions  
- [ ] Final Breath activation (deck empty)  
- [ ] Final Breath 5-turn countdown  
- [ ] End-of-game resolution (dice / attack-PRD comparison)

## 9. Interface & Feedback
- [ ] HUD for life, phase, turn  
- [ ] PRD indicators  
- [ ] Card highlight states  
- [ ] Combat preview  
- [ ] Minimal combat log  
- [ ] Debug mode (force draw, spawn card, view struct)

## 10. Deck Builder & Persistence
- [x] Deck editor UI  
- [x] Save deck to text 
- [ ] Load deck at match start  
- [ ] Export/import system for testing
