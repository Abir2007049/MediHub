-- ============================================================
-- MediHub Database Schema
-- ============================================================
-- 1. Profiles table (patients)
create table if not exists public.profiles (
    id uuid references auth.users on delete cascade not null primary key,
    full_name text,
    phone text unique,
    avatar_url text,
    role text not null default 'patient',
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
-- 2. Doctors table
create table if not exists public.doctors (
    id uuid references auth.users on delete cascade not null primary key,
    full_name text not null,
    email text not null unique,
    phone text,
    nid text,
    license text unique,
    specialization text,
    hospital text,
    department text,
    degree text,
    medical_college text,
    location text default 'Dhaka',
    description text,
    consultation_fee integer default 500,
    diagnostic text default 'MediHub Centre',
    experience text,
    profile_image text,
    role text not null default 'doctor',
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
-- ============================================================
-- Row Level Security
-- ============================================================
alter table public.profiles enable row level security;
alter table public.doctors enable row level security;
-- Profiles policies
create policy "Users can view own profile" on profiles for
select using (auth.uid() = id);
create policy "Users can insert own profile" on profiles for
insert with check (auth.uid() = id);
create policy "Users can update own profile" on profiles for
update using (auth.uid() = id);
-- Doctors policies
create policy "Anyone can view doctors" on doctors for
select using (true);
create policy "Doctors can insert own profile" on doctors for
insert with check (auth.uid() = id);
create policy "Doctors can update own profile" on doctors for
update using (auth.uid() = id);
-- ============================================================
-- Triggers: auto-update updated_at
-- ============================================================
create or replace function public.handle_updated_at() returns trigger as $$ begin new.updated_at = timezone('utc'::text, now());
return new;
end;
$$ language plpgsql;
create trigger on_profiles_updated before
update on public.profiles for each row execute procedure public.handle_updated_at();
create trigger on_doctors_updated before
update on public.doctors for each row execute procedure public.handle_updated_at();