package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.SiparisDetay;
import jakarta.persistence.EntityManager;
import java.util.List;

public class SiparisDetayDAO {

    public List<SiparisDetay> findBySiparisId(int siparisId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT sd FROM SiparisDetay sd WHERE sd.siparis.siparisId = :siparisId", SiparisDetay.class)
                     .setParameter("siparisId", siparisId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public SiparisDetay create(SiparisDetay detay) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(detay);
            em.getTransaction().commit();
            return detay;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error creating siparis detay", e);
        } finally {
            em.close();
        }
    }

    public List<SiparisDetay> findBySiparisTipi(String tip) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT sd FROM SiparisDetay sd WHERE sd.siparisTipi = :tip", SiparisDetay.class)
                     .setParameter("tip", tip)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}
