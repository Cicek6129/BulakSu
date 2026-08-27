package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/sepet-stok")
public class SepetStokServlet extends HttpServlet {
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String action = request.getParameter("action");
            int urunId = Integer.parseInt(request.getParameter("urunId"));
            int subeId = Integer.parseInt(request.getParameter("subeId"));
            int miktar = Integer.parseInt(request.getParameter("miktar"));

            if ("ekle".equals(action)) {
                // Sepete ekleme — stoktan düş
                // SQL: UPDATE sube_stoklari SET mevcut_stok = mevcut_stok - :miktar
                //      WHERE sube_id = :subeId AND urun_id = :urunId AND mevcut_stok >= :miktar
                boolean basarili = subeStokDAO.stokDus(subeId, urunId, miktar);
                if (basarili) {
                    int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                    out.print("{\"success\":true,\"mevcutStok\":" + stokBilgisi[0] + "}");
                } else {
                    int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                    out.print("{\"success\":false,\"error\":\"Yetersiz stok\",\"mevcutStok\":" + stokBilgisi[0] + "}");
                }

            } else if ("cikar".equals(action)) {
                // Sepetten çıkarma — stok iade et
                // SQL: UPDATE sube_stoklari SET mevcut_stok = mevcut_stok + :miktar
                //      WHERE sube_id = :subeId AND urun_id = :urunId
                boolean basarili = subeStokDAO.stokIadeEt(subeId, urunId, miktar);
                if (basarili) {
                    int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                    out.print("{\"success\":true,\"mevcutStok\":" + stokBilgisi[0] + "}");
                } else {
                    out.print("{\"success\":false,\"error\":\"Stok iade hatası\"}");
                }

            } else if ("guncelle".equals(action)) {
                // Miktar güncelleme — fark hesapla
                int eskiMiktar = Integer.parseInt(request.getParameter("eskiMiktar"));
                int fark = miktar - eskiMiktar; // pozitif = daha fazla alınıyor, negatif = azaltılıyor

                if (fark > 0) {
                    // Daha fazla alınıyor — stoktan düş
                    // SQL: UPDATE sube_stoklari SET mevcut_stok = mevcut_stok - :fark
                    //      WHERE sube_id = :subeId AND urun_id = :urunId AND mevcut_stok >= :fark
                    boolean basarili = subeStokDAO.stokDus(subeId, urunId, fark);
                    if (basarili) {
                        int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                        out.print("{\"success\":true,\"mevcutStok\":" + stokBilgisi[0] + "}");
                    } else {
                        int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                        out.print("{\"success\":false,\"error\":\"Yetersiz stok\",\"mevcutStok\":" + stokBilgisi[0] + "}");
                    }
                } else if (fark < 0) {
                    // Azaltılıyor — stok iade et
                    // SQL: UPDATE sube_stoklari SET mevcut_stok = mevcut_stok + :fark
                    //      WHERE sube_id = :subeId AND urun_id = :urunId
                    boolean basarili = subeStokDAO.stokIadeEt(subeId, urunId, Math.abs(fark));
                    if (basarili) {
                        int[] stokBilgisi = subeStokDAO.findStokBilgisiNative(subeId, urunId);
                        out.print("{\"success\":true,\"mevcutStok\":" + stokBilgisi[0] + "}");
                    } else {
                        out.print("{\"success\":false,\"error\":\"Stok iade hatası\"}");
                    }
                } else {
                    // Fark yok
                    out.print("{\"success\":true,\"mevcutStok\":0}");
                }

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\":false,\"error\":\"Geçersiz action\"}");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\":false,\"error\":\"Geçersiz parametre\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\":false,\"error\":\"Sunucu hatası\"}");
        }
    }
}
