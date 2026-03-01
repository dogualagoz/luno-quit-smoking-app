# 🎨 Luno — Flutter Tema Referansı

> **Maskot:** Ciğerito (tatlı ama yaralı akciğer) 🫁
> **Font:** Nunito (Google Fonts) — Ağırlıklar: 400, 500, 600, 700, 800
> **Paket:** `google_fonts: ^6.1.0`

---

## Renk Tokenleri

### Açık Tema (Light)

| Token            | Hex                   | Flutter             |
| ---------------- | --------------------- | ------------------- |
| background       | `#FAF8F5`             | `Color(0xFFFAF8F5)` |
| foreground       | `#2D2A3E`             | `Color(0xFF2D2A3E)` |
| card             | `#FFFFFF`             | `Color(0xFFFFFFFF)` |
| primary          | `#E8A0BF`             | `Color(0xFFE8A0BF)` |
| secondary        | `#F0E6EF`             | `Color(0xFFF0E6EF)` |
| muted            | `#F3EFF2`             | `Color(0xFFF3EFF2)` |
| muted-foreground | `#8A8494`             | `Color(0xFF8A8494)` |
| accent           | `#FCE4EC`             | `Color(0xFFFCE4EC)` |
| destructive      | `#E57373`             | `Color(0xFFE57373)` |
| border           | `rgba(45,42,62,0.08)` | `Color(0x142D2A3E)` |
| input-bg         | `#F5F2F4`             | `Color(0xFFF5F2F4)` |
| ring             | `#E8A0BF`             | `Color(0xFFE8A0BF)` |

### Koyu Tema (Dark)

| Token            | Hex                     | Flutter             |
| ---------------- | ----------------------- | ------------------- |
| background       | `#1A1625`               | `Color(0xFF1A1625)` |
| foreground       | `#E8E4EF`               | `Color(0xFFE8E4EF)` |
| card             | `#231E30`               | `Color(0xFF231E30)` |
| primary          | `#D4789E`               | `Color(0xFFD4789E)` |
| secondary        | `#2D2640`               | `Color(0xFF2D2640)` |
| muted            | `#2D2640`               | `Color(0xFF2D2640)` |
| muted-foreground | `#9B95A8`               | `Color(0xFF9B95A8)` |
| accent           | `#3A2D45`               | `Color(0xFF3A2D45)` |
| destructive      | `#E57373`               | `Color(0xFFE57373)` |
| border           | `rgba(232,228,239,0.1)` | `Color(0x1AE8E4EF)` |
| ring             | `#D4789E`               | `Color(0xFFD4789E)` |

---

## Grafik / Vurgu Renkleri

### Light

| Kullanım          | Hex       | Flutter             |
| ----------------- | --------- | ------------------- |
| chart-1 (primary) | `#E8A0BF` | `Color(0xFFE8A0BF)` |
| chart-2 (success) | `#A8D8B9` | `Color(0xFFA8D8B9)` |
| chart-3 (info)    | `#B8C5E8` | `Color(0xFFB8C5E8)` |
| chart-4 (warning) | `#F0C987` | `Color(0xFFF0C987)` |
| chart-5 (purple)  | `#C4A8E8` | `Color(0xFFC4A8E8)` |

### Dark

| Kullanım          | Hex       | Flutter             |
| ----------------- | --------- | ------------------- |
| chart-1 (primary) | `#D4789E` | `Color(0xFFD4789E)` |
| chart-2 (success) | `#7BC49A` | `Color(0xFF7BC49A)` |
| chart-3 (info)    | `#8FA4D4` | `Color(0xFF8FA4D4)` |
| chart-4 (warning) | `#DBB06E` | `Color(0xFFDBB06E)` |
| chart-5 (purple)  | `#A87FD4` | `Color(0xFFA87FD4)` |

---

## Gradient'ler

| İsim           | Light                       | Dark                        | Flutter                                                          |
| -------------- | --------------------------- | --------------------------- | ---------------------------------------------------------------- |
| Primary Button | `135deg, #E8A0BF → #D4789E` | `135deg, #D4789E → #B85E82` | `LinearGradient(colors: [Color(0xFFE8A0BF), Color(0xFFD4789E)])` |
| Success Button | `135deg, #A8D8B9 → #7BC49A` | `135deg, #7BC49A → #5AAF7A` | `LinearGradient(colors: [Color(0xFFA8D8B9), Color(0xFF7BC49A)])` |
| Recovery Bar   | `90deg, #A8D8B9 → #7BC49A`  | `90deg, #7BC49A → #5AAF7A`  | `LinearGradient(colors: [Color(0xFFA8D8B9), Color(0xFF7BC49A)])` |

