package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;

import java.io.IOException;

import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;
import tr.com.bulaksu.bulaksu.entity.SubeStok;
import java.util.List;

@WebServlet(urlPatterns = {"/anasayfa"})
public class AnaSayfaServlet extends HttpServlet {
    private final SubeDAO subeDAO = new SubeDAO();
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("subeler", subeDAO.findAktifSubeler());
        
        Kullanici kullanici = (Kullanici) request.getSession().getAttribute("kullanici");
        if (kullanici != null && kullanici.getSube() != null) {
            List<SubeStok> stokListesi = subeStokDAO.findBySubeId(kullanici.getSube().getSubeId());
            request.setAttribute("stokListesi", stokListesi);
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/index.jsp").forward(request, response);
    }
}
