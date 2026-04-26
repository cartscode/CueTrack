<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reservation.aspx.cs" Inherits="CueTrack.Reservation" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack - Reservation</title>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
        :root {
            --orange: #FF8C00;
            --orange-hot: #FF6A00;
            --dark-bg: #0f0f0f;
            --card-bg: #1a1a1a;
            --panel-bg: #161616;
            --border: #2a2a2a;
            --text: #f0f0f0;
            --muted: #888;
            --reserved: #c0392b;
            --green: #27ae60;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Barlow', sans-serif;
            background: var(--dark-bg);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ── NAVBAR ── */
        .navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            height: 60px;
            background: rgba(10,10,10,0.97);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 28px;
            z-index: 300;
        }

        .navbar-left { display: flex; align-items: center; gap: 10px; }

        .logo-shark {
            width: 38px; height: 38px;
            display: flex; align-items: center; justify-content: center;
        }

        .logo-shark img { width: 38px; height: auto; }

        .logo-text {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 800; letter-spacing: 1px; color: white;
        }

        .navbar-nav { display: flex; align-items: center; gap: 4px; }

        .nav-item {
            padding: 6px 16px; border-radius: 6px;
            font-size: 14px; font-weight: 600;
            text-decoration: none; color: var(--muted); transition: all 0.2s;
        }

        .nav-item:hover { color: white; background: rgba(255,255,255,0.06); }

        .nav-item.active {
            color: white;
            border-bottom: 2px solid var(--orange);
            border-radius: 0; padding-bottom: 4px;
        }

        .user-chip {
            display: flex; align-items: center; gap: 8px;
            background: var(--orange); color: black;
            font-weight: 700; font-size: 13px;
            padding: 6px 14px; border-radius: 20px; cursor: pointer;
        }

        /* Hamburger (mobile) */
        .hamburger {
            display: none; flex-direction: column;
            gap: 5px; cursor: pointer; padding: 4px;
        }

        .hamburger span {
            width: 24px; height: 3px;
            background: white; border-radius: 2px;
        }

        /* Mobile slide menu */
        .mobile-menu {
            display: none;
            position: fixed;
            top: 0; right: 0;
            width: 220px; height: 100vh;
            background: var(--orange);
            z-index: 500;
            flex-direction: column;
            padding: 24px 28px;
            gap: 6px;
            transform: translateX(100%);
            transition: transform 0.3s ease;
        }

        .mobile-menu.open { transform: translateX(0); }

        .mobile-menu-close {
            font-size: 22px; color: black;
            font-weight: 900; cursor: pointer;
            margin-bottom: 16px; align-self: flex-start;
        }

        .mobile-menu a {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 700;
            color: black; text-decoration: none;
            padding: 8px 0;
            border-bottom: 1px solid rgba(0,0,0,0.15);
        }

        .mobile-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 400;
        }

        /* ── PAGE LAYOUT ── */
        .page-wrapper {
            margin-top: 60px;
            display: grid;
            grid-template-columns: 1fr 300px;
            min-height: calc(100vh - 60px);
        }

        /* ── LEFT PANEL ── */
        .left-panel {
            padding: 28px 30px;
            overflow-y: auto;
            position: relative;
        }

        /* Background image blur */
        .left-panel::before {
            content: '';
            position: absolute; inset: 0;
            background: url('Image/background.jpg') center/cover no-repeat;
            opacity: 0.18;
            z-index: 0;
        }

        .left-panel > * { position: relative; z-index: 1; }

        /* ── SECTION HEADER ── */
        .section-header {
            display: flex; align-items: center; gap: 14px; margin-bottom: 22px;
        }

        .section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 26px; font-weight: 800; letter-spacing: 2px;
            color: white; text-transform: uppercase; white-space: nowrap;
        }

        .progress-track {
            flex: 1; height: 6px;
            background: var(--border); border-radius: 3px; overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--orange), var(--orange-hot));
            border-radius: 3px;
            box-shadow: 0 0 8px rgba(255,140,0,0.5);
            transition: width 0.4s ease;
        }

        /* ── STEP CONTAINERS ── */
        .step { display: none; }
        .step.active { display: block; }

        /* ── TABLE GRID ── */
        .table-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .table-card {
            background: rgba(26,26,26,0.9);
            border: 2px solid var(--border);
            border-radius: 12px; padding: 12px;
            cursor: pointer; transition: all 0.25s;
            position: relative; overflow: hidden;
        }

        .table-card:hover:not(.reserved) {
            border-color: var(--orange);
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(255,140,0,0.2);
        }

        .table-card.selected {
            border-color: var(--orange);
            background: rgba(255,140,0,0.1);
            box-shadow: 0 0 0 3px rgba(255,140,0,0.25), 0 8px 24px rgba(255,140,0,0.15);
        }

        .table-card.reserved { cursor: not-allowed; opacity: 0.65; }

        .table-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 12px; font-weight: 700; letter-spacing: 1px;
            color: var(--muted); margin-bottom: 8px; text-transform: uppercase;
        }

        .table-card.selected .table-label { color: var(--orange); }

        .pool-art {
            width: 100%; aspect-ratio: 4/3;
            border-radius: 8px; overflow: hidden; position: relative;
        }

        .pool-art svg { width: 100%; height: 100%; display: block; }

        .reserved-badge {
            position: absolute; bottom: 0; right: 0;
            background: var(--reserved); color: white;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 10px; font-weight: 800; letter-spacing: 1px;
            padding: 3px 8px;
            clip-path: polygon(10px 0%, 100% 0%, 100% 100%, 0% 100%);
            text-transform: uppercase;
        }

        /* Legend */
        .legend {
            display: flex; gap: 16px; justify-content: center; margin-top: 18px;
        }

        .legend-item {
            display: flex; align-items: center; gap: 6px;
            font-size: 11px; color: var(--muted);
        }

        .legend-dot { width: 10px; height: 10px; border-radius: 2px; }
        .dot-available { background: #2ecc71; }
        .dot-reserved  { background: var(--reserved); }
        .dot-selected  { background: var(--orange); }

        /* ── STEP 2: RENTAL TYPE ── */
        .sub-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 700; letter-spacing: 1px;
            color: white; text-transform: uppercase; margin-bottom: 14px;
        }

        .rental-options {
            display: flex; gap: 14px; margin-bottom: 28px;
        }

        .rental-btn {
            flex: 1; padding: 22px 10px;
            background: rgba(26,26,26,0.9);
            border: 2px solid var(--border);
            border-radius: 12px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 800; letter-spacing: 1px;
            color: var(--orange); text-transform: uppercase;
            cursor: pointer; transition: all 0.2s; text-align: center;
        }

        .rental-btn:hover, .rental-btn.selected {
            border-color: var(--orange);
            background: rgba(255,140,0,0.1);
            box-shadow: 0 0 0 2px rgba(255,140,0,0.2);
        }

        /* Discount toggle */
        .discount-card {
            background: rgba(26,26,26,0.9);
            border: 2px solid var(--border);
            border-radius: 12px;
            padding: 16px 20px;
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 28px;
        }

        .discount-text h4 {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 700; color: var(--orange);
            text-transform: uppercase;
        }

        .discount-text p { font-size: 12px; color: var(--muted); margin-top: 3px; }

        .toggle {
            position: relative; width: 48px; height: 26px; cursor: pointer;
        }

        .toggle input { opacity: 0; width: 0; height: 0; }

        .toggle-slider {
            position: absolute; inset: 0;
            background: #333; border-radius: 13px;
            transition: background 0.3s;
        }

        .toggle-slider::before {
            content: '';
            position: absolute;
            width: 20px; height: 20px;
            left: 3px; top: 3px;
            background: white; border-radius: 50%;
            transition: transform 0.3s;
        }

        .toggle input:checked + .toggle-slider { background: var(--orange); }
        .toggle input:checked + .toggle-slider::before { transform: translateX(22px); }

        /* ── STEP 3: BOOKING DETAILS ── */
        .booking-card {
            background: rgba(22,22,22,0.95);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 22px 26px;
        }

        .booking-row {
            display: flex; align-items: baseline;
            padding: 8px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.06);
            gap: 10px;
        }

        .booking-row:last-child { border-bottom: none; }

        .booking-key {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 700; letter-spacing: 0.5px;
            color: var(--orange); min-width: 110px; text-transform: uppercase;
        }

        .booking-dots {
            flex: 1; border-bottom: 2px dotted rgba(255,140,0,0.3);
            margin-bottom: 3px;
        }

        .booking-val {
            font-size: 13px; font-weight: 600; color: white;
        }

        /* ── STEP 4: SUCCESS ── */
        .success-wrap {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            min-height: 60vh; gap: 20px; text-align: center;
        }

        .success-check {
            width: 110px; height: 110px;
            background: var(--green);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 54px;
            box-shadow: 0 0 40px rgba(39,174,96,0.4);
            animation: popIn 0.5s ease;
        }

        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            70%  { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }

        .success-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 26px; font-weight: 800; color: white;
        }

        .success-sub { font-size: 13px; color: var(--muted); max-width: 280px; }

        .success-summary {
            background: rgba(26,26,26,0.9);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 14px 22px;
            font-size: 13px;
            display: flex; flex-direction: column; gap: 4px;
            text-align: left; width: 100%; max-width: 320px;
        }

        .success-summary span { color: var(--muted); }
        .success-summary strong { color: var(--orange); }

        /* ── RIGHT PANEL ── */
        .right-panel {
            background: var(--panel-bg);
            border-left: 1px solid var(--border);
            display: flex; flex-direction: column;
            padding: 26px 20px; gap: 16px; overflow-y: auto;
        }

        .panel-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 800; letter-spacing: 1px;
            color: white; text-align: center;
        }

        .panel-title span { color: var(--orange); }

        .field-group { display: flex; flex-direction: column; gap: 5px; }

        .field-label {
            font-size: 12px; font-weight: 600;
            color: var(--orange); letter-spacing: 0.5px; text-transform: uppercase;
        }

        .field-input {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 8px; padding: 9px 12px;
            color: white; font-family: 'Barlow', sans-serif;
            font-size: 14px; outline: none;
            transition: border-color 0.2s; width: 100%;
        }

        .field-input:focus {
            border-color: var(--orange);
            background: rgba(255,140,0,0.05);
        }

        .panel-preview {
            border-radius: 12px; overflow: hidden;
            border: 2px solid var(--border);
            aspect-ratio: 4/3; position: relative; flex-shrink: 0;
        }

        .panel-preview svg { width: 100%; height: 100%; display: block; }

        .panel-reserved-overlay {
            display: none; position: absolute; inset: 0;
            background: rgba(192,57,43,0.25);
            align-items: flex-end; justify-content: flex-end;
        }

        .panel-reserved-overlay.show { display: flex; }

        .panel-reserved-badge {
            background: var(--reserved); color: white;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 800; letter-spacing: 1px;
            padding: 5px 12px;
            clip-path: polygon(14px 0%, 100% 0%, 100% 100%, 0% 100%);
            text-transform: uppercase;
        }

        /* ── BUTTONS ── */
        .btn-orange {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            color: black; border: none;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 17px; font-weight: 800; letter-spacing: 2px;
            text-transform: uppercase; border-radius: 10px;
            padding: 13px; cursor: pointer; width: 100%;
            transition: all 0.2s;
            box-shadow: 0 4px 20px rgba(255,140,0,0.3);
        }

        .btn-orange:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(255,140,0,0.45);
        }

        .btn-outline {
            background: transparent;
            border: 2px solid var(--orange);
            color: var(--orange);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 800; letter-spacing: 2px;
            text-transform: uppercase; border-radius: 10px;
            padding: 11px; cursor: pointer; width: 100%;
            transition: all 0.2s; margin-top: 8px;
        }

        .btn-outline:hover {
            background: rgba(255,140,0,0.1);
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            .page-wrapper {
                grid-template-columns: 1fr;
            }

            .right-panel { display: none; }

            .hamburger { display: flex; }
            .navbar-nav { display: none; }
            .user-chip { display: none; }
            .mobile-menu { display: flex; }

            .table-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- MOBILE OVERLAY -->
    <div class="mobile-overlay" id="mobileOverlay" onclick="closeMobileMenu()"></div>

    <!-- MOBILE SLIDE MENU -->
    <div class="mobile-menu" id="mobileMenu">
        <div class="mobile-menu-close" onclick="closeMobileMenu()">✕</div>
        <a href="Reservation.aspx">Reservation</a>
        <a href="#">Menu</a>
        <a href="#">Events</a>
        <a href="#">Account</a>
    </div>

    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="navbar-left">
            <div class="logo-shark">
                <img src="Image/great-white-shark.png" onerror="this.style.display='none';this.parentElement.textContent='🦈'" />
            </div>
            <span class="logo-text">CueTrack</span>
        </div>

        <div class="navbar-nav">
            <a href="#" class="nav-item active">Reservation</a>
            <a href="#" class="nav-item">Menu</a>
            <a href="#" class="nav-item">Events</a>
        </div>

        <div class="user-chip">
            👤 <asp:Literal ID="litUserName" runat="server" />
        </div>

        <div class="hamburger" onclick="openMobileMenu()">
            <span></span><span></span><span></span>
        </div>
    </nav>

    <!-- PAGE -->
    <div class="page-wrapper">

        <!-- ════ LEFT PANEL ════ -->
        <div class="left-panel">

            <!-- Header with progress bar -->
            <div class="section-header">
                <div class="section-title">Reservation</div>
                <div class="progress-track">
                    <div class="progress-fill" id="progressFill" style="width:25%"></div>
                </div>
            </div>

            <!-- ── STEP 1: Table Selection ── -->
            <div class="step active" id="step1">
                <div class="table-grid" id="tableGrid"></div>
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot dot-available"></div> Available</div>
                    <div class="legend-item"><div class="legend-dot dot-selected"></div> Selected</div>
                    <div class="legend-item"><div class="legend-dot dot-reserved"></div> Reserved</div>
                </div>
                <br/>
                <button type="button" class="btn-orange" onclick="goStep(2)">CONTINUE</button>
            </div>

            <!-- ── STEP 2: Rental Type + Discount ── -->
            <div class="step" id="step2">
                <div class="sub-label">Rental Type</div>
                <div class="rental-options">
                    <div class="rental-btn selected" id="rentalRental" onclick="selectRental('Rental Time')">
                        Rental<br/>Time
                    </div>
                    <div class="rental-btn" id="rentalOpen" onclick="selectRental('Open Time')">
                        Open<br/>Time
                    </div>
                </div>

                <div class="sub-label">Discount</div>
                <div class="discount-card">
                    <div class="discount-text">
                        <h4>Student / PWD / Senior</h4>
                        <p>₱ 50 off per hour – valid ID at arrival</p>
                    </div>
                    <label class="toggle">
                        <input type="checkbox" id="discountToggle" />
                        <span class="toggle-slider"></span>
                    </label>
                </div>

                <button type="button" class="btn-orange" onclick="goStep(3)">CONTINUE</button>
                <button type="button" class="btn-outline" onclick="goStep(1)">← BACK</button>
            </div>

            <!-- ── STEP 3: Booking Summary ── -->
            <div class="step" id="step3">
                <div class="sub-label">Booking Details</div>
                <div class="booking-card">
                    <div class="booking-row">
                        <span class="booking-key">Date</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryDate">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Time</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryTime">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Table</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryTable">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Rental Type</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryRental">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Guest Name</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryName">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Contact</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryContact">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Guests</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryGuests">—</span>
                    </div>
                    <div class="booking-row">
                        <span class="booking-key">Rates</span>
                        <span class="booking-dots"></span>
                        <span class="booking-val" id="summaryRates">—</span>
                    </div>
                </div>
                <br/>
                <asp:Button ID="btnConfirm" runat="server" Text="CONFIRM BOOKING"
                    CssClass="btn-orange" OnClick="BtnConfirm_Click"
                    OnClientClick="return prepareConfirm();" />
                <button type="button" class="btn-outline" onclick="goStep(2)">← BACK</button>
            </div>

            <!-- ── STEP 4: Success ── -->
            <div class="step" id="step4">
                <div class="success-wrap">
                    <div class="success-check">✓</div>
                    <div class="success-title">You're all set!</div>
                    <p class="success-sub">Your reservation is all set and confirmed — we're looking forward to seeing you soon.</p>
                    <div class="success-summary" id="successSummary"></div>
                    <button type="button" class="btn-orange" style="max-width:320px"
                        onclick="resetReservation()">MAKE ANOTHER RESERVATION</button>
                </div>
            </div>

        </div>

        <!-- ════ RIGHT PANEL ════ -->
        <div class="right-panel">
            <div class="panel-title">Table <span id="panelTableNum">1</span></div>

            <div class="field-group">
                <label class="field-label">Time</label>
                <asp:TextBox ID="txtTime" runat="server" CssClass="field-input" placeholder="e.g. 8:00 PM" />
            </div>

            <div class="field-group">
                <label class="field-label">Date</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="field-input" TextMode="Date" />
            </div>

            <div class="field-group">
                <label class="field-label">Guest Name</label>
                <asp:TextBox ID="txtGuestName" runat="server" CssClass="field-input" placeholder="Full name" />
            </div>

            <div class="field-group">
                <label class="field-label">Contact</label>
                <asp:TextBox ID="txtContact" runat="server" CssClass="field-input" placeholder="+63 9XX XXX XXXX" />
            </div>

            <div class="field-group">
                <label class="field-label">No. of Guests</label>
                <asp:TextBox ID="txtGuests" runat="server" CssClass="field-input" placeholder="e.g. 2" TextMode="Number" />
            </div>

            <div class="panel-preview" id="panelPreview">
                <div class="panel-reserved-overlay" id="panelReservedOverlay">
                    <div class="panel-reserved-badge">Reserved</div>
                </div>
            </div>

            <button type="button" class="btn-orange" onclick="goStep(2)">CONTINUE</button>
        </div>

    </div>

    <!-- Hidden fields for postback -->
    <asp:HiddenField ID="hdnTableID"   runat="server" Value="1" />
    <asp:HiddenField ID="hdnTime"      runat="server" />
    <asp:HiddenField ID="hdnDate"      runat="server" />
    <asp:HiddenField ID="hdnRental"    runat="server" />
    <asp:HiddenField ID="hdnGuests"    runat="server" />
    <asp:HiddenField ID="hdnGuestName" runat="server" />
    <asp:HiddenField ID="hdnContact"   runat="server" />
    <asp:HiddenField ID="hdnDiscount"  runat="server" />
    <asp:HiddenField ID="hdnStep"      runat="server" Value="1" />

</form>

<script>
    // ── DATA ───────────────────────────────────────────────────
    const tables = [
        { id: 1, reserved: false },
        { id: 2, reserved: true },
        { id: 3, reserved: false },
        { id: 4, reserved: false },
        { id: 5, reserved: false },
        { id: 6, reserved: false },
        { id: 7, reserved: false },
    ];

    const RATES = { 'Rental Time': '₱ 300/hr', 'Open Time': '₱ 500 flat' };

    let selectedTable = 1;
    let selectedRental = 'Rental Time';
    let currentStep = 1;

    // ── POOL TABLE SVG ─────────────────────────────────────────
    function poolSVG(small) {
        const w = small ? 130 : 240, h = small ? 98 : 180;
        const r = small ? 5 : 9, bR = small ? 4.5 : 7.5, pR = small ? 3.5 : 6;
        return `<svg viewBox="0 0 ${w} ${h}" xmlns="http://www.w3.org/2000/svg">
            <rect x="0" y="0" width="${w}" height="${h}" rx="${r}" fill="#4E342E"/>
            <rect x="${w * .08}" y="${h * .10}" width="${w * .84}" height="${h * .80}" rx="${r * .55}" fill="#1565C0"/>
            <rect x="${w * .08}" y="${h * .10}" width="${w * .84}" height="${h * .37}" rx="${r * .55}" fill="rgba(255,255,255,0.04)"/>
            <line x1="${w / 2}" y1="${h * .12}" x2="${w / 2}" y2="${h * .88}" stroke="rgba(255,255,255,0.1)" stroke-width="1.2"/>
            <circle cx="${w / 2}" cy="${h / 2}" r="${w * .07}" fill="none" stroke="rgba(255,255,255,0.13)" stroke-width="1.2"/>
            <circle cx="${w * .10}" cy="${h * .14}" r="${pR}" fill="#111"/>
            <circle cx="${w * .90}" cy="${h * .14}" r="${pR}" fill="#111"/>
            <circle cx="${w * .10}" cy="${h * .86}" r="${pR}" fill="#111"/>
            <circle cx="${w * .90}" cy="${h * .86}" r="${pR}" fill="#111"/>
            <circle cx="${w / 2}"  cy="${h * .11}" r="${pR * .8}" fill="#111"/>
            <circle cx="${w / 2}"  cy="${h * .89}" r="${pR * .8}" fill="#111"/>
            <circle cx="${w * .34}" cy="${h * .50}" r="${bR}" fill="white" opacity=".9"/>
            <circle cx="${w * .61}" cy="${h * .41}" r="${bR * .8}" fill="#e74c3c" opacity=".85"/>
            <circle cx="${w * .67}" cy="${h * .56}" r="${bR * .8}" fill="#f39c12" opacity=".85"/>
            <circle cx="${w * .55}" cy="${h * .61}" r="${bR * .8}" fill="#2ecc71" opacity=".85"/>
        </svg>`;
    }

    // ── RENDER TABLE GRID ──────────────────────────────────────
    function renderGrid() {
        const grid = document.getElementById('tableGrid');
        grid.innerHTML = '';
        tables.forEach(t => {
            const card = document.createElement('div');
            card.className = 'table-card'
                + (t.reserved ? ' reserved' : '')
                + (t.id === selectedTable && !t.reserved ? ' selected' : '');
            card.innerHTML = `
                <div class="table-label">Table ${t.id}</div>
                <div class="pool-art">${poolSVG(true)}
                    ${t.reserved ? '<div class="reserved-badge">Reserved</div>' : ''}
                </div>`;
            if (!t.reserved) card.addEventListener('click', () => pickTable(t.id));
            grid.appendChild(card);
        });
    }

    function pickTable(id) {
        selectedTable = id;
        document.getElementById('hdnTableID').value = id;
        document.getElementById('panelTableNum').textContent = id;
        const t = tables.find(x => x.id === id);
        updatePanelPreview(t);
        renderGrid();
    }

    function updatePanelPreview(t) {
        const preview = document.getElementById('panelPreview');
        const old = preview.querySelector('svg');
        if (old) old.remove();
        preview.insertAdjacentHTML('afterbegin', poolSVG(false));
        document.getElementById('panelReservedOverlay')
            .classList.toggle('show', t && t.reserved);
    }

    // ── RENTAL SELECTION ───────────────────────────────────────
    function selectRental(type) {
        selectedRental = type;
        document.getElementById('rentalRental').classList.toggle('selected', type === 'Rental Time');
        document.getElementById('rentalOpen').classList.toggle('selected', type === 'Open Time');
    }

    // ── STEP NAVIGATION ────────────────────────────────────────
    const PROGRESS = { 1: '25%', 2: '50%', 3: '75%', 4: '100%' };

    function goStep(n) {
        // Validate before advancing
        if (n > currentStep) {
            if (currentStep === 1 && !validateStep1()) return;
            if (currentStep === 2 && !validateStep2()) return;
        }

        // Populate summary when going to step 3
        if (n === 3) populateSummary();

        document.querySelectorAll('.step').forEach(s => s.classList.remove('active'));
        document.getElementById('step' + n).classList.add('active');
        document.getElementById('progressFill').style.width = PROGRESS[n];
        document.getElementById('hdnStep').value = n;
        currentStep = n;
    }

    // ── VALIDATION ─────────────────────────────────────────────
    function validateStep1() {
        const time = val('txtTime'), date = val('txtDate');
        if (!time) { alert('Please enter a time.'); return false; }
        if (!date) { alert('Please select a date.'); return false; }

        const guestName = val('txtGuestName');
        const contact = val('txtContact');
        if (!guestName) { alert('Please enter a guest name.'); return false; }
        if (!contact) { alert('Please enter a contact number.'); return false; }
        return true;
    }

    function validateStep2() {
        if (!selectedRental) { alert('Please select a rental type.'); return false; }
        return true;
    }

    // ── POPULATE SUMMARY ───────────────────────────────────────
    function populateSummary() {
        const date = val('txtDate');
        const time = val('txtTime');
        const name = val('txtGuestName');
        const contact = val('txtContact');
        const guests = val('txtGuests') || '1';
        const discount = document.getElementById('discountToggle').checked;
        const baseRate = selectedRental === 'Rental Time' ? 300 : 500;
        const finalRate = discount ? (baseRate - 50) : baseRate;
        const rateLabel = selectedRental === 'Rental Time'
            ? `₱ ${finalRate}/hr${discount ? ' (discounted)' : ''}`
            : `₱ ${finalRate} flat${discount ? ' (discounted)' : ''}`;

        setText('summaryDate', date);
        setText('summaryTime', time);
        setText('summaryTable', 'Table ' + selectedTable);
        setText('summaryRental', selectedRental);
        setText('summaryName', name);
        setText('summaryContact', contact);
        setText('summaryGuests', guests);
        setText('summaryRates', rateLabel);

        // Sync hidden fields for postback
        setHdn('hdnTime', time);
        setHdn('hdnDate', date);
        setHdn('hdnRental', selectedRental);
        setHdn('hdnGuests', guests);
        setHdn('hdnGuestName', name);
        setHdn('hdnContact', contact);
        setHdn('hdnDiscount', discount ? '1' : '0');
    }

    function prepareConfirm() {
        populateSummary();
        return true; // allow postback
    }

    // ── SUCCESS (called after postback if needed, or client-side demo) ──
    function showSuccess() {
        const date = getHdn('hdnDate');
        const time = getHdn('hdnTime');
        const tbl = getHdn('hdnTableID');
        const name = getHdn('hdnGuestName');
        document.getElementById('successSummary').innerHTML = `
            <div><span>Name: </span><strong>${name}</strong> &nbsp; <span>Table: </span><strong>${tbl}</strong></div>
            <div><span>Date: </span><strong>${date}</strong></div>
            <div><span>Time: </span><strong>${time}</strong></div>`;
        goStep(4);
    }

    function resetReservation() {
        selectedTable = 1;
        selectedRental = 'Rental Time';
        ['txtTime', 'txtDate', 'txtGuestName', 'txtContact', 'txtGuests'].forEach(id => {
            const el = document.querySelector('[id$="' + id + '"]');
            if (el) el.value = '';
        });
        document.getElementById('discountToggle').checked = false;
        renderGrid();
        updatePanelPreview(tables[0]);
        document.getElementById('panelTableNum').textContent = '1';
        goStep(1);
    }

    // ── MOBILE MENU ────────────────────────────────────────────
    function openMobileMenu() {
        document.getElementById('mobileMenu').classList.add('open');
        document.getElementById('mobileOverlay').style.display = 'block';
    }

    function closeMobileMenu() {
        document.getElementById('mobileMenu').classList.remove('open');
        document.getElementById('mobileOverlay').style.display = 'none';
    }

    // ── HELPERS ────────────────────────────────────────────────
    function val(id) {
        const el = document.querySelector('[id$="' + id + '"]');
        return el ? el.value.trim() : '';
    }

    function setText(id, text) {
        const el = document.getElementById(id);
        if (el) el.textContent = text;
    }

    function setHdn(id, value) {
        const el = document.getElementById(id);
        if (el) el.value = value;
    }

    function getHdn(id) {
        const el = document.getElementById(id);
        return el ? el.value : '';
    }

    // ── INIT ───────────────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', () => {
        renderGrid();
        updatePanelPreview(tables[0]);

        const d = document.querySelector('[id$="txtDate"]');
        if (d) d.min = new Date().toISOString().split('T')[0];

        // If server signalled success after postback
        const stepHdn = document.getElementById('hdnStep');
        if (stepHdn && stepHdn.value === '4') showSuccess();
    });
</script>
</body>
</html>