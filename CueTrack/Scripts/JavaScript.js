function registerNow() {
    alert("Redirecting to registration page...");
    window.location.href = "Register.aspx";
}
function openLogin() {
    document.getElementById("authModal").style.display = "block";
    document.getElementById("loginForm").style.display = "block";
    document.getElementById("registerForm").style.display = "none";
}

function openRegister() {
    document.getElementById("authModal").style.display = "block";
    document.getElementById("loginForm").style.display = "none";
    document.getElementById("registerForm").style.display = "block";
}

function closeModal() {
    document.getElementById("authModal").style.display = "none";
}

function showRegister() {
    document.getElementById("loginForm").style.display = "none";
    document.getElementById("registerForm").style.display = "block";
}

function showLogin() {
    document.getElementById("loginForm").style.display = "block";
    document.getElementById("registerForm").style.display = "none";
}
