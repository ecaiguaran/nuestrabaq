# ¿Qué arquetipo de liderazgo eres?

Test de arquetipos de liderazgo de NuestraBarranquilla para encuentros y eventos de jóvenes. Es una página estática (`index.html`) que se publica gratis con **GitHub Pages** y guarda los resultados en **Supabase**.

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `index.html` | El test completo (preguntas, logos, resultados). |
| `config.js` | Los datos de conexión a Supabase. **Es el único archivo que tienes que editar.** |
| `supabase/schema.sql` | Crea la tabla `resultados` y sus reglas de seguridad. |

## 1. Crear la base de datos en Supabase (≈10 min)

1. Entra a <https://supabase.com>, crea una cuenta y haz clic en **New project**.
   - Nombre: `nuestrabaq`. Región: **East US** o **São Paulo** (las más cercanas a Colombia).
   - Guarda la contraseña de la base de datos en un lugar seguro.
2. Cuando el proyecto esté listo, ve a **SQL Editor → New query**, pega todo el contenido de `supabase/schema.sql` y presiona **Run**. Debe decir *Success*.
3. Ve a **Project Settings → API** (o **Data API / API Keys**) y copia:
   - **Project URL** → algo como `https://abcdefghijkl.supabase.co`
   - **Publishable key** (`sb_publishable_...`) o, en proyectos antiguos, la **anon public** (`eyJ...`).
   - ⚠️ **Nunca** uses la `service_role` / `secret` key en la página.
4. Abre `config.js` y pega ambos valores:
   ```js
   window.SUPABASE = {
     url: "https://abcdefghijkl.supabase.co",
     key: "sb_publishable_xxxxxxxx"
   };
   ```

## 2. Publicar la página con GitHub Pages (≈5 min)

1. Sube los cambios a GitHub (o edita `config.js` directamente en github.com con el lápiz ✏️).
2. En el repositorio: **Settings → Pages**.
3. En *Build and deployment* → **Source: Deploy from a branch**, escoge la rama (`main`, o la rama donde esté `index.html`) y la carpeta **/ (root)**. Guarda.
4. En 1–2 minutos aparece el link: `https://ecaiguaran.github.io/nuestrabaq/`.

> GitHub Pages en repositorios **privados** requiere plan pago. Si el repo es privado y no quieres pagar: hazlo público (no hay datos sensibles en el código) o arrastra la carpeta a <https://app.netlify.com/drop>.

## 3. Ver los resultados

- **Supabase → Table Editor → `resultados`**: ves cada persona que terminó el test.
- Botón **Export → CSV** para bajarlo a Excel / Google Sheets.
- **SQL Editor** → `select * from resumen_arquetipos;` para ver cuántas personas hay por arquetipo.

## Cómo probar que guarda

1. Abre la página publicada, haz el test completo hasta ver tu tarjeta.
2. Recarga el Table Editor en Supabase: debe aparecer una fila nueva.
3. Si no aparece, abre la consola del navegador (F12): un error `401` = llave mal copiada; `404` = no corriste el SQL; `403`/`42501` = faltan las políticas del SQL.

## Seguridad

- La llave pública solo permite **insertar** filas; no permite leer, editar ni borrar (lo controla RLS en `schema.sql`).
- Los datos solo se ven entrando a tu panel de Supabase.
- El plan gratis de Supabase pausa proyectos tras 7 días sin actividad: entra al panel antes del evento si llevas tiempo sin usarlo.
