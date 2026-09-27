-- ============================================================================
-- RailBook Next - Modern Train Ticket Booking Platform
-- Comprehensive Seed Data
-- ============================================================================

-- 1. STATIONS
INSERT INTO stations (code, name, city, state, zone, latitude, longitude, platforms) VALUES
('NDLS', 'New Delhi Railway Station', 'New Delhi', 'Delhi', 'NR', 28.6430, 77.2195, 16),
('MMCT', 'Mumbai Central', 'Mumbai', 'Maharashtra', 'WR', 18.9712, 72.8197, 8),
('CSMT', 'Chhatrapati Shivaji Maharaj Terminus', 'Mumbai', 'Maharashtra', 'CR', 18.9400, 72.8354, 18),
('HWH', 'Howrah Junction', 'Kolkata', 'West Bengal', 'ER', 22.5839, 88.3433, 23),
('MAS', 'MGR Chennai Central', 'Chennai', 'Tamil Nadu', 'SR', 13.0825, 80.2757, 15),
('SBC', 'KSR Bengaluru City Junction', 'Bengaluru', 'Karnataka', 'SWR', 12.9781, 77.5696, 10),
('PNBE', 'Patna Junction', 'Patna', 'Bihar', 'ECR', 25.6022, 85.1376, 10),
('ADI', 'Ahmedabad Junction', 'Ahmedabad', 'Gujarat', 'WR', 23.0270, 72.6012, 12),
('BSB', 'Varanasi Junction', 'Varanasi', 'Uttar Pradesh', 'NR', 25.3283, 82.9856, 9),
('CNB', 'Kanpur Central', 'Kanpur', 'Uttar Pradesh', 'NCR', 26.4542, 80.3507, 10),
('BPL', 'Bhopal Junction', 'Bhopal', 'Madhya Pradesh', 'WCR', 23.2678, 77.4124, 6),
('HYB', 'Hyderabad Deccan', 'Hyderabad', 'Telangana', 'SCR', 17.3934, 78.4687, 6),
('MAO', 'Madgaon Junction (Goa)', 'Madgaon', 'Goa', 'KR', 15.2736, 73.9789, 4),
('JP', 'Jaipur Junction', 'Jaipur', 'Rajasthan', 'NWR', 26.9196, 75.7878, 8),
('PUNE', 'Pune Junction', 'Pune', 'Maharashtra', 'CR', 18.5284, 73.8739, 6),
('AGC', 'Agra Cantt', 'Agra', 'Uttar Pradesh', 'NCR', 27.1591, 78.0069, 6)
ON CONFLICT (code) DO NOTHING;

-- 2. USERS (Password is 'password123' bcrypt hashed: $2a$10$w8TfW8pZkUvA84Jt8wWbteI8G4y0s6E4m5mI... or plain placeholder for seeded accounts)
INSERT INTO users (id, name, email, mobile, password_hash, role, dob, gender) VALUES
('a0000000-0000-0000-0000-000000000001', 'Admin Officer', 'admin@railbook.com', '9876543210', '$2a$10$X7mDlhBupf1.Z8x0sRkFYeP0YtB1xVb3PZ1W.Y2W1j7yK4/tMhyY.', 'admin', '1985-05-15', 'Male'),
('a0000000-0000-0000-0000-000000000002', 'Rahul Sharma', 'rahul@example.com', '9812345678', '$2a$10$X7mDlhBupf1.Z8x0sRkFYeP0YtB1xVb3PZ1W.Y2W1j7yK4/tMhyY.', 'passenger', '1994-08-20', 'Male'),
('a0000000-0000-0000-0000-000000000003', 'Priya Patel', 'priya@example.com', '9823456789', '$2a$10$X7mDlhBupf1.Z8x0sRkFYeP0YtB1xVb3PZ1W.Y2W1j7yK4/tMhyY.', 'passenger', '1998-11-12', 'Female')
ON CONFLICT (email) DO NOTHING;

-- 3. SAVED PASSENGERS FOR RAHUL
INSERT INTO saved_passengers (id, user_id, name, age, gender, berth_preference, concession_category) VALUES
('b0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Rahul Sharma', 30, 'Male', 'LOWER', 'GENERAL'),
('b0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000002', 'Anita Sharma', 58, 'Female', 'LOWER', 'SENIOR_CITIZEN'),
('b0000000-0000-0000-0000-000000000003', 'a0000000-0000-0000-0000-000000000002', 'Rohan Sharma', 10, 'Male', 'WINDOW', 'STUDENT')
ON CONFLICT (id) DO NOTHING;

