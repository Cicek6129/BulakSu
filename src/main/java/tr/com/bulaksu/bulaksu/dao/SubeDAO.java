package tr.com.bulaksu.bulaksu.dao;

import tr.com.bulaksu.bulaksu.entity.Sube;
import jakarta.persistence.EntityManager;
import java.util.List;

public class SubeDAO {

    public List<Sube> findAll() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Sube s", Sube.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Sube findById(int id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.find(Sube.class, id);
        } finally {
            em.close();
        }
    }

    public List<Sube> findAktifSubeler() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Sube s WHERE s.subeAktifmi = true", Sube.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void save(Sube sube) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(sube);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void update(Sube sube) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(sube);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void deleteById(int id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            em.getTransaction().begin();
            Sube sube = em.find(Sube.class, id);
            if (sube != null) {
                em.remove(sube);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
