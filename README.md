# RailBook Next - Modern Train Ticket Booking Platform 🚆

[![React](https://img.shields.io/badge/Frontend-React_18_%2B_TypeScript-61DAFB?logo=react)](https://react.dev/)
[![Tailwind CSS](https://img.shields.io/badge/Styling-Tailwind_CSS-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![Node.js](https://img.shields.io/badge/Backend-Node.js_%2B_Express-339933?logo=node.js)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL_%2B_In--Memory_Store-336791?logo=postgresql)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A high-performance, responsive train ticket booking platform inspired by Indian Railways / IRCTC, designed for **speed, visual elegance, and sub-60-second bookings**.

---

## 🌟 Highlights & Key Features

### 🚄 1. Core Booking & Seat Availability
- **Under 60-Second Booking**: Quick 1-click fill from saved passenger profiles.
- **Dynamic Real-Time Seat Availability**: Status badges with real counts for all classes:
  - `1A` (AC First Class), `2A` (AC 2 Tier), `3A` (AC 3 Tier), `3E` (AC 3 Economy)
  - `EC` (Executive Chair Car), `CC` (AC Chair Car), `SL` (Sleeper Class), `2S` (Second Sitting)
  - Clear state tags: **Available 42**, **RAC 14**, **WL 18**.
- **Interactive Coach Layout & Seat Map**:
  - Visual graphical coach diagram showing Lower, Middle, Upper, Side Lower, Side Upper, and Window berths.
  - Interactive berth picking with senior citizen Lower Berth concession recommendations.
- **Multi-Quota Support**: General, Tatkal, Ladies, Senior Citizen, and Divyangjan.

### 💳 2. Payment & Checkout Simulation
- **Multi-Method Gateway**:
  - **UPI**: Live QR code generator for PhonePe, Google Pay, Paytm + VPA ID input (`user@upi`).
  - **Cards**: Interactive virtual credit/debit card with real-time preview (Visa, RuPay, Mastercard).
  - **Net Banking**: HDFC, SBI, ICICI, Axis, PNB, Kotak.
  - **Wallets**: Paytm Wallet, Amazon Pay, PhonePe Wallet.
- **Transparent Fare Breakdown**:
  - Base ticket fare + 5% GST + IRCTC convenience fee (₹17.70) + Travel Insurance (₹0.35/person).
- **Celebratory Confetti & Instant Confirmation**: Smooth animated feedback upon transaction completion.

### 📄 3. Digital Tickets & PDF Generation
- **Official E-Ticket**: Authentic Electronic Reservation Slip (ERS) layout.
- **Scannable QR Code**: Contains encrypted PNR, train number, travel date, and passenger list for TTE verification.
- **Dual PDF Generation**:
  - Client-side download using `jsPDF`.
  - Server-side download endpoint: `GET /api/tickets/:id/pdf` powered by `PDFKit`.
- **Print & Share**: Built-in printer CSS layout and native mobile sharing.

### 🔍 4. PNR Status & Live Train Tracking
- **10-Digit PNR Inquiry**: Real-time confirmation status, chart preparation status, coach and berth assignment.
- **Live Train Running Status**: Real-time GPS station progression timeline, platform numbers, distance traveled, and delay status in minutes.

### 🤖 5. AI Travel Assistant & Smart Suggestions
- **Smart Suggestions**: Suggests cheaper alternate dates (±1-3 days), nearby boarding stations (e.g. Hazrat Nizamuddin / Anand Vihar for New Delhi), and alternative trains with higher seat confirmation odds.
- **Intelligent Railway Chatbot**: Instant answers on Tatkal booking timings (10 AM for AC, 11 AM for Non-AC), RAC vs Waitlist explanation, free luggage allowances, and cancellation fee rules.

### 🛡️ 6. User Dashboard & Ticket Cancellation
- **My Bookings History**: Filter by Upcoming, Completed, or Cancelled trips.
- **1-Click Ticket Cancellation**: Real-time calculated clerkage fee deduction according to official Indian Railways refund rules with instant refund credit timeline.
- **Master Passenger List**: Manage saved co-passengers for instant autofill.

### ⚙️ 7. Admin Control Center
- **System Telemetry & Analytics**: Daily bookings counter, platform revenue metrics, active users, and fleet occupancy rate.
- **Visual Analytics Charts**: 7-day revenue trend bar chart and bookings distribution by coach class.
- **Fleet Management**: Add new express trains, update schedules, manage stations, and audit live bookings.

### 🎨 8. Premium Modern Aesthetics
- Blue + White modern theme inspired by Vande Bharat & Tejas aesthetics.
- **Dark Mode**: Smooth theme toggle with full system persistence.
- **Multi-Language**: English & Hindi UI toggle.
- **Voice Search Simulation**: Voice command search for train routes.
- **Fare Calendar**: Lowest day-by-day fare view to pick the most economical travel date.

---

## 🏗️ Architecture & Project Structure

```
IRCTC IND/
├── client/                     # Frontend (React 18 + TypeScript + Vite + Tailwind CSS)
│   ├── src/
│   │   ├── components/         # Navbar, Footer, AuthModal, SeatMapModal, AiAssistant, FareCalendarModal
│   │   ├── context/            # AuthContext (JWT, OTP, Google Auth, Saved Passengers)
│   │   ├── pages/              # HomePage, SearchResultsPage, BookingPage, PaymentPage,
│   │   │                       # TicketPage, PnrStatusPage, LiveTrackingPage, UserDashboardPage, AdminDashboardPage
│   │   ├── services/           # api.ts (Centralized API connector with offline fallback)
│   │   ├── types/              # TypeScript interfaces
│   │   ├── App.tsx             # Root Router & State Coordinator
│   │   ├── index.css           # Tailwind base, glassmorphism, custom scrollbar & print CSS
│   │   └── main.tsx
│   ├── tailwind.config.js      # Tailored RailBook design tokens
│   └── package.json
│
├── server/                     # Backend (Node.js + Express + TypeScript)
│   ├── src/
│   │   ├── controllers/        # auth, train, booking, payment, pnr, pdf, admin, ai controllers
│   │   ├── db/                 # PostgreSQL pool connector + pre-seeded high performance in-memory repository
│   │   ├── middleware/         # JWT verification, optionalAuth, requireAdmin
│   │   ├── routes/             # /api/auth, /api/trains, /api/search, /api/book, /api/payment, /api/pnr, /api/admin, /api/ai
│   │   ├── types/              # Domain models
│   │   └── index.ts            # Main Express application (Port 5000)
│   ├── .env                    # Configured environment variables
│   └── package.json
│
├── database/                   # Database Schemas & Migrations
│   ├── schema.sql              # Complete PostgreSQL DDL (users, trains, stations, routes, bookings, tickets, etc.)
│   ├── seed.sql                # Seed data for Indian Railways trains, stations, and demo bookings
│   └── docker-compose.yml      # Optional 1-click Docker setup for PostgreSQL 16 + Redis
│
├── requirements.md             # Original requirements specification
└── package.json                # Root concurrent development runner
```

---

## 🗄️ Database Tables (schema.sql)

The platform includes a complete PostgreSQL schema:
1. `users`: Passenger and Admin accounts with encrypted passwords.
2. `stations`: 16+ Indian Railways junction stations with platform counts and zones.
3. `trains`: Superfast, Rajdhani, Shatabdi, and Vande Bharat trains.
4. `train_routes`: Intermediate station halts, departure/arrival schedules, and platforms.
5. `train_classes`: 1A, 2A, 3A, 3E, EC, CC, SL, 2S with dynamic seat quotas and fares.
6. `coaches`: Coach configurations (H1, A1, B1-B6, S1-S8, etc.).
7. `saved_passengers`: User's master list for fast 1-click booking.
8. `bookings`: Master reservation records with PNR references and fare breakdowns.
9. `pnr_records`: 10-digit Indian Railways PNR records and charting states.
10. `passengers`: Allocated coaches, berth numbers, and berth types (LB, MB, UB, SL, SU, WS).
11. `tickets`: Issued tickets with scannable QR code payloads.
12. `payments`: Transactions across UPI, Cards, NetBanking, and Wallets.
13. `refunds`: Cancellation clerkage charges and refund status tracking.

---

## 🚀 Getting Started

### 1. Prerequisites
- **Node.js**: v18+ or v20+
- **NPM**: v9+ or v10+

### 2. Run Both Frontend & Backend with 1 Command
From the root workspace directory, simply execute:
```bash
npm run dev
```
This automatically starts:
- **Backend API**: `http://localhost:5000`
- **Frontend Vite Client**: `http://localhost:5173`

*(Alternatively, you can run them in separate terminals)*:
```bash
# Terminal 1: Backend
cd server
npm run dev

# Terminal 2: Frontend
cd client
npm run dev
```

### 3. Optional: Running with Local PostgreSQL & Docker
If you have Docker installed, start PostgreSQL and Redis:
```bash
cd database
docker compose up -d
```
The backend automatically detects and connects to PostgreSQL on `localhost:5432`. If PostgreSQL is not running, the backend seamlessly operates on its pre-seeded repository with zero configuration required!

---

## 🔑 Demo Accounts & Testing

For instant testing, use the 1-click quick login buttons in the navbar or modal:

| Role | Email / Identifier | Password | Access Rights |
| :--- | :--- | :--- | :--- |
| **Demo Passenger** | `rahul@example.com` or `9812345678` | `password123` | Search, 60s booking, seat map, cancel & refund, saved passengers |
| **Demo Admin** | `admin@railbook.com` or `9876543210` | `password123` | Analytics dashboard, train CRUD, station CRUD, audit bookings |
| **Demo OTP** | Any 10-digit mobile (e.g. `9876543210`) | `123456` (or simulated OTP shown on screen) | Instant mobile login |

---

## 📡 REST API Reference

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `POST` | `/api/auth/login` | Email/mobile + password authentication |
| `POST` | `/api/auth/otp/send` | Request 6-digit login OTP |
| `POST` | `/api/auth/otp/verify` | Verify OTP and authenticate |
| `GET` | `/api/trains/stations` | Search stations by city or code |
| `GET` | `/api/trains/search` | Search trains by route, date, class, and quota |
| `GET` | `/api/trains/:trainNumber/coach/:classCode` | Get interactive coach seat layout map |
| `GET` | `/api/trains/:trainNumber/live` | Get live train running status & GPS timeline |
| `POST` | `/api/book` | Reserve seats, allocate berths, generate 10-digit PNR |
| `GET` | `/api/book/my` | Retrieve logged-in user's travel history |
| `POST` | `/api/book/:id/cancel` | Cancel booking & calculate IRCTC refund |
| `GET` | `/api/pnr/:pnr` | Query real-time PNR confirmation status |
| `GET` | `/api/tickets/:id/pdf` | Download official E-Ticket PDF |
| `GET` | `/api/ai/suggestions` | AI suggestions for nearby stations & cheaper dates |
| `POST` | `/api/ai/chat` | AI railway knowledge base assistant |
| `GET` | `/api/admin/analytics` | Revenue telemetry, active users, occupancy rate |
| `POST` | `/api/admin/trains` | Add new express train to platform fleet |

---

## 🛡️ Security & Performance
- **Input Validation & Sanitization**: Validates PNR formats, train numbers, and passenger details.
- **JWT Authentication**: Secure Bearer tokens with 7-day expiration.
- **IRCTC Cancellation Logic**: Accurately computes clerkage charges per passenger based on class and timing.
- **Mobile First & Responsive**: Optimized for smartphones, tablets, and desktop displays.
