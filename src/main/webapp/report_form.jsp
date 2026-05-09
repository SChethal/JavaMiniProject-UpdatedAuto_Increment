<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Reports | HostelMS</title>
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
  .page-title h1 span { color: #a29bfe; }
  .page-title p { color: rgba(255,255,255,0.6); margin-top: 8px; }

  .container { max-width: 680px; margin: 0 auto; padding: 0 20px 60px; }

  /* Quick cards */
  .quick-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 16px; margin-bottom: 28px; }
  @media(max-width:520px) { .quick-grid { grid-template-columns: 1fr; } }
  .quick-card { background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.12);
    border-radius: 16px; padding: 20px 15px; text-align: center; cursor: pointer; transition: all 0.3s; }
  .quick-card:hover, .quick-card.active { border-color: #a29bfe; background: rgba(162,155,254,0.18);
    transform: translateY(-4px); }
  .quick-card .icon { font-size: 2rem; display: block; margin-bottom: 10px; }
  .quick-card h4 { color: #a29bfe; font-size: 0.95rem; font-weight: 700; margin-bottom: 6px; }
  .quick-card p { color: rgba(255,255,255,0.5); font-size: 0.78rem; line-height: 1.4; }

  /* Form card */
  .form-card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 35px; }
  .form-card h3 { color: #a29bfe; font-weight: 700; font-size: 1.25rem; margin-bottom: 24px; }

  .field { margin-bottom: 20px; }
  label { display: block; color: rgba(255,255,255,0.85); font-weight: 500;
    font-size: 0.9rem; margin-bottom: 7px; }
  label .req { color: #e94560; }
  select, input[type="text"], input[type="date"] {
    width: 100%; padding: 11px 15px; background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25); border-radius: 10px;
    color: white; font-size: 0.95rem; outline: none; transition: all 0.3s; }
  select option { background: #1a1a2e; }
  select:focus, input:focus { border-color: #a29bfe; background: rgba(255,255,255,0.15);
    box-shadow: 0 0 0 3px rgba(162,155,254,0.2); }

  .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
  @media(max-width:520px) { .row-2 { grid-template-columns: 1fr; } }

  #roomFields, #dateFields { display: none; }

  .btn-generate { width: 100%; padding: 13px; margin-top: 8px;
    background: linear-gradient(45deg, #a29bfe, #6c5ce7);
    border: none; border-radius: 10px; color: white;
    font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-generate:hover { box-shadow: 0 5px 20px rgba(162,155,254,0.5); transform: translateY(-2px); }

  .back-links { text-align: center; margin-top: 20px; }
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
  </div>
</nav>

<div class="page-title">
  <h1>📊 Generate <span>Reports</span></h1>
  <p>Analyze hostel data with dynamic reports</p>
</div>

<div class="container">

  <!-- Quick Select Cards -->
  <div class="quick-grid">
    <div class="quick-card" onclick="selectReport('pending')">
      <span class="icon">⚠️</span>
      <h4>Pending Fees</h4>
      <p>Students with outstanding balance</p>
    </div>
    <div class="quick-card" onclick="selectReport('room')">
      <span class="icon">🚪</span>
      <h4>By Room</h4>
      <p>Students in a specific room</p>
    </div>
    <div class="quick-card" onclick="selectReport('date')">
      <span class="icon">📅</span>
      <h4>By Date</h4>
      <p>Admissions in a date range</p>
    </div>
  </div>

  <!-- Form -->
  <div class="form-card">
    <h3>🔧 Report Options</h3>
    <form action="Report" method="post" id="reportForm" novalidate>

      <div class="field">
        <label>Report Type <span class="req">*</span></label>
        <select name="reportType" id="reportType" onchange="toggleFields()">
          <option value="">-- Select Report Type --</option>
          <option value="pending">Students with Pending Fees</option>
          <option value="room">Students by Room Number</option>
          <option value="date">Students by Admission Date Range</option>
        </select>
      </div>

      <div id="roomFields" class="field">
        <label>Room Number</label>
        <input type="text" name="roomNumber" id="roomNumber" placeholder="e.g. A101">
      </div>

      <div id="dateFields">
        <div class="row-2">
          <div class="field">
            <label>From Date</label>
            <input type="date" name="fromDate" id="fromDate">
          </div>
          <div class="field">
            <label>To Date</label>
            <input type="date" name="toDate" id="toDate">
          </div>
        </div>
      </div>

      <button type="submit" class="btn-generate">▶ Generate Report</button>
    </form>
  </div>

  <div class="back-links">
    <a href="index.jsp">← Home</a>
  </div>
</div>

<script>
function toggleFields() {
  const t = document.getElementById('reportType').value;
  document.getElementById('roomFields').style.display = t === 'room' ? 'block' : 'none';
  document.getElementById('dateFields').style.display = t === 'date' ? 'block' : 'none';
  document.querySelectorAll('.quick-card').forEach(c => c.classList.remove('active'));
  const map = { pending: 0, room: 1, date: 2 };
  if (t in map) document.querySelectorAll('.quick-card')[map[t]].classList.add('active');
}
function selectReport(type) {
  document.getElementById('reportType').value = type;
  toggleFields();
}
document.getElementById('reportForm').addEventListener('submit', function(e) {
  const t = document.getElementById('reportType').value;
  if (!t) { e.preventDefault(); alert('Please select a report type!'); return; }
  if (t === 'room' && !document.getElementById('roomNumber').value.trim()) {
    e.preventDefault(); alert('Please enter a room number!'); return;
  }
  if (t === 'date') {
    const f = document.getElementById('fromDate').value;
    const to = document.getElementById('toDate').value;
    if (!f || !to) { e.preventDefault(); alert('Please enter both From and To dates!'); return; }
    if (new Date(f) > new Date(to)) { e.preventDefault(); alert('From date cannot be after To date!'); }
  }
});
</script>
</body>
</html>