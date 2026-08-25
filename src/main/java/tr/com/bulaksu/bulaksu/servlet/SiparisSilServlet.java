package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SiparisDAO;

import java.io.IOException;

@WebServlet("/admin/siparis-sil")
public class SiparisSilServlet extends HttpServlet {
    private final SiparisDAO siparisDAO = new SiparisDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String siparisIdStr = request.getParameter("siparisId");
        
        // Return URL allows redirecting back with the same filters
        String returnUrl = request.getParameter("returnUrl");
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            returnUrl = request.getContextPath() + "/admin";
        }
        
        try {
            if (siparisIdStr != null) {
                int siparisId = Integer.parseInt(siparisIdStr);
                siparisDAO.deleteSiparis(siparisId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(returnUrl);
    }
}
