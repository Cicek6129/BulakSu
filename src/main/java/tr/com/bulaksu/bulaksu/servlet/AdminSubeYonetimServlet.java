package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.entity.Sube;

import java.io.IOException;

@WebServlet("/admin/subeler")
public class AdminSubeYonetimServlet extends HttpServlet {
    private final SubeDAO subeDAO = new SubeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("subeler", subeDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/jsp/admin-subeler.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/subeler");
            return;
        }

        try {
            switch (action) {
                case "add":
                    Sube yeniSube = new Sube();
                    yeniSube.setSubeAdi(request.getParameter("subeAdi"));
                    yeniSube.setAdres(request.getParameter("adres"));
                    String aktifParam = request.getParameter("subeAktifmi");
                    yeniSube.setSubeAktifmi(aktifParam != null);
                    subeDAO.save(yeniSube);
                    break;
                case "update":
                    int id = Integer.parseInt(request.getParameter("subeId"));
                    Sube sube = subeDAO.findById(id);
                    if (sube != null) {
                        String subeAdi = request.getParameter("subeAdi");
                        if (subeAdi != null && !subeAdi.isEmpty()) sube.setSubeAdi(subeAdi);

                        String adres = request.getParameter("adres");
                        if (adres != null && !adres.isEmpty()) sube.setAdres(adres);

                        String aktifMi = request.getParameter("subeAktifmi");
                        sube.setSubeAktifmi(aktifMi != null);

                        subeDAO.update(sube);
                    }
                    break;
                case "delete":
                    int delId = Integer.parseInt(request.getParameter("subeId"));
                    subeDAO.deleteById(delId);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/subeler");
    }
}
