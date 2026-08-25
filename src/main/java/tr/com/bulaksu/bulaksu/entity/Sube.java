package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "subeler")
public class Sube {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "sube_id")
    private Integer subeId;

    @Column(name = "sube_adi", length = 100, nullable = false)
    private String subeAdi;

    @Column(name = "adres", length = 255)
    private String adres;

    @Column(name = "SUBE_AKTIFMI")
    private Boolean subeAktifmi = true;

    public Sube() {}

    public Integer getSubeId() {
        return subeId;
    }

    public void setSubeId(Integer subeId) {
        this.subeId = subeId;
    }

    public String getSubeAdi() {
        return subeAdi;
    }

    public void setSubeAdi(String subeAdi) {
        this.subeAdi = subeAdi;
    }

    public String getAdres() {
        return adres;
    }

    public void setAdres(String adres) {
        this.adres = adres;
    }

    public Boolean getSubeAktifmi() {
        return subeAktifmi;
    }

    public void setSubeAktifmi(Boolean subeAktifmi) {
        this.subeAktifmi = subeAktifmi;
    }
}
