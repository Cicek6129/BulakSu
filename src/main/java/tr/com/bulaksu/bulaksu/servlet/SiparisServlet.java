package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tr.com.bulaksu.bulaksu.dao.SiparisDAO;
import tr.com.bulaksu.bulaksu.dao.SubeDAO;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.dao.UrunDAO;
import tr.com.bulaksu.bulaksu.entity.Kullanici;
import tr.com.bulaksu.bulaksu.entity.Siparis;
import tr.com.bulaksu.bulaksu.entity.SiparisDetay;
import tr.com.bulaksu.bulaksu.entity.Sube;
import tr.com.bulaksu.bulaksu.entity.SubeStok;
import tr.com.bulaksu.bulaksu.entity.Urun;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/siparis")
public class SiparisServlet extends HttpServlet {
    private final SiparisDAO siparisDAO = new SiparisDAO();
    private final SubeDAO subeDAO = new SubeDAO();
    private final UrunDAO urunDAO = new UrunDAO();
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/sepet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String[] urunIds = request.getParameterValues("urunId");
            String[] miktarlar = request.getParameterValues("miktar");
            String[] fiyatlar = request.getParameterValues("fiyat");
            String[] tipDetaylar = request.getParameterValues("siparisTipiDetay");
            String[] subeIdDetaylar = request.getParameterValues("subeIdDetay");
            
            if (urunIds == null || urunIds.length == 0) {
                response.sendRedirect(request.getContextPath() + "/anasayfa?error=empty");
                return;
            }

            // Session'dan kullanıcı bilgisini al
            HttpSession session = request.getSession(false);
            Kullanici kullanici = null;
            if (session != null && session.getAttribute("kullanici") != null) {
                kullanici = (Kullanici) session.getAttribute("kullanici");
            }

            // İlk ürünün şube ID'sini kullan (sipariş tek şubeye bağlı)
            int subeId = 1;
            if (subeIdDetaylar != null && subeIdDetaylar.length > 0) {
                try { subeId = Integer.parseInt(subeIdDetaylar[0]); } catch (NumberFormatException e) { /* default */ }
            }
            // Kullanıcının şubesi varsa onu kullan
            if (kullanici != null && kullanici.getSube() != null) {
                subeId = kullanici.getSube().getSubeId();
            }

            Sube sube = subeDAO.findById(subeId);

            // İlk ürünün tipini sipariş tipi olarak kullan
            String siparisTipi = (tipDetaylar != null && tipDetaylar.length > 0) ? tipDetaylar[0] : "G";
            
            Siparis siparis = new Siparis();
            siparis.setSube(sube);
            siparis.setSiparisDurumu("TAMAMLANDI");
            siparis.setSiparisTipi(siparisTipi);
            
            // Kullanıcı bilgilerini session'dan al
            if (kullanici != null) {
                siparis.setKullanici(kullanici);
                siparis.setMusteriAd(kullanici.getAdSoyad());
                siparis.setMusteriTelefon(kullanici.getTelefon());
            }
            
            List<SiparisDetay> detaylar = new ArrayList<>();
            BigDecimal toplamTutar = BigDecimal.ZERO;
            
            // ÖNCELİKLE STOK KONTROLÜ YAP — yetersiz stok varsa siparişi reddet
            List<String> stokHatalari = new ArrayList<>();
            for (int i = 0; i < urunIds.length; i++) {
                Urun urun = urunDAO.findById(Integer.parseInt(urunIds[i]));
                int miktar = Integer.parseInt(miktarlar[i]);
                int detaySubeId = subeId;
                if (subeIdDetaylar != null && i < subeIdDetaylar.length) {
                    try { detaySubeId = Integer.parseInt(subeIdDetaylar[i]); } catch (NumberFormatException e) { /* default */ }
                }
                
                SubeStok stok = subeStokDAO.findBySubeIdVeUrunId(detaySubeId, urun.getUrunId());
                if (stok == null || stok.getMevcutStok() < miktar) {
                    int mevcutStok = (stok != null) ? stok.getMevcutStok() : 0;
                    stokHatalari.add(urun.getUrunAdi() + " (istenen: " + miktar + ", stok: " + mevcutStok + ")");
                }
            }
            
            if (!stokHatalari.isEmpty()) {
                String hataMsg = "Yetersiz stok: " + String.join(", ", stokHatalari);
                response.sendRedirect(request.getContextPath() + "/anasayfa?error=stok&mesaj=" + java.net.URLEncoder.encode(hataMsg, "UTF-8"));
                return;
            }
            
            // Stok kontrolü geçti, siparişi oluştur
            for (int i = 0; i < urunIds.length; i++) {
                Urun urun = urunDAO.findById(Integer.parseInt(urunIds[i]));
                int miktar = Integer.parseInt(miktarlar[i]);
                String detayTipi = (tipDetaylar != null && i < tipDetaylar.length) ? tipDetaylar[i] : siparisTipi;
                int detaySubeId = subeId;
                if (subeIdDetaylar != null && i < subeIdDetaylar.length) {
                    try { detaySubeId = Integer.parseInt(subeIdDetaylar[i]); } catch (NumberFormatException e) { /* default */ }
                }
                
                SiparisDetay detay = new SiparisDetay();
                detay.setSiparis(siparis);
                detay.setUrun(urun);
                detay.setMiktar(miktar);
                detay.setBirimFiyat(new BigDecimal(fiyatlar[i]));
                detay.setSiparisTipi(detayTipi);
                
                BigDecimal satirToplam = detay.getBirimFiyat().multiply(BigDecimal.valueOf(detay.getMiktar()));
                toplamTutar = toplamTutar.add(satirToplam);
                
                detaylar.add(detay);
                
                // Stok güncellemesi
                try {
                    SubeStok stok = subeStokDAO.findBySubeIdVeUrunId(detaySubeId, urun.getUrunId());
                    if (stok != null) {
                        int yeniStok = stok.getMevcutStok() - miktar;
                        if (yeniStok < 0) yeniStok = 0;
                        stok.setMevcutStok(yeniStok);
                        subeStokDAO.update(stok);
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            
            siparis.setToplamTutar(toplamTutar);
            siparis.setSiparisDetaylari(detaylar);
            
            siparisDAO.create(siparis);
            
            response.sendRedirect(request.getContextPath() + "/anasayfa?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/anasayfa?error=true");
        }
    }
}
