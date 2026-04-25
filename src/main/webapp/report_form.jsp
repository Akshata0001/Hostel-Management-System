<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Report Filters – HMS</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<header class="navbar">
  <a href="<%= request.getContextPath() %>/index.jsp" class="brand">
    <span class="icon">🏨</span> Hostel Management System
  </a>
  <nav>
    <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
    <a href="<%= request.getContextPath() %>/displayStudents">Students</a>
    <a href="<%= request.getContextPath() %>/reports.jsp" class="active">Reports</a>
  </nav>
</header>

<div class="page-wrapper">

  <div class="page-header">
    <div class="breadcrumb">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &rsaquo;
      <a href="<%= request.getContextPath() %>/reports.jsp">Reports</a> &rsaquo;
      Report Builder
    </div>
    <h1>🔍 Report Builder</h1>
    <p>Select a report type and supply the required filters, then generate the results.</p>
  </div>

  <%-- Error --%>
  <% String err = (String) request.getAttribute("errorMessage");
     if (err != null && !err.isEmpty()) { %>
  <div class="alert alert-error">⚠️ <%= err %></div>
  <% } %>

  <%
    String preType = request.getParameter("type");   // pre-select tab if arriving from reports.jsp
    @SuppressWarnings("unchecked")
    List<String> rooms = (List<String>) request.getAttribute("roomNumbers");
  %>

  <!-- Report type tabs -->
  <div style="display:flex; gap:10px; flex-wrap:wrap; margin-bottom:24px;">
    <button onclick="showTab('pending')" id="btn-pending" class="btn btn-warning">💰 Pending Fees</button>
    <button onclick="showTab('room')"    id="btn-room"    class="btn btn-primary">🚪 By Room</button>
    <button onclick="showTab('date')"    id="btn-date"    class="btn btn-success">📅 By Date Range</button>
  </div>

  <!-- ======== Tab 1: Pending Fees ======== -->
  <div id="tab-pending" class="card report-tab">
    <div class="card-title">💰 Pending Fees Report</div>
    <p style="margin-bottom:20px; color:var(--muted);">
      Returns all students who have a pending fee balance greater than ₹0, sorted by highest outstanding amount.
    </p>
    <form action="<%= request.getContextPath() %>/report" method="post">
      <input type="hidden" name="reportType" value="pending">
      <div class="form-actions">
        <button type="submit" class="btn btn-warning">▶ Generate Report</button>
      </div>
    </form>
  </div>

  <!-- ======== Tab 2: By Room ======== -->
  <div id="tab-room" class="card report-tab" style="display:none;">
    <div class="card-title">🚪 Students by Room Number</div>
    <form action="<%= request.getContextPath() %>/report" method="post">
      <input type="hidden" name="reportType" value="room">
      <div class="form-grid" style="max-width:520px;">
        <div class="form-group">
          <label for="roomSelect">Select Room <span class="req">*</span></label>
          <% if (rooms != null && !rooms.isEmpty()) { %>
          <select id="roomSelect" name="roomNumber" class="form-control" required>
            <option value="">-- Select a Room --</option>
            <% for (String r : rooms) { %>
            <option value="<%= r %>"><%= r %></option>
            <% } %>
          </select>
          <% } else { %>
          <input type="text" id="roomNumber" name="roomNumber" class="form-control"
                 placeholder="e.g. A101" required>
          <% } %>
        </div>
        <div class="form-group">
          <label style="visibility:hidden;">or type it</label>
          <input type="text" id="roomManual" name="roomNumber" class="form-control"
                 placeholder="Or type room no."
                 <% if (rooms != null && !rooms.isEmpty()) { %>style="display:none;"<% } %>>
        </div>
      </div>
      <div class="form-actions">
        <button type="submit" class="btn btn-primary">▶ Generate Report</button>
      </div>
    </form>
  </div>

  <!-- ======== Tab 3: Date Range ======== -->
  <div id="tab-date" class="card report-tab" style="display:none;">
    <div class="card-title">📅 Students by Admission Date Range</div>
    <form action="<%= request.getContextPath() %>/report" method="post" id="dateForm">
      <input type="hidden" name="reportType" value="dateRange">
      <div class="form-grid" style="max-width:620px;">
        <div class="form-group">
          <label for="startDate">Start Date <span class="req">*</span></label>
          <input type="date" id="startDate" name="startDate" class="form-control" required>
        </div>
        <div class="form-group">
          <label for="endDate">End Date <span class="req">*</span></label>
          <input type="date" id="endDate" name="endDate" class="form-control" required>
        </div>
      </div>
      <div class="form-actions">
        <button type="submit" class="btn btn-success">▶ Generate Report</button>
      </div>
    </form>
  </div>

</div>

<footer class="footer">&copy; 2026 Hostel Management System</footer>

<script>
function showTab(name) {
  document.querySelectorAll('.report-tab').forEach(t => t.style.display = 'none');
  document.getElementById('tab-' + name).style.display = '';
  // highlight active button
  ['pending','room','date'].forEach(n => {
    const btn = document.getElementById('btn-' + n);
    btn.style.opacity = (n === name) ? '1' : '0.55';
  });
}

// Date range validation
const df = document.getElementById('dateForm');
if (df) {
  df.addEventListener('submit', function(e) {
    const s = new Date(document.getElementById('startDate').value);
    const en = new Date(document.getElementById('endDate').value);
    if (s > en) {
      e.preventDefault();
      alert('Start date must be on or before end date.');
    }
  });
}

// Auto-select tab based on query param
const urlParams = new URLSearchParams(window.location.search);
const preType = urlParams.get('type') || 'pending';
showTab(preType === 'date' ? 'date' : preType === 'room' ? 'room' : 'pending');
</script>
</body>
</html>
