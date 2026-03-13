-- ============================================================
-- blocked_licenses table
-- Stores suspended/blocked BMDC license numbers
-- ============================================================
create table if not exists public.blocked_licenses (
    license text primary key,
    reason text,
    blocked_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.blocked_licenses enable row level security;

-- Anyone can check if a license is blocked (used during pre-auth signup flow)
create policy "Anyone can read blocked licenses"
    on public.blocked_licenses for select
    using (true);

-- Only service_role (admin) can insert/update/delete blocked licenses
-- (no insert/update/delete policies for regular users)

-- Seed existing blocked registrations (from BMDC notices)
insert into public.blocked_licenses (license, reason) values
    ('A-57882', 'Suspended per BMDC notice'),
    ('A-78864', 'Suspended per BMDC notice'),
    ('A-53065', 'Suspended per BMDC notice'),
    ('A-49675', 'Suspended per BMDC notice'),
    ('A-53658', 'Suspended per BMDC notice'),
    ('A-42757', 'Suspended per BMDC notice'),
    ('A-95890', 'Suspended per BMDC notice'),
    ('A-104355', 'Suspended per BMDC notice'),
    ('A-35620', 'Suspended per BMDC notice'),
    ('A-67372', 'Suspended per BMDC notice')
on conflict (license) do nothing;
