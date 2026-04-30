<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CashierDashboard.aspx.cs" Inherits="CueTrack.CashierDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack · Cashier Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
        :root {
            --orange:     #FF8C00;
            --orange-hot: #FF6A00;
            --dark-bg:    #0d0d0d;
            --panel-bg:   #161616;
            --card-bg:    #1c1c1c;
            --border:     #2a2a2a;
            --text:       #f0f0f0;
            --muted:      #777;
            --green:      #27ae60;
            --green-dim:  rgba(39,174,96,0.15);
            --red:        #c0392b;
            --red-dim:    rgba(192,57,43,0.15);
            --blue:       #2980b9;
            --blue-dim:   rgba(41,128,185,0.15);
        }

        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'Barlow', sans-serif;
            background: var(--dark-bg);
            color: var(--text);
            height: 100vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* ── TOPBAR ── */
        .topbar {
            height: 52px;
            background: rgba(10,10,10,0.98);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            flex-shrink: 0;
            z-index: 200;
        }

        .topbar-left { display: flex; align-items: center; gap: 10px; }

        .logo-img { width: 30px; height: auto; }
        .logo-text {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px; font-weight: 800;
            letter-spacing: 1px; color: white;
        }
        .topbar-divider {
            width: 1px; height: 20px;
            background: var(--border); margin: 0 6px;
        }
        .topbar-page {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 14px; font-weight: 700;
            letter-spacing: 1px; color: var(--muted);
            text-transform: uppercase;
        }

        .topbar-right { display: flex; align-items: center; gap: 10px; }

        .clock-badge {
            background: var(--orange);
            color: black;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 14px; font-weight: 800;
            letter-spacing: 1px;
            padding: 4px 14px;
            border-radius: 20px;
        }

        .staff-chip {
            display: flex; align-items: center; gap: 7px;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 4px 12px 4px 6px;
            cursor: pointer;
            position: relative;
        }
        .staff-avatar {
            width: 28px; height: 28px;
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 900; color: black;
        }
        .staff-name {
            font-size: 13px; font-weight: 600; color: var(--text);
        }
        .staff-dropdown {
            display: none;
            position: absolute; top: calc(100% + 8px); right: 0;
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 12px; min-width: 160px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.6);
            z-index: 999;
        }
        .staff-chip.open .staff-dropdown { display: block; }
        .staff-dd-item {
            padding: 11px 16px;
            font-size: 13px; font-weight: 600; color: var(--text);
            cursor: pointer;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            transition: background 0.15s;
        }
        .staff-dd-item:last-child { border: none; }
        .staff-dd-item:hover { background: rgba(255,255,255,0.06); color: var(--orange); }
        .staff-dd-item.danger { color: var(--red); }
        .staff-dd-item.danger:hover { background: var(--red-dim); }

        /* ── TAB BAR ── */
        .tabbar {
            display: flex;
            background: var(--panel-bg);
            border-bottom: 1px solid var(--border);
            padding: 0 16px;
            flex-shrink: 0;
            gap: 2px;
        }
        .tab {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 15px; font-weight: 800;
            letter-spacing: 1.2px; text-transform: uppercase;
            color: var(--muted);
            padding: 10px 18px;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            position: relative; top: 1px;
            transition: all 0.2s;
        }
        .tab:hover { color: var(--text); }
        .tab.active { color: var(--orange); border-bottom-color: var(--orange); }

        /* ── MAIN LAYOUT ── */
        .main {
            display: grid;
            grid-template-columns: 1fr 320px;
            flex: 1;
            overflow: hidden;
        }

        /* ── TABLE GRID PANEL ── */
        .tables-panel {
            overflow-y: auto;
            padding: 14px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .tables-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
        }

        .table-card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 10px 12px 10px;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
            overflow: hidden;
        }
        .table-card:hover { border-color: var(--orange); background: rgba(255,140,0,0.05); }
        .table-card.active-card { border-color: var(--orange); box-shadow: 0 0 0 2px rgba(255,140,0,0.2); }

        .table-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 5px;
        }

        .table-name {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 15px; font-weight: 800;
            letter-spacing: 0.5px; color: white;
        }

        .status-pill {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 10px; font-weight: 800;
            letter-spacing: 1px; text-transform: uppercase;
            padding: 2px 8px; border-radius: 10px;
        }
        .pill-inuse    { background: rgba(41,128,185,0.2); color: #5dade2; border: 1px solid rgba(41,128,185,0.4); }
        .pill-reserve  { background: rgba(255,140,0,0.2); color: var(--orange); border: 1px solid rgba(255,140,0,0.4); }
        .pill-avail    { background: rgba(39,174,96,0.2); color: #2ecc71; border: 1px solid rgba(39,174,96,0.4); }

        .table-timer {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 800; color: white;
            letter-spacing: 1px; margin-bottom: 2px;
        }
        .table-timer.stopped { color: var(--muted); }

        .table-guest { font-size: 12px; color: var(--muted); margin-bottom: 3px; }
        .table-rate  { font-size: 11px; color: var(--orange); font-weight: 600; }

        .table-card-footer {
            display: flex; gap: 6px; margin-top: 10px;
        }

        .btn-sm {
            flex: 1; padding: 5px 4px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 12px; font-weight: 800;
            letter-spacing: 0.8px; text-transform: uppercase;
            border: none; border-radius: 6px;
            cursor: pointer; transition: all 0.15s;
        }
        .btn-bill-out {
            background: linear-gradient(135deg, var(--green), #219a52);
            color: white;
        }
        .btn-bill-out:hover { filter: brightness(1.1); }
        .btn-add-order {
            background: rgba(255,255,255,0.07);
            color: var(--text);
            border: 1px solid var(--border);
        }
        .btn-add-order:hover { background: rgba(255,140,0,0.12); color: var(--orange); border-color: var(--orange); }
        .btn-add-time {
            background: var(--blue-dim);
            color: #5dade2;
            border: 1px solid rgba(41,128,185,0.4);
        }
        .btn-add-time:hover { background: rgba(41,128,185,0.25); }
        .btn-start {
            background: var(--orange);
            color: black;
        }

        /* ── RIGHT DETAIL PANEL ── */
        .detail-panel {
            background: var(--panel-bg);
            border-left: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .detail-panel-header {
            padding: 14px 16px 12px;
            border-bottom: 1px solid var(--border);
            background: rgba(255,140,0,0.04);
            flex-shrink: 0;
        }
        .detail-table-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 800;
            letter-spacing: 1px; color: white;
        }
        .detail-table-sub { font-size: 12px; color: var(--muted); margin-top: 2px; }

        .detail-scroll {
            flex: 1;
            overflow-y: auto;
            padding: 14px 16px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .detail-section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 800;
            letter-spacing: 1px; text-transform: uppercase;
            color: var(--orange); margin-bottom: 8px;
        }

        .info-row {
            display: flex; justify-content: space-between;
            align-items: baseline;
            padding: 5px 0;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            font-size: 13px;
        }
        .info-key { color: var(--muted); }
        .info-val { font-weight: 600; color: var(--text); text-align: right; max-width: 55%; }

        /* order items */
        .order-item {
            display: flex; justify-content: space-between; align-items: center;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 8px; padding: 8px 12px;
            margin-bottom: 6px;
            font-size: 13px;
        }
        .order-item-name { font-weight: 600; color: var(--text); }
        .order-item-qty  { color: var(--muted); font-size: 12px; margin-top: 2px; }
        .order-item-price { font-family: 'Barlow Condensed', sans-serif; font-size: 15px; font-weight: 800; color: var(--orange); }

        .empty-orders {
            text-align: center; color: var(--muted);
            font-size: 12px; padding: 20px 0;
        }

        /* vehicle */
        .vehicle-fields {
            display: grid; grid-template-columns: 1fr 1fr; gap: 8px;
        }
        .vfield { display: flex; flex-direction: column; gap: 3px; }
        .vfield label { font-size: 10px; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .vfield input {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border); border-radius: 6px;
            padding: 7px 10px; color: var(--text);
            font-family: 'Barlow', sans-serif; font-size: 13px; outline: none;
            transition: border-color 0.2s;
        }
        .vfield input:focus { border-color: var(--orange); }

        /* total bar */
        .total-bar {
            padding: 12px 16px;
            border-top: 1px solid var(--border);
            background: var(--panel-bg);
            flex-shrink: 0;
        }
        .total-row {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 10px;
        }
        .total-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 800; color: white;
        }
        .total-amount {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 28px; font-weight: 900; color: var(--orange);
        }
        .discount-toggle-row {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 10px;
        }
        .discount-toggle-label { font-size: 12px; color: var(--muted); }
        .toggle { position: relative; width: 42px; height: 22px; cursor: pointer; }
        .toggle input { opacity: 0; width: 0; height: 0; }
        .toggle-slider { position: absolute; inset: 0; background: #333; border-radius: 11px; transition: background 0.3s; }
        .toggle-slider::before { content: ''; position: absolute; width: 16px; height: 16px; left: 3px; top: 3px; background: white; border-radius: 50%; transition: transform 0.3s; }
        .toggle input:checked + .toggle-slider { background: var(--orange); }
        .toggle input:checked + .toggle-slider::before { transform: translateX(20px); }
        .btn-bill-out-full {
            width: 100%; padding: 12px;
            background: linear-gradient(135deg, var(--green), #219a52);
            color: white; border: none; border-radius: 10px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 900;
            letter-spacing: 2px; text-transform: uppercase;
            cursor: pointer; transition: all 0.2s;
            box-shadow: 0 4px 16px rgba(39,174,96,0.35);
        }
        .btn-bill-out-full:hover { transform: translateY(-2px); filter: brightness(1.1); }

        /* ── MODALS ── */
        .overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.85); z-index: 800;
            align-items: center; justify-content: center; padding: 20px;
        }
        .overlay.open { display: flex; }
        .modal {
            background: var(--card-bg); border: 1px solid var(--border);
            border-radius: 16px; width: 100%; overflow: hidden;
            animation: popIn 0.22s ease;
        }
        @keyframes popIn {
            from { transform: scale(0.93); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }
        .modal-head {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            padding: 16px 20px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-head.green { background: linear-gradient(135deg, var(--green), #219a52); }
        .modal-head-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 900; color: black;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .modal-head-sub { font-size: 11px; color: rgba(0,0,0,0.6); font-weight: 600; margin-top: 2px; }
        .modal-x {
            width: 28px; height: 28px; background: rgba(0,0,0,0.2);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 14px; color: black; font-weight: 900;
        }
        .modal-x:hover { background: rgba(0,0,0,0.4); }
        .modal-body { padding: 20px; }

        /* Add Order Modal */
        .menu-search {
            width: 100%; padding: 9px 12px;
            background: rgba(255,255,255,0.05); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text);
            font-family: 'Barlow', sans-serif; font-size: 14px;
            outline: none; margin-bottom: 12px;
            transition: border-color 0.2s;
        }
        .menu-search:focus { border-color: var(--orange); }
        .menu-category { font-size: 11px; font-weight: 700; color: var(--orange); text-transform: uppercase; letter-spacing: 0.8px; margin: 10px 0 6px; }
        .menu-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .menu-item {
            background: rgba(255,255,255,0.04); border: 1px solid var(--border);
            border-radius: 8px; padding: 10px 12px; cursor: pointer;
            transition: all 0.15s; display: flex; justify-content: space-between; align-items: center;
        }
        .menu-item:hover { border-color: var(--orange); background: rgba(255,140,0,0.08); }
        .menu-item-name { font-size: 13px; font-weight: 600; }
        .menu-item-price { font-family: 'Barlow Condensed', sans-serif; font-size: 14px; font-weight: 800; color: var(--orange); }
        .cart-section { border-top: 1px solid var(--border); margin-top: 14px; padding-top: 14px; }
        .cart-item {
            display: flex; justify-content: space-between; align-items: center;
            padding: 7px 0; border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .cart-item-controls { display: flex; align-items: center; gap: 8px; }
        .qty-btn {
            width: 24px; height: 24px; background: rgba(255,255,255,0.08);
            border: 1px solid var(--border); border-radius: 4px;
            color: white; font-size: 14px; font-weight: 700;
            cursor: pointer; display: flex; align-items: center; justify-content: center;
            transition: all 0.15s;
        }
        .qty-btn:hover { background: var(--orange); border-color: var(--orange); color: black; }
        .qty-val { font-weight: 700; min-width: 20px; text-align: center; font-size: 14px; }

        /* Bill Out Modal */
        .bill-row {
            display: flex; justify-content: space-between; padding: 7px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.06); font-size: 13px;
        }
        .bill-row:last-child { border: none; }
        .bill-key { color: var(--muted); }
        .bill-val { font-weight: 600; }
        .bill-total-row { display: flex; justify-content: space-between; align-items: baseline; margin-top: 14px; }
        .bill-total-label { font-family: 'Barlow Condensed', sans-serif; font-size: 20px; font-weight: 800; color: white; }
        .bill-total-amount { font-family: 'Barlow Condensed', sans-serif; font-size: 30px; font-weight: 900; color: var(--green); }
        .btn-confirm-bill {
            width: 100%; margin-top: 16px; padding: 13px;
            background: linear-gradient(135deg, var(--green), #219a52);
            color: white; border: none; border-radius: 10px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px; font-weight: 900;
            letter-spacing: 2px; text-transform: uppercase;
            cursor: pointer; transition: all 0.2s;
            box-shadow: 0 4px 16px rgba(39,174,96,0.35);
        }
        .btn-confirm-bill:hover { transform: translateY(-2px); }

        /* Add Time Modal */
        .time-options { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 16px 0; }
        .time-opt {
            background: rgba(255,255,255,0.04); border: 2px solid var(--border);
            border-radius: 10px; padding: 14px; text-align: center;
            cursor: pointer; transition: all 0.2s;
        }
        .time-opt:hover, .time-opt.selected {
            border-color: var(--orange); background: rgba(255,140,0,0.08);
        }
        .time-opt-h { font-family: 'Barlow Condensed', sans-serif; font-size: 24px; font-weight: 900; color: var(--orange); }
        .time-opt-l { font-size: 11px; color: var(--muted); margin-top: 2px; }
        .btn-add-time-confirm {
            width: 100%; padding: 12px;
            background: var(--blue); color: white; border: none;
            border-radius: 10px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px; font-weight: 900;
            letter-spacing: 2px; cursor: pointer; transition: all 0.2s;
        }
        .btn-add-time-confirm:hover { filter: brightness(1.15); }

        /* Start Session Modal */
        .start-form { display: flex; flex-direction: column; gap: 10px; }
        .start-field { display: flex; flex-direction: column; gap: 4px; }
        .start-label { font-size: 11px; font-weight: 700; color: var(--orange); text-transform: uppercase; letter-spacing: 0.5px; }
        .start-input {
            background: rgba(255,255,255,0.05); border: 1px solid var(--border);
            border-radius: 8px; padding: 9px 12px; color: var(--text);
            font-family: 'Barlow', sans-serif; font-size: 14px; outline: none;
            transition: border-color 0.2s;
        }
        .start-input:focus { border-color: var(--orange); }
        .btn-start-session {
            width: 100%; margin-top: 6px; padding: 12px;
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            color: black; border: none; border-radius: 10px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px; font-weight: 900;
            letter-spacing: 2px; cursor: pointer; transition: all 0.2s;
            box-shadow: 0 4px 16px rgba(255,140,0,0.35);
        }
        .btn-start-session:hover { transform: translateY(-2px); }

        /* Pending reservations badge */
        .pending-badge {
            background: var(--red); color: white;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 10px; font-weight: 900;
            width: 18px; height: 18px; border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            margin-left: 6px;
        }

        /* Reservation tab table */
        .reserv-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .reserv-table th {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 11px; font-weight: 800; letter-spacing: 0.8px;
            text-transform: uppercase; color: var(--muted);
            padding: 8px 10px; text-align: left;
            border-bottom: 1px solid var(--border);
        }
        .reserv-table td {
            padding: 10px 10px; border-bottom: 1px solid rgba(255,255,255,0.04);
            color: var(--text);
        }
        .reserv-table tr:hover td { background: rgba(255,255,255,0.02); }
        .btn-approve {
            padding: 4px 10px;
            background: var(--green-dim); color: #2ecc71;
            border: 1px solid rgba(39,174,96,0.4);
            border-radius: 6px; font-size: 11px; font-weight: 700;
            cursor: pointer; transition: all 0.15s;
        }
        .btn-approve:hover { background: rgba(39,174,96,0.25); }
        .btn-reject {
            padding: 4px 10px;
            background: var(--red-dim); color: #e74c3c;
            border: 1px solid rgba(192,57,43,0.4);
            border-radius: 6px; font-size: 11px; font-weight: 700;
            cursor: pointer; transition: all 0.15s; margin-left: 5px;
        }
        .btn-reject:hover { background: rgba(192,57,43,0.25); }

        /* Scrollbar */
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #444; }

        /* Tab panels */
        .tab-panel { display: none; }
        .tab-panel.active { display: flex; flex-direction: column; flex: 1; overflow: hidden; }

        .billing-tab { padding: 14px; overflow-y: auto; }
        .billing-summary-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 10px; margin-bottom: 16px; }
        .billing-stat {
            background: var(--card-bg); border: 1px solid var(--border);
            border-radius: 10px; padding: 14px 16px;
        }
        .billing-stat-label { font-size: 11px; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; }
        .billing-stat-value {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 26px; font-weight: 900; color: var(--orange); margin-top: 4px;
        }
        .billing-stat-sub { font-size: 11px; color: var(--muted); margin-top: 2px; }

        .billing-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .billing-table th {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 11px; font-weight: 800; letter-spacing: 0.8px;
            color: var(--muted); text-transform: uppercase;
            padding: 8px 12px; text-align: left; border-bottom: 1px solid var(--border);
        }
        .billing-table td { padding: 10px 12px; border-bottom: 1px solid rgba(255,255,255,0.04); }
        .billing-table tr:hover td { background: rgba(255,255,255,0.02); }

        .parking-grid { display: grid; grid-template-columns: repeat(4,1fr); gap: 10px; padding: 14px; }
        .parking-slot {
            background: var(--card-bg); border: 1px solid var(--border);
            border-radius: 10px; padding: 14px; text-align: center;
            cursor: pointer; transition: all 0.2s;
        }
        .parking-slot.occupied { border-color: var(--red); background: var(--red-dim); }
        .parking-slot.occupied:hover { filter: brightness(1.1); }
        .parking-slot:not(.occupied):hover { border-color: var(--green); background: var(--green-dim); }
        .parking-icon { font-size: 28px; margin-bottom: 6px; }
        .parking-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 14px; font-weight: 800; color: white;
        }
        .parking-plate { font-size: 11px; color: var(--muted); margin-top: 3px; }

        /* ASP hidden button */
        #btnApproveHdn, #btnRejectHdn, #btnBillOutHdn,
        #btnAddTimeHdn, #btnStartSessionHdn, #btnAddOrderHdn { display: none; }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- ═══ ADD ORDER MODAL ═══ -->
    <div class="overlay" id="addOrderModal">
        <div class="modal" style="max-width:480px;max-height:85vh;display:flex;flex-direction:column;">
            <div class="modal-head">
                <div>
                    <div class="modal-head-title">Add Order</div>
                    <div class="modal-head-sub" id="addOrderSub">Table 1</div>
                </div>
                <div class="modal-x" onclick="closeModal('addOrderModal')">✕</div>
            </div>
            <div class="modal-body" style="overflow-y:auto;flex:1;">
                <input class="menu-search" type="text" placeholder="Search menu..." oninput="filterMenu(this.value)" />
                <div id="menuList"></div>
                <div class="cart-section" id="cartSection" style="display:none;">
                    <div class="detail-section-title">Cart</div>
                    <div id="cartList"></div>
                    <div style="display:flex;justify-content:flex-end;margin-top:8px;">
                        <span style="font-family:'Barlow Condensed',sans-serif;font-size:18px;font-weight:900;color:var(--orange);">Cart Total: ₱<span id="cartTotal">0</span></span>
                    </div>
                    <button type="button" class="btn-confirm-bill" style="background:linear-gradient(135deg,var(--orange),var(--orange-hot));margin-top:10px;" onclick="confirmAddOrder()">ADD TO ORDER</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ ADD TIME MODAL ═══ -->
    <div class="overlay" id="addTimeModal">
        <div class="modal" style="max-width:380px;">
            <div class="modal-head">
                <div>
                    <div class="modal-head-title">Add Time</div>
                    <div class="modal-head-sub" id="addTimeSub">Table 1</div>
                </div>
                <div class="modal-x" onclick="closeModal('addTimeModal')">✕</div>
            </div>
            <div class="modal-body">
                <p style="font-size:13px;color:var(--muted);margin-bottom:4px;">Select additional time:</p>
                <div class="time-options">
                    <div class="time-opt selected" onclick="selectTimeOpt(this, 1)">
                        <div class="time-opt-h">+1</div>
                        <div class="time-opt-l">hour</div>
                    </div>
                    <div class="time-opt" onclick="selectTimeOpt(this, 2)">
                        <div class="time-opt-h">+2</div>
                        <div class="time-opt-l">hours</div>
                    </div>
                    <div class="time-opt" onclick="selectTimeOpt(this, 3)">
                        <div class="time-opt-h">+3</div>
                        <div class="time-opt-l">hours</div>
                    </div>
                    <div class="time-opt" onclick="selectTimeOpt(this, 4)">
                        <div class="time-opt-h">+4</div>
                        <div class="time-opt-l">hours</div>
                    </div>
                </div>
                <button type="button" class="btn-add-time-confirm" onclick="confirmAddTime()">CONFIRM ADD TIME</button>
            </div>
        </div>
    </div>

    <!-- ═══ BILL OUT MODAL ═══ -->
    <div class="overlay" id="billOutModal">
        <div class="modal" style="max-width:380px;">
            <div class="modal-head green">
                <div>
                    <div class="modal-head-title">Bill Out</div>
                    <div class="modal-head-sub" id="billOutSub">Table 1 · Final Billing</div>
                </div>
                <div class="modal-x" onclick="closeModal('billOutModal')">✕</div>
            </div>
            <div class="modal-body">
                <div id="billOutBreakdown"></div>
                <div class="bill-total-row">
                    <span class="bill-total-label">TOTAL DUE</span>
                    <span class="bill-total-amount">₱<span id="billOutTotal">0</span></span>
                </div>
                <button type="button" class="btn-confirm-bill" onclick="confirmBillOut()">✓ CONFIRM PAYMENT</button>
            </div>
        </div>
    </div>

    <!-- ═══ START SESSION MODAL ═══ -->
    <div class="overlay" id="startModal">
        <div class="modal" style="max-width:380px;">
            <div class="modal-head">
                <div>
                    <div class="modal-head-title">Start Session</div>
                    <div class="modal-head-sub" id="startModalSub">Table 1</div>
                </div>
                <div class="modal-x" onclick="closeModal('startModal')">✕</div>
            </div>
            <div class="modal-body">
                <div class="start-form">
                    <div class="start-field">
                        <label class="start-label">Guest Name</label>
                        <input class="start-input" id="startGuestName" type="text" placeholder="Full name" />
                    </div>
                    <div class="start-field">
                        <label class="start-label">Rental Type</label>
                        <select class="start-input" id="startRentalType">
                            <option value="Rental Time">Rental Time (₱350/hr)</option>
                            <option value="Open Time">Open Time (₱350/hr until end)</option>
                        </select>
                    </div>
                    <div class="start-field" id="startHoursField">
                        <label class="start-label">Hours (Rental Time)</label>
                        <select class="start-input" id="startHours">
                            <option value="1">1 hour</option>
                            <option value="2">2 hours</option>
                            <option value="3">3 hours</option>
                            <option value="4">4 hours</option>
                        </select>
                    </div>
                    <div class="start-field">
                        <label class="start-label">Discount</label>
                        <select class="start-input" id="startDiscount">
                            <option value="none">No Discount</option>
                            <option value="student">Student / PWD / Senior (₱300/hr)</option>
                        </select>
                    </div>
                    <button type="button" class="btn-start-session" onclick="confirmStartSession()">▶ START SESSION</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ LOGOUT CONFIRM ═══ -->
    <div class="overlay" id="logoutModal">
        <div class="modal" style="max-width:320px;">
            <div class="modal-head" style="background:linear-gradient(135deg,var(--red),#e74c3c);">
                <div class="modal-head-title" style="color:white;">Logout</div>
                <div class="modal-x" style="color:white;" onclick="closeModal('logoutModal')">✕</div>
            </div>
            <div class="modal-body" style="text-align:center;">
                <p style="color:var(--muted);font-size:14px;margin-bottom:16px;">Are you sure you want to sign out?</p>
                <asp:Button ID="btnDoLogout" runat="server" Text="YES, LOGOUT"
                    CssClass="btn-confirm-bill"
                    style="background:linear-gradient(135deg,var(--red),#e74c3c);"
                    OnClick="BtnLogout_Click" />
                <button type="button" onclick="closeModal('logoutModal')"
                    style="width:100%;margin-top:8px;padding:10px;background:transparent;border:1px solid var(--border);border-radius:8px;color:var(--muted);cursor:pointer;font-family:'Barlow Condensed',sans-serif;font-size:15px;font-weight:700;">CANCEL</button>
            </div>
        </div>
    </div>

    <!-- ═══ TOPBAR ═══ -->
    <div class="topbar">
        <div class="topbar-left">
            <img src="Image/great-white-shark.png" class="logo-img"
                 onerror="this.style.display='none'" />
            <span class="logo-text">SHARKS ARENA</span>
            <div class="topbar-divider"></div>
            <span class="topbar-page">▹ Cashier Dashboard</span>
        </div>
        <div class="topbar-right">
            <div class="clock-badge" id="clockBadge">3:00 PM</div>
            <div class="staff-chip" id="staffChip" onclick="toggleStaffDrop()">
                <div class="staff-avatar" id="staffInitial">C</div>
                <span class="staff-name">Staff: <asp:Literal ID="litCashierName" runat="server" /></span>
                <div class="staff-dropdown">
                    <div class="staff-dd-item">⚙️ &nbsp;Settings</div>
                    <div class="staff-dd-item danger" onclick="openLogoutModal()">🚪 &nbsp;Logout</div>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ TAB BAR ═══ -->
    <div class="tabbar">
        <div class="tab active" onclick="switchTab('table')">Table</div>
        <div class="tab" onclick="switchTab('orders')">Orders</div>
        <div class="tab" onclick="switchTab('billing')">Billing</div>
        <div class="tab" onclick="switchTab('reservation')">
            Reservation
            <span class="pending-badge" id="pendingBadge">3</span>
        </div>
        <div class="tab" onclick="switchTab('parking')">Parking</div>
    </div>

    <!-- ═══ MAIN AREA ═══ -->
    <div class="main">

        <!-- ── TABLE PANEL (left) ── -->
        <div class="tables-panel" id="tableTabPanel">

            <!-- TABLE TAB -->
            <div class="tab-panel active" id="panel-table">
                <div class="tables-grid" id="tablesGrid"></div>
            </div>

            <!-- ORDERS TAB -->
            <div class="tab-panel" id="panel-orders">
                <div style="padding:4px 0 12px;">
                    <div class="detail-section-title">All Active Orders</div>
                    <div id="allOrdersList"></div>
                </div>
            </div>

            <!-- BILLING TAB -->
            <div class="tab-panel" id="panel-billing">
                <div class="billing-tab" style="padding:0;">
                    <div class="billing-summary-grid">
                        <div class="billing-stat">
                            <div class="billing-stat-label">Today's Revenue</div>
                            <div class="billing-stat-value">₱<span id="statRevenue">0</span></div>
                            <div class="billing-stat-sub">Billed sessions</div>
                        </div>
                        <div class="billing-stat">
                            <div class="billing-stat-label">Active Tables</div>
                            <div class="billing-stat-value"><span id="statActive">0</span></div>
                            <div class="billing-stat-sub">In use right now</div>
                        </div>
                        <div class="billing-stat">
                            <div class="billing-stat-label">Sessions Today</div>
                            <div class="billing-stat-value"><span id="statSessions">0</span></div>
                            <div class="billing-stat-sub">Completed</div>
                        </div>
                    </div>
                    <div class="detail-section-title">Recent Billing History</div>
                    <table class="billing-table">
                        <thead>
                            <tr>
                                <th>Table</th>
                                <th>Guest</th>
                                <th>Duration</th>
                                <th>Amount</th>
                                <th>Time</th>
                            </tr>
                        </thead>
                        <tbody id="billingHistory"></tbody>
                    </table>
                </div>
            </div>

            <!-- RESERVATION TAB -->
            <div class="tab-panel" id="panel-reservation">
                <div style="padding: 4px 0 12px;">
                    <div class="detail-section-title">Pending Reservations</div>
                    <asp:GridView ID="gvReservations" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="reserv-table"
                        GridLines="None"
                        OnRowCommand="GvReservations_RowCommand">
                        <Columns>
                            <asp:BoundField  DataField="ReservationID"   HeaderText="ID"      ItemStyle-Width="40px" />
                            <asp:BoundField  DataField="GuestName"        HeaderText="Guest"   />
                            <asp:BoundField  DataField="TableID"          HeaderText="Table"   ItemStyle-Width="55px" />
                            <asp:BoundField  DataField="ReservationDate"  HeaderText="Date"    DataFormatString="{0:MMM dd}" />
                            <asp:BoundField  DataField="Schedule"         HeaderText="Time"    />
                            <asp:BoundField  DataField="RentalType"       HeaderText="Type"    />
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" Text="✓ Approve"
                                        CssClass="btn-approve"
                                        CommandName="Approve"
                                        CommandArgument='<%# Eval("ReservationID") %>' />
                                    <asp:LinkButton runat="server" Text="✕ Reject"
                                        CssClass="btn-reject"
                                        CommandName="Reject"
                                        CommandArgument='<%# Eval("ReservationID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div style="padding:20px;text-align:center;color:var(--muted);font-size:13px;">No pending reservations.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

            <!-- PARKING TAB -->
            <div class="tab-panel" id="panel-parking">
                <div class="parking-grid" id="parkingGrid"></div>
            </div>

        </div>

        <!-- ── DETAIL PANEL (right) ── -->
        <div class="detail-panel">
            <div class="detail-panel-header">
                <div class="detail-table-title" id="detailTitle">Table 1</div>
                <div class="detail-table-sub" id="detailSub">Select a table to see details</div>
            </div>
            <div class="detail-scroll" id="detailScroll">

                <!-- Session Info -->
                <div id="detailSessionSection">
                    <div class="detail-section-title">Session Info</div>
                    <div class="info-row"><span class="info-key">Time Running</span><span class="info-val" id="dTime">—</span></div>
                    <div class="info-row"><span class="info-key">Full Name</span><span class="info-val" id="dName">—</span></div>
                    <div class="info-row"><span class="info-key">Rental Type</span><span class="info-val" id="dRental">—</span></div>
                    <div class="info-row"><span class="info-key">Discount Type</span><span class="info-val" id="dDiscount">N/A</span></div>
                </div>

                <!-- Food & Drinks -->
                <div>
                    <div class="detail-section-title">Food &amp; Drinks</div>
                    <div id="detailOrders"><div class="empty-orders">No orders yet.</div></div>
                    <button type="button" class="btn-sm btn-add-order" style="width:100%;margin-top:4px;" id="detailAddOrderBtn" onclick="openAddOrder(currentDetailTable)">+ Add Order</button>
                </div>

                <!-- Vehicle -->
                <div>
                    <div class="detail-section-title">Vehicle</div>
                    <div class="vehicle-fields">
                        <div class="vfield"><label>Type</label><input id="vType" placeholder="e.g. Sedan" /></div>
                        <div class="vfield"><label>Brand</label><input id="vBrand" placeholder="e.g. Toyota" /></div>
                        <div class="vfield"><label>Color</label><input id="vColor" placeholder="e.g. White" /></div>
                        <div class="vfield"><label>Plate No.</label><input id="vPlate" placeholder="e.g. ABC 123" /></div>
                    </div>
                </div>

            </div>

            <!-- Total Bar -->
            <div class="total-bar">
                <div class="total-row">
                    <span class="total-label">Total:</span>
                    <span class="total-amount">₱<span id="detailTotal">0</span></span>
                </div>
                <div class="discount-toggle-row">
                    <span class="discount-toggle-label">Discount Applied</span>
                    <label class="toggle">
                        <input type="checkbox" id="detailDiscountToggle" onchange="toggleDetailDiscount()" />
                        <span class="toggle-slider"></span>
                    </label>
                </div>
                <button type="button" class="btn-bill-out-full" id="detailBillOutBtn" onclick="openBillOut(currentDetailTable)">BILL OUT</button>
            </div>
        </div>

    </div>

    <!-- Hidden server-side fields & buttons -->
    <asp:HiddenField ID="hdnAction"       runat="server" />
    <asp:HiddenField ID="hdnTableID"      runat="server" />
    <asp:HiddenField ID="hdnReservID"     runat="server" />
    <asp:Button ID="btnServerAction" runat="server" style="display:none" OnClick="BtnServerAction_Click" />

</form>

<script>
// ═══════════════════════════════════════════════════════════════
//  CUE TRACK · CASHIER DASHBOARD
// ═══════════════════════════════════════════════════════════════

var RATE_NORMAL   = 350;
var RATE_DISCOUNT = 300;

// ── TABLE STATE ──────────────────────────────────────────────
// status: 'available' | 'inuse' | 'reserved'
var tables = [
    { id:1, status:'inuse',    guest:'Juan Dela Cruz', rental:'Open Time',    discount:false, elapsed:7566, orders:[{name:'Cheeze Burger',qty:1,price:120},{name:'Tapsilog',qty:2,price:180},{name:'Coke Zero',qty:2,price:80}] },
    { id:2, status:'reserved', guest:'Juan Dela Cruz', rental:'Rental Time',  discount:false, elapsed:0,    orders:[] },
    { id:3, status:'available',guest:'',               rental:'',             discount:false, elapsed:0,    orders:[] },
    { id:4, status:'inuse',    guest:'Carter Carig',   rental:'Open Time',    discount:false, elapsed:7566, orders:[] },
    { id:5, status:'inuse',    guest:'Carlo Millo',    rental:'Fix Timed',    discount:false, elapsed:7566, orders:[] },
    { id:6, status:'inuse',    guest:'John Dart',      rental:'Open Time',    discount:false, elapsed:7566, orders:[] },
    { id:7, status:'reserved', guest:'Juan Dela Cruz', rental:'Fix Timed',    discount:false, elapsed:3600, orders:[] },
];

var parking = [
    { slot:'P1', plate:'ABC 123', type:'Sedan',   occupied:true  },
    { slot:'P2', plate:'',        type:'',         occupied:false },
    { slot:'P3', plate:'XYZ 789', type:'SUV',      occupied:true  },
    { slot:'P4', plate:'',        type:'',         occupied:false },
    { slot:'P5', plate:'DEF 456', type:'Hatchback',occupied:true  },
    { slot:'P6', plate:'',        type:'',         occupied:false },
    { slot:'P7', plate:'',        type:'',         occupied:false },
    { slot:'P8', plate:'GHI 321', type:'Van',      occupied:true  },
];

var billingHistory = [];
var totalRevenue = 0, sessionCount = 0;
var currentDetailTable = 1;
var selectedAddTimeHours = 1;
var addTimeTargetTable = null;
var cart = {};

// ── MENU DATA ────────────────────────────────────────────────
var MENU = {
    'Food': [
        {name:'Cheeze Burger', price:120}, {name:'Tapsilog', price:90},
        {name:'Hotdog Sandwich', price:60}, {name:'Fried Rice', price:55},
        {name:'Fries', price:70}, {name:'Nachos', price:85},
    ],
    'Drinks': [
        {name:'Coke Regular', price:40}, {name:'Coke Zero', price:40},
        {name:'Bottled Water', price:25}, {name:'Red Bull', price:110},
        {name:'Iced Coffee', price:80}, {name:'Juice', price:50},
    ],
    'Snacks': [
        {name:'Chips (BBQ)', price:45}, {name:'Pretzels', price:35},
        {name:'Peanuts', price:30}, {name:'Popcorn', price:40},
    ],
};

// ═══ CLOCK ═══════════════════════════════════════════════════
function updateClock() {
    var now = new Date();
    var h = now.getHours(), m = now.getMinutes();
    var ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12 || 12;
    document.getElementById('clockBadge').textContent =
        h + ':' + (m < 10 ? '0' : '') + m + ' ' + ampm;
}
setInterval(updateClock, 1000);
updateClock();

// ═══ TIMERS ══════════════════════════════════════════════════
setInterval(function() {
    tables.forEach(function(t) {
        if (t.status === 'inuse') t.elapsed++;
    });
    renderGrid();
    updateDetailPanel();
    updateBillingStats();
}, 1000);

function formatElapsed(sec) {
    var h = Math.floor(sec / 3600);
    var m = Math.floor((sec % 3600) / 60);
    var s = sec % 60;
    return pad(h) + ':' + pad(m) + ':' + pad(s);
}
function pad(n) { return n < 10 ? '0' + n : '' + n; }

// ═══ TABLE GRID ══════════════════════════════════════════════
function renderGrid() {
    var grid = document.getElementById('tablesGrid');
    if (!grid) return;
    grid.innerHTML = '';

    tables.forEach(function(t) {
        var pill, pillCls;
        if (t.status === 'inuse') { pill = 'In Use'; pillCls = 'pill-inuse'; }
        else if (t.status === 'reserved') { pill = 'Reserve'; pillCls = 'pill-reserve'; }
        else { pill = 'Available'; pillCls = 'pill-avail'; }

        var timer = t.status === 'inuse' ? formatElapsed(t.elapsed) : (t.status === 'reserved' ? '00:00:00' : '—');
        var timerCls = t.status !== 'inuse' ? ' stopped' : '';

        var rateStr = '';
        if (t.status === 'inuse' || t.status === 'reserved') {
            var rate = t.discount ? RATE_DISCOUNT : RATE_NORMAL;
            rateStr = t.rental + ' ' + rate + '/hr';
        }

        var card = document.createElement('div');
        card.className = 'table-card' + (t.id === currentDetailTable ? ' active-card' : '');
        card.innerHTML =
            '<div class="table-card-header">'
            + '<span class="table-name">Table ' + t.id + '</span>'
            + '<span class="status-pill ' + pillCls + '">' + pill + '</span>'
            + '</div>'
            + '<div class="table-timer' + timerCls + '">' + timer + '</div>'
            + '<div class="table-guest">' + (t.guest || '—') + '</div>'
            + '<div class="table-rate">' + (rateStr || '&mdash;') + '</div>'
            + '<div class="table-card-footer">' + cardButtons(t) + '</div>';

        card.addEventListener('click', function(e) {
            if (!e.target.closest('.btn-sm')) selectTable(t.id);
        });
        grid.appendChild(card);
    });
}

function cardButtons(t) {
    if (t.status === 'available') {
        return '<button class="btn-sm btn-start" onclick="openStartSession(' + t.id + ')">▶ START</button>';
    }
    var html = '<button class="btn-sm btn-bill-out" onclick="openBillOut(' + t.id + ')">Bill Out</button>';
    html += '<button class="btn-sm btn-add-order" onclick="openAddOrder(' + t.id + ')">Add Order</button>';
    if (t.status === 'inuse' && t.rental !== 'Open Time') {
        html += '<button class="btn-sm btn-add-time" onclick="openAddTime(' + t.id + ')">+Time</button>';
    }
    return html;
}

// ═══ SELECT TABLE → DETAIL ═══════════════════════════════════
function selectTable(id) {
    currentDetailTable = id;
    renderGrid();
    updateDetailPanel();
}

function updateDetailPanel() {
    var t = tables.find(function(x) { return x.id === currentDetailTable; });
    if (!t) return;

    document.getElementById('detailTitle').textContent = 'Table ' + t.id;
    document.getElementById('detailSub').textContent =
        t.status === 'inuse' ? 'Active Session · ' + t.rental :
        t.status === 'reserved' ? 'Upcoming Reservation' : 'Available';

    document.getElementById('dTime').textContent    = t.status === 'inuse' ? formatElapsed(t.elapsed) : '—';
    document.getElementById('dName').textContent    = t.guest    || '—';
    document.getElementById('dRental').textContent  = t.rental   || '—';
    document.getElementById('dDiscount').textContent = t.discount ? 'Student / PWD / Senior' : 'N/A';
    document.getElementById('detailDiscountToggle').checked = t.discount;

    // Orders
    var ordersEl = document.getElementById('detailOrders');
    if (!t.orders || t.orders.length === 0) {
        ordersEl.innerHTML = '<div class="empty-orders">No orders yet.</div>';
    } else {
        ordersEl.innerHTML = t.orders.map(function(o) {
            return '<div class="order-item">'
                + '<div><div class="order-item-name">' + o.name + '</div>'
                + '<div class="order-item-qty">x' + o.qty + '</div></div>'
                + '<div class="order-item-price">₱' + (o.price * o.qty) + '</div>'
                + '</div>';
        }).join('');
    }

    // Total
    document.getElementById('detailTotal').textContent = calcTotal(t);
}

function calcTotal(t) {
    if (t.status !== 'inuse') return 0;
    var rate = t.discount ? RATE_DISCOUNT : RATE_NORMAL;
    var hours = t.elapsed / 3600;
    var tableCharge = Math.ceil(hours * rate * 10) / 10;
    var foodTotal = (t.orders || []).reduce(function(sum, o) { return sum + o.price * o.qty; }, 0);
    return (tableCharge + foodTotal).toFixed(2);
}

// ═══ DISCOUNT TOGGLE ════════════════════════════════════════
function toggleDetailDiscount() {
    var t = tables.find(function(x) { return x.id === currentDetailTable; });
    if (t) {
        t.discount = document.getElementById('detailDiscountToggle').checked;
        updateDetailPanel();
    }
}

// ═══ BILL OUT ════════════════════════════════════════════════
function openBillOut(id) {
    var t = tables.find(function(x) { return x.id === id; });
    if (!t) return;
    currentDetailTable = id;
    document.getElementById('billOutSub').textContent = 'Table ' + id + ' · Final Billing';

    var rate = t.discount ? RATE_DISCOUNT : RATE_NORMAL;
    var hrs  = (t.elapsed / 3600).toFixed(2);
    var tableCharge = (parseFloat(hrs) * rate).toFixed(2);
    var foodTotal   = (t.orders || []).reduce(function(sum, o) { return sum + o.price * o.qty; }, 0);
    var grandTotal  = (parseFloat(tableCharge) + foodTotal).toFixed(2);

    var rows = '<div class="bill-row"><span class="bill-key">Table Charge (' + hrs + ' hrs × ₱' + rate + ')</span><span class="bill-val">₱' + tableCharge + '</span></div>';
    if (t.orders && t.orders.length) {
        t.orders.forEach(function(o) {
            rows += '<div class="bill-row"><span class="bill-key">' + o.name + ' x' + o.qty + '</span><span class="bill-val">₱' + (o.price * o.qty) + '</span></div>';
        });
    }
    rows += '<div class="bill-row"><span class="bill-key">Discount</span><span class="bill-val">' + (t.discount ? 'Yes (₱50 off/hr)' : 'None') + '</span></div>';

    document.getElementById('billOutBreakdown').innerHTML = rows;
    document.getElementById('billOutTotal').textContent = grandTotal;
    openModal('billOutModal');
}

function confirmBillOut() {
    var t = tables.find(function(x) { return x.id === currentDetailTable; });
    if (!t) return;
    var total = parseFloat(calcTotal(t));

    // log history
    var now = new Date();
    billingHistory.unshift({
        table: t.id,
        guest: t.guest,
        duration: formatElapsed(t.elapsed),
        amount: total.toFixed(2),
        time: now.getHours() + ':' + pad(now.getMinutes()),
    });
    totalRevenue += total;
    sessionCount++;

    // reset table
    t.status = 'available';
    t.guest = ''; t.rental = ''; t.elapsed = 0; t.orders = []; t.discount = false;

    closeModal('billOutModal');
    renderGrid();
    updateDetailPanel();
    updateBillingStats();
    renderBillingHistory();
}

// ═══ ADD ORDER ═══════════════════════════════════════════════
function openAddOrder(id) {
    currentDetailTable = id;
    cart = {};
    document.getElementById('addOrderSub').textContent = 'Table ' + id;
    renderMenuList('');
    renderCart();
    openModal('addOrderModal');
}

function renderMenuList(filter) {
    var html = '';
    Object.keys(MENU).forEach(function(cat) {
        var items = MENU[cat].filter(function(m) {
            return !filter || m.name.toLowerCase().includes(filter.toLowerCase());
        });
        if (!items.length) return;
        html += '<div class="menu-category">' + cat + '</div><div class="menu-grid">';
        items.forEach(function(m) {
            html += '<div class="menu-item" onclick="addToCart(\'' + m.name.replace(/'/g, "\\'") + '\',' + m.price + ')">'
                + '<span class="menu-item-name">' + m.name + '</span>'
                + '<span class="menu-item-price">₱' + m.price + '</span>'
                + '</div>';
        });
        html += '</div>';
    });
    document.getElementById('menuList').innerHTML = html;
}

function filterMenu(v) { renderMenuList(v); }

function addToCart(name, price) {
    if (!cart[name]) cart[name] = { price: price, qty: 0 };
    cart[name].qty++;
    renderCart();
}

function renderCart() {
    var keys = Object.keys(cart).filter(function(k) { return cart[k].qty > 0; });
    var cartSec = document.getElementById('cartSection');
    if (!keys.length) { cartSec.style.display = 'none'; return; }
    cartSec.style.display = 'block';
    var total = 0;
    var html = keys.map(function(k) {
        var item = cart[k];
        total += item.price * item.qty;
        return '<div class="cart-item">'
            + '<span>' + k + '</span>'
            + '<div class="cart-item-controls">'
            + '<div class="qty-btn" onclick="changeQty(\'' + k.replace(/'/g,"\\'") + '\',-1)">−</div>'
            + '<span class="qty-val">' + item.qty + '</span>'
            + '<div class="qty-btn" onclick="changeQty(\'' + k.replace(/'/g,"\\'") + '\',1)">+</div>'
            + '</div>'
            + '<span style="font-weight:700;color:var(--orange);">₱' + (item.price * item.qty) + '</span>'
            + '</div>';
    }).join('');
    document.getElementById('cartList').innerHTML = html;
    document.getElementById('cartTotal').textContent = total;
}

function changeQty(name, delta) {
    if (!cart[name]) return;
    cart[name].qty += delta;
    if (cart[name].qty <= 0) delete cart[name];
    renderCart();
}

function confirmAddOrder() {
    var t = tables.find(function(x) { return x.id === currentDetailTable; });
    if (!t) return;
    Object.keys(cart).forEach(function(k) {
        var existing = t.orders.find(function(o) { return o.name === k; });
        if (existing) existing.qty += cart[k].qty;
        else t.orders.push({ name: k, price: cart[k].price, qty: cart[k].qty });
    });
    cart = {};
    closeModal('addOrderModal');
    updateDetailPanel();
}

// ═══ ADD TIME ════════════════════════════════════════════════
function openAddTime(id) {
    addTimeTargetTable = id;
    document.getElementById('addTimeSub').textContent = 'Table ' + id;
    selectedAddTimeHours = 1;
    document.querySelectorAll('.time-opt').forEach(function(el, i) {
        el.classList.toggle('selected', i === 0);
    });
    openModal('addTimeModal');
}

function selectTimeOpt(el, h) {
    selectedAddTimeHours = h;
    document.querySelectorAll('.time-opt').forEach(function(x) { x.classList.remove('selected'); });
    el.classList.add('selected');
}

function confirmAddTime() {
    var t = tables.find(function(x) { return x.id === addTimeTargetTable; });
    if (t) t.elapsed += selectedAddTimeHours * 3600;
    closeModal('addTimeModal');
    updateDetailPanel();
}

// ═══ START SESSION ═══════════════════════════════════════════
function openStartSession(id) {
    currentDetailTable = id;
    document.getElementById('startModalSub').textContent = 'Table ' + id;
    document.getElementById('startGuestName').value = '';
    document.getElementById('startRentalType').value = 'Rental Time';
    document.getElementById('startHoursField').style.display = 'flex';
    openModal('startModal');
}

document.addEventListener('DOMContentLoaded', function() {
    var rentalSel = document.getElementById('startRentalType');
    if (rentalSel) rentalSel.addEventListener('change', function() {
        document.getElementById('startHoursField').style.display =
            this.value === 'Rental Time' ? 'flex' : 'none';
    });
});

function confirmStartSession() {
    var guestName = document.getElementById('startGuestName').value.trim();
    if (!guestName) { alert('Please enter a guest name.'); return; }
    var rental   = document.getElementById('startRentalType').value;
    var discount = document.getElementById('startDiscount').value !== 'none';
    var t = tables.find(function(x) { return x.id === currentDetailTable; });
    if (t) {
        t.status = 'inuse'; t.guest = guestName;
        t.rental = rental; t.discount = discount; t.elapsed = 0; t.orders = [];
    }
    closeModal('startModal');
    selectTable(currentDetailTable);
}

// ═══ BILLING STATS ═══════════════════════════════════════════
function updateBillingStats() {
    var active = tables.filter(function(t) { return t.status === 'inuse'; }).length;
    document.getElementById('statRevenue').textContent = totalRevenue.toFixed(0);
    document.getElementById('statActive').textContent  = active;
    document.getElementById('statSessions').textContent = sessionCount;
}

function renderBillingHistory() {
    var tbody = document.getElementById('billingHistory');
    if (!tbody) return;
    tbody.innerHTML = billingHistory.map(function(r) {
        return '<tr>'
            + '<td>Table ' + r.table + '</td>'
            + '<td>' + r.guest + '</td>'
            + '<td>' + r.duration + '</td>'
            + '<td style="color:var(--orange);font-weight:700;">₱' + r.amount + '</td>'
            + '<td>' + r.time + '</td>'
            + '</tr>';
    }).join('');
}

// ═══ PARKING ═════════════════════════════════════════════════
function renderParking() {
    var grid = document.getElementById('parkingGrid');
    if (!grid) return;
    grid.innerHTML = parking.map(function(p) {
        return '<div class="parking-slot' + (p.occupied ? ' occupied' : '') + '" onclick="toggleParking(\'' + p.slot + '\')">'
            + '<div class="parking-icon">' + (p.occupied ? '🚗' : '🅿️') + '</div>'
            + '<div class="parking-label">' + p.slot + '</div>'
            + '<div class="parking-plate">' + (p.occupied ? p.plate + ' · ' + p.type : 'Open') + '</div>'
            + '</div>';
    }).join('');
}

function toggleParking(slot) {
    var p = parking.find(function(x) { return x.slot === slot; });
    if (!p) return;
    if (p.occupied) {
        if (confirm('Mark ' + slot + ' as vacant?')) { p.occupied = false; p.plate = ''; p.type = ''; }
    } else {
        var plate = prompt('Enter plate number:');
        if (plate) { p.occupied = true; p.plate = plate.toUpperCase(); p.type = 'Vehicle'; }
    }
    renderParking();
}

// ═══ ALL ORDERS TAB ══════════════════════════════════════════
function renderAllOrders() {
    var el = document.getElementById('allOrdersList');
    if (!el) return;
    var active = tables.filter(function(t) { return t.status === 'inuse' && t.orders.length; });
    if (!active.length) { el.innerHTML = '<div class="empty-orders" style="padding:30px;">No active orders.</div>'; return; }
    el.innerHTML = active.map(function(t) {
        return '<div style="margin-bottom:14px;">'
            + '<div class="detail-section-title" style="margin-bottom:6px;">Table ' + t.id + ' — ' + t.guest + '</div>'
            + t.orders.map(function(o) {
                return '<div class="order-item">'
                    + '<div><div class="order-item-name">' + o.name + '</div>'
                    + '<div class="order-item-qty">x' + o.qty + '</div></div>'
                    + '<div class="order-item-price">₱' + (o.price * o.qty) + '</div>'
                    + '</div>';
            }).join('')
            + '</div>';
    }).join('');
}

// ═══ TABS ════════════════════════════════════════════════════
var activeTab = 'table';
function switchTab(name) {
    activeTab = name;
    document.querySelectorAll('.tab').forEach(function(el, i) {
        el.classList.toggle('active', ['table','orders','billing','reservation','parking'][i] === name);
    });
    document.querySelectorAll('.tab-panel').forEach(function(el) { el.classList.remove('active'); });
    var panel = document.getElementById('panel-' + name);
    if (panel) panel.classList.add('active');

    if (name === 'parking') renderParking();
    if (name === 'orders')  renderAllOrders();
    if (name === 'billing') { updateBillingStats(); renderBillingHistory(); }
}

// ═══ MODALS ══════════════════════════════════════════════════
function openModal(id) { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
function openLogoutModal() { openModal('logoutModal'); }

// ═══ STAFF DROPDOWN ══════════════════════════════════════════
function toggleStaffDrop() {
    document.getElementById('staffChip').classList.toggle('open');
}
document.addEventListener('click', function(e) {
    var chip = document.getElementById('staffChip');
    if (chip && !chip.contains(e.target)) chip.classList.remove('open');
});

// Close modals clicking outside
['addOrderModal','addTimeModal','billOutModal','startModal','logoutModal'].forEach(function(id) {
    var el = document.getElementById(id);
    if (el) el.addEventListener('click', function(e) {
        if (e.target === el) closeModal(id);
    });
});

// ═══ INIT ═════════════════════════════════════════════════════
document.addEventListener('DOMContentLoaded', function() {
    renderGrid();
    selectTable(1);
    updateBillingStats();
});
</script>
</body>
</html>
