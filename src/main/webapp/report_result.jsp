<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.model.Student, java.util.List, java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Report Results – HMS</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
  <style>
    @media print {
      .navbar, .footer, .no-print { display: none !important; }
      .page-wrapper { margin: 0; padding: 0; }
      table { font-size: 12px; }
    }
  </style>
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
      Results
    </div>
    <h1>📊 Report Results</h1>
  </div>

  <%
    String err         = (String) request.getAttribute("errorMessage");
    String reportTitle = (String) request.getAttribute("reportTitle");
    String reportType  = (String) request.getAttribute("reportType");
    @SuppressWarnings("unchecked")
    List<Student> results = (List<Student>) request.getAttribute("results");
  %>

  <%-- Error --%>
  <% if (err != null && !err.isEmpty()) { %>
  <div class="alert alert-error">⚠️ <%= err %>
    <a href="<%= request.getContextPath() %>/reportCriteria" class="btn btn-outline btn-sm" style="margin-left:10px;">← Back to Filters</a>
  </div>
  <% } %>

  <% if (results != null) { %>

  <!-- Report header card -->
  <div class="card" style="background:linear-gradient(135deg,#1a3a5c,#122840); color:#fff; padding:20px 28px; margin-bottom:24px;">
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
      <div>
        <div style="font-size:.8rem; color:rgba(255,255,255,.65); text-transform:uppercase; letter-spacing:.8px;">Report</div>
        <div style="font-size:1.25rem; font-weight:700; margin-top:4px;"><%= reportTitle %></div>
        <div style="font-size:.85rem; color:rgba(255,255,255,.7); margin-top:4px;">
          Generated: <%= new java.util.Date() %>
        </div>
      </div>
      <div class="no-print" style="display:flex; gap:10px; flex-wrap:wrap;">
        <button onclick="window.print()" class="btn btn-outline" style="border-color:rgba(255,255,255,.5); color:#fff;">🖨️ Print</button>
        <a href="<%= request.getContextPath() %>/reportCriteria" class="btn btn-outline"
           style="border-color:rgba(255,255,255,.5); color:#fff;">← New Report</a>
      </div>
    </div>
  </div>

  <% if (results.isEmpty()) { %>
  <div class="card no-results">
    <div class="no-icon">🔍</div>
    <p>No records match the selected criteria.</p>
    <a href="<%= request.getContextPath() %>/reportCriteria" class="btn btn-primary mt-16">← Try Different Filters</a>
  </div>

  <% } else {
       // Compute totals for this result set
       BigDecimal totalPaid    = BigDecimal.ZERO;
       BigDecimal totalPending = BigDecimal.ZERO;
       for (Student st : results) {
         if (st.getFeesPaid()    != null) totalPaid    = totalPaid.add(st.getFeesPaid());
         if (st.getPendingFees() != null) totalPending = totalPending.add(st.getPendingFees());
       }
  %>

  <!-- Summary cards for this result set -->
  <div class="stat-grid" style="margin-bottom:24px;">
    <div class="stat-card blue">
      <div class="stat-icon">👨‍🎓</div>
      <div class="stat-info">
        <div class="label">Students Found</div>
        <div class="value"><%= results.size() %></div>
      </div>
    </div>
    <div class="stat-card green">
      <div class="stat-icon">💵</div>
      <div class="stat-info">
        <div class="label">Total Fees Paid</div>
        <div class="value">₹<%= totalPaid %></div>
      </div>
    </div>
    <div class="stat-card orange">
      <div class="stat-icon">⏳</div>
      <div class="stat-info">
        <div class="label">Total Pending</div>
        <div class="value">₹<%= totalPending %></div>
      </div>
    </div>
  </div>

  <!-- Data table -->
  <div class="table-wrapper">
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Student ID</th>
          <th>Name</th>
          <th>Room</th>
          <th>Admission Date</th>
          <th>Fees Paid (₹)</th>
          <th>Pending Fees (₹)</th>
          <th>Fee Status</th>
        </tr>
      </thead>
      <tbody>
        <%
          int row = 1;
          for (Student st : results) {
            boolean hasPending = st.getPendingFees() != null
                                 && st.getPendingFees().compareTo(BigDecimal.ZERO) > 0;
        %>
        <tr>
          <td class="text-muted"><%= row++ %></td>
          <td><strong><%= st.getStudentId() %></strong></td>
          <td><%= st.getStudentName() %></td>
          <td><span class="badge badge-warning"><%= st.getRoomNumber() %></span></td>
          <td><%= st.getAdmissionDate() %></td>
          <td>₹<%= st.getFeesPaid() %></td>
          <td>
            <% if (hasPending) { %>
              <span style="color:#c62828; font-weight:700;">₹<%= st.getPendingFees() %></span>
            <% } else { %>
              <span style="color:#2e7d32;">₹0.00</span>
            <% } %>
          </td>
          <td>
            <% if (hasPending) { %>
              <span class="badge badge-danger">Pending</span>
            <% } else { %>
              <span class="badge badge-success">Cleared</span>
            <% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
      <!-- Totals row -->
      <tfoot>
        <tr style="background:#eceff1; font-weight:600;">
          <td colspan="5" style="text-align:right; padding:10px 16px;">Totals (<%= results.size() %> students):</td>
          <td style="padding:10px 16px;">₹<%= totalPaid %></td>
          <td style="padding:10px 16px; color:#c62828;">₹<%= totalPending %></td>
          <td></td>
        </tr>
      </tfoot>
    </table>
  </div>

  <div class="no-print" style="display:flex; gap:10px; flex-wrap:wrap; margin-top:20px;">
    <a href="<%= request.getContextPath() %>/reportCriteria" class="btn btn-primary">← New Report</a>
    <a href="<%= request.getContextPath() %>/reports.jsp"    class="btn btn-secondary">Reports Home</a>
    <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-outline">View All Students</a>
  </div>

  <% } %>
  <% } %>

</div>

<footer class="footer">&copy; 2026 Hostel Management System</footer>
</body>
</html>
