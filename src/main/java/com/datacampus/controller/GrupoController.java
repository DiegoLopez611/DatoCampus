package com.datacampus.controller;

import com.datacampus.dto.*;
import com.datacampus.service.GrupoService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/grupos")
@RequiredArgsConstructor
public class GrupoController {

    private final GrupoService grupoService;

    // Crear grupo
    @PostMapping
    public ResponseEntity<GrupoCrearResponse> crearGrupo(
            @RequestBody GrupoCrearRequest request) {
        return ResponseEntity.ok(grupoService.crearGrupo(request));
    }

    // Asignar docente a un grupo
    @PostMapping("/{idGrupo}/asignar-docente")
    public ResponseEntity<GrupoAsignarDocenteResponse> asignarDocente(
            @PathVariable Integer idGrupo,
            @RequestBody GrupoAsignarDocenteRequest request) {
        return ResponseEntity.ok(grupoService.asignarDocente(idGrupo, request));
    }

    @PostMapping("/{idGrupo}/clases")
    public ResponseEntity<ClaseCrearResponse> crearClase(
            @PathVariable Integer idGrupo,
            @RequestBody ClaseCrearRequest request) {

        return ResponseEntity.ok(grupoService.crearClase(idGrupo, request));
    }

}