---

## Tipografi Ölçeği

| İsim               | Size   | Weight | Flutter                                       | Kullanım                        |
| ------------------ | ------ | ------ | --------------------------------------------- | ------------------------------- |
| H1 / Başlık        | 28.8px | 800    | `fontSize: 28.8, fontWeight: FontWeight.w800` | Ana başlık, onboarding title    |
| H2 / Sayfa Başlığı | 22.4px | 700    | `fontSize: 22.4, fontWeight: FontWeight.w700` | Sayfa başlıkları ("Merhaba, X") |
| H3 / Kart Başlığı  | 17.6px | 700    | `fontSize: 17.6, fontWeight: FontWeight.w700` | Section title, kart başlıkları  |
| Büyük Sayı         | 48px   | 800    | `fontSize: 48, fontWeight: FontWeight.w800`   | Slider değer gösterimi          |
| İstatistik Değer   | 24px   | 700    | `fontSize: 24, fontWeight: FontWeight.w700`   | Dashboard stat değerleri        |
| Özet Değer         | 20.8px | 800    | `fontSize: 20.8, fontWeight: FontWeight.w800` | Quick summary bar               |
| Body / Paragraf    | 14.1px | 400    | `fontSize: 14.1, fontWeight: FontWeight.w400` | Ana metin, açıklama             |
| Body Semibold      | 13.6px | 600    | `fontSize: 13.6, fontWeight: FontWeight.w600` | Seçenek metinleri               |
| Label / Etiket     | 13.1px | 600    | `fontSize: 13.1, fontWeight: FontWeight.w600` | Alt başlık, form label          |
| Button Hızlı Seç   | 12.8px | 600    | `fontSize: 12.8, fontWeight: FontWeight.w600` | Quick pick butonları            |
| Caption            | 12.5px | 400    | `fontSize: 12.5, fontWeight: FontWeight.w400` | Stat label, yardımcı metin      |
| Footnote / İpucu   | 11.5px | 400    | `fontSize: 11.5, fontWeight: FontWeight.w400` | Alt bilgi, gizlilik metni       |
| Micro              | 10.9px | 400    | `fontSize: 10.9, fontWeight: FontWeight.w400` | Çok küçük bilgi metni           |
| Nav Label          | 9.6px  | 600    | `fontSize: 9.6, fontWeight: FontWeight.w600`  | Bottom nav etiketleri           |

---

## Spacing / Boşluklar

| İsim                | Değer   | Flutter                                        |
| ------------------- | ------- | ---------------------------------------------- |
| Page Horizontal     | 20px    | `EdgeInsets.symmetric(horizontal: 20)`         |
| Page Top            | 24px    | `EdgeInsets.only(top: 24)`                     |
| Card Padding        | 16–20px | `EdgeInsets.all(16)` / `EdgeInsets.all(20)`    |
| Section Gap         | 20–24px | `SizedBox(height: 20)`                         |
| Card Gap (Grid)     | 12px    | `SizedBox(width: 12, height: 12)`              |
| Element Gap         | 8–10px  | `SizedBox(height: 8)` / `SizedBox(height: 10)` |
| Icon Padding        | 10px    | `EdgeInsets.all(10)`                           |
| Bottom Nav PaddingB | 24px    | `EdgeInsets.only(bottom: 24)`                  |
| Bottom Nav Height   | ~80px   | `height: 80`                                   |
| Content Bottom Pad  | 96px    | `EdgeInsets.only(bottom: 96)`                  |

---

## Border Radius

| İsim                 | Değer  | Flutter                       |
| -------------------- | ------ | ----------------------------- |
| Card / Ana Kart      | 16px   | `BorderRadius.circular(16)`   |
| Button               | 16px   | `BorderRadius.circular(16)`   |
| Input                | 12px   | `BorderRadius.circular(12)`   |
| Icon Container       | 12px   | `BorderRadius.circular(12)`   |
| Chip / Quick Pick    | 12px   | `BorderRadius.circular(12)`   |
| Progress Bar         | 9999px | `BorderRadius.circular(9999)` |
| Checkbox             | 8px    | `BorderRadius.circular(8)`    |
| Mascot Speech Bubble | 16px   | `BorderRadius.circular(16)`   |

---

## Gölgeler (Shadows)

