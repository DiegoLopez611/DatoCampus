package com.datacampus.dto;

import java.util.List;

public record NotasGrupoResponse(
        Integer idGrupo,
        List<NotaDetalle> notas
) {
}
