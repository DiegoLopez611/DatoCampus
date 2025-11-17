package com.datacampus.service;

import com.datacampus.dto.*;

public interface GrupoService {

    GrupoCrearResponse crearGrupo(GrupoCrearRequest request);

    GrupoAsignarDocenteResponse asignarDocente(Integer idGrupo, GrupoAsignarDocenteRequest request);

    ClaseCrearResponse crearClase(Integer idGrupo, ClaseCrearRequest request);
}
