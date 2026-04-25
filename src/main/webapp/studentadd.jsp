<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Student – HMS</title>
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
    <a href="<%= request.getContextPath() %>/reports.jsp">Reports</a>
  </nav>
</header>

<div class="page-wrapper">

  <div class="page-header">
    <div class="breadcrumb">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a> &rsaquo;
      <a href="<%= request.getContextPath() %>/displayStudents">Students</a> &rsaquo;
      Add Student
    </div>
    <h1>➕ Add New Student</h1>
    <p>Fill in all the details to admit a new student to the hostel.</p>
  </div>

  <%-- Error message --%>
  <% String err = (String) request.getAttribute("errorMessage");
     if (err != null && !err.isEmpty()) { %>
  <div class="alert alert-error">⚠️ <%= err %></div>
  <% } %>

  <div class="card">
    <div class="card-title">📝 Student Admission Form</div>

    <form action="<%= request.getContextPath() %>/addStudent" method="post" id="addForm" novalidate>

      <div class="form-grid">

        <!-- Student ID -->
        <div class="form-group">
          <label for="studentId">Student ID <span class="req">*</span></label>
          <input type="number" id="studentId" name="studentId" class="form-control"
                 placeholder="e.g. 1011" min="1"
                 value="<%= request.getAttribute("studentId") != null ? request.getAttribute("studentId") : "" %>"
                 required>
          <span class="form-hint">Must be a unique positive integer.</span>
        </div>

        <!-- Student Name -->
        <div class="form-group">
          <label for="studentName">Student Name <span class="req">*</span></label>
          <input type="text" id="studentName" name="studentName" class="form-control"
                 placeholder="Full name" maxlength="100"
                 value="<%= request.getAttribute("studentName") != null ? request.getAttribute("studentName") : "" %>"
                 required>
        </div>

        <!-- Room Number -->
        <div class="form-group">
          <label for="roomNumber">Room Number <span class="req">*</span></label>
          <input type="text" id="roomNumber" name="roomNumber" class="form-control"
                 placeholder="e.g. A101" maxlength="10"
                 value="<%= request.getAttribute("roomNumber") != null ? request.getAttribute("roomNumber") : "" %>"
                 required>
          <span class="form-hint">Max 10 characters (e.g., A101, B202).</span>
        </div>

        <!-- Admission Date -->
        <div class="form-group">
          <label for="admissionDate">Admission Date <span class="req">*</span></label>
          <input type="date" id="admissionDate" name="admissionDate" class="form-control"
                 value="<%= request.getAttribute("admissionDate") != null ? request.getAttribute("admissionDate") : "" %>"
                 required>
        </div>

        <!-- Fees Paid -->
        <div class="form-group">
          <label for="feesPaid">Fees Paid (₹) <span class="req">*</span></label>
          <input type="number" id="feesPaid" name="feesPaid" class="form-control"
                 placeholder="0.00" min="0" step="0.01"
                 value="<%= request.getAttribute("feesPaid") != null ? request.getAttribute("feesPaid") : "0.00" %>"
                 required>
        </div>

        <!-- Pending Fees -->
        <div class="form-group">
          <label for="pendingFees">Pending Fees (₹) <span class="req">*</span></label>
          <input type="number" id="pendingFees" name="pendingFees" class="form-control"
                 placeholder="0.00" min="0" step="0.01"
                 value="<%= request.getAttribute("pendingFees") != null ? request.getAttribute("pendingFees") : "0.00" %>"
                 required>
        </div>

      </div><!-- /form-grid -->

      <div class="form-actions">
        <button type="submit" class="btn btn-success">💾 Save Student</button>
        <a href="<%= request.getContextPath() %>/displayStudents" class="btn btn-secondary">Cancel</a>
        <button type="reset" class="btn btn-outline">↺ Reset</button>
      </div>

    </form>
  </div><!-- /card -->

</div><!-- /page-wrapper -->

<footer class="footer">&copy; 2026 Hostel Management System</footer>

<!-- ===================== CLIENT-SIDE VALIDATION ===================== -->
<script>
document.getElementById('addForm').addEventListener('submit', function(e) {
  let ok = true;
  const errors = [];

  const id   = document.getElementById('studentId');
  const name = document.getElementById('studentName');
  const room = document.getElementById('roomNumber');
  const date = document.getElementById('admissionDate');
  const paid = document.getElementById('feesPaid');
  const pend = document.getElementById('pendingFees');

  // Reset borders
  [id, name, room, date, paid, pend].forEach(f => f.style.borderColor = '');

  if (!id.value || parseInt(id.value) <= 0) {
    errors.push('Student ID must be a positive number.');
    id.style.borderColor = '#c62828'; ok = false;
  }
  if (!name.value.trim()) {
    errors.push('Student name is required.');
    name.style.borderColor = '#c62828'; ok = false;
  }
  if (!room.value.trim()) {
    errors.push('Room number is required.');
    room.style.borderColor = '#c62828'; ok = false;
  }
  if (!date.value) {
    errors.push('Admission date is required.');
    date.style.borderColor = '#c62828'; ok = false;
  }
  if (parseFloat(paid.value) < 0) {
    errors.push('Fees Paid cannot be negative.');
    paid.style.borderColor = '#c62828'; ok = false;
  }
  if (parseFloat(pend.value) < 0) {
    errors.push('Pending Fees cannot be negative.');
    pend.style.borderColor = '#c62828'; ok = false;
  }

  if (!ok) {
    e.preventDefault();
    let box = document.querySelector('.alert.alert-error');
    if (!box) {
      box = document.createElement('div');
      box.className = 'alert alert-error';
      document.querySelector('.card').before(box);
    }
    box.innerHTML = '⚠️ ' + errors.join(' ');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }
});
</script>
</body>
</html>
