package com.datacampus.dto;

public record ReporteMatriculaCargaRow(

        String programa,
        String sede,
        String asignatura,
        String grupo,
        Integer inscritos,
        Integer creditos,
        Double porcentajeOcupacion
) {
}