-- 4. TRAINS
INSERT INTO trains (train_number, train_name, train_type, source_station_code, dest_station_code, departure_time, arrival_time, duration_minutes, distance_km, runs_on, has_pantry) VALUES
('12952', 'Mumbai Tejas Rajdhani Express', 'Rajdhani', 'NDLS', 'MMCT', '16:55:00', '08:35:00', 940, 1384, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('12951', 'New Delhi Tejas Rajdhani Express', 'Rajdhani', 'MMCT', 'NDLS', '17:00:00', '08:32:00', 932, 1384, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('22436', 'Vande Bharat Express', 'Vande Bharat', 'NDLS', 'BSB', '06:00:00', '14:00:00', 480, 759, 'TUE,WED,FRI,SAT,SUN', true),
('22435', 'Vande Bharat Express', 'Vande Bharat', 'BSB', 'NDLS', '15:00:00', '23:00:00', 480, 759, 'TUE,WED,FRI,SAT,SUN', true),
('12002', 'Bhopal Shatabdi Express', 'Shatabdi', 'NDLS', 'BPL', '06:00:00', '14:40:00', 520, 707, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('12302', 'Howrah Rajdhani Express', 'Rajdhani', 'NDLS', 'HWH', '16:50:00', '09:55:00', 1025, 1451, 'MON,TUE,WED,THU,SAT,SUN', true),
('12622', 'Tamil Nadu Superfast Express', 'Superfast', 'NDLS', 'MAS', '21:05:00', '06:15:00', 1990, 2182, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('20901', 'Mumbai - Gandhinagar Vande Bharat', 'Vande Bharat', 'MMCT', 'ADI', '06:10:00', '11:25:00', 315, 491, 'MON,TUE,WED,THU,FRI,SAT', true),
('12138', 'Punjab Mail', 'Mail/Express', 'NDLS', 'CSMT', '05:15:00', '07:35:00', 1580, 1541, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('12560', 'Shiv Ganga Express', 'Superfast', 'NDLS', 'BSB', '20:05:00', '06:10:00', 605, 759, 'MON,TUE,WED,THU,FRI,SAT,SUN', false),
('12954', 'August Kranti Tejas Rajdhani', 'Rajdhani', 'NDLS', 'MMCT', '17:15:00', '10:05:00', 1010, 1377, 'MON,TUE,WED,THU,FRI,SAT,SUN', true),
('12626', 'Kerala Superfast Express', 'Superfast', 'NDLS', 'SBC', '20:10:00', '16:30:00', 2660, 2370, 'MON,TUE,WED,THU,FRI,SAT,SUN', true)
ON CONFLICT (train_number) DO NOTHING;

-- 5. TRAIN CLASSES & FARES
INSERT INTO train_classes (train_number, class_code, class_name, base_fare, tatkal_fare, total_seats, available_seats, rac_seats, waiting_seats) VALUES
-- 12952 Mumbai Rajdhani
('12952', '1A', 'AC First Class', 4200.00, 4800.00, 24, 8, 2, 0),
('12952', '2A', 'AC 2 Tier', 2650.00, 3100.00, 96, 28, 6, 0),
('12952', '3A', 'AC 3 Tier', 1880.00, 2250.00, 320, 74, 18, 5),
('12952', '3E', 'AC 3 Economy', 1720.00, 2050.00, 144, 42, 10, 0),

-- 22436 Vande Bharat (NDLS - BSB)
('22436', 'EC', 'Executive Chair Car', 2850.00, 3350.00, 52, 14, 0, 0),
('22436', 'CC', 'AC Chair Car', 1750.00, 2050.00, 480, 112, 12, 0),

-- 12002 Bhopal Shatabdi
('12002', 'EC', 'Executive Chair Car', 2420.00, 2800.00, 52, 19, 0, 0),
('12002', 'CC', 'AC Chair Car', 1315.00, 1550.00, 420, 88, 14, 0),

-- 12622 Tamil Nadu Express
('12622', '1A', 'AC First Class', 5100.00, 5800.00, 24, 5, 0, 0),
('12622', '2A', 'AC 2 Tier', 3200.00, 3750.00, 96, 18, 4, 0),
('12622', '3A', 'AC 3 Tier', 2250.00, 2680.00, 384, 55, 12, 0),
('12622', 'SL', 'Sleeper Class', 840.00, 1040.00, 540, 140, 24, 0),

-- 12138 Punjab Mail
('12138', '2A', 'AC 2 Tier', 2450.00, 2900.00, 48, 12, 4, 0),
('12138', '3A', 'AC 3 Tier', 1720.00, 2050.00, 240, 38, 8, 0),
('12138', 'SL', 'Sleeper Class', 635.00, 785.00, 480, 92, 15, 0),
('12138', '2S', 'Second Sitting', 380.00, 460.00, 200, 65, 0, 0),

-- 12560 Shiv Ganga Express
('12560', '1A', 'AC First Class', 2980.00, 3400.00, 24, 4, 0, 0),
('12560', '2A', 'AC 2 Tier', 1890.00, 2200.00, 96, 22, 5, 0),
('12560', '3A', 'AC 3 Tier', 1350.00, 1600.00, 320, 60, 12, 0),
('12560', 'SL', 'Sleeper Class', 495.00, 620.00, 480, 110, 20, 0)
ON CONFLICT (train_number, class_code) DO NOTHING;

-- 6. ROUTE STOPS (for 12952 Mumbai Rajdhani)
INSERT INTO train_routes (train_number, station_code, stop_sequence, arrival_time, departure_time, halt_minutes, distance_from_source_km, day_number, platform_number) VALUES
('12952', 'NDLS', 1, NULL, '16:55:00', 0, 0, 1, 3),
('12952', 'AGC', 2, '18:50:00', '18:55:00', 5, 195, 1, 1),
('12952', 'CNB', 3, '21:30:00', '21:35:00', 5, 435, 1, 2),
('12952', 'BPL', 4, '01:10:00', '01:15:00', 5, 707, 2, 1),
('12952', 'MMCT', 5, '08:35:00', NULL, 0, 1384, 2, 1)
ON CONFLICT (train_number, stop_sequence) DO NOTHING;

-- 7. SAMPLE BOOKING & PNR
INSERT INTO bookings (id, booking_reference, user_id, train_number, from_station_code, to_station_code, journey_date, class_code, quota, status, total_passengers, base_amount, tax_amount, convenience_fee, insurance_fee, total_amount, contact_email, contact_mobile) VALUES
('c0000000-0000-0000-0000-000000000001', 'RB-2026-84920', 'a0000000-0000-0000-0000-000000000002', '12952', 'NDLS', 'MMCT', CURRENT_DATE + INTERVAL '5 days', '3A', 'GENERAL', 'CONFIRMED', 2, 3760.00, 188.00, 17.70, 0.70, 3966.40, 'rahul@example.com', '9812345678')
ON CONFLICT (id) DO NOTHING;

INSERT INTO pnr_records (pnr_number, booking_id, train_number, journey_date, from_station_code, to_station_code, class_code, chart_status) VALUES
('8429184729', 'c0000000-0000-0000-0000-000000000001', '12952', CURRENT_DATE + INTERVAL '5 days', 'NDLS', 'MMCT', '3A', 'CHART_NOT_PREPARED')
ON CONFLICT (pnr_number) DO NOTHING;

INSERT INTO passengers (id, booking_id, pnr_number, name, age, gender, berth_preference, allocated_coach, allocated_berth, allocated_berth_type, booking_status, current_status, fare) VALUES
('d0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', '8429184729', 'Rahul Sharma', 30, 'Male', 'LOWER', 'B3', 21, 'LB', 'CNF', 'CNF', 1880.00),
('d0000000-0000-0000-0000-000000000002', 'c0000000-0000-0000-0000-000000000001', '8429184729', 'Anita Sharma', 58, 'Female', 'LOWER', 'B3', 24, 'LB', 'CNF', 'CNF', 1880.00)
ON CONFLICT (id) DO NOTHING;

INSERT INTO payments (id, booking_id, user_id, transaction_id, payment_method, amount, currency, status) VALUES
('e0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'TXN-RAZORPAY-89241', 'UPI', 3966.40, 'INR', 'SUCCESS')
ON CONFLICT (id) DO NOTHING;

INSERT INTO tickets (id, booking_id, ticket_number, pnr_number, qr_code_data, is_cancelled) VALUES
('f0000000-0000-0000-0000-000000000001', 'c0000000-0000-0000-0000-000000000001', 'TKT-2026-00491', '8429184729', '{"pnr":"8429184729","train":"12952","from":"NDLS","to":"MMCT","passengers":2,"status":"CONFIRMED"}', false)
ON CONFLICT (id) DO NOTHING;
