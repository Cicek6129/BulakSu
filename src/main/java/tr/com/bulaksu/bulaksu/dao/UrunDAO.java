package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.Urun;
import jakarta.persistence.EntityManager;
import java.util.List;

public class UrunDAO {

    public List<Urun> findAll() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM Urun u", Urun.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Urun findById(int id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.find(Urun.class, id);
        } finally {
            em.close();
        }
    }

    public List<Urun> findSatistakiUrunler() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM Urun u WHERE u.urunSatistami = true", Urun.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Urun> findByAdContaining(String ad) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT u FROM Urun u WHERE u.urunAdi LIKE :ad", Urun.class)
                     .setParameter("ad", "%" + ad + "%")
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public void save(Urun urun) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(urun);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(Urun urun) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(urun);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void deleteById(int id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery("DELETE FROM Urun u WHERE u.urunId = :id")
              .setParameter("id", id)
              .executeUpdate();
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public int bulkUpdateGorselUrl(String url) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            int updatedCount = em.createQuery("UPDATE Urun u SET u.gorselUrl = :url WHERE u.gorselUrl IS NULL OR u.gorselUrl = ''")
                                 .setParameter("url", url)
                                 .executeUpdate();
            em.getTransaction().commit();
            return updatedCount;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
