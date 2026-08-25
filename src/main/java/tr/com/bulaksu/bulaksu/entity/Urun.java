package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "urunler")
public class Urun {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "urun_id")
    private Integer urunId;

    @Column(name = "urun_adi", length = 100)
    private String urunAdi;

    @Column(name = "URUN_SATISTAMI")
    private Boolean urunSatistami = true;

    @Column(name = "gorsel_url", length = 500)
    private String gorselUrl;

    public Urun() {}

    public Integer getUrunId() {
        return urunId;
    }

    public void setUrunId(Integer urunId) {
        this.urunId = urunId;
    }

    public String getUrunAdi() {
        return urunAdi;
    }

    public void setUrunAdi(String urunAdi) {
        this.urunAdi = urunAdi;
    }

    public Boolean getUrunSatistami() {
        return urunSatistami;
    }

    public void setUrunSatistami(Boolean urunSatistami) {
        this.urunSatistami = urunSatistami;
    }

    public String getGorselUrl() {
        return gorselUrl;
    }

    public void setGorselUrl(String gorselUrl) {
        this.gorselUrl = gorselUrl;
    }
}
