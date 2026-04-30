<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="CueTrack.Order" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack - Menu</title>
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
            position: fixed; top: 0; left: 0; right: 0; height: 60px;
            background: rgba(10,10,10,0.97);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid var(--border);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 28px; z-index: 300;
        }
        .navbar-left { display: flex; align-items: center; gap: 10px; }
        .logo-shark { width: 38px; height: 38px; display: flex; align-items: center; justify-content: center; }
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
        .nav-item.active { color: white; border-bottom: 2px solid var(--orange); border-radius: 0; padding-bottom: 4px; }
        .user-chip-wrap { position: relative; }
        .user-chip { cursor: pointer; user-select: none; transition: background 0.2s;
            display: flex; align-items: center; gap: 8px;
            background: rgba(255,140,0,0.12); border: 1px solid rgba(255,140,0,0.3);
            border-radius: 20px; padding: 6px 14px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 14px; font-weight: 700; color: var(--orange); }
        .user-chip:hover { background: var(--orange-hot); color: black; }
        .chip-arrow { font-size: 9px; transition: transform 0.2s; }
        .user-chip-wrap.open .chip-arrow { transform: rotate(180deg); }
        .user-dropdown {
            display: none; position: absolute;
            top: calc(100% + 10px); right: 0;
            background: #1c1c1c; border: 1px solid var(--border);
            border-radius: 14px; min-width: 200px; overflow: hidden;
            box-shadow: 0 12px 40px rgba(0,0,0,0.7);
            z-index: 999; animation: dropIn 0.2s ease;
        }
        .user-chip-wrap.open .user-dropdown { display: block; }
        @keyframes dropIn { from { opacity: 0; transform: translateY(-8px); } to { opacity: 1; transform: translateY(0); } }
        .dropdown-header { padding: 14px 16px 12px; border-bottom: 1px solid var(--border); background: rgba(255,140,0,0.06); }
        .dropdown-username { font-family: 'Barlow Condensed', sans-serif; font-size: 16px; font-weight: 800; color: white; }
        .dropdown-email { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .dropdown-item { display: flex; align-items: center; gap: 10px; padding: 12px 16px; font-size: 14px; font-weight: 600; color: var(--text); cursor: pointer; transition: all 0.15s; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .dropdown-item:last-child { border-bottom: none; }
        .dropdown-item:hover { background: rgba(255,255,255,0.06); color: var(--orange); }
        .dropdown-item.danger { color: #e74c3c; }
        .dropdown-item.danger:hover { background: rgba(231,76,60,0.08); }
        .hamburger { display: none; flex-direction: column; gap: 5px; cursor: pointer; padding: 4px; }
        .hamburger span { width: 24px; height: 3px; background: white; border-radius: 2px; }
        .mobile-menu { display: none; position: fixed; top: 0; right: 0; width: 220px; height: 100vh; background: var(--orange); z-index: 500; flex-direction: column; padding: 24px 28px; gap: 6px; transform: translateX(100%); transition: transform 0.3s ease; }
        .mobile-menu.open { transform: translateX(0); }
        .mobile-menu-close { font-size: 22px; color: black; font-weight: 900; cursor: pointer; margin-bottom: 16px; align-self: flex-start; }
        .mobile-menu a { font-family: 'Barlow Condensed', sans-serif; font-size: 22px; font-weight: 700; color: black; text-decoration: none; padding: 8px 0; border-bottom: 1px solid rgba(0,0,0,0.15); }
        .mobile-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 400; }

        /* ── MODALS ── */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.85); z-index: 700; align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.open { display: flex; }
        .modal-box { background: #1a1a1a; border: 1px solid var(--border); border-radius: 16px; width: 100%; overflow: hidden; animation: modalPop 0.25s ease; }
        @keyframes modalPop { from { transform: scale(0.92); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .modal-hdr { background: linear-gradient(135deg, var(--orange), var(--orange-hot)); padding: 18px 22px; display: flex; align-items: center; justify-content: space-between; }
        .modal-hdr.danger { background: linear-gradient(135deg, #c0392b, #e74c3c); }
        .modal-hdr-title { font-family: 'Barlow Condensed', sans-serif; font-size: 22px; font-weight: 800; color: black; text-transform: uppercase; }
        .modal-hdr-sub { font-size: 12px; color: rgba(0,0,0,0.65); font-weight: 600; margin-top: 2px; }
        .modal-x { width: 30px; height: 30px; background: rgba(0,0,0,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 16px; color: black; font-weight: 900; transition: background 0.2s; flex-shrink: 0; }
        .modal-x:hover { background: rgba(0,0,0,0.4); }
        .modal-bdy { padding: 22px; }
        .btn-danger { background: linear-gradient(135deg,#c0392b,#e74c3c); color: white; border: none; font-family: 'Barlow Condensed', sans-serif; font-size: 17px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; border-radius: 10px; padding: 13px; cursor: pointer; width: 100%; transition: all 0.2s; box-shadow: 0 4px 20px rgba(192,57,43,0.35); }
        .btn-danger:hover { transform: translateY(-2px); }
        .btn-outline { background: transparent; border: 2px solid var(--orange); color: var(--orange); font-family: 'Barlow Condensed', sans-serif; font-size: 16px; font-weight: 800; letter-spacing: 2px; text-transform: uppercase; border-radius: 10px; padding: 11px; cursor: pointer; width: 100%; transition: all 0.2s; margin-top: 8px; }
        .btn-outline:hover { background: rgba(255,140,0,0.1); }

        /* ── LAYOUT ── */
        .page-wrapper {
            margin-top: 60px;
            display: grid;
            grid-template-columns: 1fr 320px;
            min-height: calc(100vh - 60px);
        }

        /* ── LEFT PANEL ── */
        .left-panel { padding: 28px 30px; overflow-y: auto; position: relative; }
        .left-panel::before { content: ''; position: absolute; inset: 0; background: url('Image/background.jpg') center/ no-repeat; opacity: 0.10; z-index: 0; }
        .left-panel > * { position: relative; z-index: 1; }

        .section-header { display: flex; align-items: center; gap: 14px; margin-bottom: 22px; }
        .section-title { font-family: 'Barlow Condensed', sans-serif; font-size: 26px; font-weight: 800; letter-spacing: 2px; color: white; text-transform: uppercase; white-space: nowrap; }

        /* ── CATEGORY TABS ── */
        .cat-tabs { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 22px; }
        .cat-tab {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 800; letter-spacing: 1px;
            text-transform: uppercase; padding: 7px 16px;
            border-radius: 20px; cursor: pointer; transition: all 0.2s;
            border: 1px solid var(--border); color: var(--muted);
            background: rgba(26,26,26,0.9);
        }
        .cat-tab:hover { color: white; border-color: rgba(255,255,255,0.2); }
        .cat-tab.active { background: var(--orange); color: black; border-color: var(--orange); }

        /* ── MENU GRID ── */
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 14px; }
        .menu-card {
            background: rgba(26,26,26,0.9);
            border: 1px solid var(--border);
            border-radius: 12px; overflow: hidden;
            cursor: pointer; transition: all 0.25s;
            position: relative;
        }
        .menu-card:hover { border-color: var(--orange); transform: translateY(-3px); box-shadow: 0 8px 24px rgba(255,140,0,0.2); }
        .menu-card-img {
            width: 100%; aspect-ratio: 4/3; overflow: hidden;
            background: #222; display: flex; align-items: center; justify-content: center;
            font-size: 36px;
        }
        .menu-card-img img { width: 100%; height: 100%; object-fit: cover; }
        .menu-card-body { padding: 10px 12px 12px; }
        .menu-card-name { font-family: 'Barlow Condensed', sans-serif; font-size: 14px; font-weight: 800; letter-spacing: 0.5px; color: white; margin-bottom: 2px; line-height: 1.2; }
        .menu-card-desc { font-size: 10px; color: var(--muted); margin-bottom: 8px; line-height: 1.4; }
        .menu-card-footer { display: flex; align-items: center; justify-content: space-between; }
        .menu-card-price { font-family: 'Barlow Condensed', sans-serif; font-size: 15px; font-weight: 800; color: var(--orange); }
        .menu-card-add {
            width: 26px; height: 26px;
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            border-radius: 50%; border: none;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; font-weight: 900; color: black;
            cursor: pointer; transition: all 0.2s; line-height: 1;
        }
        .menu-card-add:hover { transform: scale(1.15); box-shadow: 0 4px 12px rgba(255,140,0,0.4); }
        .qty-badge {
            position: absolute; top: 8px; right: 8px;
            background: var(--orange); color: black;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 12px; font-weight: 900;
            width: 20px; height: 20px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.5);
        }
        .menu-section-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px; font-weight: 800; letter-spacing: 2px;
            color: var(--orange); text-transform: uppercase;
            margin: 20px 0 12px; padding-bottom: 6px;
            border-bottom: 1px solid var(--border);
        }
        .menu-section-label:first-child { margin-top: 0; }

        /* ── RIGHT PANEL (CART) ── */
        .right-panel {
            background: var(--panel-bg); border-left: 1px solid var(--border);
            display: flex; flex-direction: column;
            padding: 26px 20px; gap: 14px; overflow-y: auto;
            position: sticky; top: 60px; height: calc(100vh - 60px);
        }
        .panel-title { font-family: 'Barlow Condensed', sans-serif; font-size: 22px; font-weight: 800; letter-spacing: 1px; color: white; }
        .panel-title span { color: var(--orange); }

        /* ── TABLE SELECTOR ── */
        .field-group { display: flex; flex-direction: column; gap: 5px; }
        .field-label { font-size: 12px; font-weight: 600; color: var(--orange); letter-spacing: 0.5px; text-transform: uppercase; }
        .field-select {
            background: rgba(255,255,255,0.04); border: 1px solid var(--border);
            border-radius: 8px; padding: 9px 12px; color: white;
            font-family: 'Barlow', sans-serif; font-size: 14px;
            outline: none; transition: border-color 0.2s; width: 100%;
            cursor: pointer;
        }
        .field-select:focus { border-color: var(--orange); background: rgba(255,140,0,0.05); }
        .field-select option { background: #1a1a1a; }

        /* ── CART ITEMS ── */
        .cart-empty { text-align: center; color: var(--muted); font-size: 13px; padding: 30px 0; }
        .cart-empty-icon { font-size: 40px; margin-bottom: 10px; opacity: 0.4; }

        .cart-items { display: flex; flex-direction: column; gap: 8px; flex: 1; overflow-y: auto; min-height: 0; }
        .cart-item {
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border); border-radius: 10px;
            padding: 10px 12px;
            display: flex; align-items: center; gap: 10px;
        }
        .cart-item-emoji { font-size: 22px; flex-shrink: 0; }
        .cart-item-info { flex: 1; min-width: 0; }
        .cart-item-name { font-family: 'Barlow Condensed', sans-serif; font-size: 13px; font-weight: 700; color: white; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .cart-item-price { font-size: 11px; color: var(--orange); font-weight: 600; }
        .cart-item-controls { display: flex; align-items: center; gap: 6px; flex-shrink: 0; }
        .ctrl-btn { width: 22px; height: 22px; border-radius: 50%; border: 1px solid var(--border); background: rgba(255,255,255,0.06); color: white; font-size: 14px; font-weight: 900; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; line-height: 1; }
        .ctrl-btn:hover { border-color: var(--orange); color: var(--orange); }
        .ctrl-btn.remove { border-color: rgba(231,76,60,0.4); color: #e74c3c; }
        .ctrl-btn.remove:hover { background: rgba(231,76,60,0.12); }
        .ctrl-qty { font-family: 'Barlow Condensed', sans-serif; font-size: 14px; font-weight: 800; color: white; min-width: 18px; text-align: center; }

        /* ── DIVIDER ── */
        .cart-divider { border: none; border-top: 1px dashed rgba(255,255,255,0.08); margin: 0; }

        /* ── TOTALS ── */
        .cart-totals { display: flex; flex-direction: column; gap: 6px; }
        .total-row { display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: var(--muted); }
        .total-row.grand { font-family: 'Barlow Condensed', sans-serif; font-size: 18px; font-weight: 800; color: white; margin-top: 4px; padding-top: 8px; border-top: 1px solid var(--border); }
        .total-row.grand span:last-child { color: var(--orange); }

        /* ── ORDER NOTES ── */
        .notes-input {
            background: rgba(255,255,255,0.04); border: 1px solid var(--border);
            border-radius: 8px; padding: 9px 12px; color: white;
            font-family: 'Barlow', sans-serif; font-size: 13px;
            outline: none; transition: border-color 0.2s; width: 100%;
            resize: none; min-height: 70px;
        }
        .notes-input:focus { border-color: var(--orange); background: rgba(255,140,0,0.05); }
        .notes-input::placeholder { color: var(--muted); }

        /* ── BUTTONS ── */
        .btn-orange {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            color: black; border: none;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 17px; font-weight: 800; letter-spacing: 2px;
            text-transform: uppercase; border-radius: 10px;
            padding: 13px; cursor: pointer; width: 100%;
            transition: all 0.2s; box-shadow: 0 4px 20px rgba(255,140,0,0.3);
        }
        .btn-orange:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,140,0,0.45); }
        .btn-orange:disabled { opacity: 0.35; cursor: not-allowed; transform: none; }
        .btn-clear { background: transparent; border: 1px solid rgba(231,76,60,0.35); color: #e74c3c; font-family: 'Barlow Condensed', sans-serif; font-size: 13px; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; border-radius: 8px; padding: 8px; cursor: pointer; width: 100%; transition: all 0.2s; }
        .btn-clear:hover { background: rgba(231,76,60,0.1); }

        /* ── SUCCESS MODAL ── */
        .success-modal-inner { text-align: center; }
        .success-check { width: 90px; height: 90px; background: var(--green); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 44px; box-shadow: 0 0 40px rgba(39,174,96,0.4); margin: 0 auto 16px; animation: popIn 0.5s ease; }
        @keyframes popIn { 0% { transform: scale(0); opacity: 0; } 70% { transform: scale(1.1); } 100% { transform: scale(1); opacity: 1; } }
        .success-title { font-family: 'Barlow Condensed', sans-serif; font-size: 24px; font-weight: 800; color: white; margin-bottom: 6px; }
        .success-sub { font-size: 13px; color: var(--muted); margin-bottom: 20px; }
        .success-summary { background: rgba(255,255,255,0.03); border: 1px solid var(--border); border-radius: 10px; padding: 14px 18px; font-size: 13px; text-align: left; display: flex; flex-direction: column; gap: 6px; margin-bottom: 20px; }
        .success-summary-row { display: flex; justify-content: space-between; color: var(--muted); }
        .success-summary-row strong { color: white; }
        .success-summary-row.total { border-top: 1px dashed rgba(255,255,255,0.1); padding-top: 8px; margin-top: 2px; }
        .success-summary-row.total strong { color: var(--orange); font-family: 'Barlow Condensed', sans-serif; font-size: 16px; }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            .navbar-nav { display: none; }
            .user-chip { display: none; }
            .hamburger { display: flex; }
            .mobile-menu { display: flex; }
            .page-wrapper { grid-template-columns: 1fr; }
            .right-panel { position: static; height: auto; border-left: none; border-top: 1px solid var(--border); }
            .menu-grid { grid-template-columns: repeat(2, 1fr); }
            .left-panel { padding: 16px 14px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- LOGOUT MODAL -->
    <div class="modal-overlay" id="logoutModal">
        <div class="modal-box" style="max-width:340px;">
            <div class="modal-hdr danger">
                <div style="display:flex;align-items:center;gap:12px;">
                    <span style="font-size:28px;">🚪</span>
                    <div>
                        <div class="modal-hdr-title">Logout</div>
                        <div class="modal-hdr-sub">Are you sure you want to sign out?</div>
                    </div>
                </div>
                <div class="modal-x" onclick="closeLogout()">✕</div>
            </div>
            <div class="modal-bdy">
                <p style="font-size:14px;color:var(--muted);text-align:center;margin-bottom:20px;">You'll be returned to the login page.</p>
                <asp:Button ID="btnLogout" runat="server" Text="YES, LOGOUT" CssClass="btn-danger" OnClick="BtnLogout_Click" />
                <button type="button" class="btn-outline" onclick="closeLogout()">CANCEL</button>
            </div>
        </div>
    </div>

    <!-- ORDER SUCCESS MODAL -->
    <div class="modal-overlay" id="successModal">
        <div class="modal-box" style="max-width:400px;">
            <div class="modal-hdr">
                <div style="display:flex;align-items:center;gap:12px;">
                    <span style="font-size:28px;">🎱</span>
                    <div>
                        <div class="modal-hdr-title">Order Placed!</div>
                        <div class="modal-hdr-sub">Your order is being prepared</div>
                    </div>
                </div>
                <div class="modal-x" onclick="closeSuccessModal()">✕</div>
            </div>
            <div class="modal-bdy">
                <div class="success-modal-inner">
                    <div class="success-check">✓</div>
                    <div class="success-title">Order Confirmed</div>
                    <p class="success-sub">Staff will bring your order to your table shortly.</p>
                    <div class="success-summary" id="successSummary"></div>
                    <button type="button" class="btn-orange" onclick="closeSuccessModal()">CONTINUE ORDERING</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MOBILE OVERLAY -->
    <div class="mobile-overlay" id="mobileOverlay" onclick="closeMobileMenu()"></div>
    <div class="mobile-menu" id="mobileMenu">
        <div class="mobile-menu-close" onclick="closeMobileMenu()">✕</div>
        <a href="Reservation.aspx">Reservation</a>
        <a href="Order.aspx">Menu</a>
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
            <a href="Reservation.aspx" class="nav-item">Reservation</a>
            <a href="Order.aspx" class="nav-item active">Menu</a>
            <a href="#" class="nav-item">Events</a>
        </div>
        <div class="user-chip-wrap" id="userChipWrap">
            <div class="user-chip" onclick="toggleDropdown()">
                👤 <asp:Literal ID="litUserName" runat="server" />
                <span class="chip-arrow">▼</span>
            </div>
            <div class="user-dropdown" id="userDropdown">
                <div class="dropdown-header">
                    <div class="dropdown-username"><asp:Literal ID="litUserName2" runat="server" /></div>
                    <div class="dropdown-email"><asp:Literal ID="litUserEmail" runat="server" /></div>
                </div>
                <div class="dropdown-item danger" onclick="openLogout()"><span>🚪</span> Logout</div>
            </div>
        </div>
        <div class="hamburger" onclick="openMobileMenu()">
            <span></span><span></span><span></span>
        </div>
    </nav>

    <div class="page-wrapper">

        <!-- ════ LEFT PANEL — MENU ════ -->
        <div class="left-panel">
            <div class="section-header">
                <div class="section-title">Menu</div>
            </div>

            <!-- CATEGORY TABS -->
            <div class="cat-tabs" id="catTabs">
                <div class="cat-tab active" onclick="filterCat('all')">All Items</div>
                <div class="cat-tab" onclick="filterCat('cocktails')">🍹 Cocktails</div>
                <div class="cat-tab" onclick="filterCat('beer')">🍺 Beer</div>
                <div class="cat-tab" onclick="filterCat('whiskey')">🥃 Whiskey</div>
                <div class="cat-tab" onclick="filterCat('shots')">🍸 Shots & Mixed</div>
                <div class="cat-tab" onclick="filterCat('wine')">🍷 Wine & Liqueur</div>
                <div class="cat-tab" onclick="filterCat('brandy')">🥂 Brandy</div>
                <div class="cat-tab" onclick="filterCat('beverages')">☕ Beverages</div>
                <div class="cat-tab" onclick="filterCat('food')">🍽️ Food</div>
                <div class="cat-tab" onclick="filterCat('snacks')">🍟 Snacks</div>
            </div>

            <!-- MENU ITEMS rendered by JS -->
            <div id="menuContainer"></div>
        </div>

        <!-- ════ RIGHT PANEL — CART ════ -->
        <div class="right-panel">
            <div class="panel-title">🛒 Your <span>Order</span></div>

            <!-- TABLE SELECT -->
            <div class="field-group">
                <label class="field-label">Table Number</label>
                <select class="field-select" id="tableSelect">
                    <option value="">— Select table —</option>
                    <option value="1">Table 1 — Wolf</option>
                    <option value="2">Table 2 — Iron Man</option>
                    <option value="3">Table 3 — Hero</option>
                    <option value="4">Table 4 — Acurra</option>
                    <option value="5">Table 5 — Wolf</option>
                    <option value="6">Table 6 — Iron Man</option>
                    <option value="7">Table 7 — Hero</option>
                </select>
            </div>

            <!-- CART ITEMS -->
            <div class="cart-items" id="cartItems">
                <div class="cart-empty" id="cartEmpty">
                    <div class="cart-empty-icon">🛒</div>
                    <div>No items yet.<br/>Tap + to add.</div>
                </div>
            </div>

            <hr class="cart-divider" />

            <!-- TOTALS -->
            <div class="cart-totals">
                <div class="total-row"><span>Subtotal</span><span id="subtotalDisplay">₱0</span></div>
                <div class="total-row grand"><span>TOTAL</span><span id="totalDisplay">₱0</span></div>
            </div>

            <!-- NOTES -->
            <div class="field-group">
                <label class="field-label">Special Instructions</label>
                <textarea class="notes-input" id="orderNotes" placeholder="e.g. No ice, extra shot, allergies…"></textarea>
            </div>

            <!-- ACTIONS -->
            <button type="button" class="btn-orange" id="placeOrderBtn" onclick="placeOrder()" disabled>PLACE ORDER</button>
            <button type="button" class="btn-clear" onclick="clearCart()">CLEAR CART</button>

            <!-- Hidden for postback -->
            <asp:HiddenField ID="hdnOrderJson" runat="server" />
            <asp:HiddenField ID="hdnOrderTable" runat="server" />
            <asp:HiddenField ID="hdnOrderNotes" runat="server" />
            <asp:HiddenField ID="hdnOrderTotal" runat="server" />
            <asp:Button ID="btnSubmitOrder" runat="server" style="display:none" OnClick="BtnSubmitOrder_Click" />
        </div>
    </div>
</form>

<script>
var SESSION_USER = '<asp:Literal ID="litSession" runat="server" />';

var MENU = [
    /* ─ COCKTAILS ─ */
    { id:'c1', cat:'cocktails', name:"Shark's Bite", desc:"Light, citrusy, and gently sweet. Refreshing island vibes.", price:250, emoji:'🦈' },
    { id:'c2', cat:'cocktails', name:"Gin & Tonic", desc:"Classic gin and crisp tonic water. Clean, botanical, and dry.", price:200, emoji:'🍸' },
    { id:'c3', cat:'cocktails', name:"Whiskey Highball", desc:"Whiskey, fizzed and lifted. Smooth up front, sharp on the finish.", price:300, emoji:'🥃' },
    { id:'c4', cat:'cocktails', name:"Blue Lagoon", desc:"Sweet, sharp, and shimmering. Summer like a beach party.", price:250, emoji:'🌊' },
    { id:'c5', cat:'cocktails', name:"Tequila Sunrise", desc:"Sweet, bold, and made to turn heads.", price:300, emoji:'🌅' },
    { id:'c6', cat:'cocktails', name:"Meiji", desc:"Smooth, creamy, and sweet with a hint of berry.", price:200, emoji:'🍓' },
    { id:'c7', cat:'cocktails', name:"Monkey's Brain", desc:"Tart meets creamy in a bold, unexpected blend.", price:200, emoji:'🐒' },
    { id:'c8', cat:'cocktails', name:"Dirty Shirley Temple", desc:"Grenadine and bubbles with just enough sass.", price:200, emoji:'🌸' },
    { id:'c9', cat:'cocktails', name:"Rose Float", desc:"Light, creamy, and sparkling with a strawberry twist.", price:300, emoji:'🌹' },
    { id:'c10', cat:'cocktails', name:"Malibu Nights", desc:"Creamy meets tropical. A smooth-talking troublemaker.", price:350, emoji:'🌴' },
    /* ─ TOWERS ─ */
    { id:'tw1', cat:'cocktails', name:"Sargo Tower (3L)", desc:"Cocktail tower – serves 4–6", price:750, emoji:'🗼' },
    { id:'tw2', cat:'cocktails', name:"Carambola Tower (3L)", desc:"Cocktail tower – serves 4–6", price:750, emoji:'🗼' },
    { id:'tw3', cat:'cocktails', name:"Masse Tower (3L)", desc:"Cocktail tower – serves 4–6", price:900, emoji:'🗼' },
    { id:'tw4', cat:'cocktails', name:"Kurida Tower (3L)", desc:"Cocktail tower – serves 4–6", price:850, emoji:'🗼' },
    /* ─ BEER ─ */
    { id:'b1', cat:'beer', name:"San Miguel Light", desc:"Light, crisp lager", price:115, emoji:'🍺' },
    { id:'b2', cat:'beer', name:"San Miguel Pale Pilsen", desc:"Classic pilsner", price:100, emoji:'🍺' },
    { id:'b3', cat:'beer', name:"San Miguel Apple", desc:"Fruity apple-flavored beer", price:100, emoji:'🍏' },
    { id:'b4', cat:'beer', name:"San Miguel Lychee", desc:"Light lychee-flavored beer", price:100, emoji:'🍈' },
    { id:'b5', cat:'beer', name:"Super Dry", desc:"Japanese dry lager", price:160, emoji:'🍺' },
    { id:'b6', cat:'beer', name:"Red Horse", desc:"Extra strong lager", price:115, emoji:'🐴' },
    { id:'b7', cat:'beer', name:"Corona Beer", desc:"Mexican lager with lime", price:170, emoji:'🌞' },
    { id:'b8', cat:'beer', name:"Soda Water", desc:"", price:110, emoji:'💧' },
    { id:'b9', cat:'beer', name:"Tonic Water", desc:"", price:110, emoji:'💧' },
    /* ─ WHISKEY ─ */
    { id:'w1', cat:'whiskey', name:"Jack Daniels (Glass)", desc:"700ml bottle also available ₱3,300", price:250, emoji:'🥃' },
    { id:'w2', cat:'whiskey', name:"Jack Daniels (Bottle)", desc:"700ml bottle", price:3300, emoji:'🥃' },
    { id:'w3', cat:'whiskey', name:"J.W. Black (Glass)", desc:"700ml bottle also available ₱3,500", price:250, emoji:'🥃' },
    { id:'w4', cat:'whiskey', name:"J.W. Black (Bottle)", desc:"700ml bottle", price:3500, emoji:'🥃' },
    { id:'w5', cat:'whiskey', name:"J.W. Double Black (Bottle)", desc:"700ml bottle", price:5100, emoji:'🥃' },
    { id:'w6', cat:'whiskey', name:"J.W. Gold Reserve (Bottle)", desc:"700ml bottle", price:6000, emoji:'🥃' },
    { id:'w7', cat:'whiskey', name:"J.W. Blue (Bottle)", desc:"750ml bottle – premium", price:20000, emoji:'🥃' },
    /* ─ TEQUILA & LIQUEUR ─ */
    { id:'t1', cat:'shots', name:"Jose Cuervo Gold (Glass)", desc:"Tequila – bottle also available ₱2,250", price:200, emoji:'🌵' },
    { id:'t2', cat:'shots', name:"Jose Cuervo Gold (Bottle)", desc:"700ml bottle", price:2250, emoji:'🌵' },
    { id:'t3', cat:'shots', name:"Tequila Rose (Bottle)", desc:"Liqueur – 700ml", price:2400, emoji:'🌹' },
    { id:'t4', cat:'shots', name:"Baileys Irish Cream (Bottle)", desc:"Liqueur – 700ml", price:2400, emoji:'☘️' },
    { id:'t5', cat:'shots', name:"Jack Coke", desc:"Mixed drink", price:250, emoji:'🥤' },
    { id:'t6', cat:'shots', name:"Fruit Punch", desc:"Mixed drink", price:200, emoji:'🍊' },
    { id:'t7', cat:'shots', name:"Fruit Punch Pitcher", desc:"Serves 3–4", price:600, emoji:'🍹' },
    { id:'t8', cat:'shots', name:"Cheesecake Shot", desc:"Signature shot", price:300, emoji:'🎂' },
    { id:'t9', cat:'shots', name:"Blow Job Shot", desc:"Signature shot", price:250, emoji:'💥' },
    /* ─ WINE ─ */
    { id:'v1', cat:'wine', name:"Yellow Tail Shiraz", desc:"700ml bottle – bold and fruity", price:1500, emoji:'🍷' },
    { id:'v2', cat:'wine', name:"Yellow Tail (Other)", desc:"Merlot / Cab Merlot / Grenache – 700ml", price:1500, emoji:'🍷' },
    { id:'v3', cat:'wine', name:"Carlo Rossi", desc:"700ml bottle – smooth red", price:1200, emoji:'🍷' },
    /* ─ BRANDY ─ */
    { id:'br1', cat:'brandy', name:"Alfonso Light", desc:"700ml bottle", price:900, emoji:'🥂' },
    { id:'br2', cat:'brandy', name:"Fundador Light", desc:"700ml bottle", price:1200, emoji:'🥂' },
    { id:'br3', cat:'brandy', name:"Carlos I", desc:"700ml bottle – premium brandy", price:3300, emoji:'🥂' },
    { id:'br4', cat:'brandy', name:"Hennessy V.S.", desc:"700ml bottle", price:6000, emoji:'✨' },
    { id:'br5', cat:'brandy', name:"Hennessy X.O.", desc:"700ml bottle – ultra premium", price:25000, emoji:'✨' },
    /* ─ BEVERAGES ─ */
    { id:'bv1', cat:'beverages', name:"Soda / Juice (Can)", desc:"Coke, Sprite, Royal, Pineapple, Mango, Orange", price:100, emoji:'🥤' },
    { id:'bv2', cat:'beverages', name:"Lemon Iced Tea", desc:"Bottled", price:100, emoji:'🍋' },
    { id:'bv3', cat:'beverages', name:"Coffee (Black/Brown)", desc:"Hot", price:60, emoji:'☕' },
    { id:'bv4', cat:'beverages', name:"Hot Tea", desc:"", price:60, emoji:'🍵' },
    { id:'bv5', cat:'beverages', name:"Bottled Water", desc:"", price:50, emoji:'💧' },
    { id:'bv6', cat:'beverages', name:"Hot Chocolate / Milktea / Matcha", desc:"", price:79, emoji:'🍫' },
    { id:'bv7', cat:'beverages', name:"Iced Choco / Milktea / Matcha Latte", desc:"", price:119, emoji:'🧋' },
    { id:'bv8', cat:'beverages', name:"Iced (With Pearl)", desc:"Choco / Milktea / Matcha with pearls", price:139, emoji:'🧋' },
    { id:'bv9', cat:'beverages', name:"Extra Lemon", desc:"Add-on", price:100, emoji:'🍋' },
    /* ─ FOOD ─ */
    { id:'f1', cat:'food', name:"Tapa", desc:"Classic cured beef – with rice", price:290, emoji:'🍖' },
    { id:'f2', cat:'food', name:"Chicken Poppers", desc:"With rice", price:199, emoji:'🍗' },
    { id:'f3', cat:'food', name:"Chicken Fillet (1pc)", desc:"With rice", price:199, emoji:'🍗' },
    { id:'f4', cat:'food', name:"Chicken Fillet (2pcs)", desc:"With rice", price:249, emoji:'🍗' },
    { id:'f5', cat:'food', name:"Hungarian", desc:"With rice", price:199, emoji:'🌭' },
    { id:'f6', cat:'food', name:"Longganisa", desc:"With rice", price:199, emoji:'🌭' },
    { id:'f7', cat:'food', name:"Shanghai", desc:"With rice", price:199, emoji:'🥢' },
    { id:'f8', cat:'food', name:"Luncheon Meat", desc:"With rice", price:199, emoji:'🍱' },
    { id:'f9', cat:'food', name:"Tocino", desc:"With rice", price:199, emoji:'🍖' },
    { id:'f10', cat:'food', name:"Nuggets", desc:"With rice", price:199, emoji:'🍗' },
    /* ─ SNACKS ─ */
    { id:'s1', cat:'snacks', name:"Hash Brown (1pc)", desc:"", price:65, emoji:'🥔' },
    { id:'s2', cat:'snacks', name:"Hash Brown (3pcs)", desc:"Set of 3", price:180, emoji:'🥔' },
    { id:'s3', cat:'snacks', name:"Potato Wedges", desc:"250g", price:230, emoji:'🍟' },
    { id:'s4', cat:'snacks', name:"Cajun Fries", desc:"Spicy seasoned fries", price:230, emoji:'🌶️' },
    { id:'s5', cat:'snacks', name:"Dumplings (10pcs)", desc:"", price:200, emoji:'🥟' },
    { id:'s6', cat:'snacks', name:"Pork Sisig", desc:"Sizzling sisig", price:349, emoji:'🍳' },
    { id:'s7', cat:'snacks', name:"Chicken Skin", desc:"Crispy", price:199, emoji:'🍗' },
    { id:'s8', cat:'snacks', name:"Tokwa't Baboy", desc:"Tofu and pork", price:199, emoji:'🧆' },
    { id:'s9', cat:'snacks', name:"Pork Siomai (10pcs)", desc:"", price:125, emoji:'🥟' },
    { id:'s10', cat:'snacks', name:"Japanese Siomai (10pcs)", desc:"", price:150, emoji:'🥟' },
    { id:'s11', cat:'snacks', name:"French Fries (250g)", desc:"", price:180, emoji:'🍟' },
    { id:'s12', cat:'snacks', name:"Peanut (100g)", desc:"", price:120, emoji:'🥜' },
    { id:'s13', cat:'snacks', name:"Onion Rings (250g)", desc:"", price:275, emoji:'🧅' },
    { id:'s14', cat:'snacks', name:"Cheese Sticks (10pcs)", desc:"", price:170, emoji:'🧀' },
    { id:'s15', cat:'snacks', name:"Buchiron (100g)", desc:"", price:185, emoji:'🍡' },
    { id:'s16', cat:'snacks', name:"Lumpiang Shanghai (Pork)", desc:"", price:280, emoji:'🥢' },
    { id:'s17', cat:'snacks', name:"Dynamite", desc:"Spicy stuffed pepper roll", price:220, emoji:'💥' },
    { id:'s18', cat:'snacks', name:"Extra Dip", desc:"", price:30, emoji:'🥫' },
];

var CAT_LABELS = {
    cocktails: '🍹 Cocktails & Towers',
    beer: '🍺 Beer',
    whiskey: '🥃 Whiskey',
    shots: '🌵 Shots, Tequila & Mixed',
    wine: '🍷 Wine & Liqueur',
    brandy: '🥂 Brandy',
    beverages: '☕ Beverages & Café',
    food: '🍽️ Rice Platters',
    snacks: '🍟 Crisp & Crave'
};

var cart = {};
var activeFilter = 'all';

/* ── RENDER MENU ── */
function renderMenu() {
    var container = document.getElementById('menuContainer');
    container.innerHTML = '';
    var lastCat = null;
    var items = MENU.filter(function(m) { return activeFilter === 'all' || m.cat === activeFilter; });

    if (items.length === 0) {
        container.innerHTML = '<div style="color:var(--muted);text-align:center;padding:40px;font-size:14px;">No items found.</div>';
        return;
    }

    var gridEl = null;
    items.forEach(function(item) {
        if (item.cat !== lastCat) {
            if (activeFilter === 'all') {
                var label = document.createElement('div');
                label.className = 'menu-section-label';
                label.textContent = CAT_LABELS[item.cat] || item.cat;
                container.appendChild(label);
            }
            gridEl = document.createElement('div');
            gridEl.className = 'menu-grid';
            container.appendChild(gridEl);
            lastCat = item.cat;
        }

        var qty = cart[item.id] ? cart[item.id].qty : 0;
        var card = document.createElement('div');
        card.className = 'menu-card';
        card.id = 'card-' + item.id;
        card.innerHTML =
            '<div class="menu-card-img">' + item.emoji + '</div>'
            + (qty > 0 ? '<div class="qty-badge" id="badge-' + item.id + '">' + qty + '</div>' : '<div class="qty-badge" id="badge-' + item.id + '" style="display:none">' + qty + '</div>')
            + '<div class="menu-card-body">'
            + '<div class="menu-card-name">' + item.name + '</div>'
            + (item.desc ? '<div class="menu-card-desc">' + item.desc + '</div>' : '')
            + '<div class="menu-card-footer">'
            + '<div class="menu-card-price">₱' + item.price.toLocaleString() + '</div>'
            + '<button class="menu-card-add" onclick="addToCart(\'' + item.id + '\', event)">+</button>'
            + '</div></div>';
        gridEl.appendChild(card);
    });
}

/* ── FILTER ── */
function filterCat(cat) {
    activeFilter = cat;
    document.querySelectorAll('.cat-tab').forEach(function(t) { t.classList.remove('active'); });
    event.target.classList.add('active');
    renderMenu();
}

/* ── CART OPERATIONS ── */
function addToCart(id, e) {
    if (e) e.stopPropagation();
    var item = MENU.find(function(m) { return m.id === id; });
    if (!item) return;
    if (!cart[id]) cart[id] = { item: item, qty: 0 };
    cart[id].qty++;
    updateBadge(id);
    renderCart();
}

function removeFromCart(id) {
    if (!cart[id]) return;
    cart[id].qty--;
    if (cart[id].qty <= 0) delete cart[id];
    updateBadge(id);
    renderCart();
}

function updateBadge(id) {
    var badge = document.getElementById('badge-' + id);
    if (!badge) return;
    var qty = cart[id] ? cart[id].qty : 0;
    badge.textContent = qty;
    badge.style.display = qty > 0 ? 'flex' : 'none';
}

function renderCart() {
    var cartEl = document.getElementById('cartItems');
    var emptyEl = document.getElementById('cartEmpty');
    var keys = Object.keys(cart);
    var total = 0;

    if (keys.length === 0) {
        emptyEl.style.display = 'block';
        cartEl.querySelectorAll('.cart-item').forEach(function(el) { el.remove(); });
        document.getElementById('subtotalDisplay').textContent = '₱0';
        document.getElementById('totalDisplay').textContent = '₱0';
        document.getElementById('placeOrderBtn').disabled = true;
        return;
    }

    emptyEl.style.display = 'none';

    // Clear existing items
    cartEl.querySelectorAll('.cart-item').forEach(function(el) { el.remove(); });

    keys.forEach(function(id) {
        var entry = cart[id];
        var lineTotal = entry.item.price * entry.qty;
        total += lineTotal;

        var row = document.createElement('div');
        row.className = 'cart-item';
        row.id = 'ci-' + id;
        row.innerHTML =
            '<div class="cart-item-emoji">' + entry.item.emoji + '</div>'
            + '<div class="cart-item-info">'
            + '<div class="cart-item-name">' + entry.item.name + '</div>'
            + '<div class="cart-item-price">₱' + entry.item.price.toLocaleString() + ' × ' + entry.qty + ' = ₱' + lineTotal.toLocaleString() + '</div>'
            + '</div>'
            + '<div class="cart-item-controls">'
            + '<button class="ctrl-btn remove" onclick="removeFromCart(\'' + id + '\')">−</button>'
            + '<span class="ctrl-qty">' + entry.qty + '</span>'
            + '<button class="ctrl-btn" onclick="addToCart(\'' + id + '\')">+</button>'
            + '</div>';
        cartEl.insertBefore(row, emptyEl);
    });

    document.getElementById('subtotalDisplay').textContent = '₱' + total.toLocaleString();
    document.getElementById('totalDisplay').textContent = '₱' + total.toLocaleString();
    document.getElementById('placeOrderBtn').disabled = false;
}

function clearCart() {
    if (Object.keys(cart).length === 0) return;
    if (!confirm('Clear all items from your cart?')) return;
    cart = {};
    MENU.forEach(function(m) { updateBadge(m.id); });
    renderCart();
}

/* ── PLACE ORDER ── */
function placeOrder() {
    var tableEl = document.getElementById('tableSelect');
    if (!tableEl.value) { alert('Please select your table number.'); return; }

    var orderLines = Object.keys(cart).map(function(id) {
        var e = cart[id];
        return { id: id, name: e.item.name, price: e.item.price, qty: e.qty };
    });

    var total = orderLines.reduce(function(sum, l) { return sum + l.price * l.qty; }, 0);
    var notes = document.getElementById('orderNotes').value.trim();

    document.getElementById('hdnOrderJson').value = JSON.stringify(orderLines);
    document.getElementById('hdnOrderTable').value = tableEl.value;
    document.getElementById('hdnOrderNotes').value = notes;
    document.getElementById('hdnOrderTotal').value = total;

    // Show success immediately (optimistic UI), then submit
    showSuccess(tableEl.value, orderLines, total);
    document.getElementById('btnSubmitOrder').click();
}

function showSuccess(tableNum, lines, total) {
    var html = '';
    lines.slice(0, 5).forEach(function(l) {
        html += '<div class="success-summary-row"><span>' + l.name + ' ×' + l.qty + '</span><strong>₱' + (l.price * l.qty).toLocaleString() + '</strong></div>';
    });
    if (lines.length > 5) {
        html += '<div class="success-summary-row"><span>...and ' + (lines.length - 5) + ' more item(s)</span><strong></strong></div>';
    }
    html += '<div class="success-summary-row total"><span>Table ' + tableNum + ' · Total</span><strong>₱' + total.toLocaleString() + '</strong></div>';
    document.getElementById('successSummary').innerHTML = html;
    document.getElementById('successModal').classList.add('open');

    // Clear cart after order
    cart = {};
    MENU.forEach(function(m) { updateBadge(m.id); });
    renderCart();
    document.getElementById('orderNotes').value = '';
}

function closeSuccessModal() {
    document.getElementById('successModal').classList.remove('open');
}

/* ── NAV ── */
function toggleDropdown() { document.getElementById('userChipWrap').classList.toggle('open'); }
function openLogout() { document.getElementById('userChipWrap').classList.remove('open'); document.getElementById('logoutModal').classList.add('open'); }
function closeLogout() { document.getElementById('logoutModal').classList.remove('open'); }
function openMobileMenu() { document.getElementById('mobileMenu').classList.add('open'); document.getElementById('mobileOverlay').style.display = 'block'; }
function closeMobileMenu() { document.getElementById('mobileMenu').classList.remove('open'); document.getElementById('mobileOverlay').style.display = 'none'; }

document.addEventListener('DOMContentLoaded', function() {
    document.addEventListener('click', function(e) {
        var wrap = document.getElementById('userChipWrap');
        if (wrap && !wrap.contains(e.target)) wrap.classList.remove('open');
    });
    renderMenu();
    renderCart();
});
</script>
</body>
</html>
