package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SiparisDAO;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;
import tr.com.bulaksu.bulaksu.entity.Siparis;
import tr.com.bulaksu.bulaksu.entity.Sube;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private final SiparisDAO siparisDAO = new SiparisDAO();
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Session'dan admin bilgisini al ve JSP'ye gönder
        Kullanici admin = (Kullanici) request.getSession().getAttribute("kullanici");
        if (admin != null) {
            request.setAttribute("adminAd", admin.getAdSoyad());
        }
        
        // Filtre parametrelerini al
        String subeIdStr = request.getParameter("subeId");
        String baslangicTarihStr = request.getParameter("baslangicTarih");
        String bitisTarihStr = request.getParameter("bitisTarih");
        
        // Şube ID parse
        Integer subeId = null;
        if (subeIdStr != null && !subeIdStr.trim().isEmpty()) {
            try {
                subeId = Integer.parseInt(subeIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        // Tarih parse
        LocalDateTime baslangic = null;
        if (baslangicTarihStr != null && !baslangicTarihStr.trim().isEmpty()) {
            baslangic = LocalDate.parse(baslangicTarihStr).atStartOfDay();
        }
        
        LocalDateTime bitis = null;
        if (bitisTarihStr != null && !bitisTarihStr.trim().isEmpty()) {
            bitis = LocalDate.parse(bitisTarihStr).atTime(23, 59, 59);
        }
        
        // JPQL ile filtrelenmiş siparişleri getir
        List<Siparis> siparisler = siparisDAO.findBySubeVeTarihVeDurum(subeId, baslangic, bitis, null, null);
        List<Sube> subeler = subeDAO.findAktifSubeler();
        
        // JSP'ye attribute'ları gönder
        request.setAttribute("siparisler", siparisler);
        request.setAttribute("subeler", subeler);
        request.setAttribute("subeId", subeId);
        request.setAttribute("baslangicTarih", baslangicTarihStr);
        request.setAttribute("bitisTarih", bitisTarihStr);
        
        request.getRequestDispatcher("/WEB-INF/jsp/admin.jsp").forward(request, response);
    }
}
