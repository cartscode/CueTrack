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

            <!-- CLOSE BUTTON -->
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
    <div class="hero">
        <div class="overlay"></div>

        <!-- NAVBAR -->
        <div class="navbar">
            <div class="logo">
                <img src="Image/great-white-shark.png" class="logo-img" />
                CueTrack
            </div>

            <div class="nav-links">
                <a href="#">Home</a>
                <a href="#">Services</a>
                <a href="#">Contact Us</a>
                <a href="#">About Us</a>
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

</form>

<!-- JS -->
<script src="Scripts/JavaScript.js"></script>

</body>
</html>
