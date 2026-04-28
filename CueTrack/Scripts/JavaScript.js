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

// ── LOGIN VALIDATION ──────────────────────────────────────────
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

// ── REGISTER VALIDATION ───────────────────────────────────────
function validateRegister() {
    var firstname = document.querySelector('[id$="txtFirstname"]');
    var lastname = document.querySelector('[id$="txtLastname"]');
    var phone = document.querySelector('[id$="txtPhoneno"]');
    var email = document.querySelector('[id$="txtEmail"]');
    var pass = document.querySelector('[id$="txtPassword"]');
    var chkTerms = document.getElementById('chkTerms');

    if (!firstname || firstname.value.trim() === '') {
        alert('Please enter your first name.');
        return false;
    }
    if (!lastname || lastname.value.trim() === '') {
        alert('Please enter your last name.');
        return false;
    }
    if (!phone || phone.value.trim() === '') {
        alert('Please enter your phone number.');
        return false;
    }
    if (!email || email.value.trim() === '') {
        alert('Please enter your email.');
        return false;
    }
    if (!pass || pass.value.trim() === '') {
        alert('Please enter a password.');
        return false;
    }
    if (!chkTerms || !chkTerms.checked) {
        alert('You must agree to the Terms & Conditions before registering.');
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
    nav.classList.toggle('active');
    spans.forEach(function (span) {
        span.classList.toggle('active');
    });
}

// ── TERMS POPUP ────────────────────────────────────────────────
function openTermsPopup() {
    var popup = document.getElementById('termsPopup');
    var body = document.getElementById('termsScrollBody');
    var btn = document.getElementById('termsAcceptBtn');
    var hint = document.getElementById('termsScrollHint');

    // Reset every open
    body.scrollTop = 0;
    btn.disabled = true;
    btn.style.opacity = '0.35';
    btn.style.cursor = 'not-allowed';
    hint.style.display = 'block';

    popup.style.display = 'flex';
}

function closeTermsPopup() {
    document.getElementById('termsPopup').style.display = 'none';
}

function onTermsScroll() {
    var body = document.getElementById('termsScrollBody');
    var btn = document.getElementById('termsAcceptBtn');
    var hint = document.getElementById('termsScrollHint');

    // Enable Accept once user scrolls to within 30px of the bottom
    var nearBottom = body.scrollTop + body.clientHeight >= body.scrollHeight - 30;
    if (nearBottom) {
        btn.disabled = false;
        btn.style.opacity = '1';
        btn.style.cursor = 'pointer';
        hint.style.display = 'none';
    }
}

function acceptTerms() {
    document.getElementById('chkTerms').checked = true;
    closeTermsPopup();
}