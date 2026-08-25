package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.UrunDAO;
import tr.com.bulaksu.bulaksu.dao.UrunFiyatDAO;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.entity.Urun;
import tr.com.bulaksu.bulaksu.entity.Sube;
import tr.com.bulaksu.bulaksu.entity.SubeStok;

import java.io.IOException;

@WebServlet("/admin/urunler")
public class AdminUrunServlet extends HttpServlet {
    private final UrunDAO urunDAO = new UrunDAO();
    private final UrunFiyatDAO urunFiyatDAO = new UrunFiyatDAO();
    private final SubeDAO subeDAO = new SubeDAO();
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("getStock".equals(action)) {
            try {
                int subeId = Integer.parseInt(request.getParameter("subeId"));
                int urunId = Integer.parseInt(request.getParameter("urunId"));
                int[] stokData = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(String.format("{\"mevcutStok\": %d, \"kritikStok\": %d}", stokData[0], stokData[1]));
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            }
            return;
        }

        request.setAttribute("urunler", urunDAO.findAll());
        request.setAttribute("subeler", subeDAO.findAktifSubeler());
        request.getRequestDispatcher("/WEB-INF/jsp/admin-urunler.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/urunler");
            return;
        }

        try {
            switch (action) {
                case "add":
                    Urun yeniUrun = new Urun();
                    yeniUrun.setUrunAdi(request.getParameter("urunAdi"));
                    yeniUrun.setGorselUrl(request.getParameter("gorselUrl"));
                    yeniUrun.setUrunSatistami(request.getParameter("urunSatistami") != null);
                    urunDAO.save(yeniUrun);
                    break;
                case "update":
                    int urunId = Integer.parseInt(request.getParameter("urunId"));
                    Urun urun = urunDAO.findById(urunId);
                    if (urun != null) {
                        String reqUrunAdi = request.getParameter("urunAdi");
                        if (reqUrunAdi != null && !reqUrunAdi.trim().isEmpty()) {
                            urun.setUrunAdi(reqUrunAdi.trim());
                        }

                        String reqGorselUrl = request.getParameter("gorselUrl");
                        if (reqGorselUrl != null && !reqGorselUrl.trim().isEmpty()) {
                            urun.setGorselUrl(reqGorselUrl.trim());
                        }

                        urun.setUrunSatistami(request.getParameter("urunSatistami") != null);
                        urunDAO.update(urun);
                    }
                    break;
                case "delete":
                    int delUrunId = Integer.parseInt(request.getParameter("urunId"));
                    urunDAO.deleteById(delUrunId);
                    break;
                case "bulkImage":
                    String bulkImageUrl = request.getParameter("gorselUrl");
                    urunDAO.bulkUpdateGorselUrl(bulkImageUrl);
                    break;
                case "bulkDiscount":
                    String indirimOraniStr = request.getParameter("indirimOrani");
                    if (indirimOraniStr != null && !indirimOraniStr.isEmpty()) {
                        double oran = Double.parseDouble(indirimOraniStr);
                        // oran %10 ise carpan = 0.90 vb
                        double carpan = (100 - oran) / 100.0;
                        urunFiyatDAO.bulkFiyatGuncelle(carpan);
                    }
                    break;
                case "updateStock":
                    int stokSubeId = Integer.parseInt(request.getParameter("subeId"));
                    int stokUrunId = Integer.parseInt(request.getParameter("urunId"));
                    int mevcutStok = Integer.parseInt(request.getParameter("mevcutStok"));
                    int kritikStok = Integer.parseInt(request.getParameter("kritikStok"));
                    
                    SubeStok existingStok = subeStokDAO.findBySubeIdVeUrunId(stokSubeId, stokUrunId);
                    if (existingStok != null) {
                        existingStok.setMevcutStok(mevcutStok);
                        existingStok.setKritikStokSeviyesi(kritikStok);
                        subeStokDAO.update(existingStok);
                    } else {
                        SubeStok yeniStok = new SubeStok();
                        yeniStok.setSube(subeDAO.findById(stokSubeId));
                        yeniStok.setUrun(urunDAO.findById(stokUrunId));
                        yeniStok.setMevcutStok(mevcutStok);
                        yeniStok.setKritikStokSeviyesi(kritikStok);
                        subeStokDAO.save(yeniStok);
                    }
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Ignore for now
        }

        response.sendRedirect(request.getContextPath() + "/admin/urunler");
    }
}
