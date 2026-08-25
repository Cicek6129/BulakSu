package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.dao.UrunDAO;
import tr.com.bulaksu.bulaksu.entity.Sube;
import tr.com.bulaksu.bulaksu.entity.SubeStok;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/stok")
public class AdminStokServlet extends HttpServlet {
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String subeIdStr = request.getParameter("subeId");
        
        Integer subeId = null;
        if (subeIdStr != null && !subeIdStr.trim().isEmpty()) {
            try {
                subeId = Integer.parseInt(subeIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        List<SubeStok> stoklar;
        if (subeId != null) {
            stoklar = subeStokDAO.findBySubeId(subeId);
        } else {
            stoklar = subeStokDAO.getAggregatedStok();
        }
        
        request.setAttribute("subeler", subeDAO.findAktifSubeler());
        request.setAttribute("seciliSubeId", subeId);
        request.setAttribute("stoklar", stoklar);
        
        request.getRequestDispatcher("/WEB-INF/jsp/admin-stok.jsp").forward(request, response);
    }
}
