package tr.com.bulaksu.bulaksu;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckAdminEncoding {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/bulaksu?zeroDateTimeBehavior=CONVERT_TO_NULL&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Europe/Istanbul&useUnicode=true&characterEncoding=UTF-8";
        String user = "root";
        String password = "E29RmAvIs";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String query = "SELECT ad_soyad FROM kullanicilar WHERE rol = 'ADMIN'";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    System.out.println("DB Value: " + rs.getString("ad_soyad"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
