package com.datacampus.dto;

public record ReporteTopGruposRow(
        String sede,
        String periodo,
        String asignatura,
        String grupo,
        Double porcentajeOcupacion
) {
}
