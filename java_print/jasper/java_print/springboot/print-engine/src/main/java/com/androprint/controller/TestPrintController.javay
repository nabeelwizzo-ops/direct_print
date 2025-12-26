package com.androprint.controller;

import net.sf.jasperreports.engine.*;
import org.springframework.web.bind.annotation.*;

import javax.sql.DataSource;
import java.util.Map;

@RestController
@RequestMapping("/print")
public class TestPrintController {

    private final DataSource dataSource;

    public TestPrintController(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @PostMapping("/test")
    public String testPrint(@RequestBody Map<String, Object> params) throws Exception {

        JasperPrint print = JasperFillManager.fillReport(
                this.getClass()
                    .getResourceAsStream("/jasper/compiled/ThermalPrintB2b_TAXGST.jasper"),
                params,
                dataSource.getConnection()
        );

        JasperPrintManager.printReport(print, false);

        return "PRINT OK";
    }
}
