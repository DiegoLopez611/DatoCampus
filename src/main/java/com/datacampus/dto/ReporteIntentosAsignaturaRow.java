package com.datacampus.dto;

public record ReporteIntentosAsignaturaRow(
        String asignatura,
        Integer intentos,
        Double tasaAprobacion
) {
}
