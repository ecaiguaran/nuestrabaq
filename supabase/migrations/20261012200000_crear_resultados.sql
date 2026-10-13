-- Tabla donde la página guarda cada test terminado.
-- La integración de Supabase con GitHub aplica este archivo sola. Si prefieres hacerlo a mano: SQL Editor → New query → pega todo → Run.

create table if not exists public.resultados (
  id uuid primary key default gen_random_uuid(),
  creado_en timestamptz not null default now(),
  nombre text not null check (char_length(nombre) between 3 and 60),
  localidad text not null check (char_length(localidad) <= 120),
  acepta_autorizacion boolean not null check (acepta_autorizacion),
  predominante text not null check (char_length(predominante) <= 40),
  ascendente text not null check (char_length(ascendente) <= 40),
  claridad text check (claridad in ('Alta','Media','Baja')),
  codigo text check (char_length(codigo) <= 20),
  indices jsonb check (pg_column_size(indices) < 2000),
  respuestas jsonb check (pg_column_size(respuestas) < 4000),
  version text check (char_length(version) <= 30)
);

-- Seguridad: el público solo puede INSERTAR. Nadie con la llave pública puede leer, editar ni borrar.
alter table public.resultados enable row level security;

drop policy if exists "publico puede insertar" on public.resultados;
create policy "publico puede insertar"
  on public.resultados for insert
  to anon, authenticated
  with check (acepta_autorizacion);

revoke all on public.resultados from anon, authenticated;
grant insert on public.resultados to anon, authenticated;

-- Vista práctica para el equipo (se consulta desde el panel de Supabase, no desde la página).
create or replace view public.resumen_arquetipos
with (security_invoker = true) as
  select predominante, count(*) as personas
  from public.resultados
  group by predominante
  order by personas desc;
revoke all on public.resumen_arquetipos from anon, authenticated;
