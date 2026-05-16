<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Student | HostelMS</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body { background: linear-gradient(135deg, #1a1a2e, #0f3460);
    min-height: 100vh; font-family: 'Segoe UI', sans-serif; }

  nav { background: rgba(255,255,255,0.05); backdrop-filter: blur(10px);
    border-bottom: 1px solid rgba(255,255,255,0.1); padding: 15px 40px;
    display: flex; justify-content: space-between; align-items: center; }
  .brand { font-size: 1.4rem; font-weight: 700; color: #e94560; text-decoration: none; }
  .nav-links { display: flex; gap: 10px; }
  .nav-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 6px 14px;
    border: 1px solid rgba(255,255,255,0.2); border-radius: 20px; font-size: 0.88rem; transition: all 0.3s; }
  .nav-links a:hover { color: white; border-color: #e94560; background: rgba(233,69,96,0.15); }

  .page-title { text-align: center; padding: 40px 20px 20px; color: white; }
  .page-title h1 { font-size: 2.2rem; font-weight: 800; }
  .page-title h1 span { color: #e94560; }
  .page-title p { color: rgba(255,255,255,0.6); margin-top: 8px; }

  .container { max-width: 650px; margin: 0 auto; padding: 0 20px 60px; }

  .alert { border-radius: 12px; padding: 16px 20px; margin-bottom: 20px;
    font-size: 0.95rem; line-height: 1.6; font-weight: 500; }
  .alert-success { background: rgba(39,174,96,0.2); border: 1px solid #27ae60; color: #2ecc71; }
  .alert-error   { background: rgba(231,76,60,0.2); border: 1px solid #e74c3c; color: #ff6b6b; }

  .form-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 40px; }
  .form-card h2 { color: #e94560; font-weight: 700; font-size: 1.5rem; margin-bottom: 28px; }

  .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
  @media(max-width:550px) { .row-2 { grid-template-columns: 1fr; } .form-card { padding: 25px; } }

  .field { margin-bottom: 20px; }
  label { display: block; color: rgba(255,255,255,0.85); font-weight: 500;
    font-size: 0.9rem; margin-bottom: 7px; }
  label .req { color: #e94560; }

  input[type="text"], input[type="number"], input[type="date"] {
    width: 100%; padding: 11px 15px;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25);
    border-radius: 10px; color: white;
    font-size: 0.95rem; transition: all 0.3s; outline: none; }
  input::placeholder { color: rgba(255,255,255,0.4); }
  input:focus { border-color: #e94560; background: rgba(255,255,255,0.15);
    box-shadow: 0 0 0 3px rgba(233,69,96,0.2); }
  input.invalid { border-color: #e74c3c !important;
    box-shadow: 0 0 0 3px rgba(231,76,60,0.2) !important; }

  /* ── READONLY AUTO-ID ── */
  input[readonly] {
    background: rgba(233,69,96,0.12) !important;
    border: 1px solid rgba(233,69,96,0.5) !important;
    color: #e94560 !important;
    font-weight: 700; cursor: not-allowed; }
  .id-hint { font-size: 0.78rem; color: rgba(233,69,96,0.8); margin-top: 5px; }

  .err-msg { color: #ff6b6b; font-size: 0.8rem; margin-top: 5px; display: none; }

  /* ── ROOM DUPLICATE WARNING (client-side hint) ── */
  .room-dup-warn {
    display: none;
    background: rgba(231,76,60,0.18);
    border: 1px solid rgba(231,76,60,0.6);
    border-radius: 10px;
    padding: 10px 14px;
    margin-top: 8px;
    color: #ff6b6b;
    font-size: 0.82rem;
    font-weight: 600;
  }
  .room-dup-warn::before { content: "🚫 "; }

  .btn-submit { width: 100%; padding: 13px; margin-top: 8px;
    background: linear-gradient(45deg, #e94560, #c0392b);
    border: none; border-radius: 10px; color: white;
    font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-submit:hover { box-shadow: 0 5px 20px rgba(233,69,96,0.5); transform: translateY(-2px); }

  .back-links { text-align: center; margin-top: 20px;
    display: flex; gap: 12px; justify-content: center; }
  .back-links a { color: rgba(255,255,255,0.7); text-decoration: none; padding: 8px 20px;
    border: 1px solid rgba(255,255,255,0.25); border-radius: 20px; font-size: 0.88rem; transition: all 0.3s; }
  .back-links a:hover { color: white; background: rgba(255,255,255,0.1); }
</style>
</head>
<body>

<nav>
  <a class="brand" href="index.jsp">🏨 HostelMS</a>
  <div class="nav-links">
    <a href="index.jsp">🏠 Home</a>
    <a href="DisplayStudents">👥 Students</a>
    <a href="Report">📊 Reports</a>
  </div>
</nav>

<div class="page-title">
  <h1>➕ Add <span>New Student</span></h1>
  <p>Register a new hostel student</p>
</div>

<div class="container">

  <%
    String success  = (String)  request.getAttribute("success");
    String error    = (String)  request.getAttribute("error");
    Integer nextID  = (Integer) request.getAttribute("nextID");
    if (nextID == null) nextID = 1;

    // Retain filled values on error
    String fName    = request.getAttribute("formName")    != null ? (String)request.getAttribute("formName")    : "";
    String fRoom    = request.getAttribute("formRoom")    != null ? (String)request.getAttribute("formRoom")    : "";
    String fDate    = request.getAttribute("formDate")    != null ? (String)request.getAttribute("formDate")    : "";
    String fPaid    = request.getAttribute("formPaid")    != null ? (String)request.getAttribute("formPaid")    : "";
    String fPending = request.getAttribute("formPending") != null ? (String)request.getAttribute("formPending") : "";
  %>

  <% if (success != null) { %>
    <div class="alert alert-success">✅ <%= success %></div>
  <% } %>
  <% if (error != null) { %>
    <div class="alert alert-error">❌ <%= error %></div>
  <% } %>

  <div class="form-card">
    <h2>📋 Student Registration</h2>
    <form action="AddStudent" method="post" id="addForm" novalidate>

      <div class="row-2">
        <!-- AUTO ID: readonly -->
        <div class="field">
          <label>Student ID <span style="color:#a29bfe;font-size:0.78rem;">(Auto-assigned)</span></label>
          <input type="number" name="studentID" value="<%= nextID %>" readonly>
          <div class="id-hint">🔒 Auto-assigned by system</div>
        </div>

        <div class="field">
          <label>Student Name <span class="req">*</span></label>
          <input type="text" name="studentName" id="studentName"
                 placeholder="e.g. Rahul Sharma"
                 value="<%= fName %>">
          <div class="err-msg" id="nameErr">Name must contain only letters and spaces.</div>
        </div>
      </div>

      <div class="row-2">
        <div class="field">
          <label>Room Number <span class="req">*</span></label>
          <input type="text" name="roomNumber" id="roomNumber"
                 placeholder="e.g. A101"
                 value="<%= fRoom %>"
                 oninput="this.value=this.value.toUpperCase(); liveRoomCheck(this.value);"
                 autocomplete="off">
          <div class="err-msg"    id="roomErr">Room must be alphanumeric (e.g. A101).</div>
          <div class="room-dup-warn" id="roomDupWarn">
            Room already occupied! Choose a different room.
          </div>
        </div>

        <div class="field">
          <label>Admission Date <span class="req">*</span></label>
          <input type="date" name="admissionDate" id="admissionDate"
                 value="<%= fDate %>">
          <div class="err-msg" id="dateErr">Admission date is required.</div>
        </div>
      </div>

      <div class="row-2">
        <div class="field">
          <label>Fees Paid (₹) <span class="req">*</span></label>
          <input type="number" name="feesPaid" id="feesPaid"
                 placeholder="e.g. 15000" min="0" step="0.01"
                 value="<%= fPaid %>"
                 oninput="if(this.value < 0) this.value = 0;">
          <div class="err-msg" id="paidErr">Fees Paid must be 0 or more.</div>
        </div>
        <div class="field">
          <label>Pending Fees (₹) <span class="req">*</span></label>
          <input type="number" name="pendingFees" id="pendingFees"
                 placeholder="e.g. 5000" min="0" step="0.01"
                 value="<%= fPending %>"
                 oninput="if(this.value < 0) this.value = 0;">
          <div class="err-msg" id="pendingErr">Pending Fees must be 0 or more.</div>
        </div>
      </div>

      <button type="submit" class="btn-submit">💾 Register Student</button>
    </form>
  </div>

  <div class="back-links">
    <a href="index.jsp">← Back to Home</a>
    <a href="DisplayStudents">👥 View All Students</a>
  </div>
</div>

<script>
// ── Load all used rooms once (for live client-side hint) ──────────
let usedRooms = [];

(function loadUsedRooms() {
  const xhr = new XMLHttpRequest();
  xhr.open('GET', 'DisplayStudents', true);
  xhr.onload = function() {
    if (xhr.status === 200) {
      const matches = xhr.responseText.matchAll(/class="room-tag">([^<]+)<\/span>/g);
      for (const m of matches) {
        usedRooms.push(m[1].trim().toUpperCase());
      }
    }
  };
  xhr.send();
})();

function liveRoomCheck(val) {
  const warn = document.getElementById('roomDupWarn');
  const input = document.getElementById('roomNumber');
  if (val.length >= 2 && usedRooms.includes(val.trim().toUpperCase())) {
    warn.style.display = 'block';
    input.classList.add('invalid');
  } else {
    warn.style.display = 'none';
    input.classList.remove('invalid');
  }
}

// ── Client-side form validation ───────────────────────────────────
document.getElementById('addForm').addEventListener('submit', function(e) {
  let valid = true;
  clearAll();

  const name    = document.getElementById('studentName');
  const room    = document.getElementById('roomNumber');
  const date    = document.getElementById('admissionDate');
  const paid    = document.getElementById('feesPaid');
  const pending = document.getElementById('pendingFees');

  if (!name.value.trim() || !/^[a-zA-Z ]+$/.test(name.value.trim())) {
    mark(name, 'nameErr', 'Name must contain only letters and spaces.'); valid = false;
  }
  if (!room.value.trim() || !/^[A-Za-z0-9]+$/.test(room.value.trim())) {
    mark(room, 'roomErr', 'Room must be alphanumeric (e.g. A101).'); valid = false;
  }
  // Block submit if live-check already flagged this room
  if (usedRooms.includes(room.value.trim().toUpperCase())) {
    mark(room, 'roomErr', 'Room ' + room.value.trim().toUpperCase() + ' is already occupied!');
    document.getElementById('roomDupWarn').style.display = 'block';
    valid = false;
  }
  if (!date.value) {
    mark(date, 'dateErr', 'Admission date is required.'); valid = false;
  }
  if (paid.value === '' || parseFloat(paid.value) < 0) {
    mark(paid, 'paidErr', 'Fees Paid must be 0 or more.'); valid = false;
  }
  if (pending.value === '' || parseFloat(pending.value) < 0) {
    mark(pending, 'pendingErr', 'Pending Fees must be 0 or more.'); valid = false;
  }

  if (!valid) e.preventDefault();
});

function mark(field, errId, msg) {
  field.classList.add('invalid');
  const el = document.getElementById(errId);
  el.innerText = msg;
  el.style.display = 'block';
}
function clearAll() {
  document.querySelectorAll('input').forEach(i => i.classList.remove('invalid'));
  document.querySelectorAll('.err-msg').forEach(e => e.style.display = 'none');
  document.getElementById('roomDupWarn').style.display = 'none';
}
</script>
</body>
</html>