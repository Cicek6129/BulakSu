package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.Siparis;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;

public class SiparisDAO {

    public List<Siparis> findAll() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Siparis s", Siparis.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Siparis findById(int id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.find(Siparis.class, id);
        } finally {
            em.close();
        }
    }

    public List<Siparis> findBySubeId(int subeId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Siparis s WHERE s.sube.subeId = :subeId", Siparis.class)
                     .setParameter("subeId", subeId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Siparis> findByTarihAraligi(LocalDateTime baslangic, LocalDateTime bitis) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Siparis s WHERE s.siparisTarihi BETWEEN :baslangic AND :bitis", Siparis.class)
                     .setParameter("baslangic", baslangic)
                     .setParameter("bitis", bitis)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Şube, tarih aralığı, sipariş durumu ve stok durumuna göre JPQL filtreleme.
     * Tüm filtreler opsiyoneldir - null gönderilirse o filtre uygulanmaz.
     * 
     * @param subeId Şube ID (null = tüm şubeler)
     * @param baslangic Başlangıç tarihi (null = filtresiz)
     * @param bitis Bitiş tarihi (null = filtresiz)
     * @param durum Sipariş durumu: "YENI", "TAMAMLANDI" vb. (null = tümü)
     * @param stokDurum Stok durumu: "KRITIK" (kritik seviye altı), "STOKTA" (stokta var), "TUKENMIS" (stok 0) (null = tümü)
     */
    public List<Siparis> findBySubeVeTarihVeDurum(Integer subeId, LocalDateTime baslangic, LocalDateTime bitis, 
                                                    String durum, String stokDurum) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            // JPQL sorgusu - JOIN FETCH ile lazy loading sorununu önlüyoruz
            StringBuilder jpql = new StringBuilder(
                "SELECT DISTINCT s FROM Siparis s " +
                "LEFT JOIN FETCH s.siparisDetaylari d " +
                "LEFT JOIN FETCH d.urun " +
                "LEFT JOIN FETCH s.sube ");
            
            // Stok filtresi için SubeStok tablosuna join gerekli
            if (stokDurum != null && !stokDurum.isEmpty()) {
                jpql.append("LEFT JOIN SubeStok ss ON ss.sube = s.sube AND ss.urun = d.urun ");
            }
            
            jpql.append("WHERE 1=1 ");
            
            // Şube filtresi
            if (subeId != null) {
                jpql.append("AND s.sube.subeId = :subeId ");
            }
            // Tarih aralığı filtresi
            if (baslangic != null && bitis != null) {
                jpql.append("AND s.siparisTarihi BETWEEN :baslangic AND :bitis ");
            }
            // Sipariş durumu filtresi
            if (durum != null && !durum.isEmpty()) {
                jpql.append("AND s.siparisDurumu = :durum ");
            }
            // Stok durumu filtresi
            if (stokDurum != null && !stokDurum.isEmpty()) {
                switch (stokDurum) {
                    case "KRITIK":
                        // Stoku kritik seviyenin altında olan ürünleri içeren siparişler
                        jpql.append("AND ss.mevcutStok <= ss.kritikStokSeviyesi ");
                        break;
                    case "TUKENMIS":
                        // Stoku sıfır olan ürünleri içeren siparişler
                        jpql.append("AND ss.mevcutStok = 0 ");
                        break;
                    case "STOKTA":
                        // Stokta yeterli miktar olan ürünleri içeren siparişler
                        jpql.append("AND ss.mevcutStok > ss.kritikStokSeviyesi ");
                        break;
                }
            }
            
            jpql.append("ORDER BY s.siparisTarihi DESC ");
            
            TypedQuery<Siparis> query = em.createQuery(jpql.toString(), Siparis.class);
            
            if (subeId != null) {
                query.setParameter("subeId", subeId);
            }
            if (baslangic != null && bitis != null) {
                query.setParameter("baslangic", baslangic);
                query.setParameter("bitis", bitis);
            }
            if (durum != null && !durum.isEmpty()) {
                query.setParameter("durum", durum);
            }
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Eski metod - geriye uyumluluk için korundu.
     * Yeni filtreleme metodu findBySubeVeTarihVeDurum kullanılmalı.
     */
    public List<Siparis> findBySubeVeTarih(Integer subeId, LocalDateTime baslangic, LocalDateTime bitis) {
        return findBySubeVeTarihVeDurum(subeId, baslangic, bitis, null, null);
    }

    public Siparis create(Siparis siparis) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            
            // Re-attach detached entities using the current EntityManager
            if (siparis.getSube() != null) {
                siparis.setSube(em.getReference(tr.com.bulaksu.bulaksu.entity.Sube.class, siparis.getSube().getSubeId()));
            }
            
            if (siparis.getSiparisDetaylari() != null) {
                for (tr.com.bulaksu.bulaksu.entity.SiparisDetay detay : siparis.getSiparisDetaylari()) {
                    if (detay.getUrun() != null) {
                        detay.setUrun(em.getReference(tr.com.bulaksu.bulaksu.entity.Urun.class, detay.getUrun().getUrunId()));
                    }
                }
            }
            
            em.persist(siparis);
            em.getTransaction().commit();
            return siparis;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error creating siparis", e);
        } finally {
            em.close();
        }
    }

    public Siparis update(Siparis siparis) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            Siparis mergedSiparis = em.merge(siparis);
            em.getTransaction().commit();
            return mergedSiparis;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating siparis", e);
        } finally {
            em.close();
        }
    }

    public void updateDurum(int siparisId, String yeniDurum) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery("UPDATE Siparis s SET s.siparisDurumu = :durum WHERE s.siparisId = :id")
              .setParameter("durum", yeniDurum)
              .setParameter("id", siparisId)
              .executeUpdate();
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating siparis durumu", e);
        } finally {
            em.close();
        }
    }

    public void deleteSiparis(int siparisId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            // Hocanın isteği üzerine Native SQL sorguları ile silme işlemi
            em.createNativeQuery("DELETE FROM siparis_detaylari WHERE siparis_id = :id")
              .setParameter("id", siparisId)
              .executeUpdate();
              
            em.createNativeQuery("DELETE FROM siparisler WHERE siparis_id = :id")
              .setParameter("id", siparisId)
              .executeUpdate();
              
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting siparis with native SQL", e);
        } finally {
            em.close();
        }
    }
}
