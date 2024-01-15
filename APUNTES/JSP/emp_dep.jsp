// GetDeptEmps.java
<%@ page language="java" contentType="text/html" 
         import = "java.sql.*, java.util.*, oracle.jdbc.driver.*" %>
<HTML>
<HEAD>
<TITLE>
Lista de empleados por departamento
</TITLE>
</HEAD>
<BODY>
<H1>Empleados del departamento <%= request.getParameter("deptno") %> </H1>
<TABLE BORDER=1>
<TR>
<% String sql = "select * from emp where deptno = ? order by ename" ;
   String connString;
   try {
     DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
     Connection conn = null;
     connString = new String("jdbc:oracle:thin:scott/tiger@servidor:1521:ORCL");
     conn = DriverManager.getConnection(connString);
     PreparedStatement pstmt = conn.prepareStatement(sql);
     pstmt.setInt(1, Integer.parseInt(request.getParameter("deptno")));
     ResultSet rset = pstmt.executeQuery();
     ResultSetMetaData meta =  rset.getMetaData();
// Retrieves the number of columns returned
     int cols = meta.getColumnCount(), rows =  0;
     for (int i = 1; i <= cols; i++) {
       String label = meta.getColumnLabel(i);
%><TH><% out.println(label); %></TH>
<%   }  %>
</TR>
<%   while (rset.next()) {
       rows++;
       out.println("<TR>");
       for (int i = 1; i <= cols; i++)   {
        String value = rset.getString(i);
        if (value == null) {
             value = "&nbsp;";
        }
%><TD><% out.println(value); %></TD>
<%   }  %>
</TR>
<%   }
     if (rows == 0) {
         out.println("No se han encontrado datos!\n");
     }
     // Close up the record set
     rset.close();
     pstmt.close();
     conn.close();
   } 
   catch (SQLException e) {
        out.println(e.getMessage());
   }
%>
</TABLE>
</BODY>
</HTML>
-----------------------------------------------

