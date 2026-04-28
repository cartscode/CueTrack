<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CueTrack.WebForm1" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CueTrack - Home</title>

    <!-- CSS -->
    <link rel="stylesheet" href="Content/style.css" />
    <link href="https://fonts.googleapis.com/css2?family=Handelson+Two&display=swap" rel="stylesheet" />
</head>

<body>
<form id="form1" runat="server">

    <input type="hidden" id="hdnModalState" name="hdnModalState" value="" />
    <!-- AUTH MODAL -->
    <div id="authModal" class="modal">
        <div class="modal-box">
            <span class="close-btn" onclick="closeModal()">&times;</span>

            <!-- LOGIN FORM -->
            <div id="loginForm">
                <h2>Login</h2>
                <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="input" Placeholder="Email"></asp:TextBox>
                <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="input" TextMode="Password" Placeholder="Password"></asp:TextBox>
                <asp:Button ID="BtnLogin" runat="server" Text="Login"
    CssClass="btn" OnClick="BtnLogin_Click"
    OnClientClick="return validateLogin();" />

                <p>Don't have an account?
                    <a href="#" onclick="showRegister(); return false;">Register</a>
                </p>
            </div>

            <!-- REGISTER FORM -->
<!-- REGISTER FORM -->
<div id="registerForm" style="display:none;">
    <h2>Register</h2>
    <asp:TextBox ID="txtFirstname" runat="server" CssClass="input" Placeholder="First Name"></asp:TextBox>
    <asp:TextBox ID="txtLastname" runat="server" CssClass="input" Placeholder="Last Name"></asp:TextBox>
    <asp:TextBox ID="txtPhoneno" runat="server" CssClass="input" Placeholder="Phone number"></asp:TextBox>
    <asp:TextBox ID="txtEmail" runat="server" CssClass="input" Placeholder="Email"></asp:TextBox>
    <asp:TextBox ID="txtPassword" runat="server" CssClass="input" TextMode="Password" Placeholder="Password"></asp:TextBox>

    <!-- ✅ ADD THIS CHECKBOX ROW -->
    <div style="display:flex;align-items:flex-start;gap:8px;margin:10px 0;text-align:left;">
        <input type="checkbox" id="chkTerms" style="margin-top:3px;accent-color:orange;width:15px;height:15px;flex-shrink:0;cursor:pointer;" />
        <label for="chkTerms" style="font-size:12px;color:#ccc;line-height:1.5;cursor:pointer;">
            I have read and agree to the
            <a href="#" onclick="openTermsPopup();return false;" 
               style="color:orange;font-weight:700;text-decoration:underline;">
                Terms &amp; Conditions
            </a>
        </label>
    </div>
    <!-- ✅ END CHECKBOX ROW -->

<asp:Button ID="btnRegister" runat="server" Text="Register"
    CssClass="btn" OnClick="BtnRegister_Click"
    OnClientClick="return validateRegister();" />
    <p>Already have an account?
        <a href="#" onclick="showLogin(); return false;">Login</a>
    </p>
</div>
        </div>
    </div>

    <!-- HERO SECTION -->
    <div class="hero" id="home">
        <div class="overlay"></div>

        <!-- NAVBAR -->
<div class="navbar">
    <div class="logo">
        <img src="Image/great-white-shark.png" class="logo-img" />
        CueTrack
    </div>
    <div class="menu-toggle" onclick="toggleMenu()">
        <span></span>
        <span></span>
        <span></span>
    </div>
    <div class="nav-links" id="navLinks">
        <a href="#home" onclick="toggleMenu()">Home</a>
        <a href="#services" onclick="toggleMenu()">Services</a>
        <a href="#contact" onclick="toggleMenu()">Contact Us</a>
        <a href="#about" onclick="toggleMenu()">About Us</a>
        <a href="#" class="login-btn" onclick="openLogin(); toggleMenu(); return false;">LOGIN</a>
    </div>
