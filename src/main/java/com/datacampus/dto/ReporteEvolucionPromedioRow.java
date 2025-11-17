package com.datacampus.dto;

public record ReporteEvolucionPromedioRow(
        String periodo,
        Double promedio,
        Double variacionRespectoAnterior
) {
}
