package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "urun_fiyatlari")
public class UrunFiyat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "fiyat_id")
    private Integer fiyatId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "urun_id", nullable = false)
    private Urun urun;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sube_id")
    private Sube sube;

    @Column(name = "fiyat_servis", nullable = false, precision = 10, scale = 2)
    private BigDecimal fiyatServis = BigDecimal.ZERO;

    @Column(name = "fiyat_gel_al", nullable = false, precision = 10, scale = 2)
    private BigDecimal fiyatGelAl = BigDecimal.ZERO;

    @Column(name = "fiyat_toptan", nullable = false, precision = 10, scale = 2)
    private BigDecimal fiyatToptan = BigDecimal.ZERO;

    @Column(name = "guncelleme_tarihi", insertable = false, updatable = false)
    private LocalDateTime guncellemeTarihi;

    public UrunFiyat() {}

    public Integer getFiyatId() {
        return fiyatId;
    }

    public void setFiyatId(Integer fiyatId) {
        this.fiyatId = fiyatId;
    }

    public Urun getUrun() {
        return urun;
    }

    public void setUrun(Urun urun) {
        this.urun = urun;
    }

    public Sube getSube() {
        return sube;
    }

    public void setSube(Sube sube) {
        this.sube = sube;
    }

    public BigDecimal getFiyatServis() {
        return fiyatServis;
    }

    public void setFiyatServis(BigDecimal fiyatServis) {
        this.fiyatServis = fiyatServis;
    }

    public BigDecimal getFiyatGelAl() {
        return fiyatGelAl;
    }

    public void setFiyatGelAl(BigDecimal fiyatGelAl) {
        this.fiyatGelAl = fiyatGelAl;
    }

    public BigDecimal getFiyatToptan() {
        return fiyatToptan;
    }

    public void setFiyatToptan(BigDecimal fiyatToptan) {
        this.fiyatToptan = fiyatToptan;
    }

    public LocalDateTime getGuncellemeTarihi() {
        return guncellemeTarihi;
    }

    public void setGuncellemeTarihi(LocalDateTime guncellemeTarihi) {
        this.guncellemeTarihi = guncellemeTarihi;
    }
}
