-- ============================================================
--  Quiniela Mundial — Esquema Supabase (Postgres + RLS + RPC)
--  Pegar TODO esto en: Supabase → SQL Editor → New query → Run.
--  Seguro de re-ejecutar (usa IF NOT EXISTS / on conflict).
-- ============================================================

-- ---------- TABLAS ----------

-- settings: fila única (id=1). Lectura pública; solo admin escribe.
create table if not exists public.settings (
  id int primary key default 1 check (id = 1),
  locked boolean not null default false,
  scoring jsonb not null default '{"r16":1,"qf":2,"sf":4,"fin":6,"champ":10,"exact":3,"diff":1}'::jsonb,
  updated_at timestamptz not null default now()
);
insert into public.settings(id) values (1) on conflict (id) do nothing;

-- official: el "answer key" (resultados reales). Se revela solo al bloquear.
create table if not exists public.official (
  id int primary key default 1 check (id = 1),
  picks jsonb not null default '{}'::jsonb,   -- { winners:{slot:{c,n}}, scores:{slot:[g0,g1]} }
  updated_at timestamptz not null default now()
);
insert into public.official(id) values (1) on conflict (id) do nothing;

-- brackets: un registro por participante.
create table if not exists public.brackets (
  id uuid primary key default gen_random_uuid(),
  token uuid not null,                        -- secreto del dispositivo (para poder editar)
  name text not null,
  picks jsonb not null,                       -- { winners:{...}, scores:{...} }
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists brackets_token_idx on public.brackets(token);

-- ---------- ROW LEVEL SECURITY ----------
alter table public.settings enable row level security;
alter table public.official enable row level security;
alter table public.brackets enable row level security;

-- settings: todos leen; solo admin autenticado actualiza.
drop policy if exists s_read  on public.settings;
drop policy if exists s_write on public.settings;
create policy s_read  on public.settings for select using (true);
create policy s_write on public.settings for update to authenticated using (true) with check (true);

-- official: lectura solo si está bloqueado (o si eres admin); escritura solo admin.
drop policy if exists o_read  on public.official;
drop policy if exists o_write on public.official;
create policy o_read  on public.official for select
  using ( (select locked from public.settings where id = 1) or auth.role() = 'authenticated' );
create policy o_write on public.official for update to authenticated using (true) with check (true);

-- brackets: lectura pública solo al bloquear (admin siempre); borrado solo admin.
-- No hay INSERT/UPDATE directos para anónimos: se hace por la función submit_bracket.
drop policy if exists b_read   on public.brackets;
drop policy if exists b_delete on public.brackets;
create policy b_read   on public.brackets for select
  using ( (select locked from public.settings where id = 1) or auth.role() = 'authenticated' );
create policy b_delete on public.brackets for delete to authenticated using (true);

-- ---------- RPC: guardar / editar bracket ----------
-- Valida que no esté bloqueado y que tenga nombre. Upsert por token.
create or replace function public.submit_bracket(p_token uuid, p_name text, p_picks jsonb)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_locked boolean;
  v_id uuid;
begin
  select locked into v_locked from settings where id = 1;
  if v_locked then
    raise exception 'El torneo está cerrado; ya no se aceptan cambios.';
  end if;
  if coalesce(trim(p_name), '') = '' then
    raise exception 'El nombre es obligatorio.';
  end if;

  update brackets
     set name = p_name, picks = p_picks, updated_at = now()
   where token = p_token
   returning id into v_id;

  if v_id is null then
    insert into brackets(token, name, picks)
    values (p_token, p_name, p_picks)
    returning id into v_id;
  end if;

  return v_id;
end;
$$;

revoke all on function public.submit_bracket(uuid, text, jsonb) from public;
grant execute on function public.submit_bracket(uuid, text, jsonb) to anon, authenticated;

-- ============================================================
--  Después de correr esto:
--   1) Authentication → Users → Add user: crea tu usuario admin (email + password).
--   2) Project Settings → API: copia Project URL y anon public key.
--   3) Pega esas 2 claves en app.js (SUPABASE_URL y SUPABASE_ANON_KEY).
-- ============================================================
