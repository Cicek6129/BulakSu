package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "siparisler")
public class Siparis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "siparis_id")
    private Integer siparisId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sube_id", nullable = false)
    private Sube sube;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "kullanici_id")
    private Kullanici kullanici;

    @Column(name = "toplam_tutar", precision = 10, scale = 2)
    private BigDecimal toplamTutar = BigDecimal.ZERO;

    @Column(name = "siparis_durumu")
    private String siparisDurumu;

    @Column(name = "siparis_tarihi", insertable = false, updatable = false)
    private LocalDateTime siparisTarihi;

    @Column(name = "musteri_ad", length = 100)
    private String musteriAd;

    @Column(name = "musteri_telefon", length = 20)
    private String musteriTelefon;

    @Column(name = "siparis_tipi", length = 10)
    private String siparisTipi;

    @OneToMany(mappedBy = "siparis", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<SiparisDetay> siparisDetaylari;

    public Siparis() {}

    public Integer getSiparisId() {
        return siparisId;
    }

    public void setSiparisId(Integer siparisId) {
        this.siparisId = siparisId;
    }

    public Sube getSube() {
        return sube;
    }

    public void setSube(Sube sube) {
        this.sube = sube;
    }

    public Kullanici getKullanici() {
        return kullanici;
    }

    public void setKullanici(Kullanici kullanici) {
        this.kullanici = kullanici;
    }

    public BigDecimal getToplamTutar() {
        return toplamTutar;
    }

    public void setToplamTutar(BigDecimal toplamTutar) {
        this.toplamTutar = toplamTutar;
    }

    public String getSiparisDurumu() {
        return siparisDurumu;
    }

    public void setSiparisDurumu(String siparisDurumu) {
        this.siparisDurumu = siparisDurumu;
    }

    public LocalDateTime getSiparisTarihi() {
        return siparisTarihi;
    }

    public void setSiparisTarihi(LocalDateTime siparisTarihi) {
        this.siparisTarihi = siparisTarihi;
    }

    public String getMusteriAd() {
        return musteriAd;
    }

    public void setMusteriAd(String musteriAd) {
        this.musteriAd = musteriAd;
    }

    public String getMusteriTelefon() {
        return musteriTelefon;
    }

    public void setMusteriTelefon(String musteriTelefon) {
        this.musteriTelefon = musteriTelefon;
    }

    public String getSiparisTipi() {
        return siparisTipi;
    }

    public void setSiparisTipi(String siparisTipi) {
        this.siparisTipi = siparisTipi;
    }

    public List<SiparisDetay> getSiparisDetaylari() {
        return siparisDetaylari;
    }

    public void setSiparisDetaylari(List<SiparisDetay> siparisDetaylari) {
        this.siparisDetaylari = siparisDetaylari;
    }
}
