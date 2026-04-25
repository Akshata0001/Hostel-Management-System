<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports – HMS</title>
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
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &rsaquo; Reports
    </div>
    <h1>📊 Reports &amp; Analytics</h1>
    <p>Generate targeted reports to assist administrative decisions.</p>
  </div>

  <div class="report-grid">

    <!-- Report 1: Pending Fees -->
    <div class="report-card orange">
      <div class="report-icon">💰</div>
      <h3>Pending Fees Report</h3>
      <p>View all students who have outstanding balances, sorted by highest pending amount first.</p>
      <a href="<%= request.getContextPath() %>/report?reportType=pending" class="btn btn-warning">
        ▶ Run Report
      </a>
    </div>

    <!-- Report 2: By Room -->
    <div class="report-card">
      <div class="report-icon">🚪</div>
      <h3>Students by Room</h3>
      <p>Filter students assigned to a specific room number to view occupancy and fee status.</p>
      <a href="<%= request.getContextPath() %>/reportCriteria?type=room" class="btn btn-primary">
        ▶ Run Report
      </a>
    </div>

    <!-- Report 3: Date Range -->
    <div class="report-card green">
      <div class="report-icon">📅</div>
      <h3>Admissions by Date Range</h3>
      <p>List all students admitted within a specified date range for batch reporting.</p>
      <a href="<%= request.getContextPath() %>/reportCriteria?type=date" class="btn btn-success">
        ▶ Run Report
      </a>
    </div>

    <!-- Report 4: Custom (link to form with all options) -->
    <div class="report-card" style="border-color:#7b1fa2;">
      <div class="report-icon">🔍</div>
      <h3>Custom Report Builder</h3>
      <p>Use the full report form to choose any filter — room, date range, or pending fees.</p>
      <a href="<%= request.getContextPath() %>/reportCriteria" class="btn btn-secondary"
         style="background:#7b1fa2;">
        ▶ Open Builder
      </a>
    </div>

  </div><!-- /report-grid -->

  <!-- Quick link: all students -->
  <div class="card mt-24" style="display:flex; align-items:center; gap:16px; flex-wrap:wrap;">
    <span style="font-size:1.8rem;">📄</span>
    <div>
      <strong>Full Student List</strong>
      <p class="text-muted">View the complete, unfiltered student roster with all details.</p>
    </div>
    <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-outline" style="margin-left:auto;">
      View All Students →
    </a>
  </div>

</div>

<footer class="footer">&copy; 2026 Hostel Management System</footer>
</body>
</html>
