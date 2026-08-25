package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.KullaniciDAO;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;
import tr.com.bulaksu.bulaksu.entity.Sube;

import java.io.IOException;

@WebServlet("/admin/kullanicilar")
public class AdminKullaniciYonetimServlet extends HttpServlet {
    private final KullaniciDAO kullaniciDAO = new KullaniciDAO();
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("kullanicilar", kullaniciDAO.findAll());
        request.setAttribute("subeler", subeDAO.findAktifSubeler());
        request.getRequestDispatcher("/WEB-INF/jsp/admin-kullanicilar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/kullanicilar");
            return;
        }

        try {
            switch (action) {
                case "add":
                    Kullanici yeniKullanici = new Kullanici();
                    yeniKullanici.setAdSoyad(request.getParameter("adSoyad"));
                    yeniKullanici.setEmail(request.getParameter("email"));
                    yeniKullanici.setSifre(KullaniciDAO.sha256(request.getParameter("sifre")));
                    yeniKullanici.setTelefon(request.getParameter("telefon"));
                    
                    // Şube ataması
                    String subeIdStr = request.getParameter("subeId");
                    if (subeIdStr != null && !subeIdStr.isEmpty()) {
                        Sube sube = subeDAO.findById(Integer.parseInt(subeIdStr));
                        yeniKullanici.setSube(sube);
                    }
                    
                    kullaniciDAO.save(yeniKullanici);
                    break;
                case "update":
                    int id = Integer.parseInt(request.getParameter("kullaniciId"));
                    Kullanici k = kullaniciDAO.findById(id);
                    if (k != null) {
                        String ad = request.getParameter("adSoyad");
                        if (ad != null && !ad.isEmpty()) k.setAdSoyad(ad);
                        
                        String email = request.getParameter("email");
                        if (email != null && !email.isEmpty()) k.setEmail(email);

                        String sifre = request.getParameter("sifre");
                        if (sifre != null && !sifre.isEmpty()) k.setSifre(KullaniciDAO.sha256(sifre));
                        
                        String tel = request.getParameter("telefon");
                        if (tel != null && !tel.isEmpty()) k.setTelefon(tel);
                        
                        // Şube ataması güncelleme
                        String updateSubeId = request.getParameter("subeId");
                        if (updateSubeId != null) {
                            if (updateSubeId.isEmpty()) {
                                // "Tüm Şubeler" seçildi → şubeyi kaldır
                                k.setSube(null);
                            } else {
                                Sube sube = subeDAO.findById(Integer.parseInt(updateSubeId));
                                k.setSube(sube);
                            }
                        }
                        
                        kullaniciDAO.update(k);
                    }
                    break;
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("kullaniciId"));
                    kullaniciDAO.deleteById(delId);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/kullanicilar");
    }
}
