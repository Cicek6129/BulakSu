package tr.com.bulaksu.bulaksu.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "kullanicilar")
public class Kullanici {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "kullanici_id")
    private Integer kullaniciId;

    @Column(name = "ad_soyad", length = 100, nullable = false)
    private String adSoyad;

    @Column(name = "email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "sifre", length = 255, nullable = false)
    private String sifre;

    @Column(name = "telefon", length = 20)
    private String telefon;

    @Column(name = "rol", length = 20, nullable = false)
    private String rol = "MUSTERI"; // Varsayılan MUSTERI

    @Column(name = "aktif")
    private Boolean aktif = true;

    @Column(name = "kayit_tarihi", insertable = false, updatable = false)
    private LocalDateTime kayitTarihi;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sube_id")
    private Sube sube;

    @OneToMany(mappedBy = "kullanici", fetch = FetchType.LAZY)
    private List<Siparis> siparisler;

    public Kullanici() {
    }

    public Integer getKullaniciId() {
        return kullaniciId;
    }

    public void setKullaniciId(Integer kullaniciId) {
        this.kullaniciId = kullaniciId;
    }

    public String getAdSoyad() {
        return adSoyad;
    }

    public void setAdSoyad(String adSoyad) {
        this.adSoyad = adSoyad;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSifre() {
        return sifre;
    }

    public void setSifre(String sifre) {
        this.sifre = sifre;
    }

    public String getTelefon() {
        return telefon;
    }

    public void setTelefon(String telefon) {
        this.telefon = telefon;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public Boolean getAktif() {
        return aktif;
    }

    public void setAktif(Boolean aktif) {
        this.aktif = aktif;
    }

    public LocalDateTime getKayitTarihi() {
        return kayitTarihi;
    }

    public void setKayitTarihi(LocalDateTime kayitTarihi) {
        this.kayitTarihi = kayitTarihi;
    }

    public Sube getSube() {
        return sube;
    }

    public void setSube(Sube sube) {
        this.sube = sube;
    }

    public List<Siparis> getSiparisler() {
        return siparisler;
    }

    public void setSiparisler(List<Siparis> siparisler) {
        this.siparisler = siparisler;
    }
}
