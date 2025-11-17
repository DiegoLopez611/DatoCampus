package com.datacampus.dto;

import java.util.List;

public record NotasEstudianteResponse(
        Integer idEstudiante,
        List<NotaDetalle> notas
) {
}
