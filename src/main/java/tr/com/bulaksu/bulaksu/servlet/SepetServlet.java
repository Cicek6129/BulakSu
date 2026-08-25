package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/sepet")
public class SepetServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Sepet artık localStorage'dan okunuyor, sadece JSP'yi göster
        request.getRequestDispatcher("/WEB-INF/jsp/sepet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Eski POST akışı da desteklensin (geriye uyumluluk)
        request.getRequestDispatcher("/WEB-INF/jsp/sepet.jsp").forward(request, response);
    }
}
