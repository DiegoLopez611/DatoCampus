package com.datacampus.dto;

public record ClaseCrearRequest(

        String dia,
        String horaInicio,
        String horaFin,
        Integer idAula
) {
}
