-- ============================================================================
-- RailBook Next - Modern Train Ticket Booking Platform
-- Complete PostgreSQL Database Schema
-- Matches all tables from requirements.md:
-- Users, Passengers, Stations, Trains, Routes, Bookings, Tickets, Payments, PNR, Refunds
-- ============================================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mobile VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    role VARCHAR(20) DEFAULT 'passenger' CHECK (role IN ('passenger', 'admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. STATIONS TABLE
CREATE TABLE IF NOT EXISTS stations (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zone VARCHAR(10),
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    platforms INT DEFAULT 4,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. TRAINS TABLE
CREATE TABLE IF NOT EXISTS trains (
    train_number VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(150) NOT NULL,
    train_type VARCHAR(50) NOT NULL, -- Vande Bharat, Rajdhani, Shatabdi, Superfast, Mail/Express
    source_station_code VARCHAR(10) REFERENCES stations(code) ON DELETE RESTRICT,
    dest_station_code VARCHAR(10) REFERENCES stations(code) ON DELETE RESTRICT,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    duration_minutes INT NOT NULL,
    distance_km INT NOT NULL,
    runs_on VARCHAR(50) DEFAULT 'MON,TUE,WED,THU,FRI,SAT,SUN', -- Comma-separated days
    has_pantry BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. TRAIN ROUTES / SCHEDULE TABLE (Intermediate halts)
CREATE TABLE IF NOT EXISTS train_routes (
    id SERIAL PRIMARY KEY,
    train_number VARCHAR(10) REFERENCES trains(train_number) ON DELETE CASCADE,
    station_code VARCHAR(10) REFERENCES stations(code) ON DELETE RESTRICT,
    stop_sequence INT NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    halt_minutes INT DEFAULT 2,
    distance_from_source_km INT NOT NULL DEFAULT 0,
    day_number INT DEFAULT 1,
    platform_number INT DEFAULT 1,
    UNIQUE(train_number, stop_sequence)
);

-- 5. TRAIN CLASSES & FARES TABLE
CREATE TABLE IF NOT EXISTS train_classes (
    id SERIAL PRIMARY KEY,
    train_number VARCHAR(10) REFERENCES trains(train_number) ON DELETE CASCADE,
    class_code VARCHAR(5) NOT NULL, -- 1A, 2A, 3A, 3E, CC, EC, SL, 2S
    class_name VARCHAR(50) NOT NULL,
    base_fare NUMERIC(10, 2) NOT NULL,
    tatkal_fare NUMERIC(10, 2) NOT NULL,
    total_seats INT NOT NULL DEFAULT 72,
    available_seats INT NOT NULL DEFAULT 72,
    rac_seats INT NOT NULL DEFAULT 12,
    waiting_seats INT NOT NULL DEFAULT 20,
    coaches_count INT DEFAULT 4,
    UNIQUE(train_number, class_code)
);

-- 6. COACHES TABLE
CREATE TABLE IF NOT EXISTS coaches (
    id SERIAL PRIMARY KEY,
    train_number VARCHAR(10) REFERENCES trains(train_number) ON DELETE CASCADE,
    coach_code VARCHAR(10) NOT NULL, -- e.g. B1, B2, A1, H1, S1, C1
    class_code VARCHAR(5) NOT NULL,
    total_berths INT NOT NULL DEFAULT 72,
    UNIQUE(train_number, coach_code)
);

-- 7. SAVED PASSENGERS TABLE (For fast 1-click booking)
CREATE TABLE IF NOT EXISTS saved_passengers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    berth_preference VARCHAR(20) DEFAULT 'NO_PREF', -- LOWER, MIDDLE, UPPER, SIDE_LOWER, SIDE_UPPER, WINDOW
    concession_category VARCHAR(30) DEFAULT 'GENERAL', -- GENERAL, SENIOR_CITIZEN, STUDENT, DIVYANG
    id_card_type VARCHAR(30),
    id_card_number VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. BOOKINGS TABLE
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_reference VARCHAR(20) UNIQUE NOT NULL, -- e.g. RB-2026-94821
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    train_number VARCHAR(10) REFERENCES trains(train_number) ON DELETE RESTRICT,
    from_station_code VARCHAR(10) REFERENCES stations(code) ON DELETE RESTRICT,
    to_station_code VARCHAR(10) REFERENCES stations(code) ON DELETE RESTRICT,
    journey_date DATE NOT NULL,
    class_code VARCHAR(5) NOT NULL,
    quota VARCHAR(20) DEFAULT 'GENERAL', -- GENERAL, TATKAL, LADIES, SENIOR_CITIZEN, DIVYANG
    status VARCHAR(20) DEFAULT 'CONFIRMED' CHECK (status IN ('CONFIRMED', 'RAC', 'WAITLIST', 'CANCELLED', 'PARTIALLY_CANCELLED')),
    total_passengers INT NOT NULL DEFAULT 1,
    base_amount NUMERIC(10, 2) NOT NULL,
    tax_amount NUMERIC(10, 2) NOT NULL DEFAULT 0,
    convenience_fee NUMERIC(10, 2) NOT NULL DEFAULT 17.70,
    insurance_fee NUMERIC(10, 2) NOT NULL DEFAULT 0.35,
    discount_amount NUMERIC(10, 2) DEFAULT 0,
    total_amount NUMERIC(10, 2) NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    contact_mobile VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. PNR RECORDS TABLE
CREATE TABLE IF NOT EXISTS pnr_records (
    pnr_number VARCHAR(10) PRIMARY KEY, -- 10-digit Indian Railway format
    booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
    train_number VARCHAR(10) REFERENCES trains(train_number),
    journey_date DATE NOT NULL,
    from_station_code VARCHAR(10) REFERENCES stations(code),
    to_station_code VARCHAR(10) REFERENCES stations(code),
    class_code VARCHAR(5) NOT NULL,
    chart_status VARCHAR(30) DEFAULT 'CHART_NOT_PREPARED', -- CHART_PREPARED, CHART_NOT_PREPARED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. PASSENGERS TABLE (Per-booking passenger breakdown)
CREATE TABLE IF NOT EXISTS passengers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
    pnr_number VARCHAR(10) REFERENCES pnr_records(pnr_number) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    berth_preference VARCHAR(20),
    allocated_coach VARCHAR(10),
    allocated_berth INT,
    allocated_berth_type VARCHAR(20), -- LB, MB, UB, SL, SU, WS
    booking_status VARCHAR(20) NOT NULL DEFAULT 'CNF', -- CNF, RAC, WL
    current_status VARCHAR(20) NOT NULL DEFAULT 'CNF',
    fare NUMERIC(10, 2) NOT NULL,
    concession_category VARCHAR(30) DEFAULT 'GENERAL',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 11. TICKETS TABLE
CREATE TABLE IF NOT EXISTS tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
    ticket_number VARCHAR(30) UNIQUE NOT NULL,
    pnr_number VARCHAR(10) REFERENCES pnr_records(pnr_number) ON DELETE CASCADE,
    qr_code_data TEXT NOT NULL,
    pdf_url VARCHAR(255),
    is_cancelled BOOLEAN DEFAULT FALSE,
    issued_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 12. PAYMENTS TABLE
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    transaction_id VARCHAR(100) UNIQUE NOT NULL,
    payment_method VARCHAR(30) NOT NULL, -- UPI, RAZORPAY, STRIPE, CARD, NETBANKING, WALLET
    amount NUMERIC(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'INR',
    status VARCHAR(20) DEFAULT 'SUCCESS' CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED')),
    gateway_response JSONB,
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 13. REFUNDS TABLE
CREATE TABLE IF NOT EXISTS refunds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    booking_id UUID REFERENCES bookings(id) ON DELETE CASCADE,
    payment_id UUID REFERENCES payments(id) ON DELETE SET NULL,
    refund_reference VARCHAR(100) UNIQUE NOT NULL,
    cancellation_reason TEXT,
    refund_amount NUMERIC(10, 2) NOT NULL,
    cancellation_charge NUMERIC(10, 2) NOT NULL DEFAULT 60.00,
    status VARCHAR(20) DEFAULT 'PROCESSED' CHECK (status IN ('REQUESTED', 'PROCESSED', 'FAILED')),
    processed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- INDEXES FOR MAXIMUM SEARCH & BOOKING VELOCITY
CREATE INDEX IF NOT EXISTS idx_trains_src_dest ON trains(source_station_code, dest_station_code);
CREATE INDEX IF NOT EXISTS idx_train_routes_train ON train_routes(train_number, stop_sequence);
CREATE INDEX IF NOT EXISTS idx_train_routes_station ON train_routes(station_code);
CREATE INDEX IF NOT EXISTS idx_train_classes_train ON train_classes(train_number, class_code);
CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_ref ON bookings(booking_reference);
CREATE INDEX IF NOT EXISTS idx_pnr_number ON pnr_records(pnr_number);
CREATE INDEX IF NOT EXISTS idx_passengers_booking ON passengers(booking_id);
CREATE INDEX IF NOT EXISTS idx_payments_booking ON payments(booking_id);
