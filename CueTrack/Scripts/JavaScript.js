// ── MODAL ─────────────────────────────────────────────────────
function openLogin() {
    document.getElementById('authModal').style.display = 'block';
    document.getElementById('loginForm').style.display = 'block';
    document.getElementById('registerForm').style.display = 'none';
    setModalState('login');
}

function openRegister() {
    document.getElementById('authModal').style.display = 'block';
    document.getElementById('loginForm').style.display = 'none';
    document.getElementById('registerForm').style.display = 'block';
    setModalState('register');
}

function closeModal() {
    document.getElementById('authModal').style.display = 'none';
    setModalState('');
}

function showRegister() {
    document.getElementById('loginForm').style.display = 'none';
    document.getElementById('registerForm').style.display = 'block';
    setModalState('register');
}

function showLogin() {
    document.getElementById('loginForm').style.display = 'block';
    document.getElementById('registerForm').style.display = 'none';
    setModalState('login');
}

// ── MODAL STATE (persist across postback) ─────────────────────
function setModalState(state) {
    var hdn = document.getElementById('hdnModalState');
    if (hdn) hdn.value = state;
}

function restoreModalState() {
    var hdn = document.getElementById('hdnModalState');
    if (!hdn) return;
    if (hdn.value === 'login') openLogin();
    else if (hdn.value === 'register') openRegister();
}

// ── LOGIN VALIDATION (no <%= %> — uses querySelector) ─────────
function validateLogin() {
    var email = document.querySelector('[id$="txtLoginEmail"]');
    var pass = document.querySelector('[id$="txtLoginPassword"]');

    if (!email || email.value.trim() === '') {
        alert('Please enter your email.');
        return false;
    }
    if (!pass || pass.value.trim() === '') {
        alert('Please enter your password.');
        return false;
    }
    return true;
}

// ── NAV ACTIVE STATE ──────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {

    // Restore modal if postback happened
    restoreModalState();

    // Set Home active on first load
    var homeLink = document.querySelector('.nav-links a[href="#home"]');
    if (homeLink) homeLink.classList.add('active');

    // Click → set active immediately
    document.querySelectorAll('.nav-links a:not(.login-btn)').forEach(function (link) {
        link.addEventListener('click', function () {
            document.querySelectorAll('.nav-links a').forEach(function (l) {
                l.classList.remove('active');
            });
            this.classList.add('active');
        });
    });
});

// Scroll → sync active with visible section
window.addEventListener('scroll', function () {
    var sections = document.querySelectorAll('section[id], div[id]');
    var navLinks = document.querySelectorAll('.nav-links a:not(.login-btn)');
    var current = '';

    sections.forEach(function (section) {
        if (window.scrollY >= section.offsetTop - 100) {
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

// ── MOBILE MENU ───────────────────────────────────────────────
function toggleMenu() {
    var nav = document.getElementById('navLinks');
    var spans = document.querySelectorAll('.menu-toggle span');
    nav.classList.toggle('open');
    spans.forEach(function (span) {
        span.classList.toggle('open');
    });
}