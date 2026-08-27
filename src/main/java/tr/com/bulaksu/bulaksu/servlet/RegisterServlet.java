package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tr.com.bulaksu.bulaksu.dao.KullaniciDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;

import java.io.IOException;

@WebServlet("/kayit")
public class RegisterServlet extends HttpServlet {
    private final KullaniciDAO kullaniciDAO = new KullaniciDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String adSoyad = request.getParameter("adSoyad");
        String email = request.getParameter("email");
        String sifre = request.getParameter("sifre");
        String telefon = request.getParameter("telefon");

        if (adSoyad == null || adSoyad.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            sifre == null || sifre.trim().isEmpty()) {
            
            request.setAttribute("registerHata", "Ad Soyad, E-posta ve Şifre zorunludur.");
            request.setAttribute("activeForm", "register");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        // Email kullanılıyor mu?
        Kullanici mevcutKullanici = kullaniciDAO.findByEmail(email.trim());
        if (mevcutKullanici != null) {
            request.setAttribute("registerHata", "Bu e-posta adresi zaten kullanımda.");
            request.setAttribute("activeForm", "register");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        // Yeni Kullanıcı Oluştur
        Kullanici k = new Kullanici();
        k.setAdSoyad(adSoyad.trim());
        k.setEmail(email.trim());
        k.setSifre(kullaniciDAO.sha256(sifre)); // Şifreyi hashle
        k.setRol("KASA"); // Varsayılan rol
        k.setAktif(true);
        if (telefon != null && !telefon.trim().isEmpty()) {
            k.setTelefon(telefon.trim());
        }

        try {
            kullaniciDAO.save(k);
            
            // Kayıt başarılı, direkt giriş yaptır
            HttpSession session = request.getSession(true);
            session.setAttribute("kullanici", k);
            session.setMaxInactiveInterval(60 * 60);
            
            response.sendRedirect(request.getContextPath() + "/anasayfa");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("registerHata", "Kayıt sırasında bir hata oluştu.");
            request.setAttribute("activeForm", "register");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }
}
