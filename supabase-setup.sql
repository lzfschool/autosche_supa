-- ============================================================
-- 拔河賽自動賽程表：Supabase 初始化
-- 在 Supabase 主控台 → SQL Editor 貼上整段後按 Run（可重複執行）
-- ============================================================

-- 1. 賽程資料表：每個房間、每個年級一列
create table if not exists public.tugofwar (
  room       text        not null,
  grade      text        not null,
  data       jsonb       not null,
  updated_at timestamptz not null default now(),
  primary key (room, grade)
);

alter table public.tugofwar enable row level security;
grant select, insert, update on public.tugofwar to anon, authenticated;

drop policy if exists "tugofwar_select" on public.tugofwar;
drop policy if exists "tugofwar_insert" on public.tugofwar;
drop policy if exists "tugofwar_update" on public.tugofwar;
create policy "tugofwar_select" on public.tugofwar for select to anon, authenticated using (true);
create policy "tugofwar_insert" on public.tugofwar for insert to anon, authenticated with check (true);
create policy "tugofwar_update" on public.tugofwar for update to anon, authenticated using (true) with check (true);

-- 2. 開啟即時推播（Realtime）
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'tugofwar'
  ) then
    alter publication supabase_realtime add table public.tugofwar;
  end if;
end $$;

-- 3. 每日喚醒用的小表（GitHub Actions 每天寫入一次，避免免費專案因閒置被暫停）
create table if not exists public.keepalive (
  id        int         primary key,
  pinged_at timestamptz not null default now()
);

alter table public.keepalive enable row level security;
grant select, insert, update on public.keepalive to anon, authenticated;

drop policy if exists "keepalive_select" on public.keepalive;
drop policy if exists "keepalive_insert" on public.keepalive;
drop policy if exists "keepalive_update" on public.keepalive;
create policy "keepalive_select" on public.keepalive for select to anon, authenticated using (true);
create policy "keepalive_insert" on public.keepalive for insert to anon, authenticated with check (id = 1);
create policy "keepalive_update" on public.keepalive for update to anon, authenticated using (id = 1) with check (id = 1);

insert into public.keepalive (id) values (1) on conflict (id) do nothing;
