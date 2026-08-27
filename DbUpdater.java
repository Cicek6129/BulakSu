import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DbUpdater {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/bulaksu?useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "E29RmAvIs";

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             Statement stmt = conn.createStatement()) {

            String[] queries = {
                "CREATE TABLE IF NOT EXISTS kullanicilar (" +
                "kullanici_id INT AUTO_INCREMENT PRIMARY KEY, " +
                "ad_soyad VARCHAR(100) NOT NULL, " +
                "email VARCHAR(150) NOT NULL UNIQUE, " +
                "sifre VARCHAR(255) NOT NULL, " +
                "telefon VARCHAR(20), " +
                "rol VARCHAR(20) NOT NULL DEFAULT 'KASA', " +
                "aktif BOOLEAN DEFAULT true, " +
                "kayit_tarihi DATETIME DEFAULT CURRENT_TIMESTAMP)",
                
                "INSERT IGNORE INTO kullanicilar (ad_soyad, email, sifre, rol, aktif) VALUES ('Sistem Yöneticisi', 'admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', true)",
                
                // Artık kullanılmıyor: kullanici_id sütunu siparisler tablosundan kaldırıldı
                // "ALTER TABLE siparisler ADD COLUMN kullanici_id INT",
                
                "DROP TABLE IF EXISTS admin_kullanici"
            };

            for (String q : queries) {
                try {
                    stmt.executeUpdate(q);
                    System.out.println("Success: " + q);
                } catch (Exception e) {
                    System.out.println("Error on: " + q + " - " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
