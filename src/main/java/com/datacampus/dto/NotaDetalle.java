package com.datacampus.dto;

public record NotaDetalle(

        Integer idNota,
        String asignatura,
        String tipoNota,
        Double valor,
        Double porcentaje
) {
}
