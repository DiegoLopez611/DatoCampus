package com.datacampus.dto;

public record NotaCrearRequest(

        Integer idDetalleMatricula,
        Integer idConfiguracionNota,
        Double valor
) {
}
