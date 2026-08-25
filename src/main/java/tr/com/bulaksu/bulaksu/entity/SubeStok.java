package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "sube_stoklari")
public class SubeStok {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stok_id")
    private Integer stokId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sube_id", nullable = false)
    private Sube sube;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "urun_id", nullable = false)
    private Urun urun;

    @Column(name = "mevcut_stok")
    private Integer mevcutStok = 0;

    @Column(name = "kritik_stok_seviyesi")
    private Integer kritikStokSeviyesi = 0;

    public SubeStok() {}

    public Integer getStokId() {
        return stokId;
    }

    public void setStokId(Integer stokId) {
        this.stokId = stokId;
    }

    public Sube getSube() {
        return sube;
    }

    public void setSube(Sube sube) {
        this.sube = sube;
    }

    public Urun getUrun() {
        return urun;
    }

    public void setUrun(Urun urun) {
        this.urun = urun;
    }

    public Integer getMevcutStok() {
        return mevcutStok;
    }

    public void setMevcutStok(Integer mevcutStok) {
        this.mevcutStok = mevcutStok;
    }

    public Integer getKritikStokSeviyesi() {
        return kritikStokSeviyesi;
    }

    public void setKritikStokSeviyesi(Integer kritikStokSeviyesi) {
        this.kritikStokSeviyesi = kritikStokSeviyesi;
    }
}
