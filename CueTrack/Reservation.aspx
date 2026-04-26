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
        .user-chip {
            display: flex; align-items: center; gap: 8px;
            background: var(--orange); color: black;
            font-weight: 700; font-size: 13px;
            padding: 6px 14px; border-radius: 20px; cursor: pointer;
        }
        .hamburger { display: none; flex-direction: column; gap: 5px; cursor: pointer; padding: 4px; }
        .hamburger span { width: 24px; height: 3px; background: white; border-radius: 2px; }
        .mobile-menu {
            display: none; position: fixed; top: 0; right: 0;
            width: 220px; height: 100vh; background: var(--orange);
            z-index: 500; flex-direction: column;
            padding: 24px 28px; gap: 6px;
            transform: translateX(100%); transition: transform 0.3s ease;
        }
        .mobile-menu.open { transform: translateX(0); }
        .mobile-menu-close {
            font-size: 22px; color: black; font-weight: 900;
            cursor: pointer; margin-bottom: 16px; align-self: flex-start;
        }
        .mobile-menu a {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 700; color: black;
            text-decoration: none; padding: 8px 0;
            border-bottom: 1px solid rgba(0,0,0,0.15);
        }
        .mobile-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.5); z-index: 400;
        }

        /* ── TABLE INFO MODAL ── */
        .table-modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.85);
            z-index: 600;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .table-modal-overlay.open { display: flex; }

        .table-modal {
            background: #1a1a1a;
            border: 1px solid var(--border);
            border-radius: 16px;
            width: 100%;
            max-width: 480px;
            overflow: hidden;
            animation: modalPop 0.25s ease;
        }

        @keyframes modalPop {
            from { transform: scale(0.92); opacity: 0; }
            to   { transform: scale(1);    opacity: 1; }
        }

        .modal-header {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            padding: 18px 22px;
            display: flex; align-items: center; justify-content: space-between;
        }

        .modal-header-left { display: flex; align-items: center; gap: 14px; }

        .modal-table-svg {
    width: 80px;
    height: 60px;
    border-radius: 8px;
    overflow: hidden;
    flex-shrink: 0;
    border: 1px solid rgba(0,0,0,0.2);
}
        .modal-table-svg svg { width: 100%; height: 100%; display: block; }

        .modal-table-name {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 22px; font-weight: 800; letter-spacing: 1px;
            color: black; text-transform: uppercase;
        }

        .modal-table-model {
            font-size: 12px; color: rgba(0,0,0,0.7); font-weight: 600; margin-top: 2px;
        }

        .modal-close {
            width: 30px; height: 30px;
            background: rgba(0,0,0,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; font-size: 16px; color: black; font-weight: 900;
            transition: background 0.2s; flex-shrink: 0;
        }
        .modal-close:hover { background: rgba(0,0,0,0.4); }

        .modal-body { padding: 20px 22px; }

        .modal-specs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 16px;
        }

        .spec-item {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 12px 14px;
        }

        .spec-key {
            font-size: 10px; font-weight: 700;
            color: var(--orange); text-transform: uppercase;
            letter-spacing: 0.8px; margin-bottom: 4px;
        }

        .spec-val {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 15px; font-weight: 700; color: white;
        }

        .modal-status-row {
            display: flex; align-items: center; justify-content: space-between;
            background: rgba(255,255,255,0.03);
            border: 1px solid var(--border);
            border-radius: 10px; padding: 12px 16px;
            margin-bottom: 16px;
        }

        .modal-status-label {
            font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase;
        }

        .status-badge {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 800; letter-spacing: 1px;
            padding: 4px 12px; border-radius: 20px; text-transform: uppercase;
        }
        .status-available { background: rgba(39,174,96,0.15); color: #2ecc71; border: 1px solid #2ecc71; }
        .status-taken     { background: rgba(192,57,43,0.15); color: #e74c3c; border: 1px solid #e74c3c; }

        .modal-info-note {
            font-size: 11px; color: var(--muted);
            text-align: center; line-height: 1.5;
        }

        .modal-select-btn {
            width: 100%; margin-top: 14px;
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            color: black; border: none;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 800; letter-spacing: 2px;
            text-transform: uppercase; border-radius: 10px;
            padding: 12px; cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 20px rgba(255,140,0,0.3);
        }
        .modal-select-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,140,0,0.45); }
        .modal-select-btn:disabled { opacity: 0.4; cursor: not-allowed; transform: none; }

        /* Info icon on table card */
        .table-info-btn {
            position: absolute; top: 8px; right: 8px;
            width: 20px; height: 20px;
            background: rgba(255,140,0,0.15);
            border: 1px solid var(--orange);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 11px; font-weight: 900; color: var(--orange);
            cursor: pointer; z-index: 2;
            transition: all 0.2s;
        }
        .table-info-btn:hover { background: var(--orange); color: black; }

        /* ── LAYOUT ── */
        .page-wrapper {
            margin-top: 60px;
            display: grid;
            grid-template-columns: 1fr 300px;
            min-height: calc(100vh - 60px);
        }

        /* ── LEFT PANEL ── */
        .left-panel { padding: 28px 30px; overflow-y: auto; position: relative; }
        .left-panel::before {
            content: ''; position: absolute; inset: 0;
            background: url('Image/background.jpg') center/ no-repeat;
            opacity: 0.18; z-index: 0;
        }
        .left-panel > * { position: relative; z-index: 1; }

        .section-header { display: flex; align-items: center; gap: 14px; margin-bottom: 22px; }
        .section-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 26px; font-weight: 800; letter-spacing: 2px;
            color: white; text-transform: uppercase; white-space: nowrap;
        }
        .progress-track { flex: 1; height: 6px; background: var(--border); border-radius: 3px; overflow: hidden; }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--orange), var(--orange-hot));
            border-radius: 3px;
            box-shadow: 0 0 8px rgba(255,140,0,0.5);
            transition: width 0.4s ease;
        }

        /* ── STEPS ── */
        .step { display: none; }
        .step.active { display: block; }

        /* ── TABLE GRID ── */
        .table-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
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
        .pool-art { width: 100%; aspect-ratio: 4/3; border-radius: 8px; overflow: hidden; position: relative; }
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

        .legend { display: flex; gap: 16px; justify-content: center; margin-top: 18px; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 11px; color: var(--muted); }
        .legend-dot { width: 10px; height: 10px; border-radius: 2px; }
        .dot-available { background: #2ecc71; }
        .dot-reserved  { background: var(--reserved); }
        .dot-selected  { background: var(--orange); }

        /* ── TIME SLOT PICKER ── */
        .slot-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 700; letter-spacing: 0.5px;
            color: var(--orange); text-transform: uppercase; margin-bottom: 8px;
        }
        .slot-note { font-size: 11px; color: var(--muted); margin-bottom: 12px; }
        .slot-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-bottom: 6px; }
        .slot-btn {
            padding: 9px 4px;
            background: rgba(26,26,26,0.9);
            border: 1px solid #2ecc71;
            border-radius: 8px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 700;
            color: #2ecc71;
            cursor: pointer; transition: all 0.18s; text-align: center;
            position: relative;
        }
        .slot-btn:hover:not(.slot-taken) { background: rgba(46,204,113,0.12); transform: translateY(-1px); }
        .slot-btn.slot-selected {
            border-color: var(--orange); background: rgba(255,140,0,0.18);
            color: var(--orange); box-shadow: 0 0 0 2px rgba(255,140,0,0.25);
        }
        .slot-btn.slot-taken {
            background: rgba(192,57,43,0.18); border-color: #c0392b;
            color: #e74c3c; cursor: not-allowed; opacity: 1; overflow: hidden;
        }
        .slot-btn.slot-taken::after {
            content: ''; position: absolute;
            top: 50%; left: 0; right: 0; height: 2px;
            background: rgba(231,76,60,0.7); transform: rotate(-10deg);
        }
        .slot-btn.slot-taken::before {
            content: 'TAKEN'; position: absolute;
            bottom: 1px; right: 3px;
            font-size: 7px; font-weight: 900; letter-spacing: 0.5px;
            color: #e74c3c; opacity: 0.8;
        }
        .slot-legend { display: flex; gap: 14px; margin-top: 10px; margin-bottom: 20px; }
        .slot-legend-item { display: flex; align-items: center; gap: 6px; font-size: 11px; color: var(--muted); }
        .slot-dot { width: 10px; height: 10px; border-radius: 2px; }
        .slot-dot-avail    { background: #2ecc71; }
        .slot-dot-taken    { background: #e74c3c; }
        .slot-dot-selected { background: var(--orange); }

        /* ── STEP 2: RENTAL ── */
        .sub-label {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 700; letter-spacing: 1px;
            color: white; text-transform: uppercase; margin-bottom: 14px;
        }
        .rental-options { display: flex; gap: 14px; margin-bottom: 28px; }
        .rental-btn {
            flex: 1; padding: 22px 10px;
            background: rgba(26,26,26,0.9); border: 2px solid var(--border);
            border-radius: 12px;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px; font-weight: 800; letter-spacing: 1px;
            color: var(--orange); text-transform: uppercase;
            cursor: pointer; transition: all 0.2s; text-align: center;
        }
        .rental-btn:hover, .rental-btn.selected {
            border-color: var(--orange); background: rgba(255,140,0,0.1);
            box-shadow: 0 0 0 2px rgba(255,140,0,0.2);
        }
        .discount-card {
            background: rgba(26,26,26,0.9); border: 2px solid var(--border);
            border-radius: 12px; padding: 16px 20px;
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 28px;
        }
        .discount-text h4 {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 700; color: var(--orange); text-transform: uppercase;
        }
        .discount-text p { font-size: 12px; color: var(--muted); margin-top: 3px; }
        .toggle { position: relative; width: 48px; height: 26px; cursor: pointer; }
        .toggle input { opacity: 0; width: 0; height: 0; }
        .toggle-slider {
            position: absolute; inset: 0;
            background: #333; border-radius: 13px; transition: background 0.3s;
        }
        .toggle-slider::before {
            content: ''; position: absolute;
            width: 20px; height: 20px; left: 3px; top: 3px;
            background: white; border-radius: 50%; transition: transform 0.3s;
        }
        .toggle input:checked + .toggle-slider { background: var(--orange); }
        .toggle input:checked + .toggle-slider::before { transform: translateX(22px); }

        /* ── STEP 3 ── */
        .booking-card {
            background: rgba(22,22,22,0.95); border: 1px solid var(--border);
            border-radius: 12px; padding: 22px 26px;
        }
        .booking-row {
            display: flex; align-items: baseline; padding: 8px 0;
            border-bottom: 1px dashed rgba(255,255,255,0.06); gap: 10px;
        }
        .booking-row:last-child { border-bottom: none; }
        .booking-key {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 13px; font-weight: 700; letter-spacing: 0.5px;
            color: var(--orange); min-width: 110px; text-transform: uppercase;
        }
        .booking-dots { flex: 1; border-bottom: 2px dotted rgba(255,140,0,0.3); margin-bottom: 3px; }
        .booking-val { font-size: 13px; font-weight: 600; color: white; }

        /* ── STEP 4: SUCCESS ── */
        .success-wrap {
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            min-height: 60vh; gap: 20px; text-align: center;
        }
        .success-check {
            width: 110px; height: 110px; background: var(--green);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-size: 54px; box-shadow: 0 0 40px rgba(39,174,96,0.4);
            animation: popIn 0.5s ease;
        }
        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            70%  { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }
        .success-title { font-family: 'Barlow Condensed', sans-serif; font-size: 26px; font-weight: 800; color: white; }
        .success-sub { font-size: 13px; color: var(--muted); max-width: 280px; }
        .success-summary {
            background: rgba(26,26,26,0.9); border: 1px solid var(--border);
            border-radius: 10px; padding: 14px 22px; font-size: 13px;
            display: flex; flex-direction: column; gap: 4px;
            text-align: left; width: 100%; max-width: 320px;
        }
        .success-summary span { color: var(--muted); }
        .success-summary strong { color: var(--orange); }

        /* ── RIGHT PANEL ── */
        .right-panel {
            background: var(--panel-bg); border-left: 1px solid var(--border);
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
            background: rgba(255,255,255,0.04); border: 1px solid var(--border);
            border-radius: 8px; padding: 9px 12px; color: white;
            font-family: 'Barlow', sans-serif; font-size: 14px;
            outline: none; transition: border-color 0.2s; width: 100%;
        }
        .field-input:focus { border-color: var(--orange); background: rgba(255,140,0,0.05); }
        .time-display {
            background: rgba(255,140,0,0.08); border: 1px solid var(--orange);
            border-radius: 8px; padding: 9px 12px;
            color: var(--orange); font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 700; text-align: center; min-height: 38px;
        }
        .panel-preview {
            border-radius: 12px; overflow: hidden; border: 2px solid var(--border);
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
            transition: all 0.2s; box-shadow: 0 4px 20px rgba(255,140,0,0.3);
        }
        .btn-orange:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,140,0,0.45); }
        .btn-outline {
            background: transparent; border: 2px solid var(--orange); color: var(--orange);
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 16px; font-weight: 800; letter-spacing: 2px;
            text-transform: uppercase; border-radius: 10px;
            padding: 11px; cursor: pointer; width: 100%;
            transition: all 0.2s; margin-top: 8px;
        }
        .btn-outline:hover { background: rgba(255,140,0,0.1); }

        /* ── RESPONSIVE ── */
        @media (max-width: 768px) {
            .navbar-nav { display: none; }
            .user-chip  { display: none; }
            .hamburger  { display: flex; }
            .mobile-menu { display: flex; }
            .page-wrapper { grid-template-columns: 1fr; grid-template-rows: auto auto; }
            .right-panel {
                display: flex; border-left: none;
                border-top: 1px solid var(--border);
                padding: 20px 16px; gap: 14px;
            }
            .panel-preview { display: none; }
            .table-grid { grid-template-columns: repeat(2, 1fr); }
            .slot-grid  { grid-template-columns: repeat(3, 1fr); }
            .slot-btn   { font-size: 11px; padding: 8px 2px; }
            .btn-orange, .btn-outline { font-size: 15px; }
            .section-title { font-size: 20px; }
            .left-panel { padding: 16px 14px; }
            .modal-specs { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 400px) {
            .table-grid { grid-template-columns: repeat(2, 1fr); }
            .slot-grid  { grid-template-columns: repeat(2, 1fr); }
            .slot-btn   { font-size: 10px; padding: 7px 2px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- TABLE INFO MODAL -->
    <div class="table-modal-overlay" id="tableModalOverlay" onclick="closeTableModal(event)">
        <div class="table-modal" id="tableModal">
            <div class="modal-header">
                <div class="modal-header-left">
                    <div class="modal-table-svg" id="modalTableSvg"></div>
                    <div>
                        <div class="modal-table-name" id="modalTableName">Table 1</div>
                        <div class="modal-table-model" id="modalTableModel">Wolf · Standard Premium</div>
                    </div>
                </div>
                <div class="modal-close" onclick="closeTableModal()">✕</div>
            </div>
            <div class="modal-body">
                <div class="modal-specs">
                    <div class="spec-item">
                        <div class="spec-key">Brand</div>
                        <div class="spec-val" id="modalBrand">Wolf</div>
                    </div>
                    <div class="spec-item">
                        <div class="spec-key">Series</div>
                        <div class="spec-val" id="modalSeries">Standard Premium</div>
                    </div>
                    <div class="spec-item">
                        <div class="spec-key">Size</div>
                        <div class="spec-val" id="modalSize">9ft</div>
                    </div>
                    <div class="spec-item">
                        <div class="spec-key">Slate</div>
                        <div class="spec-val" id="modalSlate">30mm</div>
                    </div>
                    <div class="spec-item">
                        <div class="spec-key">Frame</div>
                        <div class="spec-val" id="modalFrame">Aluminum + Steel</div>
                    </div>
                    <div class="spec-item">
                        <div class="spec-key">Play Level</div>
                        <div class="spec-val" id="modalPlay">Semi-pro</div>
                    </div>
                </div>
                <div class="modal-status-row">
                    <span class="modal-status-label">Current Status</span>
                    <span class="status-badge" id="modalStatusBadge">Available</span>
                </div>
                <p class="modal-info-note" id="modalNote">Click "Select This Table" to reserve this table.</p>
                <button class="modal-select-btn" id="modalSelectBtn" onclick="selectFromModal()">
                    ✓ SELECT THIS TABLE
                </button>
            </div>
        </div>
    </div>

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

    <div class="page-wrapper">

        <!-- ════ LEFT PANEL ════ -->
        <div class="left-panel">
            <div class="section-header">
                <div class="section-title">Reservation</div>
                <div class="progress-track">
                    <div class="progress-fill" id="progressFill" style="width:25%"></div>
                </div>
            </div>

            <!-- STEP 1 -->
            <div class="step active" id="step1">
                <div class="table-grid" id="tableGrid"></div>
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot dot-available"></div> Available</div>
                    <div class="legend-item"><div class="legend-dot dot-selected"></div> Selected</div>
                    <div class="legend-item"><div class="legend-dot dot-reserved"></div> All slots taken</div>
                </div>
                <br/>
                <button type="button" class="btn-orange" onclick="goStep(2)">CONTINUE</button>
            </div>

            <!-- STEP 2 -->
            <div class="step" id="step2">
                <div class="sub-label">Rental Type</div>
                <div class="rental-options">
                    <div class="rental-btn selected" id="rentalRental" onclick="selectRental('Rental Time')">Rental<br/>Time</div>
                    <div class="rental-btn"           id="rentalOpen"   onclick="selectRental('Open Time')">Open<br/>Time</div>
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

            <!-- STEP 3 -->
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

            <!-- STEP 4 -->
            <div class="step" id="step4">
                <div class="success-wrap">
                    <div class="success-check">✓</div>
                    <div class="success-title">You're all set!</div>
                    <p class="success-sub">Your reservation is confirmed — we're looking forward to seeing you soon.</p>
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
                <label class="field-label">Date</label>
                <asp:TextBox ID="txtDate" runat="server" CssClass="field-input" TextMode="Date" />
            </div>

            <div class="field-group">
                <label class="field-label">Selected Time</label>
                <div class="time-display" id="timeDisplay">— pick a slot —</div>
            </div>

            <div class="field-group">
                <div class="slot-label">Available Time Slots</div>
                <div class="slot-note">Open: 3:00 PM – 5:00 AM · Tap to select</div>
                <div class="slot-grid" id="slotGrid"></div>
                <div class="slot-legend">
                    <div class="slot-legend-item"><div class="slot-dot slot-dot-avail"></div> Available</div>
                    <div class="slot-legend-item"><div class="slot-dot slot-dot-taken"></div> Taken</div>
                    <div class="slot-legend-item"><div class="slot-dot slot-dot-selected"></div> Selected</div>
                </div>
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

            <!-- NO button here — buttons are only in left panel steps -->
        </div>
    </div>

    <!-- Hidden fields -->
    <asp:HiddenField ID="hdnTableID"   runat="server" Value="1" />
    <asp:HiddenField ID="hdnTime"      runat="server" />
    <asp:HiddenField ID="hdnDate"      runat="server" />
    <asp:HiddenField ID="hdnRental"    runat="server" />
    <asp:HiddenField ID="hdnGuests"    runat="server" />
    <asp:HiddenField ID="hdnGuestName" runat="server" />
    <asp:HiddenField ID="hdnContact"   runat="server" />
    <asp:HiddenField ID="hdnDiscount"  runat="server" />
    <asp:HiddenField ID="hdnStep"      runat="server" Value="1" />

    <asp:Button ID="btnLoadSlots" runat="server" style="display:none" OnClick="BtnLoadSlots_Click" />

</form>

<script>
    var TABLE_INFO = {
        1: { brand: 'Wolf', series: 'Standard Premium', size: '9ft', slate: '30mm', frame: 'Aluminum + Steel', play: 'Semi-pro', design: '"W" Modern', img: 'Image/table1.jpg' },
        2: { brand: 'Iron Man', series: 'MR-SUNG', size: '9ft', slate: '30mm', frame: 'Heavy-duty Metal', play: 'Pro', design: 'Industrial/Heavy', img: 'Image/ironman.jpg' },
        3: { brand: 'Hero', series: 'MR-SUNG', size: '8ft', slate: '30mm', frame: 'Hybrid', play: 'Semi-pro', design: 'Modern Premium', img: 'Image/table3.jpg' },
        4: { brand: 'Acurra', series: 'MR-SUNG', size: '9ft', slate: '30mm', frame: 'Hybrid', play: 'Semi-pro to Pro', design: 'Clean Minimalist', img: 'Image/table4.jpg' },
        5: { brand: 'Wolf', series: 'Standard Premium', size: '8ft', slate: '30mm', frame: 'Aluminum + Steel', play: 'Semi-pro', design: '"W" Modern', img: 'Image/table5.jpg' },
        6: { brand: 'Iron Man', series: 'MR-SUNG', size: '9ft', slate: '30mm', frame: 'Heavy-duty Metal', play: 'Pro', design: 'Industrial/Heavy', img: 'Image/ironman.jpg' },
        7: { brand: 'Hero', series: 'MR-SUNG', size: '7ft', slate: '30mm', frame: 'Hybrid', play: 'Semi-pro', design: 'Modern Premium', img: 'Image/table7.jpg' },
    };

    var tables = [
        { id: 1 }, { id: 2 }, { id: 3 }, { id: 4 },
        { id: 5 }, { id: 6 }, { id: 7 }
    ];

    var ALL_SLOTS = [
        '3:00 PM', '4:00 PM', '5:00 PM', '6:00 PM',
        '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM',
        '11:00 PM', '12:00 AM', '1:00 AM', '2:00 AM',
        '3:00 AM', '4:00 AM', '5:00 AM'
    ];

    var takenSlots = [];
    var selectedSlot = '';
    var selectedTable = parseInt((document.getElementById('hdnTableID') || {}).value) || 1;
    var selectedRental = 'Rental Time';
    var currentStep = 1;
    var modalTableID = null;   // which table the modal is showing

    // Server init
    if (typeof serverReservedTables !== 'undefined') {
        serverReservedTables.forEach(function (id) {
            var t = tables.find(function (x) { return x.id === id; });
            if (t) t.fullyReserved = true;
        });
    }

    // ── POOL TABLE SVG ─────────────────────────────────────────
    function poolSVG(small) {
        var w = small ? 130 : 240, h = small ? 98 : 180;
        var r = small ? 5 : 9, bR = small ? 4.5 : 7.5, pR = small ? 3.5 : 6;
        return '<svg viewBox="0 0 ' + w + ' ' + h + '" xmlns="http://www.w3.org/2000/svg">'
            + '<rect x="0" y="0" width="' + w + '" height="' + h + '" rx="' + r + '" fill="#4E342E"/>'
            + '<rect x="' + (w * .08) + '" y="' + (h * .10) + '" width="' + (w * .84) + '" height="' + (h * .80) + '" rx="' + (r * .55) + '" fill="#1565C0"/>'
            + '<rect x="' + (w * .08) + '" y="' + (h * .10) + '" width="' + (w * .84) + '" height="' + (h * .37) + '" rx="' + (r * .55) + '" fill="rgba(255,255,255,0.04)"/>'
            + '<line x1="' + (w / 2) + '" y1="' + (h * .12) + '" x2="' + (w / 2) + '" y2="' + (h * .88) + '" stroke="rgba(255,255,255,0.1)" stroke-width="1.2"/>'
            + '<circle cx="' + (w / 2) + '" cy="' + (h / 2) + '" r="' + (w * .07) + '" fill="none" stroke="rgba(255,255,255,0.13)" stroke-width="1.2"/>'
            + '<circle cx="' + (w * .10) + '" cy="' + (h * .14) + '" r="' + pR + '" fill="#111"/>'
            + '<circle cx="' + (w * .90) + '" cy="' + (h * .14) + '" r="' + pR + '" fill="#111"/>'
            + '<circle cx="' + (w * .10) + '" cy="' + (h * .86) + '" r="' + pR + '" fill="#111"/>'
            + '<circle cx="' + (w * .90) + '" cy="' + (h * .86) + '" r="' + pR + '" fill="#111"/>'
            + '<circle cx="' + (w / 2) + '" cy="' + (h * .11) + '" r="' + (pR * .8) + '" fill="#111"/>'
            + '<circle cx="' + (w / 2) + '" cy="' + (h * .89) + '" r="' + (pR * .8) + '" fill="#111"/>'
            + '<circle cx="' + (w * .34) + '" cy="' + (h * .50) + '" r="' + bR + '" fill="white" opacity=".9"/>'
            + '<circle cx="' + (w * .61) + '" cy="' + (h * .41) + '" r="' + (bR * .8) + '" fill="#e74c3c" opacity=".85"/>'
            + '<circle cx="' + (w * .67) + '" cy="' + (h * .56) + '" r="' + (bR * .8) + '" fill="#f39c12" opacity=".85"/>'
            + '<circle cx="' + (w * .55) + '" cy="' + (h * .61) + '" r="' + (bR * .8) + '" fill="#2ecc71" opacity=".85"/>'
            + '</svg>';
    }

    // ── TABLE GRID ─────────────────────────────────────────────
    function renderGrid() {
        var grid = document.getElementById('tableGrid');
        grid.innerHTML = '';
        tables.forEach(function (t) {
            var info = TABLE_INFO[t.id] || {};
            var cls = 'table-card';
            if (t.fullyReserved) cls += ' reserved';
            else if (t.id === selectedTable) cls += ' selected';

            var imgHTML = info.img
                ? '<img src="' + info.img + '" style="width:100%;height:100%;object-fit:cover;border-radius:8px;" '
                + 'onerror="this.style.display=\'none\';this.nextSibling.style.display=\'block\'" />'
                + '<div style="display:none;width:100%;height:100%;">' + poolSVG(true) + '</div>'
                : poolSVG(true);

            var card = document.createElement('div');
            card.className = cls;
            card.innerHTML =
                '<div class="table-info-btn" title="View table details">i</div>'
                + '<div class="table-label">Table ' + t.id
                + (info.brand ? ' <span style="color:var(--muted);font-weight:400;text-transform:none;font-size:10px;">— ' + info.brand + '</span>' : '')
                + '</div>'
                + '<div class="pool-art">' + imgHTML
                + (t.fullyReserved ? '<div class="reserved-badge">Reserved</div>' : '')
                + '</div>';

            card.querySelector('.table-info-btn').addEventListener('click', function (e) {
                e.stopPropagation();
                openTableModal(t.id);
            });

            if (!t.fullyReserved) {
                card.addEventListener('click', function () { pickTable(t.id); });
            }

            grid.appendChild(card);
        });
    }

    // ── TABLE MODAL ────────────────────────────────────────────
    function openTableModal(id) {
        modalTableID = id;
        var info = TABLE_INFO[id] || {};
        var t = tables.find(function (x) { return x.id === id; });
        var isReserved = t && t.fullyReserved;

        document.getElementById('modalTableName').textContent = 'Table ' + id;
        document.getElementById('modalTableModel').textContent = (info.brand || '') + ' · ' + (info.series || '');
        document.getElementById('modalBrand').textContent = info.brand || '—';
        document.getElementById('modalSeries').textContent = info.series || '—';
        document.getElementById('modalSize').textContent = info.size || '—';
        document.getElementById('modalSlate').textContent = info.slate || '—';
        document.getElementById('modalFrame').textContent = info.frame || '—';
        document.getElementById('modalPlay').textContent = info.play || '—';

        // Real photo in modal header (falls back to SVG if image missing)
        var svgEl = document.getElementById('modalTableSvg');
        if (info.img) {
            svgEl.innerHTML = '<img src="' + info.img + '" '
                + 'style="width:100%;height:100%;object-fit:cover;border-radius:6px;" '
                + 'onerror="this.outerHTML=\'' + poolSVG(true).replace(/'/g, "\\'") + '\'"/>';
        } else {
            svgEl.innerHTML = poolSVG(true);
        }

        var badge = document.getElementById('modalStatusBadge');
        var btn = document.getElementById('modalSelectBtn');
        var note = document.getElementById('modalNote');

        if (isReserved) {
            badge.textContent = 'All Slots Taken';
            badge.className = 'status-badge status-taken';
            btn.disabled = true;
            note.textContent = 'This table is fully booked. Please choose another.';
        } else if (id === selectedTable) {
            badge.textContent = 'Currently Selected';
            badge.className = 'status-badge status-available';
            btn.disabled = false;
            btn.textContent = '✓ ALREADY SELECTED';
            note.textContent = 'This is your currently selected table.';
        } else {
            badge.textContent = 'Available';
            badge.className = 'status-badge status-available';
            btn.disabled = false;
            btn.textContent = '✓ SELECT THIS TABLE';
            note.textContent = 'Click below to select this table for your reservation.';
        }

        document.getElementById('tableModalOverlay').classList.add('open');
    }

    function selectFromModal() {
        if (modalTableID) {
            var t = tables.find(function (x) { return x.id === modalTableID; });
            if (t && !t.fullyReserved) {
                pickTable(modalTableID);
            }
        }
        document.getElementById('tableModalOverlay').classList.remove('open');
        modalTableID = null;
    }

    // ── PICK TABLE ─────────────────────────────────────────────
    function pickTable(id) {
        selectedTable = id;
        document.getElementById('hdnTableID').value = id;
        document.getElementById('panelTableNum').textContent = id;
        var t = tables.find(function (x) { return x.id === id; });
        updatePanelPreview(t);
        renderGrid();
        var date = valEl('txtDate');
        if (date) fetchSlots(id, date);

        // Auto-scroll to inputs on mobile
        if (window.innerWidth <= 768) {
            var panel = document.querySelector('.right-panel');
            if (panel) panel.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    function updatePanelPreview(t) {
        var preview = document.getElementById('panelPreview');
        var old = preview.querySelector('svg');
        if (old) old.remove();
        preview.insertAdjacentHTML('afterbegin', poolSVG(false));
        document.getElementById('panelReservedOverlay')
            .classList.toggle('show', t && t.fullyReserved);
    }

    // ── TIME SLOTS ─────────────────────────────────────────────
    function renderSlots() {
        var grid = document.getElementById('slotGrid');
        grid.innerHTML = '';
        ALL_SLOTS.forEach(function (slot) {
            var btn = document.createElement('div');
            var taken = takenSlots.indexOf(slot) !== -1;
            var sel = slot === selectedSlot && !taken;
            btn.className = 'slot-btn'
                + (taken ? ' slot-taken' : '')
                + (sel ? ' slot-selected' : '');
            if (taken) {
                btn.innerHTML =
                    '<span style="display:block;font-size:13px">' + slot + '</span>'
                    + '<span style="display:block;font-size:10px;margin-top:1px;color:#ff6b6b">Reserved</span>';
                btn.title = slot + ' is already reserved';
            } else {
                btn.textContent = slot;
                btn.title = slot + ' — Available';
                btn.addEventListener('click', function () { pickSlot(slot); });
            }
            grid.appendChild(btn);
        });
    }

    function pickSlot(slot) {
        selectedSlot = slot;
        document.getElementById('timeDisplay').textContent = slot;
        document.getElementById('hdnTime').value = slot;
        renderSlots();
    }

    function loadReservedSlots(slots) {
        takenSlots = slots;
        if (takenSlots.indexOf(selectedSlot) !== -1) {
            selectedSlot = '';
            document.getElementById('timeDisplay').textContent = '— pick a slot —';
            document.getElementById('hdnTime').value = '';
        }
        renderSlots();
    }

    function fetchSlots(tableID, date) {
        document.getElementById('hdnTableID').value = tableID;
        document.getElementById('hdnDate').value = date;
        document.getElementById('btnLoadSlots').click();
    }

    // ── RENTAL ─────────────────────────────────────────────────
    function selectRental(type) {
        selectedRental = type;
        document.getElementById('rentalRental').classList.toggle('selected', type === 'Rental Time');
        document.getElementById('rentalOpen').classList.toggle('selected', type === 'Open Time');
    }

    // ── STEP NAV ───────────────────────────────────────────────
    var PROGRESS = { 1: '25%', 2: '50%', 3: '75%', 4: '100%' };

    function goStep(n) {
        document.getElementById('hdnTableID').value = selectedTable;
        if (n > currentStep) {
            if (currentStep === 1 && !validateStep1()) return;
            if (currentStep === 2 && !validateStep2()) return;
        }
        if (n === 3) populateSummary();
        document.querySelectorAll('.step').forEach(function (s) { s.classList.remove('active'); });
        document.getElementById('step' + n).classList.add('active');
        document.getElementById('progressFill').style.width = PROGRESS[n];
        document.getElementById('hdnStep').value = n;
        currentStep = n;
    }

    function validateStep1() {
        if (!selectedSlot) { alert('Please select a time slot.'); return false; }
        if (!valEl('txtDate')) { alert('Please select a date.'); return false; }
        if (!valEl('txtGuestName')) { alert('Please enter a guest name.'); return false; }
        if (!valEl('txtContact')) { alert('Please enter a contact number.'); return false; }
        return true;
    }

    function validateStep2() {
        if (!selectedRental) { alert('Please select a rental type.'); return false; }
        return true;
    }

    function populateSummary() {
        var date = valEl('txtDate');
        var name = valEl('txtGuestName');
        var contact = valEl('txtContact');
        var guests = valEl('txtGuests') || '1';
        var discount = document.getElementById('discountToggle').checked;
        var baseRate = selectedRental === 'Rental Time' ? 300 : 500;
        var final = discount ? baseRate - 50 : baseRate;
        var rateLabel = selectedRental === 'Rental Time'
            ? '₱ ' + final + '/hr' + (discount ? ' (discounted)' : '')
            : '₱ ' + final + ' flat' + (discount ? ' (discounted)' : '');

        setText('summaryDate', date);
        setText('summaryTime', selectedSlot);
        setText('summaryTable', 'Table ' + selectedTable);
        setText('summaryRental', selectedRental);
        setText('summaryName', name);
        setText('summaryContact', contact);
        setText('summaryGuests', guests);
        setText('summaryRates', rateLabel);

        setHdn('hdnTime', selectedSlot);
        setHdn('hdnDate', date);
        setHdn('hdnRental', selectedRental);
        setHdn('hdnGuests', guests);
        setHdn('hdnGuestName', name);
        setHdn('hdnContact', contact);
        setHdn('hdnDiscount', discount ? '1' : '0');
    }

    function prepareConfirm() { populateSummary(); return true; }

    function showSuccess() {
        var date = getHdn('hdnDate');
        var time = getHdn('hdnTime');
        var tbl = getHdn('hdnTableID');
        var name = getHdn('hdnGuestName');
        document.getElementById('successSummary').innerHTML =
            '<div><span>Name: </span><strong>' + name + '</strong>'
            + ' &nbsp; <span>Table: </span><strong>' + tbl + '</strong></div>'
            + '<div><span>Date: </span><strong>' + date + '</strong></div>'
            + '<div><span>Time: </span><strong>' + time + '</strong></div>';
        goStep(4);
    }

    function resetReservation() {
        selectedTable = 1; selectedRental = 'Rental Time';
        selectedSlot = ''; takenSlots = [];
        ['txtDate', 'txtGuestName', 'txtContact', 'txtGuests'].forEach(function (id) {
            var el = document.querySelector('[id$="' + id + '"]');
            if (el) el.value = '';
        });
        document.getElementById('discountToggle').checked = false;
        document.getElementById('timeDisplay').textContent = '— pick a slot —';
        renderGrid(); renderSlots();
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
    function valEl(id) {
        var el = document.querySelector('[id$="' + id + '"]');
        return el ? el.value.trim() : '';
    }
    function setText(id, text) { var el = document.getElementById(id); if (el) el.textContent = text; }
    function setHdn(id, value) { var el = document.getElementById(id); if (el) el.value = value; }
    function getHdn(id) { var el = document.getElementById(id); return el ? el.value : ''; }

    // ── INIT ───────────────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', function () {
        // Restore state from hidden fields (survives postback)
        var hdnTable = document.getElementById('hdnTableID');
        var hdnTime = document.getElementById('hdnTime');
        var hdnStepEl = document.getElementById('hdnStep');
        var hdnRentalEl = document.getElementById('hdnRental');
        var hdnDiscountEl = document.getElementById('hdnDiscount');

        if (hdnTable && hdnTable.value) selectedTable = parseInt(hdnTable.value) || 1;
        if (hdnTime && hdnTime.value) { selectedSlot = hdnTime.value; var td = document.getElementById('timeDisplay'); if (td) td.textContent = selectedSlot; }
        if (hdnRentalEl && hdnRentalEl.value) { selectedRental = hdnRentalEl.value; selectRental(selectedRental); }
        if (hdnDiscountEl) { var tog = document.getElementById('discountToggle'); if (tog) tog.checked = hdnDiscountEl.value === '1'; }

        // Server init slots
        if (typeof serverInitSlots !== 'undefined') takenSlots = serverInitSlots;

        renderGrid();
        renderSlots();
        var t = tables.find(function (x) { return x.id === selectedTable; });
        updatePanelPreview(t || tables[0]);
        document.getElementById('panelTableNum').textContent = selectedTable;

        // Date min + change listener
        var d = document.querySelector('[id$="txtDate"]');
        if (d) {
            d.min = new Date().toISOString().split('T')[0];
            d.addEventListener('change', function () { if (this.value) fetchSlots(selectedTable, this.value); });
        }

        // Restore step
        if (hdnStepEl) {
            var s = parseInt(hdnStepEl.value) || 1;
            if (s === 4) { showSuccess(); }
            else if (s > 1) {
                document.querySelectorAll('.step').forEach(function (el) { el.classList.remove('active'); });
                document.getElementById('step' + s).classList.add('active');
                document.getElementById('progressFill').style.width = PROGRESS[s];
                currentStep = s;
            }
        }
    });
</script>
</body>
</html>