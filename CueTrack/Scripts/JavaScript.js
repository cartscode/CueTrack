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

// Click handler — set active immediately on click
document.querySelectorAll('.nav-links a:not(.login-btn)').forEach(function (link) {
    link.addEventListener('click', function () {
        document.querySelectorAll('.nav-links a').forEach(function (l) {
            l.classList.remove('active');
        });
        this.classList.add('active');
    });
});

// Scroll handler — sync active with visible section
window.addEventListener('scroll', function () {
    var sections = document.querySelectorAll('section[id], div[id]');
    var navLinks = document.querySelectorAll('.nav-links a:not(.login-btn)');
    var current = '';

    sections.forEach(function (section) {
        var sectionTop = section.offsetTop - 100;
        if (window.pageYOffset >= sectionTop) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(function (link) {
        link.classList.remove('active');
        if (link.getAttribute('href') === '#' + current) {
            link.classList.add('active');
        }
    });
});

// Set Home as active on page load
document.addEventListener('DOMContentLoaded', function () {
    var homeLink = document.querySelector('.nav-links a[href="#home"]');
    if (homeLink) homeLink.classList.add('active');
});