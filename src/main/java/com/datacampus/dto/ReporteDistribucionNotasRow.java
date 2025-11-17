package com.datacampus.dto;

public record ReporteDistribucionNotasRow(
        String asignatura,
        String periodo,
        String rango,
        Integer cantidad
) {
}
