package com.datacampus.dto;

public record ReporteMapaPrerrequisitosRow(
        String asignatura,
        Integer nivel,
        String prerrequisitoPadre,
        String prerrequisitoHijo
) {
}
