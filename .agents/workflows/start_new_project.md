---
description: Create a clear project starting blueprint before implementation begins. This workflow should help define the product, technical direction, MVP scope, and execution plan so development starts with a stable foundation.
---

## Steps

### 1. Identify the project
Ask these questions in **Turkish**:
- Projenin adı nedir?
- Ürünü tek cümlede nasıl anlatırsın?
- Bu ürün hangi problemi çözüyor?
- Hedef kullanıcı kim?
- Bu proje benzer ürünlerden nasıl ayrışıyor?

### 2. Define product direction
Ask these questions in **Turkish**:
- Bu ürünün ana amacı nedir?
- Kullanıcının temel yolculuğu nasıl olacak?
- Ürünün hissi / tonu nasıl olmalı? (ör. ciddi, eğlenceli, premium, minimalist, kara mizahi)
- Marka dili, maskot veya görsel stil yönü var mı?

Then:
- Summarize the product briefly and clearly.
- Extract the core product goal.
- Identify the main user journey.
- Note the emotional tone, brand direction, and style cues.

### 3. Define MVP scope
Ask these questions in **Turkish**:
- İlk sürümde mutlaka olması gereken özellikler neler?
- Olursa iyi olur ama şart olmayan özellikler neler?
- İlk sürümde özellikle olmamasını istediğin şeyler neler?

Then:
- Separate must-have features from nice-to-have features.
- Remove anything that makes the MVP too large.
- Keep the MVP small, testable, and realistic.
- Output the final MVP scope as a short checklist.

### 4. Define technical direction
Ask these questions in **Turkish**:
- Hangi platform(lar) hedefleniyor? (mobil, web, masaüstü)
- Hangi dil veya framework kullanılacak?
- Backend veya veritabanı tercihin var mı?
- Authentication gerekli mi?
- Bildirim gerekli mi?
- Ödeme sistemi gerekli mi?
- Analytics gerekli mi?
- AI ile ilgili bir özellik gerekiyor mu?

Then:
- Propose a practical tech stack.
- Recommend a suitable architecture.
- Recommend state management if relevant.
- Recommend routing / navigation if relevant.

### 5. Define the core data model
- Identify the main entities in the product.
- List the minimum required fields for each entity.
- Separate source-of-truth data from derived / calculated data.
- Flag anything that should not be persisted directly.
- Output a simple first-pass data model.

### 6. Define the project structure
- Propose a clean folder structure.
- Suggest how features should be grouped.
- Identify shared / common layers if needed.
- Keep the structure simple enough for MVP, but scalable enough for growth.

### 7. Define implementation phases
Break the project into these phases:
- setup
- foundation
- MVP screens / features
- polish
- release prep

For each phase:
- list the main tasks
- order tasks to minimize rework

### 8. Define risks and constraints
- Identify technical risks.
- Identify product risks.
- Identify scope creep risks.
- Call out assumptions that could cause expensive mistakes later.

### 9. Generate execution outputs
Produce:
- short project summary
- final MVP feature list
- recommended tech stack
- architecture summary
- initial folder structure
- first implementation order
- known risks / open questions

## Output style
- Be concise and structured.
- Prefer bullet points over long paragraphs.
- Focus on decisions that prevent wasted time later.
- If something is unclear, ask in Turkish instead of inventing details.
- Keep the plan practical, not aspirational.