-- Tabla donde la página guarda cada test terminado.
-- Pégalo completo en Supabase → SQL Editor → New query → Run.

create table if not exists public.resultados (
  id uuid primary key default gen_random_uuid(),
  creado_en timestamptz not null default now(),
  nombre text not null check (char_length(nombre) between 3 and 60),
  localidad text not null check (char_length(localidad) <= 120),
  acepta_autorizacion boolean not null check (acepta_autorizacion),
  predominante text not null,
  ascendente text not null,
  claridad text,
  codigo text,
  indices jsonb,
  respuestas jsonb,
  version text
);

-- Seguridad: el público solo puede INSERTAR. Nadie con la llave pública puede leer, editar ni borrar.
alter table public.resultados enable row level security;

drop policy if exists "publico puede insertar" on public.resultados;
create policy "publico puede insertar"
  on public.resultados for insert
  to anon, authenticated
  with check (true);

grant insert on public.resultados to anon, authenticated;
revoke select, update, delete on public.resultados from anon;

-- Vista práctica para el equipo (se consulta desde el panel de Supabase, no desde la página).
create or replace view public.resumen_arquetipos
with (security_invoker = true) as
  select predominante, count(*) as personas
  from public.resultados
  group by predominante
  order by personas desc;
revoke all on public.resumen_arquetipos from anon, authenticated;
