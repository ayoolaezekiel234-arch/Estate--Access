<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <title>NITEL Estate — Access Portal</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    body { background-color: #020617; color: #f8fafc; padding: 12px; display: flex; justify-content: center; }
    .container { width: 100%; max-width: 420px; display: flex; flex-direction: column; gap: 14px; }
    .card { background-color: #0f172a; border: 1px solid #1e293b; border-radius: 16px; padding: 16px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
    .header-row { display: flex; align-items: center; gap: 12px; }
    .logo-badge { width: 48px; height: 48px; border-radius: 12px; object-fit: contain; }
    .logo-fallback { width: 48px; height: 48px; background: #2563eb; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 900; font-size: 16px; color: #fff; }
    .estate-title { font-size: 15px; font-weight: 900; text-transform: uppercase; color: #fff; }
    .estate-motto { font-size: 10px; font-weight: 700; color: #fbbf24; text-transform: uppercase; }
    .hotline-btn { display: flex; align-items: center; justify-content: center; gap: 6px; width: 100%; padding: 10px; margin-top: 10px; background: rgba(136, 19, 55, 0.5); border: 1px solid rgba(244, 63, 94, 0.4); border-radius: 10px; color: #fda4af; font-size: 12px; font-weight: bold; text-decoration: none; }
    
    .nav-bar { display: flex; background: #0f172a; padding: 4px; border-radius: 12px; border: 1px solid #1e293b; gap: 4px; }
    .nav-btn { flex: 1; padding: 10px 4px; border-radius: 8px; font-size: 11px; font-weight: bold; border: none; background: transparent; color: #94a3b8; cursor: pointer; }
    .nav-btn.active-blue { background: #2563eb; color: #fff; }
    .nav-btn.active-green { background: #059669; color: #fff; }
    .nav-btn.active-cyan { background: #0891b2; color: #fff; }

    .form-group { display: flex; flex-direction: column; gap: 4px; margin-top: 10px; }
    .form-row { display: flex; gap: 8px; }
    .form-row > div { flex: 1; }
    label { font-size: 11px; font-weight: 600; color: #cbd5e1; }
    input, select { width: 100%; padding: 10px; background: #020617; border: 1px solid #334155; border-radius: 10px; color: #fff; font-size: 12px; outline: none; margin-top: 2px; }
    
    .passcode-box { background: rgba(30, 58, 138, 0.3); border: 1px solid rgba(59, 130, 246, 0.4); border-radius: 10px; padding: 10px; margin-top: 6px; }
    .btn-action { width: 100%; padding: 14px; border-radius: 12px; font-size: 13px; font-weight: 900; border: none; cursor: pointer; text-transform: uppercase; margin-top: 14px; }
    .btn-blue { background: #2563eb; color: #fff; }
    .btn-green { background: #059669; color: #fff; }

    .result-card { background: #022c22; border: 2px solid #10b981; border-radius: 14px; padding: 14px; text-align: center; margin-top: 14px; display: none; }
    .pin-hero { font-size: 38px; font-weight: 900; font-family: monospace; letter-spacing: 4px; color: #34d399; margin: 4px 0; }
    .timer-hero { font-size: 42px; font-weight: 900; font-family: monospace; color: #34d399; margin: 8px 0; }

    .keypad-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 10px; }
    .keypad-btn { padding: 14px; font-size: 18px; font-weight: bold; background: #1e293b; color: #fff; border: 1px solid #334155; border-radius: 10px; cursor: pointer; }
    .keypad-btn:active { background: #334155; }
  </style>
</head>
<body>

  <div class="container">

    <!-- Header & Hotline -->
    <div class="card">
      <div class="header-row">
        <img src="nitel-logo.png" alt="NITEL" class="logo-badge" onerror="this.style.display='none'; document.getElementById('logo-fallback').style.display='flex';" />
        <div id="logo-fallback" class="logo-fallback" style="display:none;">NE</div>
        <div>
          <div class="estate-title">NITEL Estate</div>
          <div class="estate-motto">Our Home • Our Community • Our Pride</div>
        </div>
      </div>
      <a href="tel:08108429710" class="hotline-btn">
        <span>🚨 Security Hotline: 0810 842 9710</span>
      </a>
    </div>

    <!-- Navigation -->
    <div id="main-nav-bar" class="nav-bar">
      <button id="tab-resident" class="nav-btn active-blue" onclick="switchTab('resident')">Pass Generator</button>
      <button id="tab-guard" class="nav-btn" onclick="switchTab('guard')">🔒 Gate Post</button>
      <button id="tab-pass" class="nav-btn" onclick="switchTab('pass')">My Pass</button>
    </div>

    <!-- 1. RESIDENT PASS GENERATOR -->
    <div id="view-resident" class="card">
      <div style="font-size: 14px; font-weight: bold; color: #60a5fa;">Generate Visitor Pass</div>
      <div style="font-size: 11px; color: #94a3b8; margin-top: 2px;">Verified NITEL Estate Resident Portal</div>

      <div class="passcode-box">
        <label style="color: #93c5fd;">🔑 Resident Verification Passcode</label>
        <input id="res-passcode-auth" type="password" placeholder="Enter Resident Passcode" />
      </div>

      <div class="form-row form-group">
        <div>
          <label>Host Resident Name</label>
          <input id="res-host-name" type="text" placeholder="e.g. Mr. Adeleke" />
        </div>
        <div>
          <label>Host Phone Number</label>
          <input id="res-host-phone" type="tel" placeholder="e.g. 08031234567" />
        </div>
      </div>

      <div class="form-row form-group">
        <div>
          <label>Avenue / Road</label>
          <select id="res-zone-select">
            <optgroup label="Avenues (1 – 5)">
              <option value="Avenue 1">Avenue 1</option>
              <option value="Avenue 2">Avenue 2</option>
              <option value="Avenue 3">Avenue 3</option>
              <option value="Avenue 4">Avenue 4</option>
              <option value="Avenue 5">Avenue 5</option>
            </optgroup>
            <optgroup label="Roads (A – U)">
              <option value="Road A">Road A</option>
              <option value="Road B">Road B</option>
              <option value="Road C">Road C</option>
              <option value="Road D">Road D</option>
              <option value="Road E">Road E</option>
              <option value="Road F">Road F</option>
              <option value="Road G">Road G</option>
              <option value="Road H">Road H</option>
              <option value="Road I">Road I</option>
              <option value="Road J">Road J</option>
              <option value="Road K">Road K</option>
              <option value="Road L">Road L</option>
              <option value="Road M">Road M</option>
              <option value="Road N">Road N</option>
              <option value="Road O">Road O</option>
              <option value="Road P">Road P</option>
              <option value="Road Q">Road Q</option>
              <option value="Road R">Road R</option>
              <option value="Road S">Road S</option>
              <option value="Road T">Road T</option>
              <option value="Road U">Road U</option>
            </optgroup>
            <optgroup label="Wings">
              <option value="Main Gate Axis">Main Gate Axis</option>
              <option value="Commercial Wing">Commercial Wing</option>
              <option value="Worship Axis">Worship Center Axis</option>
            </optgroup>
          </select>
        </div>
        <div>
          <label>Plot / House</label>
          <input id="res-house-no" type="text" placeholder="e.g. Plot 12" />
        </div>
      </div>

      <div class="form-group">
        <label>Visitor Full Name</label>
        <input id="res-visitor-name" type="text" placeholder="e.g. Emmanuel Chukwu" />
      </div>

      <div class="form-group">
        <label>Destination & Visit Type</label>
        <select id="res-pass-type">
          <option value="RESIDENTIAL">Residential Guest (24 Hours)</option>
          <option value="ARTISAN">Artisan / Delivery (2 Hours)</option>
          <option value="MOSQUE">Mosque Service (4 Hours)</option>
          <option value="CHURCH">Church Service (4 Hours)</option>
          <option value="SUPERMARKET">Supermarket / Retail (1 Hour)</option>
          <option value="HOTEL">Hotel / Short-let (7 Days)</option>
        </select>
      </div>

      <button type="button" class="btn-action btn-blue" onclick="generatePassSafely()">
        Authorize & Generate Pass
      </button>

      <!-- Output Result -->
      <div id="pass-result" class="result-card">
        <div style="font-size: 10px; font-weight: 800; color: #6ee7b7; text-transform: uppercase;">Access Pass Authorized</div>
        <div id="pass-code-display" class="pin-hero">000000</div>
        <div id="pass-visitor-display" style="font-size: 12px; font-weight: bold; color: #fff;"></div>
        <div id="pass-host-display" style="font-size: 11px; color: #cbd5e1;"></div>
        <div id="pass-validity-display" style="font-size: 11px; color: #fde047; margin-top: 4px;"></div>
        <button type="button" class="btn-action btn-green" onclick="sharePassWhatsApp()">📲 Share via WhatsApp</button>
      </div>
    </div>

    <!-- 2. GUARD TERMINAL -->
    <div id="view-guard" class="card" style="display: none;">
      <div id="guard-auth-box" style="text-align: center;">
        <div style="font-size: 32px;">🛡️</div>
        <div style="font-size: 14px; font-weight: bold; margin-top: 4px;">Gate Security Terminal</div>
        <div style="font-size: 11px; color: #94a3b8;">Enter Security Master PIN to unlock</div>
        <input id="guard-master-pin" type="password" maxlength="4" style="width: 120px; margin: 10px auto; text-align: center; font-size: 20px; font-family: monospace; letter-spacing: 4px;" placeholder="••••" />
        <button type="button" class="btn-action btn-green" onclick="unlockTerminal()">Unlock Keypad</button>
      </div>

      <div id="guard-terminal-box" style="display: none;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <span style="font-size: 12px; font-weight: bold; color: #34d399;">Gate Verification Keypad</span>
          <button type="button" onclick="lockTerminal()" style="background:none; border:none; color:#94a3b8; font-size:10px; text-decoration:underline;">Lock</button>
        </div>

        <div style="background:#000; border:1px solid #334155; padding: 12px; border-radius: 10px; text-align:center; margin: 10px 0;">
          <span id="pin-display" style="font-size: 32px; font-family: monospace; letter-spacing: 4px; color: #34d399;">------</span>
        </div>

        <div class="keypad-grid">
          <button type="button" class="keypad-btn" onclick="pressKey('1')">1</button>
          <button type="button" class="keypad-btn" onclick="pressKey('2')">2</button>
          <button type="button" class="keypad-btn" onclick="pressKey('3')">3</button>
          <button type="button" class="keypad-btn" onclick="pressKey('4')">4</button>
          <button type="button" class="keypad-btn" onclick="pressKey('5')">5</button>
          <button type="button" class="keypad-btn" onclick="pressKey('6')">6</button>
          <button type="button" class="keypad-btn" onclick="pressKey('7')">7</button>
          <button type="button" class="keypad-btn" onclick="pressKey('8')">8</button>
          <button type="button" class="keypad-btn" onclick="pressKey('9')">9</button>
          <button type="button" class="keypad-btn" style="background:#881337;" onclick="clearPin()">CLR</button>
          <button type="button" class="keypad-btn" onclick="pressKey('0')">0</button>
          <button type="button" class="keypad-btn" style="background:#059669;" onclick="verifyGatePass()">ENTER</button>
        </div>

        <div id="gate-result" style="display:none; padding:10px; border-radius:10px; text-align:center; margin-top:10px;"></div>
      </div>
    </div>

    <!-- 3. VISITOR LIVE PASS -->
    <div id="view-pass" class="card" style="display: none; text-align: center;">
      <div style="font-size: 10px; font-weight: 900; color: #34d399; text-transform: uppercase;">NITEL Estate Digital Pass</div>
      <div id="guest-code-hero" class="pin-hero" style="font-size: 32px; color: #fff;">------</div>
      <div id="guest-name-box" style="font-size: 12px; font-weight: bold;"></div>
      <div id="guest-dest-box" style="font-size: 11px; color: #94a3b8; margin-top: 2px;"></div>

      <div style="background: #020617; border: 1px solid #1e293b; padding: 12px; border-radius: 14px; margin: 12px 0;">
        <div style="font-size: 10px; color: #94a3b8; text-transform: uppercase;">Authorized Stay Remaining</div>
        <div id="guest-countdown" class="timer-hero">00:00:00</div>
        <div style="font-size: 11px; color: #94a3b8;">Present PIN at Gate Post</div>
      </div>

      <button id="exit-estate-btn" type="button" class="btn-action btn-rose" style="background:#be123c;" onclick="checkoutVisitor()">🚪 I Have Left Estate</button>
      <div id="exit-confirmed-msg" style="display:none; padding:10px; background:#022c22; border:1px solid #10b981; border-radius:10px; font-size:12px; color:#34d399; font-weight:bold;">
        ✅ Checked Out Successfully
      </div>
    </div>

  </div>

  <script>
    var GUARD_MASTER_PIN = "6232";
    var RESIDENT_PASSCODE = "NITEL2026";

    var enteredPin = "";
    var currentPassCode = "";
    var currentVisitorName = "";
    var currentHostInfo = "";
    var currentExpiry = 0;
    var timerInterval = null;

    function getStorage() {
      try { return JSON.parse(localStorage.getItem("nitel_records") || "[]"); } 
      catch (e) { return []; }
    }

    function saveStorage(arr) {
      try { localStorage.setItem("nitel_records", JSON.stringify(arr.slice(0, 50))); } 
      catch (e) {}
    }

    function switchTab(tab) {
      document.getElementById("view-resident").style.display = (tab === 'resident') ? 'block' : 'none';
      document.getElementById("view-guard").style.display = (tab === 'guard') ? 'block' : 'none';
      document.getElementById("view-pass").style.display = (tab === 'pass') ? 'block' : 'none';

      document.getElementById("tab-resident").className = "nav-btn" + (tab === 'resident' ? ' active-blue' : '');
      document.getElementById("tab-guard").className = "nav-btn" + (tab === 'guard' ? ' active-green' : '');
      document.getElementById("tab-pass").className = "nav-btn" + (tab === 'pass' ? ' active-cyan' : '');
    }

    function generatePassSafely() {
      try {
        var passInput = document.getElementById("res-passcode-auth");
        var hostInput = document.getElementById("res-host-name");
        var phoneInput = document.getElementById("res-host-phone");
        var zoneInput = document.getElementById("res-zone-select");
        var houseInput = document.getElementById("res-house-no");
        var visitorInput = document.getElementById("res-visitor-name");
        var typeInput = document.getElementById("res-pass-type");

        var passKey = passInput ? passInput.value.trim().toUpperCase() : "";
        var host = hostInput ? hostInput.value.trim() : "";
        var phone = phoneInput ? phoneInput.value.trim() : "";
        var zone = zoneInput ? zoneInput.value : "Avenue 1";
        var house = houseInput ? houseInput.value.trim() : "";
        var visitor = visitorInput ? visitorInput.value.trim() : "";
        var type = typeInput ? typeInput.value : "RESIDENTIAL";

        if (!passKey) {
          alert("Please enter the Resident Verification Passcode.");
          return;
        }
        if (passKey !== RESIDENT_PASSCODE) {
          alert("Incorrect Passcode. Use the official NITEL Estate passcode.");
          return;
        }
        if (!visitor) {
          alert("Please enter visitor name.");
          return;
        }

        var code = String(Math.floor(100000 + Math.random() * 900000));
        var hostFull = (host || "Host Resident") + " (" + zone + (house ? " - " + house : "") + ")";
        var durationHours = (type === 'HOTEL') ? 168 : (type === 'RESIDENTIAL' ? 24 : 4);

        currentPassCode = code;
        currentVisitorName = visitor;
        currentHostInfo = hostFull;
        currentExpiry = Date.now() + (durationHours * 3600 * 1000);

        var records = getStorage();
        records.unshift({ code: code, visitor: visitor, host: hostFull, status: "ACTIVE" });
        saveStorage(records);

        document.getElementById("pass-code-display").innerText = code;
        document.getElementById("pass-visitor-display").innerText = "Visitor: " + visitor;
        document.getElementById("pass-host-display").innerText = "Host: " + hostFull + (phone ? " [Tel: " + phone + "]" : "");
        document.getElementById("pass-validity-display").innerText = "⏱️ Authorized for " + durationHours + " Hours";

        var resBox = document.getElementById("pass-result");
        resBox.style.display = "block";
        resBox.scrollIntoView({ behavior: "smooth" });
      } catch (err) {
        alert("Error: " + err.message);
      }
    }

    function sharePassWhatsApp() {
      if (!currentPassCode) return;
      var link = window.location.origin + window.location.pathname + "?code=" + currentPassCode + "&name=" + encodeURIComponent(currentVisitorName) + "&host=" + encodeURIComponent(currentHostInfo) + "&exp=" + currentExpiry;
      var text = "*NITEL ESTATE DIGITAL PASS*\n\n*Visitor:* " + currentVisitorName + "\n*Destination:* " + currentHostInfo + "\n*Access PIN:* " + currentPassCode + "\n\n*Live Gate Link:*\n" + link;
      window.open("https://wa.me/?text=" + encodeURIComponent(text), "_blank");
    }

    function unlockTerminal() {
      var pin = (document.getElementById("guard-master-pin").value || "").trim();
      if (pin === GUARD_MASTER_PIN) {
        document.getElementById("guard-auth-box").style.display = "none";
        document.getElementById("guard-terminal-box").style.display = "block";
      } else {
        alert("Incorrect PIN");
      }
    }

    function lockTerminal() {
      document.getElementById("guard-master-pin").value = "";
      document.getElementById("guard-auth-box").style.display = "block";
      document.getElementById("guard-terminal-box").style.display = "none";
    }

    function pressKey(n) {
      if (enteredPin.length < 6) {
        enteredPin += n;
        document.getElementById("pin-display").innerText = enteredPin.padEnd(6, "-");
      }
    }

    function clearPin() {
      enteredPin = "";
      document.getElementById("pin-display").innerText = "------";
      document.getElementById("gate-result").style.display = "none";
    }

    function verifyGatePass() {
      if (enteredPin.length !== 6) return alert("Enter 6-digit PIN");
      var res = document.getElementById("gate-result");
      res.style.display = "block";

      var records = getStorage();
      var found = records.find(function(r) { return r.code === enteredPin; });

      if (!found) {
        res.style.background = "#450a0a";
        res.style.color = "#fca5a5";
        res.innerHTML = "<b>ACCESS DENIED</b><br><small>Invalid Code</small>";
      } else if (found.status === 'USED') {
        res.style.background = "#451a03";
        res.style.color = "#fcd34d";
        res.innerHTML = "<b>ACCESS DENIED</b><br><small>Pass Already Used</small>";
      } else {
        found.status = 'USED';
        saveStorage(records);
        res.style.background = "#022c22";
        res.style.color = "#6ee7b7";
        res.innerHTML = "<b>ACCESS GRANTED</b><br><small>" + found.visitor + " — " + found.host + "</small>";
      }
    }

    function checkoutVisitor() {
      if (!confirm("Confirm you have exited NITEL Estate?")) return;
      if (timerInterval) clearInterval(timerInterval);
      document.getElementById("exit-estate-btn").style.display = "none";
      document.getElementById("exit-confirmed-msg").style.display = "block";
      document.getElementById("guest-countdown").innerText = "EXITED";
    }

    function runTimer(exp) {
      var disp = document.getElementById("guest-countdown");
      if (timerInterval) clearInterval(timerInterval);
      function update() {
        var diff = exp - Date.now();
        if (diff <= 0) {
          clearInterval(timerInterval);
          disp.innerText = "EXPIRED";
          disp.style.color = "#f43f5e";
          return;
        }
        var s = Math.floor(diff / 1000);
        var hrs = Math.floor(s / 3600);
        var mins = Math.floor((s % 3600) / 60);
        var secs = s % 60;
        disp.innerText = (hrs < 10 ? '0' : '') + hrs + ":" + (mins < 10 ? '0' : '') + mins + ":" + (secs < 10 ? '0' : '') + secs;
      }
      update();
      timerInterval = setInterval(update, 1000);
    }

    window.onload = function() {
      var urlParams = new URLSearchParams(window.location.search);
      var code = urlParams.get("code");
      var name = urlParams.get("name");
      var host = urlParams.get("host");
      var exp = urlParams.get("exp");

      if (code) {
        document.getElementById("main-nav-bar").style.display = "none";
        switchTab("pass");
        document.getElementById("guest-code-hero").innerText = code;
        if (name) document.getElementById("guest-name-box").innerText = "Visitor: " + name;
        if (host) document.getElementById("guest-dest-box").innerText = "Host: " + host;
        runTimer(exp ? parseInt(exp) : (Date.now() + 4 * 3600 * 1000));
      }
    };
  </script>
</body>
</html>
