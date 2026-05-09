<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Update Student | HostelMS</title>
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
  .page-title h1 span { color: #f39c12; }
  .page-title p { color: rgba(255,255,255,0.6); margin-top: 8px; }

  .container { max-width: 650px; margin: 0 auto; padding: 0 20px 60px; }

  .alert { border-radius: 12px; padding: 14px 18px; margin-bottom: 18px; font-size: 0.95rem; }
  .alert-success { background: rgba(39,174,96,0.2); border: 1px solid #27ae60; color: #2ecc71; }
  .alert-error   { background: rgba(231,76,60,0.2);  border: 1px solid #e74c3c; color: #ff6b6b; }

  .card { background: rgba(255,255,255,0.08); backdrop-filter: blur(15px);
    border: 1px solid rgba(255,255,255,0.15); border-radius: 20px; padding: 30px; margin-bottom: 24px; }
  .card h2, .card h3 { font-weight: 700; font-size: 1.3rem; margin-bottom: 20px; }
  .card h2 { color: #f39c12; }
  .card h3 { color: #3498db; }

  .search-row { display: flex; gap: 12px; }
  .search-row input { flex: 1; padding: 11px 15px; background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25); border-radius: 10px;
    color: white; font-size: 0.95rem; outline: none; }
  .search-row input::placeholder { color: rgba(255,255,255,0.4); }
  .search-row input:focus { border-color: #3498db; background: rgba(255,255,255,0.15); }
  .btn-search { padding: 11px 24px; background: linear-gradient(45deg,#3498db,#2980b9);
    border: none; border-radius: 10px; color: white; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-search:hover { box-shadow: 0 4px 15px rgba(52,152,219,0.4); transform: translateY(-1px); }

  .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
  @media(max-width:550px) { .row-2 { grid-template-columns: 1fr; } .card { padding: 20px; } }

  .field { margin-bottom: 18px; }
  label { display: block; color: rgba(255,255,255,0.85); font-weight: 500; font-size: 0.9rem; margin-bottom: 7px; }
  label .req { color: #e94560; }
  input[type="text"], input[type="number"], input[type="date"] {
    width: 100%; padding: 11px 15px; background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.25); border-radius: 10px;
    color: white; font-size: 0.95rem; outline: none; transition: all 0.3s; }
  input::placeholder { color: rgba(255,255,255,0.4); }
  input:focus { border-color: #f39c12; background: rgba(255,255,255,0.15); box-shadow: 0 0 0 3px rgba(243,156,18,0.2); }
  input.invalid { border-color: #e74c3c; box-shadow: 0 0 0 3px rgba(231,76,60,0.2); }
  input:disabled { opacity: 0.5; cursor: not-allowed; }
  .err-msg { color: #ff6b6b; font-size: 0.8rem; margin-top: 5px; display: none; }

  .btn-update { width: 100%; padding: 13px; margin-top: 8px;
    background: linear-gradient(45deg, #f39c12, #e67e22);
    border: none; border-radius: 10px; color: white;
    font-size: 1rem; font-weight: 600; cursor: pointer; transition: all 0.3s; }
  .btn-update:hover { box-shadow: 0 5px 20px rgba(243,156,18,0.5); transform: translateY(-2px); }

  .back-links { text-align: center; margin-top: 20px; display: flex; gap: 12px; justify-content: center; }
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
  <h1>✏️ Update <span>Student</span></h1>
  <p>Search and modify student records</p>
</div>

<div class="container">

  <% String success = (String)request.getAttribute("success");
     String error   = (String)request.getAttribute("error");
     if (success != null) { %><div class="alert alert-success">✅ <%= success %></div><% }
     if (error   != null) { %><div class="alert alert-error">❌ <%= error %></div><% } %>

  <!-- Search Card -->
  <div class="card">
    <h3>🔍 Find Student</h3>
    <form action="UpdateStudent" method="get">
      <div class="search-row">
        <input type="number" name="studentID" placeholder="Enter Student ID" min="1" required>
        <button type="submit" class="btn-search">Search</button>
      </div>
    </form>
  </div>

  <!-- Edit Form (shown only when student found) -->
  <% Student s = (Student)request.getAttribute("student");
     if (s != null) { %>
  <div class="card">
    <h2>✏️ Edit Details — ID: <%= s.getStudentID() %></h2>
    <form action="UpdateStudent" method="post" id="updateForm" novalidate>
      <input type="hidden" name="studentID" value="<%= s.getStudentID() %>">

      <div class="field">
        <label>Student ID</label>
        <input type="text" value="<%= s.getStudentID() %>" disabled>
      </div>

      <div class="field">
        <label>Student Name <span class="req">*</span></label>
        <input type="text" name="studentName" id="studentName" value="<%= s.getStudentName() %>" required>
        <div class="err-msg" id="nameErr">Name must contain only letters and spaces.</div>
      </div>

      <div class="row-2">
        <div class="field">
          <label>Room Number <span class="req">*</span></label>
          <input type="text" name="roomNumber" id="roomNumber" value="<%= s.getRoomNumber() %>" required>
          <div class="err-msg" id="roomErr">Room number is required.</div>
        </div>
        <div class="field">
          <label>Admission Date <span class="req">*</span></label>
          <input type="date" name="admissionDate" id="admissionDate" value="<%= s.getAdmissionDate() %>" required>
        </div>
      </div>

      <div class="row-2">
        <div class="field">
          <label>Fees Paid (₹)</label>
          <input type="number" name="feesPaid" id="feesPaid" value="<%= s.getFeesPaid() %>" min="0" step="0.01">
          <div class="err-msg" id="paidErr">Cannot be negative.</div>
        </div>
        <div class="field">
          <label>Pending Fees (₹)</label>
          <input type="number" name="pendingFees" id="pendingFees" value="<%= s.getPendingFees() %>" min="0" step="0.01">
          <div class="err-msg" id="pendingErr">Cannot be negative.</div>
        </div>
      </div>

      <button type="submit" class="btn-update">💾 Update Student</button>
    </form>
  </div>
  <% } %>

  <div class="back-links">
    <a href="index.jsp">← Home</a>
    <a href="DisplayStudents">👥 All Students</a>
  </div>
</div>

<script>
const uf = document.getElementById('updateForm');
if (uf) {
  uf.addEventListener('submit', function(e) {
    let valid = true;
    clearAll();
    const name    = document.getElementById('studentName');
    const room    = document.getElementById('roomNumber');
    const paid    = document.getElementById('feesPaid');
    const pending = document.getElementById('pendingFees');
    if (!name.value.trim() || !/^[a-zA-Z ]+$/.test(name.value.trim())) { mark(name,'nameErr'); valid=false; }
    if (!room.value.trim()) { mark(room,'roomErr'); valid=false; }
    if (parseFloat(paid.value) < 0)    { mark(paid,'paidErr'); valid=false; }
    if (parseFloat(pending.value) < 0) { mark(pending,'pendingErr'); valid=false; }
    if (!valid) e.preventDefault();
  });
}
function mark(f,id){ f.classList.add('invalid'); document.getElementById(id).style.display='block'; }
function clearAll(){ document.querySelectorAll('input').forEach(i=>i.classList.remove('invalid')); document.querySelectorAll('.err-msg').forEach(e=>e.style.display='none'); }
</script>
</body>
</html>