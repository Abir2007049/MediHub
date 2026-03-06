-- ============================================================
-- 3. Appointments table
-- ============================================================
create table if not exists public.appointments (
    id uuid default gen_random_uuid() not null primary key,
    patient_id uuid references public.profiles(id) on delete cascade not null,
    doctor_id uuid references public.doctors(id) on delete cascade not null,
    patient_name text,
    patient_mobile text,
    doctor_name text,
    specialization text,
    location text,
    selected_day text not null,
    serial_number integer not null,
    approximate_time text,
    consultation_fee integer default 500,
    payment_method text,
    slot_time timestamp with time zone,
    status text default 'confirmed',
    is_follow_up boolean default false,
    parent_appointment_id uuid references public.appointments(id),
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table public.appointments
add constraint unique_booking unique (doctor_id, selected_day, serial_number);
-- 4. Prescriptions table
create table if not exists public.prescriptions (
    id uuid default gen_random_uuid() not null primary key,
    appointment_id uuid references public.appointments(id) on delete cascade not null,
    doctor_id uuid references public.doctors(id) on delete cascade not null,
    patient_id uuid references public.profiles(id) on delete cascade not null,
    doctor_name text,
    doctor_specialization text,
    patient_name text,
    patient_mobile text,
    medicines jsonb default '[]'::jsonb,
    tests jsonb default '[]'::jsonb,
    notes text,
    has_follow_up boolean default false,
    follow_up_date text,
    follow_up_fee text,
    follow_up_booked boolean default false,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
-- 5. Reviews table
create table if not exists public.reviews (
    id uuid default gen_random_uuid() not null primary key,
    doctor_id uuid references public.doctors(id) on delete cascade not null,
    patient_id uuid references public.profiles(id) on delete cascade not null,
    patient_name text,
    rating double precision not null check (
        rating >= 1
        and rating <= 5
    ),
    comment text,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
-- 6. Doctor schedules table
create table if not exists public.doctor_schedules (
    id uuid default gen_random_uuid() not null primary key,
    doctor_id uuid references public.doctors(id) on delete cascade not null,
    day_of_week text not null,
    time_range text not null,
    total_seats integer default 30,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null,
    updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
-- ============================================================
-- RLS for new tables
-- ============================================================
alter table public.appointments enable row level security;
alter table public.prescriptions enable row level security;
alter table public.reviews enable row level security;
alter table public.doctor_schedules enable row level security;
-- Appointments policies
create policy "Patients can view own appointments" on appointments for
select using (auth.uid() = patient_id);
create policy "Doctors can view their appointments" on appointments for
select using (auth.uid() = doctor_id);
create policy "Patients can create appointments" on appointments for
insert with check (auth.uid() = patient_id);
create policy "Users can update own appointments" on appointments for
update using (
        auth.uid() = patient_id
        or auth.uid() = doctor_id
    );
-- Prescriptions policies
create policy "Patients can view own prescriptions" on prescriptions for
select using (auth.uid() = patient_id);
create policy "Doctors can view their prescriptions" on prescriptions for
select using (auth.uid() = doctor_id);
create policy "Doctors can create prescriptions" on prescriptions for
insert with check (auth.uid() = doctor_id);
create policy "Doctors can update prescriptions" on prescriptions for
update using (auth.uid() = doctor_id);
-- Reviews policies
create policy "Anyone can read reviews" on reviews for
select using (true);
create policy "Patients can create reviews" on reviews for
insert with check (auth.uid() = patient_id);
create policy "Patients can update own reviews" on reviews for
update using (auth.uid() = patient_id);
-- Doctor schedules policies
create policy "Anyone can view schedules" on doctor_schedules for
select using (true);
create policy "Doctors can manage own schedules" on doctor_schedules for
insert with check (auth.uid() = doctor_id);
create policy "Doctors can update own schedules" on doctor_schedules for
update using (auth.uid() = doctor_id);
create policy "Doctors can delete own schedules" on doctor_schedules for delete using (auth.uid() = doctor_id);
-- Triggers for updated_at
create trigger on_prescriptions_updated before
update on public.prescriptions for each row execute procedure public.handle_updated_at();
create trigger on_doctor_schedules_updated before
update on public.doctor_schedules for each row execute procedure public.handle_updated_at();