| İsim               | Flutter                                                                                       |
| ------------------ | --------------------------------------------------------------------------------------------- |
| shadow-sm (Kart)   | `BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: Offset(0, 1))` |
| shadow-lg (Button) | `BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 15, offset: Offset(0, 4))` |

---

## Ciğerito Maskot Modları

**Modlar:** `default`, `sad`, `happy`, `worried`, `sarcastic`, `proud`

### Maskot Renkleri

| Parça           | Hex       |
| --------------- | --------- |
| body (default)  | `#F4C2D7` |
| blush           | `#F0A0B8` |
| bandaid         | `#FFE0B2` |
| outline         | `#D4789E` |
| eyes / mouth    | `#2D2A3E` |
| tear (sad)      | `#A8D8E8` |
| sparkle (proud) | `#F0C987` |

---

## Bileşen Anatomisi

### StatCard

- **Background:** card · **Border:** border · **Radius:** 16px · **Padding:** 16px · **Shadow:** sm
- Icon: 18px, `bg: primary/20`, `color: primary`, `radius: 12px`, `padding: 10px`
- Label: 0.78rem / w400, `color: muted-foreground`
- Value: 1.5rem / w700, `color: foreground`
- Subtext: 0.72rem / w400, `color: muted-foreground`

### Seçim Butonu

- **Active:** `bg: primary/10` · `border: primary/30` · `text: primary` · w600, check icon
- **Inactive:** `bg: secondary/30` · `border: border` · `text: foreground` · w400

### CTA Butonları

- **Height:** ~56px (py-4) · **Radius:** 16px · **Shadow:** lg · **Text:** white / w700
- **Primary:** `gradient 135deg #E8A0BF → #D4789E`
- **Success:** `gradient 135deg #A8D8B9 → #7BC49A`
- **Disabled:** `bg: secondary` · `text: muted-foreground` · w600

### Bottom Navigation

- 6 tab: Home, Damage, Recovery, Crisis, History, Settings
- Icon size: 20px
- Active: `color: primary` · strokeWidth 2.5 · dot indicator
- Inactive: `color: muted-foreground` · strokeWidth 1.8
- Label: 9.6px / w600
- Background: `card/95 + backdrop-blur`
- Border top: 1px border
- Padding bottom: 24px (safe area)

---

## Hazır Flutter Tema Kodu

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CigeritoTheme {
  // ─── Light Theme ───
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAF8F5),
    cardColor: const Color(0xFFFFFFFF),
    textTheme: GoogleFonts.nunitoTextTheme(),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFE8A0BF),
      secondary: Color(0xFFF0E6EF),
      surface: Color(0xFFFFFFFF),
      error: Color(0xFFE57373),
      onPrimary: Color(0xFF2D2A3E),
      onSecondary: Color(0xFF2D2A3E),
      onSurface: Color(0xFF2D2A3E),
      onError: Color(0xFFFFFFFF),
    ),
  );

  // ─── Dark Theme ───
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1625),
    cardColor: const Color(0xFF231E30),
    textTheme: GoogleFonts.nunitoTextTheme(
      ThemeData.dark().textTheme,
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4789E),
      secondary: Color(0xFF2D2640),
      surface: Color(0xFF231E30),
      error: Color(0xFFE57373),
      onPrimary: Color(0xFFE8E4EF),
      onSecondary: Color(0xFFE8E4EF),
      onSurface: Color(0xFFE8E4EF),
      onError: Color(0xFF1A1625),
    ),
  );

  // ─── Chart Colors ───
  static const chartLight = [
    Color(0xFFE8A0BF), // chart-1
    Color(0xFFA8D8B9), // chart-2
    Color(0xFFB8C5E8), // chart-3
    Color(0xFFF0C987), // chart-4
    Color(0xFFC4A8E8), // chart-5
  ];

  static const chartDark = [
    Color(0xFFD4789E),
    Color(0xFF7BC49A),
    Color(0xFF8FA4D4),
    Color(0xFFDBB06E),
    Color(0xFFA87FD4),
  ];

  // ─── Spacing ───
  static const double pagePadH = 20;
  static const double pagePadT = 24;
  static const double cardPad = 16;
  static const double sectionGap = 20;
  static const double cardGap = 12;
  static const double elementGap = 8;

  // ─── Radius ───
  static final cardRadius = BorderRadius.circular(16);
  static final buttonRadius = BorderRadius.circular(16);
  static final inputRadius = BorderRadius.circular(12);
  static final chipRadius = BorderRadius.circular(12);
  static final fullRadius = BorderRadius.circular(9999);
}
```
