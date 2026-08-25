<%@ page import="tr.com.bulaksu.bulaksu.dao.SubeStokDAO" %>
<%
    try {
        SubeStokDAO dao = new SubeStokDAO();
        int[] data = dao.findStokBilgisiNative(1, 1);
        out.println("Result: Mevcut=" + data[0] + " Kritik=" + data[1]);
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
