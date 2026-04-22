<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CueTrack.WebForm1" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8" />
    <title>CueTrack - Home</title>

    <!-- CSS -->
    <link rel="stylesheet" href="Content/style.css" />
    <link href="https://fonts.googleapis.com/css2?family=Handelson+Two&display=swap" rel="stylesheet" />
</head>

<body>
<form id="form1" runat="server">

    <!-- AUTH MODAL -->
    <div id="authModal" class="modal">
        <div class="modal-box">
            <span class="close-btn" onclick="closeModal()">&times;</span>

            <!-- LOGIN FORM -->
            <div id="loginForm">
                <h2>Login</h2>
                <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="input" Placeholder="Email"></asp:TextBox>
                <asp:TextBox ID="txtLoginPassword" runat="server" CssClass="input" TextMode="Password" Placeholder="Password"></asp:TextBox>
                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn" />
                <p>Don't have an account?
                    <a href="#" onclick="showRegister(); return false;">Register</a>
                </p>
            </div>

            <!-- REGISTER FORM -->
            <div id="registerForm" style="display:none;">
                <h2>Register</h2>
                <asp:TextBox ID="txtFirstname" runat="server" CssClass="input" Placeholder="First Name"></asp:TextBox>
                <asp:TextBox ID="txtLastname" runat="server" CssClass="input" Placeholder="Last Name"></asp:TextBox>
                <asp:TextBox ID="txtPhoneno" runat="server" CssClass="input" Placeholder="Phone number"></asp:TextBox>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="input" Placeholder="Email"></asp:TextBox>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="input" TextMode="Password" Placeholder="Password"></asp:TextBox>
                <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn" />
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
            <div class="nav-links">
                <a href="#home">Home</a>
                <a href="#services">Services</a>
                <a href="#contact">Contact Us</a>
                <a href="#about">About Us</a>
                <a href="#" class="login-btn" onclick="openLogin(); return false;">LOGIN</a>
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
                        <p>Sharks Arena, Quezon City, Philippines</p>
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
                        <p>facebook.com/SharksArena</p>
                    </div>
                </div>
                <div class="contact-item">
                    <span class="contact-icon">&#128336;</span>
                    <div>
                        <h4>Hours</h4>
                        <p>Open Daily: 10:00 AM – 2:00 AM</p>
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
                    reserve tables online, order food, and track your game time all in one place.
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
                <a href="#">Facebook</a>
                <a href="#">Instagram</a>
                <a href="#">YouTube</a>
            </div>

        </div>

        <div class="footer-bottom">
            <p>&copy; 2026 CueTrack &mdash; Sharks Arena. All rights reserved.</p>
        </div>
    </footer>

</form>

<!-- JS -->
<script src="Scripts/JavaScript.js"></script>

</body>
</html>