
    // ── DATA ───────────────────────────────────────────────────
    const tables = [
    {id: 1, reserved: false },
    {id: 2, reserved: true },
    {id: 3, reserved: false },
    {id: 4, reserved: false },
    {id: 5, reserved: false },
    {id: 6, reserved: false },
    {id: 7, reserved: false },
    ];

    const RATES = {'Rental Time': '₱ 300/hr', 'Open Time': '₱ 500 flat' };

    let selectedTable = 1;
    let selectedRental = 'Rental Time';
    let currentStep = 1;

    // ── POOL TABLE SVG ─────────────────────────────────────────
    function poolSVG(small) {
        const w = small ? 130 : 240, h = small ? 98 : 180;
    const r = small ? 5 : 9, bR = small ? 4.5 : 7.5, pR = small ? 3.5 : 6;
    return `<svg viewBox="0 0 ${w} ${h}" xmlns="http://www.w3.org/2000/svg">
        <rect x="0" y="0" width="${w}" height="${h}" rx="${r}" fill="#4E342E" />
        <rect x="${w * .08}" y="${h * .10}" width="${w * .84}" height="${h * .80}" rx="${r * .55}" fill="#1565C0" />
        <rect x="${w * .08}" y="${h * .10}" width="${w * .84}" height="${h * .37}" rx="${r * .55}" fill="rgba(255,255,255,0.04)" />
        <line x1="${w / 2}" y1="${h * .12}" x2="${w / 2}" y2="${h * .88}" stroke="rgba(255,255,255,0.1)" stroke-width="1.2" />
        <circle cx="${w / 2}" cy="${h / 2}" r="${w * .07}" fill="none" stroke="rgba(255,255,255,0.13)" stroke-width="1.2" />
        <circle cx="${w * .10}" cy="${h * .14}" r="${pR}" fill="#111" />
        <circle cx="${w * .90}" cy="${h * .14}" r="${pR}" fill="#111" />
        <circle cx="${w * .10}" cy="${h * .86}" r="${pR}" fill="#111" />
        <circle cx="${w * .90}" cy="${h * .86}" r="${pR}" fill="#111" />
        <circle cx="${w / 2}" cy="${h * .11}" r="${pR * .8}" fill="#111" />
        <circle cx="${w / 2}" cy="${h * .89}" r="${pR * .8}" fill="#111" />
        <circle cx="${w * .34}" cy="${h * .50}" r="${bR}" fill="white" opacity=".9" />
        <circle cx="${w * .61}" cy="${h * .41}" r="${bR * .8}" fill="#e74c3c" opacity=".85" />
        <circle cx="${w * .67}" cy="${h * .56}" r="${bR * .8}" fill="#f39c12" opacity=".85" />
        <circle cx="${w * .55}" cy="${h * .61}" r="${bR * .8}" fill="#2ecc71" opacity=".85" />
    </svg>`;
    }

    // ── RENDER TABLE GRID ──────────────────────────────────────
    function renderGrid() {
        const grid = document.getElementById('tableGrid');
    grid.innerHTML = '';
        tables.forEach(t => {
            const card = document.createElement('div');
    card.className = 'table-card'
    + (t.reserved ? ' reserved' : '')
    + (t.id === selectedTable && !t.reserved ? ' selected' : '');
    card.innerHTML = `
    <div class="table-label">Table ${t.id}</div>
    <div class="pool-art">${poolSVG(true)}
        ${t.reserved ? '<div class="reserved-badge">Reserved</div>' : ''}
    </div>`;
            if (!t.reserved) card.addEventListener('click', () => pickTable(t.id));
    grid.appendChild(card);
        });
    }

    function pickTable(id) {
        selectedTable = id;
    document.getElementById('hdnTableID').value = id;
    document.getElementById('panelTableNum').textContent = id;
        const t = tables.find(x => x.id === id);
    updatePanelPreview(t);
    renderGrid();
    }

    function updatePanelPreview(t) {
        const preview = document.getElementById('panelPreview');
    const old = preview.querySelector('svg');
    if (old) old.remove();
    preview.insertAdjacentHTML('afterbegin', poolSVG(false));
    document.getElementById('panelReservedOverlay')
    .classList.toggle('show', t && t.reserved);
    }

    // ── RENTAL SELECTION ───────────────────────────────────────
    function selectRental(type) {
        selectedRental = type;
    document.getElementById('rentalRental').classList.toggle('selected', type === 'Rental Time');
    document.getElementById('rentalOpen').classList.toggle('selected', type === 'Open Time');
    }

    // ── STEP NAVIGATION ────────────────────────────────────────
    const PROGRESS = {1: '25%', 2: '50%', 3: '75%', 4: '100%' };

    function goStep(n) {
        // Validate before advancing
        if (n > currentStep) {
            if (currentStep === 1 && !validateStep1()) return;
    if (currentStep === 2 && !validateStep2()) return;
        }

    // Populate summary when going to step 3
    if (n === 3) populateSummary();

        document.querySelectorAll('.step').forEach(s => s.classList.remove('active'));
    document.getElementById('step' + n).classList.add('active');
    document.getElementById('progressFill').style.width = PROGRESS[n];
    document.getElementById('hdnStep').value = n;
    currentStep = n;
    }

    // ── VALIDATION ─────────────────────────────────────────────
    function validateStep1() {
        const time = val('txtTime'), date = val('txtDate');
    if (!time) {alert('Please enter a time.'); return false; }
    if (!date) {alert('Please select a date.'); return false; }

    const guestName = val('txtGuestName');
    const contact = val('txtContact');
    if (!guestName) {alert('Please enter a guest name.'); return false; }
    if (!contact) {alert('Please enter a contact number.'); return false; }
    return true;
    }

    function validateStep2() {
        if (!selectedRental) {alert('Please select a rental type.'); return false; }
    return true;
    }

    // ── POPULATE SUMMARY ───────────────────────────────────────
    function populateSummary() {
        const date = val('txtDate');
    const time = val('txtTime');
    const name = val('txtGuestName');
    const contact = val('txtContact');
    const guests = val('txtGuests') || '1';
    const discount = document.getElementById('discountToggle').checked;
    const baseRate = selectedRental === 'Rental Time' ? 300 : 500;
    const finalRate = discount ? (baseRate - 50) : baseRate;
    const rateLabel = selectedRental === 'Rental Time'
    ? `₱ ${finalRate}/hr${discount ? ' (discounted)' : ''}`
    : `₱ ${finalRate} flat${discount ? ' (discounted)' : ''}`;

    setText('summaryDate', date);
    setText('summaryTime', time);
    setText('summaryTable', 'Table ' + selectedTable);
    setText('summaryRental', selectedRental);
    setText('summaryName', name);
    setText('summaryContact', contact);
    setText('summaryGuests', guests);
    setText('summaryRates', rateLabel);

    // Sync hidden fields for postback
    setHdn('hdnTime', time);
    setHdn('hdnDate', date);
    setHdn('hdnRental', selectedRental);
    setHdn('hdnGuests', guests);
    setHdn('hdnGuestName', name);
    setHdn('hdnContact', contact);
    setHdn('hdnDiscount', discount ? '1' : '0');
    }

    function prepareConfirm() {
        populateSummary();
    return true; // allow postback
    }

    // ── SUCCESS (called after postback if needed, or client-side demo) ──
    function showSuccess() {
        const date = getHdn('hdnDate');
    const time = getHdn('hdnTime');
    const tbl = getHdn('hdnTableID');
    const name = getHdn('hdnGuestName');
    document.getElementById('successSummary').innerHTML = `
    <div><span>Name: </span><strong>${name}</strong> &nbsp; <span>Table: </span><strong>${tbl}</strong></div>
    <div><span>Date: </span><strong>${date}</strong></div>
    <div><span>Time: </span><strong>${time}</strong></div>`;
    goStep(4);
    }

    function resetReservation() {
        selectedTable = 1;
    selectedRental = 'Rental Time';
        ['txtTime', 'txtDate', 'txtGuestName', 'txtContact', 'txtGuests'].forEach(id => {
            const el = document.querySelector('[id$="' + id + '"]');
    if (el) el.value = '';
        });
    document.getElementById('discountToggle').checked = false;
    renderGrid();
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
    function val(id) {
        const el = document.querySelector('[id$="' + id + '"]');
    return el ? el.value.trim() : '';
    }

    function setText(id, text) {
        const el = document.getElementById(id);
    if (el) el.textContent = text;
    }

    function setHdn(id, value) {
        const el = document.getElementById(id);
    if (el) el.value = value;
    }

    function getHdn(id) {
        const el = document.getElementById(id);
    return el ? el.value : '';
    }

    // ── INIT ───────────────────────────────────────────────────
    document.addEventListener('DOMContentLoaded', () => {
        renderGrid();
    updatePanelPreview(tables[0]);

    const d = document.querySelector('[id$="txtDate"]');
    if (d) d.min = new Date().toISOString().split('T')[0];

    // If server signalled success after postback
    const stepHdn = document.getElementById('hdnStep');
    if (stepHdn && stepHdn.value === '4') showSuccess();
    });