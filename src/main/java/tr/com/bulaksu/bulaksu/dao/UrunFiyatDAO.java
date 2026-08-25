package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.UrunFiyat;
import jakarta.persistence.EntityManager;
import java.util.List;

public class UrunFiyatDAO {

    public UrunFiyat findByUrunIdVeSubeId(int urunId, int subeId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT uf FROM UrunFiyat uf WHERE uf.urun.urunId = :urunId AND uf.sube.subeId = :subeId", UrunFiyat.class)
                     .setParameter("urunId", urunId)
                     .setParameter("subeId", subeId)
                     .getSingleResult();
        } catch (jakarta.persistence.NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<UrunFiyat> findBySubeId(int subeId) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT uf FROM UrunFiyat uf WHERE uf.sube.subeId = :subeId", UrunFiyat.class)
                     .setParameter("subeId", subeId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public List<UrunFiyat> findAll() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT uf FROM UrunFiyat uf", UrunFiyat.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void save(UrunFiyat urunFiyat) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(urunFiyat);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(UrunFiyat urunFiyat) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(urunFiyat);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public int bulkFiyatGuncelle(double carpan) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            int updatedCount = em.createQuery("UPDATE UrunFiyat uf SET uf.fiyatGelAl = uf.fiyatGelAl * :carpan, uf.fiyatServis = uf.fiyatServis * :carpan, uf.fiyatToptan = uf.fiyatToptan * :carpan")
                                 .setParameter("carpan", carpan)
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
