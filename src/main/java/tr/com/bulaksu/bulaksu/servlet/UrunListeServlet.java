package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.dao.UrunDAO;
import tr.com.bulaksu.bulaksu.dao.UrunFiyatDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;

import java.io.IOException;

@WebServlet("/urunler")
public class UrunListeServlet extends HttpServlet {
    private final UrunDAO urunDAO = new UrunDAO();
    private final UrunFiyatDAO urunFiyatDAO = new UrunFiyatDAO();
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tip = request.getParameter("tip");
        String subeIdStr = request.getParameter("subeId");
        Integer subeId = null;
        
        // Session'dan kullanıcı bilgisini al
        HttpSession session = request.getSession(false);
        Kullanici kullanici = null;
        boolean kullaniciSubeKilitli = false;
        
        if (session != null && session.getAttribute("kullanici") != null) {
            kullanici = (Kullanici) session.getAttribute("kullanici");
            
            // Kullanıcının atanmış şubesi varsa ve ADMIN değilse, şubeyi kilitle
            if (kullanici.getSube() != null && !"ADMIN".equals(kullanici.getRol())) {
                subeId = kullanici.getSube().getSubeId();
                kullaniciSubeKilitli = true;
            }
        }
        
        // Şube kilitli değilse URL parametresinden al
        if (!kullaniciSubeKilitli) {
            if (subeIdStr != null && !subeIdStr.trim().isEmpty()) {
                try {
                    subeId = Integer.parseInt(subeIdStr);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            // Hâlâ null ise default 1
            if (subeId == null) {
                subeId = 1;
            }
        }
        
        request.setAttribute("urunler", urunDAO.findSatistakiUrunler());
        request.setAttribute("fiyatlar", urunFiyatDAO.findBySubeId(subeId));
        
        request.setAttribute("tip", tip);
        request.setAttribute("subeId", subeId);
        request.setAttribute("kullaniciSubeKilitli", kullaniciSubeKilitli);
        
        // Admin veya şubesi atanmamış kullanıcı ise tüm aktif şubeleri göster
        // Şubesi kilitli kullanıcı ise sadece kendi şubesini göster (dropdown gizlenecek)
        if (kullaniciSubeKilitli) {
            java.util.List<tr.com.bulaksu.bulaksu.entity.Sube> tekSube = new java.util.ArrayList<>();
            tekSube.add(kullanici.getSube());
            request.setAttribute("subeler", tekSube);
        } else {
            request.setAttribute("subeler", subeDAO.findAktifSubeler());
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/urunler.jsp").forward(request, response);
    }
}
