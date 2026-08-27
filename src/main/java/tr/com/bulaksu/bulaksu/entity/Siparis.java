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

    @Column(name = "toplam_tutar", precision = 10, scale = 2)
    private BigDecimal toplamTutar = BigDecimal.ZERO;

    @Column(name = "siparis_durumu")
    private String siparisDurumu;

    @Column(name = "siparis_tarihi", insertable = false, updatable = false)
    private LocalDateTime siparisTarihi;

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

    public List<SiparisDetay> getSiparisDetaylari() {
        return siparisDetaylari;
    }

    public void setSiparisDetaylari(List<SiparisDetay> siparisDetaylari) {
        this.siparisDetaylari = siparisDetaylari;
    }
}
