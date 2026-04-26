<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reservation.aspx.cs" Inherits="CueTrack.Reservation" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack - Reservation</title>
    <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@400;600;700;800&family=Barlow:wght@400;500;600&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="Content/Reservation.css" />
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

<script src="Scripts/Reservation.js"></script>
</body>
</html>