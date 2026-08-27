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
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import tr.com.bulaksu.bulaksu.dao.SubeStokDAO;
import tr.com.bulaksu.bulaksu.entity.SubeStok;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet("/admin/stok/excel")
public class StokExcelExportServlet extends HttpServlet {
    private final SubeStokDAO subeStokDAO = new SubeStokDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String subeIdStr = request.getParameter("subeId");
        
        Integer subeId = null;
        if (subeIdStr != null && !subeIdStr.trim().isEmpty()) {
            try {
                subeId = Integer.parseInt(subeIdStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        
        List<SubeStok> stoklar;
        if (subeId != null) {
            stoklar = subeStokDAO.findBySubeId(subeId);
        } else {
            stoklar = subeStokDAO.getAggregatedStok();
        }
        
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"stok_durumu.xlsx\"");
        
        try (XSSFWorkbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {
            
            XSSFSheet sheet = workbook.createSheet("Stok Durumu");
            
            // Header Style
            XSSFCellStyle headerStyle = workbook.createCellStyle();
            XSSFFont headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            
            // Header
            XSSFRow headerRow = sheet.createRow(0);
            String[] headers = {"Ürün Adı", "Şube", "Mevcut Stok", "Kritik Seviye", "Durum"};
            for (int i = 0; i < headers.length; i++) {
                XSSFCell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            
            int rowNum = 1;
            for (SubeStok stok : stoklar) {
                XSSFRow row = sheet.createRow(rowNum++);
                
                row.createCell(0).setCellValue(stok.getUrun() != null ? stok.getUrun().getUrunAdi() : "");
                row.createCell(1).setCellValue(stok.getSube() != null ? stok.getSube().getSubeAdi() : "Tüm Şubeler");
                row.createCell(2).setCellValue(stok.getMevcutStok() != null ? stok.getMevcutStok() : 0);
                row.createCell(3).setCellValue(stok.getKritikStokSeviyesi() != null ? stok.getKritikStokSeviyesi() : 0);
                
                String durum = "";
                if (stok.getMevcutStok() == null || stok.getMevcutStok() == 0) {
                    durum = "Tükendi";
                } else if (stok.getKritikStokSeviyesi() != null && stok.getMevcutStok() <= stok.getKritikStokSeviyesi()) {
                    durum = "Kritik";
                } else {
                    durum = "Yeterli";
                }
                row.createCell(4).setCellValue(durum);
            }
            
            // Auto-fit columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                int currentWidth = sheet.getColumnWidth(i);
                int minWidth = 4000;
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
