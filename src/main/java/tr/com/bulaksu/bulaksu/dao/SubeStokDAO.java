package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.SubeStok;
import jakarta.persistence.EntityManager;
import java.util.List;

public class SubeStokDAO {

    public List<SubeStok> findBySubeId(int subeId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT ss FROM SubeStok ss JOIN FETCH ss.sube JOIN FETCH ss.urun WHERE ss.sube.subeId = :subeId", SubeStok.class)
                     .setParameter("subeId", subeId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public SubeStok findBySubeIdVeUrunId(int subeId, int urunId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT ss FROM SubeStok ss JOIN FETCH ss.sube JOIN FETCH ss.urun WHERE ss.sube.subeId = :subeId AND ss.urun.urunId = :urunId", SubeStok.class)
                     .setParameter("subeId", subeId)
                     .setParameter("urunId", urunId)
                     .getSingleResult();
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public void save(SubeStok stok) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(stok);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving sube stok", e);
        } finally {
            em.close();
        }
    }

    public SubeStok update(SubeStok stok) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            SubeStok mergedStok = em.merge(stok);
            em.getTransaction().commit();
            return mergedStok;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating sube stok", e);
        } finally {
            em.close();
        }
    }

    public List<SubeStok> getAggregatedStok() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            List<Object[]> results = em.createQuery(
                "SELECT ss.urun, SUM(ss.mevcutStok), SUM(ss.kritikStokSeviyesi) " +
                "FROM SubeStok ss GROUP BY ss.urun", Object[].class).getResultList();
            
            List<SubeStok> aggregatedList = new java.util.ArrayList<>();
            tr.com.bulaksu.bulaksu.entity.Sube dummySube = new tr.com.bulaksu.bulaksu.entity.Sube();
            dummySube.setSubeAdi("Tüm Şubeler");
            
            for (Object[] row : results) {
                SubeStok stok = new SubeStok();
                stok.setUrun((tr.com.bulaksu.bulaksu.entity.Urun) row[0]);
                stok.setMevcutStok(((Number) row[1]).intValue());
                stok.setKritikStokSeviyesi(((Number) row[2]).intValue());
                stok.setSube(dummySube);
                aggregatedList.add(stok);
            }
            return aggregatedList;
        } finally {
            em.close();
        }
    }

    // Zayi işlemleri için JPQL ile stok düşürme metodu (Native SQL kullanılmamıştır)
    public boolean zayiDus(int subeId, int urunId, int zayiMiktar) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            // Mevcut stoku kontrol edip düşüren JPQL UPDATE sorgusu
            int updatedRows = em.createQuery(
                "UPDATE SubeStok s SET s.mevcutStok = s.mevcutStok - :miktar " +
                "WHERE s.sube.subeId = :subeId AND s.urun.urunId = :urunId AND s.mevcutStok >= :miktar")
              .setParameter("miktar", zayiMiktar)
              .setParameter("subeId", subeId)
              .setParameter("urunId", urunId)
              .executeUpdate();
            
            em.getTransaction().commit();
            
            // Eğer update edilen satır varsa true, yoksa (stok yetersizse) false döner
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
    // AJAX istekleri için Native SQL ile stok bilgisi getirme
    public int[] findStokBilgisiNative(int subeId, int urunId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            Object[] result = (Object[]) em.createNativeQuery(
                "SELECT mevcut_stok, kritik_stok_seviyesi FROM sube_stoklari WHERE sube_id = :subeId AND urun_id = :urunId")
                .setParameter("subeId", subeId)
                .setParameter("urunId", urunId)
                .getSingleResult();
            
            if (result != null && result.length == 2) {
                return new int[] { 
                    ((Number) result[0]).intValue(), 
                    ((Number) result[1]).intValue() 
                };
            }
            return new int[] { 0, 0 };
        } catch (jakarta.persistence.NoResultException e) {
            return new int[] { 0, 0 }; // Kayıt yoksa 0,0 dön
        } finally {
            em.close();
        }
    }

    // Sepete eklerken stoktan düşme - Native SQL atomik işlem
    public boolean stokDus(int subeId, int urunId, int miktar) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createNativeQuery(
                "UPDATE sube_stoklari SET mevcut_stok = mevcut_stok - :miktar " +
                "WHERE sube_id = :subeId AND urun_id = :urunId AND mevcut_stok >= :miktar")
                .setParameter("miktar", miktar)
                .setParameter("subeId", subeId)
                .setParameter("urunId", urunId)
                .executeUpdate();
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // Sepetten çıkarırken stok iade etme - Native SQL atomik işlem
    public boolean stokIadeEt(int subeId, int urunId, int miktar) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            int updatedRows = em.createNativeQuery(
                "UPDATE sube_stoklari SET mevcut_stok = mevcut_stok + :miktar " +
                "WHERE sube_id = :subeId AND urun_id = :urunId")
                .setParameter("miktar", miktar)
                .setParameter("subeId", subeId)
                .setParameter("urunId", urunId)
                .executeUpdate();
            em.getTransaction().commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }
}
