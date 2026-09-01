package tr.com.bulaksu.bulaksu.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import tr.com.bulaksu.bulaksu.dao.SiparisDAO;
import tr.com.bulaksu.bulaksu.entity.Siparis;
import tr.com.bulaksu.bulaksu.entity.SiparisDetay;

import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/excel")
public class ExcelExportServlet extends HttpServlet {
    private final SiparisDAO siparisDAO = new SiparisDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String subeIdStr = request.getParameter("subeId");
        String baslangicTarihStr = request.getParameter("baslangicTarih");
        String bitisTarihStr = request.getParameter("bitisTarih");
        String urunIdStr = request.getParameter("urunId");
        
        Integer subeId = null;
        if (subeIdStr != null && !subeIdStr.trim().isEmpty()) {
            try {
                subeId = Integer.parseInt(subeIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        Integer urunId = null;
        if (urunIdStr != null && !urunIdStr.trim().isEmpty()) {
            try {
                urunId = Integer.parseInt(urunIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        LocalDateTime baslangic = null;
        if (baslangicTarihStr != null && !baslangicTarihStr.trim().isEmpty()) {
            baslangic = LocalDate.parse(baslangicTarihStr).atStartOfDay();
        }
        
        LocalDateTime bitis = null;
        if (bitisTarihStr != null && !bitisTarihStr.trim().isEmpty()) {
            bitis = LocalDate.parse(bitisTarihStr).atTime(23, 59, 59);
        }
        
        String tip = request.getParameter("siparisTipi");
        if (tip != null && tip.trim().isEmpty()) {
            tip = null;
        }
        
        List<Siparis> siparisler = siparisDAO.findByFiltrelerNativeSQL(subeId, baslangic, bitis, tip,urunId);
        
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"siparisler.xlsx\"");
        
        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {
            
            XSSFSheet sheet = workbook.createSheet("Siparişler");
            
            // Header Style
            XSSFCellStyle headerStyle = workbook.createCellStyle();
            XSSFFont headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            
            // Currency Style
            XSSFCellStyle currencyStyle = workbook.createCellStyle();
            XSSFDataFormat format = workbook.createDataFormat();
            currencyStyle.setDataFormat(format.getFormat("#,##0.00 ₺"));

            // Header
            XSSFRow headerRow = sheet.createRow(0);
            String[] headers = {"Sipariş No", "Şube", "Sipariş Tarihi", "Ürün Adı", "Miktar", "Birim Fiyat", "Toplam Fiyat", "Sipariş Tipi", "Durumu"};
            for (int i = 0; i < headers.length; i++) {
                XSSFCell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
            
            int rowNum = 1;
            for (Siparis siparis : siparisler) {
                if (siparis.getSiparisDetaylari() != null) {
                    for (SiparisDetay detay : siparis.getSiparisDetaylari()) {
                        // Eğer bir sipariş tipi filtresi varsa, sadece o tipe uyan detayları excele bas
                        if (tip != null && !tip.isEmpty() && !tip.equals(detay.getSiparisTipi())) {
                            continue;
                        }
                        
                        XSSFRow row = sheet.createRow(rowNum++);
                        
                        row.createCell(0).setCellValue(siparis.getSiparisId() != null ? String.valueOf(siparis.getSiparisId()) : "");
                        row.createCell(1).setCellValue(siparis.getSube() != null ? siparis.getSube().getSubeAdi() : "");
                        row.createCell(2).setCellValue(siparis.getSiparisTarihi() != null ? siparis.getSiparisTarihi().format(formatter) : "");
                        row.createCell(3).setCellValue(detay.getUrun() != null ? detay.getUrun().getUrunAdi() : "");
                        row.createCell(4).setCellValue(detay.getMiktar() != null ? detay.getMiktar() : 0);
                        
                        XSSFCell birimFiyatCell = row.createCell(5);
                        birimFiyatCell.setCellValue(detay.getBirimFiyat() != null ? detay.getBirimFiyat().doubleValue() : 0);
                        birimFiyatCell.setCellStyle(currencyStyle);
                        
                        XSSFCell toplamFiyatCell = row.createCell(6);
                        toplamFiyatCell.setCellValue(detay.getToplamFiyat() != null ? detay.getToplamFiyat().doubleValue() : 0);
                        toplamFiyatCell.setCellStyle(currencyStyle);
                        
                        String siparisTipiStr = detay.getSiparisTipi();
                        String readableSiparisTipi = "";
                        if (siparisTipiStr != null) {
                            switch (siparisTipiStr) {
                                case "S": readableSiparisTipi = "Servis"; break;
                                case "G": readableSiparisTipi = "Gel-Al"; break;
                                case "T": readableSiparisTipi = "Toptan"; break;
                                default: readableSiparisTipi = siparisTipiStr; break;
                            }
                        }
                        row.createCell(7).setCellValue(readableSiparisTipi);
                        row.createCell(8).setCellValue(siparis.getSiparisDurumu() != null ? siparis.getSiparisDurumu() : "");
                    }
                    
                    XSSFRow totalRow = sheet.createRow(rowNum);
                    totalRow.createCell(3).setCellValue("Toplam:");
                    XSSFCell totalMiktarCell = totalRow.createCell(4);
                    totalMiktarCell.setCellFormula("SUM(E2:E" + rowNum + ")");
                    XSSFCell totalTutarCell = totalRow.createCell(6);
                    totalTutarCell.setCellFormula("SUM(G2:G" + rowNum + ")");
                    totalTutarCell.setCellStyle(currencyStyle);
                }
            }
            
            // Auto-fit columns and set minimum widths
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                int currentWidth = sheet.getColumnWidth(i);
                int minWidth = (i == 1 || i == 3) ? 5000 : 3000;
                if (currentWidth < minWidth) {
                    sheet.setColumnWidth(i, minWidth);
                }
            }
            
            // Freeze pane (first row)
            sheet.createFreezePane(0, 1);
            
            // Auto filter
            if (rowNum > 1) {
                sheet.setAutoFilter(new CellRangeAddress(0, rowNum - 1, 0, headers.length - 1));
            }
            
            workbook.write(out);
        }
    }
}
