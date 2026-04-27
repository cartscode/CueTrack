<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cashierlogin.aspx.cs" Inherits="CueTrack.CashierLogin" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack Cashier Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800;900&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet" />
    <style>
        :root {
            --orange:    #FF8C00;
            --orange-hot:#FF6A00;
            --dark-bg:   #0f0f0f;
            --card-bg:   #1a1a1a;
            --border:    #2a2a2a;
            --text:      #f0f0f0;
            --muted:     #888;
            --red:       #c0392b;
            --green:     #27ae60;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Barlow', sans-serif;
            background: var(--dark-bg);
            color: var(--text);
            min-height: 100vh;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        /* ── BACKGROUND ── */
        .bg-layer {
            position: fixed;
            inset: 0;
            background: url('Image/background.jpg') center / no-repeat;
            opacity: 0.12;
            z-index: 0;
            pointer-events: none;
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

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-shark img {
            width: 38px;
            height: auto;
        }

        .logo-text {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 20px;
            font-weight: 800;
            letter-spacing: 1px;
            color: white;
        }

        .cashier-badge {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            color: black;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 3px 10px;
            border-radius: 20px;
            margin-left: 4px;
        }

        .back-link {
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color 0.2s;
        }

        .back-link:hover { color: var(--orange); }

        /* ── PAGE WRAPPER ── */
        .page {
            position: relative;
            z-index: 1;
            margin-top: 60px;
            min-height: calc(100vh - 60px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        /* ── AUTH CARD ── */
        .auth-card {
            width: 100%;
            max-width: 420px;
            background: #161616;
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 24px 80px rgba(0,0,0,0.7);
            animation: cardIn 0.4s cubic-bezier(0.34,1.56,0.64,1);
        }

        @keyframes cardIn {
            from { opacity: 0; transform: translateY(24px) scale(0.97); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        /* ── CARD HEADER ── */
        .card-header {
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            padding: 28px 30px 22px;
            text-align: center;
            position: relative;
        }

        .header-icon {
            font-size: 36px;
            display: block;
            margin-bottom: 8px;
        }

        .card-title {
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 28px;
            font-weight: 900;
            letter-spacing: 2px;
            color: black;
            text-transform: uppercase;
        }

        .card-subtitle {
            font-size: 12px;
            font-weight: 600;
            color: rgba(0,0,0,0.6);
            margin-top: 4px;
        }

        /* ── TAB SWITCHER ── */
        .tab-bar {
            display: flex;
            border-bottom: 1px solid var(--border);
        }

        .tab-btn {
            flex: 1;
            padding: 14px;
            background: transparent;
            border: none;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 15px;
            font-weight: 800;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            color: var(--muted);
            cursor: pointer;
            transition: all 0.2s;
            border-bottom: 3px solid transparent;
            position: relative;
            top: 1px;
        }

        .tab-btn.active {
            color: var(--orange);
            border-bottom-color: var(--orange);
            background: rgba(255,140,0,0.05);
        }

        .tab-btn:hover:not(.active) {
            color: var(--text);
            background: rgba(255,255,255,0.04);
        }

        /* ── FORM BODY ── */
        .card-body {
            padding: 28px 30px 32px;
        }

        .form-panel { display: none; }
        .form-panel.active { display: block; }

        /* ── FIELD GROUP ── */
        .field-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
            margin-bottom: 14px;
        }

        .field-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--orange);
            text-transform: uppercase;
            letter-spacing: 0.7px;
        }

        .field-input {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: 11px 14px;
            color: white;
            font-family: 'Barlow', sans-serif;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            width: 100%;
        }

        .field-input:focus {
            border-color: var(--orange);
            background: rgba(255,140,0,0.05);
            box-shadow: 0 0 0 3px rgba(255,140,0,0.1);
        }

        .field-input::placeholder { color: #555; }

        /* ── TWO-COL GRID ── */
        .field-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        /* ── SUBMIT BUTTON ── */
        .btn-submit {
            width: 100%;
            padding: 14px;
            margin-top: 6px;
            background: linear-gradient(135deg, var(--orange), var(--orange-hot));
            border: none;
            border-radius: 10px;
            color: black;
            font-family: 'Barlow Condensed', sans-serif;
            font-size: 18px;
            font-weight: 900;
            letter-spacing: 2px;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 4px 20px rgba(255,140,0,0.35);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(255,140,0,0.5);
        }

        .btn-submit:active { transform: translateY(0); }

        /* ── DIVIDER ── */
        .divider {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 18px 0;
        }

        .divider-line {
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .divider-text {
            font-size: 11px;
            color: var(--muted);
            white-space: nowrap;
        }

        /* ── ALERT MESSAGE ── */
        .alert-msg {
            display: none;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
            animation: alertIn 0.25s ease;
        }

        @keyframes alertIn {
            from { opacity: 0; transform: translateY(-6px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .alert-error {
            background: rgba(192,57,43,0.12);
            border: 1px solid var(--red);
            color: #e74c3c;
        }

        .alert-success {
            background: rgba(39,174,96,0.12);
            border: 1px solid var(--green);
            color: #2ecc71;
        }

        /* ── SWITCH LINK ── */
        .switch-text {
            text-align: center;
            font-size: 12px;
            color: var(--muted);
            margin-top: 18px;
        }

        .switch-text a {
            color: var(--orange);
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .switch-text a:hover { text-decoration: underline; }

        /* ── FOOTER ── */
        .card-footer-note {
            padding: 14px 30px;
            border-top: 1px solid var(--border);
            background: rgba(255,140,0,0.03);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 11px;
            color: var(--muted);
        }

        .lock-icon { color: var(--orange); font-size: 14px; }

        /* ── RESPONSIVE ── */
        @media (max-width: 480px) {
            .card-body { padding: 22px 18px 26px; }
            .car d-header { padding: 22px 18px 18px; }
            .field-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <div class="bg-layer"></div>

    <!-- NAVBAR -->
    <nav class="navbar">
        <div class="navbar-left">
            <div class="logo-shark">
                <img src="Image/great-white-shark.png"
                     onerror="this.style.display='none';this.parentElement.textContent='🦈'" />
            </div>
            <span class="logo-text">CueTrack</span>
            <span class="cashier-badge">Cashier</span>
        </div>
        <a href="Default.aspx" class="back-link">Back to main site</a>
    </nav>

    <!-- PAGE -->
    <div class="page">
        <div class="auth-card">

            <!-- HEADER -->
            <div class="card-header">
                <span class="header-icon"></span>
                <div class="card-title">Cashier Portal</div>
                <div class="card-subtitle">Sharks Arena · Staff Access Only</div>
            </div>

            <!-- TAB BAR -->
            <div class="tab-bar">
                <button type="button" class="tab-btn active" id="tabLogin" onclick="switchTab('login')">Login</button>
                <button type="button" class="tab-btn" id="tabRegister" onclick="switchTab('register')">Register</button>
            </div>

            <!-- BODY -->
            <div class="card-body">

                <!-- ALERT -->
                <div class="alert-msg" id="alertMsg"></div>

                <!-- ── LOGIN PANEL ── -->
                <div class="form-panel active" id="panelLogin">
                    <div class="field-group">
                        <label class="field-label">Email Address</label>
                        <asp:TextBox ID="txtLoginEmail" runat="server"
                            CssClass="field-input"
                            placeholder="cashier@sharksarena.com" />
                    </div>

                    <div class="field-group">
                        <label class="field-label">Password</label>
                        <asp:TextBox ID="txtLoginPassword" runat="server"
                            CssClass="field-input"
                            TextMode="Password"
                            placeholder="Enter your password" />
                    </div>

                    <asp:Button ID="btnLogin" runat="server"
                        Text="LOGIN"
                        CssClass="btn-submit"
                        OnClick="BtnLogin_Click"
                        OnClientClick="return validateLogin();" />

                    <div class="switch-text">
                        No account yet?
                        <a onclick="switchTab('register')">Register here</a>
                    </div>
                </div>

                <!-- ── REGISTER PANEL ── -->
                <div class="form-panel" id="panelRegister">
                    <div class="field-grid">
                        <div class="field-group">
                            <label class="field-label">First Name</label>
                            <asp:TextBox ID="txtFirstName" runat="server"
                                CssClass="field-input"
                                placeholder="Juan" />
                        </div>
                        <div class="field-group">
                            <label class="field-label">Last Name</label>
                            <asp:TextBox ID="txtLastName" runat="server"
                                CssClass="field-input"
                                placeholder="Dela Cruz" />
                        </div>
                    </div>

                    <div class="field-group">
                        <label class="field-label">Phone Number</label>
                        <asp:TextBox ID="txtPhone" runat="server"
                            CssClass="field-input"
                            placeholder="+63 9XX XXX XXXX" />
                    </div>

                    <div class="field-group">
                        <label class="field-label">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="field-input"
                            placeholder="cashier@sharksarena.com" />
                    </div>

                    <div class="field-group">
                        <label class="field-label">Staff Access Code</label>
                        <asp:TextBox ID="txtAccessCode" runat="server"
                            CssClass="field-input"
                            TextMode="Password"
                            placeholder="Provided by management" />
                    </div>

                    <div class="field-grid">
                        <div class="field-group">
                            <label class="field-label">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server"
                                CssClass="field-input"
                                TextMode="Password"
                                placeholder="Min. 6 characters" />
                        </div>
                        <div class="field-group">
                            <label class="field-label">Confirm</label>
                            <input type="password" id="txtConfirmPassword"
                                class="field-input"
                                placeholder="Re-enter password" />
                        </div>
                    </div>

                    <asp:Button ID="btnRegister" runat="server"
                        Text="CREATE ACCOUNT"
                        CssClass="btn-submit"
                        OnClick="BtnRegister_Click"
                        OnClientClick="return true;" />

                    <div class="switch-text">
                        Already have an account?
                        <a onclick="switchTab('login')">Login here</a>
                    </div>
                </div>

            </div>

            <!-- CARD FOOTER -->
            <div class="card-footer-note">
                Restricted to authorized Sharks Arena cashier staff only.
            </div>

        </div>
    </div>

    <!-- HIDDEN: persist active tab across postback -->
    <input type="hidden" id="hdnActiveTab" name="hdnActiveTab" value="login" />

</form>

<script>
    // ── TAB SWITCHER ────────────────────────────────────────────
    function switchTab(tab) {
        document.getElementById('hdnActiveTab').value = tab;
        clearAlert();

        // Panels
        document.getElementById('panelLogin').classList.toggle('active', tab === 'login');
        document.getElementById('panelRegister').classList.toggle('active', tab === 'register');

        // Tabs
        document.getElementById('tabLogin').classList.toggle('active', tab === 'login');
        document.getElementById('tabRegister').classList.toggle('active', tab === 'register');
    }

    // ── RESTORE TAB ON POSTBACK ─────────────────────────────────
    document.addEventListener('DOMContentLoaded', function () {
        var hdn = document.getElementById('hdnActiveTab');
        if (hdn && hdn.value === 'register') switchTab('register');
    });

    // ── ALERTS ──────────────────────────────────────────────────
    function showAlert(msg, type) {
        var el = document.getElementById('alertMsg');
        el.className = 'alert-msg ' + (type === 'success' ? 'alert-success' : 'alert-error');
        el.textContent = msg;
        el.style.display = 'block';
    }

    function clearAlert() {
        var el = document.getElementById('alertMsg');
        el.style.display = 'none';
        el.textContent = '';
    }

    // ── LOGIN VALIDATION ────────────────────────────────────────
    function validateLogin() {
        clearAlert();
        var email = document.querySelector('[id$="txtLoginEmail"]');
        var pass  = document.querySelector('[id$="txtLoginPassword"]');

        if (!email || !email.value.trim()) {
            showAlert('Please enter your email address.', 'error');
            return false;
        }
        if (!pass || !pass.value.trim()) {
            showAlert('Please enter your password.', 'error');
            return false;
        }
        return true;
    }

    // ── REGISTER VALIDATION ─────────────────────────────────────
    function validateRegister() {
        clearAlert();
        var fn   = document.querySelector('[id$="txtFirstName"]');
        var ln   = document.querySelector('[id$="txtLastName"]');
        var ph   = document.querySelector('[id$="txtPhone"]');
        var em   = document.querySelector('[id$="txtEmail"]');
        var ac   = document.querySelector('[id$="txtAccessCode"]');
        var pw   = document.querySelector('[id$="txtPassword"]');
        var cpw  = document.getElementById('txtConfirmPassword');

        if (!fn  || !fn.value.trim())  { showAlert('First name is required.',        'error'); return false; }
        if (!ln  || !ln.value.trim())  { showAlert('Last name is required.',          'error'); return false; }
        if (!ph  || !ph.value.trim())  { showAlert('Phone number is required.',       'error'); return false; }
        if (!em  || !em.value.trim())  { showAlert('Email address is required.',      'error'); return false; }
        if (!ac  || !ac.value.trim())  { showAlert('Staff access code is required.',  'error'); return false; }
        if (!pw  || !pw.value.trim())  { showAlert('Password is required.',           'error'); return false; }
        if (pw.value.length < 6)       { showAlert('Password must be at least 6 characters.', 'error'); return false; }
        if (cpw  && pw.value !== cpw.value) {
            showAlert('Passwords do not match.', 'error'); return false;
        }

        document.getElementById('hdnActiveTab').value = 'register';
        return true;
    }
</script>
</body>
</html>
