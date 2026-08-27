package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;

import java.io.IOException;

@WebServlet("/zayi-dus")
public class ZayiServlet extends HttpServlet {

    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String urunIdStr = request.getParameter("urunId");
        String miktarStr = request.getParameter("miktar");
        
        Kullanici kullanici = (Kullanici) request.getSession().getAttribute("kullanici");

        if (kullanici == null || kullanici.getSube() == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Şube yetkiniz bulunmuyor.\"}");
            return;
        }

        try {
            if (urunIdStr != null && miktarStr != null) {
                int urunId = Integer.parseInt(urunIdStr);
                int subeId = kullanici.getSube().getSubeId();
                int miktar = Integer.parseInt(miktarStr);

                if (miktar > 0) {
                    boolean success = subeStokDAO.zayiDus(subeId, urunId, miktar);
                    if (success) {
                        response.getWriter().write("{\"success\": true, \"message\": \"Zayi düşümü başarıyla kaydedildi.\"}");
                        return;
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"success\": false, \"message\": \"Yetersiz Stok: Girdiğiniz miktar mevcut stoktan fazla olamaz!\"}");
                        return;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"success\": false, \"message\": \"İşlem sırasında bir hata oluştu.\"}");
    }
}