</div>

        <!-- CONTENT -->
        <div class="content">
            <h1 class="fade-in">REGISTER NOW</h1>
            <h2 class="fade-in">& get exclusive benefits!</h2>
            <p class="fade-in">
                Register today to unlock amazing discounts, exclusive promos, and loyalty points
                while enjoying instant billiard reservations!
            </p>
            <button type="button" class="btn fade-in" onclick="openRegister()">REGISTER</button>
        </div>
    </div>

    <!-- SERVICES SECTION -->
    <section id="services" class="section">
        <h2>Our Services</h2>
        <div class="card-container">

            <!-- CARD 1 -->
            <div class="card">
                <img src="Image/service.jpg" class="card-img" />
                <div class="card-content">
                    <h3>Billiard Reservation</h3>
                    <p>Reserve tables in advance and avoid waiting time.</p>
                </div>
            </div>

            <!-- CARD 2 -->
            <div class="card">
                <img src="Image/food.jpg" class="card-img" />
                <div class="card-content">
                    <h3>Food Ordering</h3>
                    <p>Order snacks and drinks while playing.</p>
                </div>
            </div>

            <!-- CARD 3 -->
            <div class="card">
                <img src="Image/sba.jpg" class="card-img" />
                <div class="card-content">
                    <h3>Watch SBA Live</h3>
                    <p>Watch top pool players in the Philippines live.</p>
                </div>
            </div>

        </div>
    </section>

    <!-- CONTACT SECTION -->
        <section id="contact" class="section section-dark">
            <h2>Contact Us</h2>
            <div class="contact-container">
                <div class="contact-info">
                    <div class="contact-item">
                        <span class="contact-icon">&#128205;</span>
                        <div>
                            <h4>Address</h4>
                            <p> Sharks Arena, 234 Tomas Morato Ave., Diliman, Quezon City, Philippines</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <span class="contact-icon">&#128222;</span>
                        <div>
                            <h4>Phone</h4>
                            <p>+63 912 345 6789</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <span class="contact-icon">&#128140;</span>
                        <div>
                            <h4>Facebook</h4>
                            <p>https://www.facebook.com/sharks.asb/</p>
                        </div>
                    </div>
                    <div class="contact-item">
                        <span class="contact-icon">&#128336;</span>
                        <div>
                            <h4>Hours</h4>
                            <p>Open Daily: 3:00 pm – 5:00 AM</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    <!-- ABOUT SECTION -->
    <section id="about" class="section">
        <h2>About Us</h2>
        <div class="about-container">
            <div class="about-text">
                <p>
                    Sharks Arena is Quezon City's premier billiards destination. Whether you're a
                    casual player or a competitive one, we offer a world-class experience with
                    top-quality tables, great food, and live SBA events.
                </p>
                <p>
                    CueTrack is our digital system designed to make your visit seamless —
                    reserve tables online, and track your game time all in one place.
                </p>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer" id="footer">
        <div class="footer-container">

            <!-- LEFT: Brand -->
            <div class="footer-brand">
                <div class="footer-logo">
                    <img src="Image/great-white-shark.png" class="footer-logo-img" />
                    CueTrack
                </div>
                <p class="footer-tagline">Your game. Your table. Your time.</p>
            </div>

            <!-- CENTER: Quick Links -->
            <div class="footer-links">
                <h4>Quick Links</h4>
                <a href="#home">Home</a>
                <a href="#services">Services</a>
                <a href="#contact">Contact Us</a>
                <a href="#about">About Us</a>
            </div>

            <!-- RIGHT: Socials -->
            <div class="footer-links">
                <h4>Follow Us</h4>
                <a href="https://www.tiktok.com/@sharksbilliardsasso">Tiktok</a>
                <a href="https://www.facebook.com/sharks.asb/" >Facebook</a>
                <a href="https://www.instagram.com/sharksbilliardsassociation/">Instagram</a>
                <a href="https://www.youtube.com/@sharksbilliardsassoc">YouTube</a>
            </div>

        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 CueTrack &mdash; Sharks Arena. All rights reserved.</p>
        </div>
    </footer>

</form>
    <!-- TERMS POPUP -->
