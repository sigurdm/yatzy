# Pencily Yatzy ✏️🎲

A cozy, ad-free, hand-drawn **Yatzy & Yahtzee** multiplayer game built with Flutter (`CustomPainter` double-stroked graphite aesthetic, `PatrickHand` handwriting typography, and rich custom rules).

🌐 **Play online (GitHub Pages):** [https://sigurdm.github.io/yatzy/](https://sigurdm.github.io/yatzy/)

---

## ✨ Features

- **🇪🇺 EU / Scandinavian vs. 🇺🇸 US / International Rule Styles**
  - Switch seamlessly between **Scandinavian Yatzy** (+50p upper bonus, includes *One Pair* & *Two Pairs*, 3/4 of a Kind = sum of matching dice, 15/20p straights, sum Full House) and **American Yahtzee** (+35p bonus, no pairs, 3/4 of a Kind = sum of all dice, fixed 25p Full House, 30p 4-die Small Straight, 40p 5-die Large Straight).
- **🐉 Full Tabletop RPG Polyhedral Dice (`d4`, `d6`, `d8`, `d10`, `d12`, `d20`)**
  - Custom hand-drawn geometry for every polyhedral die:
    - **`d4` Tetrahedron** (1–4)
    - **`d6` Classic Cube** (1–6)
    - **`d8` Crystal Octahedron** (1–8)
    - **`d10` Kite Decahedron** (1–10)
    - **`d12` Pentagonal Dodecahedron** (1–12)
    - **`d20` RPG Icosahedron** (1–20, with "Nat 20s" upper section scoring!)
- **🎲 Custom Rules & 9 Preset Variants**
  - Choose from **3 to 8 dice**, **1 to 5 throws per turn** (including 1-roll hardcore mode!), and Par=2/3/4 upper bonus thresholds.
  - Presets include *Mini 4-Dice Yatzy*, *Classic 5-Dice Yatzy*, *US Yahtzee*, *Maxi 6-Dice Yatzy* (with *Villa*, *Tower*, *Full Straight*), *Mega 7-Dice Yatzy* (with *Pyramid*, *Even/Odd Only*, *Super Yatzy*), *Octahedron d8 Fantasy*, *RPG d20 Crit Yatzy*, *Turbo 4-Rolls*, and *Hardcore 1-Roll*.
- **🌍 12 Languages Supported**
  - Danish (`da`), English (`en`), Swedish (`sv`), Norwegian (`no`), Finnish (`fi`), Icelandic (`is`), German (`de`), Dutch (`nl`), French (`fr`), Spanish (`es`), Italian (`it`), and Polish (`pl`).
- **↩️ Multi-Step Undo & Instant Turn Roll**
  - Full turn history undo button and persistent score highlighting until the next roll.

---

## 🚀 Running Locally

```bash
flutter pub get
flutter test
flutter run -d chrome
```

## 📦 Building for Web / GitHub Pages

```bash
flutter build web --release --base-href "/yatzy/"
```
