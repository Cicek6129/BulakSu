package tr.com.bulaksu.bulaksu.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import tr.com.bulaksu.bulaksu.entity.Kullanici;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Collections;
import java.util.List;

public class KullaniciDAO {

    public void save(Kullanici kullanici) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Eğer ilişkili sube nesnesi detached ise persist öncesi referansı em ile almak daha güvenlidir
            if (kullanici.getSube() != null && kullanici.getSube().getSubeId() != null) {
                kullanici.setSube(em.getReference(kullanici.getSube().getClass(), kullanici.getSube().getSubeId()));
            }
            em.persist(kullanici);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public void update(Kullanici kullanici) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(kullanici);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Kullanici findById(Integer id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.find(Kullanici.class, id);
        } finally {
            em.close();
        }
    }

    public List<Kullanici> findAll() {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT k FROM Kullanici k ORDER BY k.kayitTarihi DESC", Kullanici.class).getResultList();
        } catch (Exception e) {
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public void deleteById(Integer id) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Kullanici k = em.find(Kullanici.class, id);
            if (k != null) {
                em.remove(k);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }

    public Kullanici findByEmailAndSifre(String emailOrUsername, String sifre) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            String sifreHash = sha256(sifre);
            List<Kullanici> list = em.createQuery("SELECT k FROM Kullanici k WHERE (k.email = :login OR k.adSoyad = :login) AND k.sifre = :sifre AND k.aktif = true", Kullanici.class)
                    .setParameter("login", emailOrUsername)
                    .setParameter("sifre", sifreHash)
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public Kullanici findByEmail(String email) {
        EntityManager em = EntityManagerProvider.getEntityManager();
        try {
            return em.createQuery("SELECT k FROM Kullanici k WHERE k.email = :email", Kullanici.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

    public static String sha256(String input) {
        if (input == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
