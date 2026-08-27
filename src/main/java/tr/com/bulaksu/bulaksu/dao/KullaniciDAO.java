package tr.com.bulaksu.bulaksu.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import tr.com.bulaksu.bulaksu.entity.Kullanici;

import java.util.List;

public class KullaniciDAO {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("bulaksu-PU");

    public void save(Kullanici kullanici) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.persist(kullanici);
        em.getTransaction().commit();
        em.close();
    }

    public void update(Kullanici kullanici) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        em.merge(kullanici);
        em.getTransaction().commit();
        em.close();
    }

    public Kullanici findById(Integer id) {
        EntityManager em = emf.createEntityManager();
        Kullanici kullanici = em.find(Kullanici.class, id);
        em.close();
        return kullanici;
    }

    public List<Kullanici> findAll() {
        EntityManager em = emf.createEntityManager();
        List<Kullanici> list = em.createQuery("SELECT k FROM Kullanici k ORDER BY k.kayitTarihi DESC", Kullanici.class).getResultList();
        em.close();
        return list;
    }

    public void deleteById(Integer id) {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();
        Kullanici k = em.find(Kullanici.class, id);
        if (k != null) {
            em.remove(k);
        }
        em.getTransaction().commit();
        em.close();
    }

    public Kullanici findByEmailAndSifre(String emailOrUsername, String sifre) {
        EntityManager em = emf.createEntityManager();
        try {
            String sifreHash = sha256(sifre);
            List<Kullanici> list = em.createQuery("SELECT k FROM Kullanici k WHERE (k.email = :login OR k.adSoyad = :login) AND k.sifre = :sifre AND k.aktif = true", Kullanici.class)
                    .setParameter("login", emailOrUsername)
                    .setParameter("sifre", sifreHash)
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            return null; // Not found or error
        } finally {
            em.close();
        }
    }

    public Kullanici findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT k FROM Kullanici k WHERE k.email = :email", Kullanici.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null; // Not found
        } finally {
            em.close();
        }
    }

    public static String sha256(String input) {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
