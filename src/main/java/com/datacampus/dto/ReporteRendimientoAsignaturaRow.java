package com.datacampus.dto;

public record ReporteRendimientoAsignaturaRow(
        String asignatura,
        String periodo,
        Double promedio,
        Double notaMinima,
        Double notaMaxima,
        Double desviacion
) {
}
