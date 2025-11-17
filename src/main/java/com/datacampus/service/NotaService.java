package com.datacampus.service;

import com.datacampus.dto.*;

public interface NotaService {

    NotaCrearResponse crearNota(NotaCrearRequest request);

    NotaEditarResponse editarNota(Integer idNota, NotaEditarRequest request);

    NotasEstudianteResponse listarNotasPorEstudiante(Integer idEstudiante);

    NotasGrupoResponse listarNotasPorGrupo(Integer idGrupo);
}
