package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "siparis_detaylari")
public class SiparisDetay {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "detay_id")
    private Integer detayId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "siparis_id", nullable = false)
    private Siparis siparis;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "urun_id", nullable = false)
    private Urun urun;

    @Column(name = "miktar", nullable = false)
    private Integer miktar = 1;

    @Column(name = "siparis_tipi", nullable = false)
    private String siparisTipi = "G";

    @Column(name = "birim_fiyat", nullable = false, precision = 10, scale = 2)
    private BigDecimal birimFiyat;

    @Column(name = "toplam_fiyat", insertable = false, updatable = false, precision = 10, scale = 2)
    private BigDecimal toplamFiyat;

    public SiparisDetay() {}

    public Integer getDetayId() {
        return detayId;
    }

    public void setDetayId(Integer detayId) {
        this.detayId = detayId;
    }

    public Siparis getSiparis() {
        return siparis;
    }

    public void setSiparis(Siparis siparis) {
        this.siparis = siparis;
    }

    public Urun getUrun() {
        return urun;
    }

    public void setUrun(Urun urun) {
        this.urun = urun;
    }

    public Integer getMiktar() {
        return miktar;
    }

    public void setMiktar(Integer miktar) {
        this.miktar = miktar;
    }

    public String getSiparisTipi() {
        return siparisTipi;
    }

    public void setSiparisTipi(String siparisTipi) {
        this.siparisTipi = siparisTipi;
    }

    public BigDecimal getBirimFiyat() {
        return birimFiyat;
    }

    public void setBirimFiyat(BigDecimal birimFiyat) {
        this.birimFiyat = birimFiyat;
    }

    public BigDecimal getToplamFiyat() {
        return toplamFiyat;
    }

    public void setToplamFiyat(BigDecimal toplamFiyat) {
        this.toplamFiyat = toplamFiyat;
    }
}
