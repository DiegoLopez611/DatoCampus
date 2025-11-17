package com.datacampus.dto;

public record ReporteIntentosFallidosRow(
        String asignatura,
        String grupo,
        String motivo,
        Integer cantidad
) {
}
