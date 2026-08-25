package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;
import tr.com.bulaksu.bulaksu.entity.Sube;
import tr.com.bulaksu.bulaksu.entity.SubeStok;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/zayi")
public class AdminZayiServlet extends HttpServlet {

    private final SubeDAO subeDAO = new SubeDAO();
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String subeIdParam = request.getParameter("subeId");
        int subeId = 1; // Default to first branch if none selected

        if (subeIdParam != null && !subeIdParam.trim().isEmpty()) {
            try {
                subeId = Integer.parseInt(subeIdParam);
            } catch (NumberFormatException ignored) {}
        } else {
            // If the admin has a specific branch, default to it
            Kullanici admin = (Kullanici) request.getSession().getAttribute("kullanici");
            if (admin != null && admin.getSube() != null) {
                subeId = admin.getSube().getSubeId();
            }
        }

        List<Sube> subeler = subeDAO.findAktifSubeler();
        List<SubeStok> stokListesi = subeStokDAO.findBySubeId(subeId);

        request.setAttribute("subeler", subeler);
        request.setAttribute("stokListesi", stokListesi);
        request.setAttribute("seciliSubeId", subeId);

        request.getRequestDispatcher("/WEB-INF/jsp/admin-zayi.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String urunIdStr = request.getParameter("urunId");
        String subeIdStr = request.getParameter("subeId");
        String miktarStr = request.getParameter("miktar");

        try {
            if (urunIdStr != null && subeIdStr != null && miktarStr != null) {
                int urunId = Integer.parseInt(urunIdStr);
                int subeId = Integer.parseInt(subeIdStr);
                int miktar = Integer.parseInt(miktarStr);

                if (miktar > 0) {
                    boolean success = subeStokDAO.zayiDus(subeId, urunId, miktar);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/admin/zayi?subeId=" + subeId + "&success=true");
                        return;
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/zayi?subeId=" + subeId + "&error=yetersiz");
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String currentSubeId = subeIdStr != null ? subeIdStr : "1";
        response.sendRedirect(request.getContextPath() + "/admin/zayi?subeId=" + currentSubeId + "&error=true");
    }
}
