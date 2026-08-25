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

@WebServlet(urlPatterns = {"/giris", "/admin/giris"})
public class LoginServlet extends HttpServlet {

    private final KullaniciDAO kullaniciDAO = new KullaniciDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String path = request.getServletPath();
        
        // Zaten giriş yapmışsa rolüne göre yönlendir
        if (session != null && session.getAttribute("kullanici") != null) {
            Kullanici k = (Kullanici) session.getAttribute("kullanici");
            if ("ADMIN".equals(k.getRol())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/anasayfa");
            }
            return;
        }
        
        request.setAttribute("activeTab", "user"); // Tek form olduğu için her zaman user
        
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email"); // email or username
        String sifre = request.getParameter("sifre");

        if (email == null || email.trim().isEmpty() ||
            sifre == null || sifre.trim().isEmpty()) {
            request.setAttribute("userHata", "E-posta/Kullanıcı Adı ve şifre boş bırakılamaz.");
            request.setAttribute("activeTab", "user");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            return;
        }

        Kullanici kullanici = kullaniciDAO.findByEmailAndSifre(email.trim(), sifre);

        if (kullanici != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("kullanici", kullanici);
            session.setMaxInactiveInterval(60 * 60);
            
            if ("ADMIN".equals(kullanici.getRol())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/anasayfa");
            }
        } else {
            request.setAttribute("userHata", "E-posta veya şifre hatalı (VEYA hesabınız pasif).");
            request.setAttribute("email", email);
            request.setAttribute("activeTab", "user");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }
}
