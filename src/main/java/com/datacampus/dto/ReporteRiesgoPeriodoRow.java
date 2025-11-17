package com.datacampus.dto;

public record ReporteRiesgoPeriodoRow(
        String programa,
        String periodo,
        Integer nivelRiesgo,
        Integer cantidadEstudiantes
) {
}
