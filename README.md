# Quiniela Mundial 2026 — Bracket del grupo

Página estática (bracket interactivo) + base de datos gratuita (Supabase) para que tu
grupo de WhatsApp llene su bracket, predigan **quién avanza** y el **marcador** de cada
partido, y tú como admin cargues los resultados oficiales y armes la **tabla de puntos**.

- **Frontend:** `index.html` + `app.js` (se sirve en GitHub Pages, sin servidor propio).
- **Backend:** Supabase (Postgres + Auth + RLS). Las claves que van en el código son
  **públicas por diseño**; la seguridad real vive en las reglas del servidor.

---

## 1) Crear el backend (Supabase) — una sola vez

1. Crea una cuenta gratis en <https://supabase.com> → **New project** (guarda la contraseña de la DB).
2. Abre **SQL Editor → New query**, pega TODO el contenido de [`supabase.sql`](./supabase.sql) y dale **Run**.
3. **Authentication → Users → Add user**: crea tu usuario **admin** (email + contraseña).
   Eso es lo que usarás para entrar a la sección de admin.
4. **Project Settings → API**: copia **Project URL** y **anon public key**.

## 2) Conectar el frontend

En [`app.js`](./app.js), arriba del todo, reemplaza:

```js
const SUPABASE_URL      = 'https://TU-PROYECTO.supabase.co';
const SUPABASE_ANON_KEY = 'TU_ANON_KEY';
```

con tus dos valores del paso 1.4. (Si los dejas sin configurar, la app funciona en
**modo local** para probar el bracket, pero no guarda en la nube.)

## 3) Publicar en GitHub Pages

1. Crea un repo y sube estos archivos: `index.html`, `app.js`, `supabase.sql`, `README.md`.
2. **Settings → Pages → Build and deployment → Deploy from a branch → `main` / `/ (root)`** → Save.
3. Tu enlace queda en `https://<usuario>.github.io/<repo>/`. Ese es el que compartes al grupo.

---

## Cómo se usa

**Tus amigos** (pestaña *Mi Bracket*):
1. Escriben su **nombre**.
2. Tocan cada partido y ponen el **marcador** + **quién avanza** (los 16vos ya vienen fijos).
3. Le dan **Guardar**. Pueden volver y corregir mientras el torneo esté abierto.

**Tú, admin** (entra por la ruta oculta `…/#admin`):
1. Inicia sesión con tu email + contraseña de Supabase.
2. Carga los **resultados oficiales** (ganador + marcador de cada partido; puedes ir ronda por ronda).
3. **Bloquear torneo** cuando ya nadie deba cambiar nada.
4. Al bloquear, todos ven la **Tabla de Puntos** y los **brackets de los demás**.

## Puntaje (ajustable en la tabla `settings.scoring`)

- **Acertar quién avanza:** 8vos = 1 · cuartos = 2 · semis = 4 · finalistas = 6 · campeón = 10.
- **Marcador** (solo si el cruce coincide con el oficial): exacto **+3**, diferencia de goles correcta **+1**.

---

## Notas

- Cada quien guarda su bracket en **su propio dispositivo** (un token en el navegador permite editarlo).
  Si cambian de dispositivo o borran datos del navegador, se crea una entrada nueva.
- Nunca subas contraseñas al repo: el admin inicia sesión en tiempo real contra Supabase.
- Las claves `anon` en `app.js` son públicas y seguras gracias a las políticas RLS de `supabase.sql`.