<div id="termsPopup" style="
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.88);
    z-index:1100;
    align-items:center;
    justify-content:center;
    padding:20px;">

    <div style="
        background:#111;
        border:1px solid #333;
        border-radius:14px;
        width:100%;
        max-width:420px;
        max-height:85vh;
        display:flex;
        flex-direction:column;
        overflow:hidden;">

        <!-- Header -->
        <div style="
            background:linear-gradient(135deg,orange,#ff7b00);
            padding:16px 20px;
            display:flex;
            align-items:center;
            justify-content:space-between;
            flex-shrink:0;">
            <div style="display:flex;align-items:center;gap:10px;">
                <span style="font-size:22px;">📋</span>
                <div>
                    <div style="font-weight:900;font-size:16px;color:black;text-transform:uppercase;letter-spacing:1px;">Terms &amp; Conditions</div>
                    <div style="font-size:11px;color:rgba(0,0,0,0.6);font-weight:600;margin-top:2px;">Scroll down to accept</div>
                </div>
            </div>
            <div onclick="closeTermsPopup()" style="
                width:28px;height:28px;
                background:rgba(0,0,0,0.2);
                border-radius:50%;
                display:flex;align-items:center;justify-content:center;
                cursor:pointer;font-size:15px;font-weight:900;color:black;">✕</div>
        </div>

        <!-- Scrollable content -->
        <div id="termsScrollBody" onscroll="onTermsScroll()" style="
            padding:18px 20px;
            overflow-y:auto;
            flex:1;
            font-size:12px;
            color:#bbb;
            line-height:1.7;">

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">1. Account Registration</div>
            <p style="margin-bottom:14px;">By creating an account with CueTrack, you agree to provide accurate, complete, and current information. You are responsible for maintaining the confidentiality of your account credentials and all activities that occur under your account.</p>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">2. Reservation Policy</div>
            <ul style="padding-left:16px;margin-bottom:14px;">
                <li>Reservations are on a first-come, first-served basis.</li>
                <li>You may only reserve one table per time slot.</li>
                <li>Please arrive on time — late arrivals may forfeit their slot.</li>
                <li>Reservations cannot be transferred to another person.</li>
            </ul>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">3. Cancellation Policy</div>
            <p style="margin-bottom:14px;">Cancellations must be made at least 1 hour before your reserved time. Repeated no-shows may result in suspension of your account.</p>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">4. Discount Eligibility</div>
            <p style="margin-bottom:14px;">Student, PWD, and Senior discounts require a valid ID upon arrival. Failure to present a valid ID will result in the full standard rate being charged.</p>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">5. Conduct</div>
            <ul style="padding-left:16px;margin-bottom:14px;">
                <li>All players must follow Sharks Arena house rules at all times.</li>
                <li>Disruptive behavior may result in removal without refund.</li>
                <li>Management reserves the right to refuse service to anyone.</li>
            </ul>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">6. Privacy</div>
            <p style="margin-bottom:14px;">Your personal information (name, email, phone number) is collected solely for reservation and account management purposes and will not be shared with third parties without your consent.</p>

            <div style="color:orange;font-weight:800;font-size:12px;text-transform:uppercase;letter-spacing:0.8px;margin-bottom:6px;">7. Liability</div>
            <p style="margin-bottom:6px;">Sharks Arena and CueTrack are not liable for lost or stolen personal belongings. All players use equipment at their own risk.</p>

        </div>

        <!-- Hint -->
        <div id="termsScrollHint" style="
            text-align:center;font-size:10px;
            color:#555;padding:6px 0;
            flex-shrink:0;
            border-top:1px solid #222;">
            ↓ Keep scrolling to enable Accept
        </div>

        <!-- Footer -->
        <div style="padding:14px 20px 18px;border-top:1px solid #222;flex-shrink:0;">
            <button id="termsAcceptBtn" onclick="acceptTerms()" disabled style="
                width:100%;padding:12px;
                background:orange;border:none;
                border-radius:10px;
                font-size:15px;font-weight:900;
                color:black;cursor:pointer;
                text-transform:uppercase;
                letter-spacing:1px;
                opacity:0.35;
                transition:opacity 0.3s;">
                ✓ I Accept the Terms
            </button>
        </div>
    </div>
</div>

<!-- JS -->
<script src="Scripts/JavaScript.js"></script>

</body>
</html>