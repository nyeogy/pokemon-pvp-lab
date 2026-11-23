-- Supabase SQL Editor에서 프로젝트 소유자가 1회 실행
create table if not exists public.pokemon_entries (
  user_id uuid not null references auth.users(id) on delete cascade,
  record_id text not null,
  data jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, record_id),
  constraint record_id_length check (length(record_id) between 1 and 160)
);
alter table public.pokemon_entries enable row level security;
revoke all on public.pokemon_entries from anon;
grant select, insert, update, delete on public.pokemon_entries to authenticated;
drop policy if exists "users_can_manage_own_pokemon" on public.pokemon_entries;
create policy "users_can_manage_own_pokemon" on public.pokemon_entries for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);
