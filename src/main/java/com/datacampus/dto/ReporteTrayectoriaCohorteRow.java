package com.datacampus.dto;

public record ReporteTrayectoriaCohorteRow(
        String cohorte,
        String asignatura,
        Double porcentajeOportuno,
        Double porcentajeAtraso
) {
}
