package com.datacampus.controller;

import com.datacampus.dto.*;
import com.datacampus.service.NotaService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/notas")
@RequiredArgsConstructor
public class NotaController {

    private final NotaService notaService;

    // Crear nota
    @PostMapping
    public ResponseEntity<NotaCrearResponse> crearNota(
            @RequestBody NotaCrearRequest request) {
        return ResponseEntity.ok(notaService.crearNota(request));
    }

    // Editar nota
    @PutMapping("/{idNota}")
    public ResponseEntity<NotaEditarResponse> editarNota(
            @PathVariable Integer idNota,
            @RequestBody NotaEditarRequest request) {
        return ResponseEntity.ok(notaService.editarNota(idNota, request));
    }

    // Listar notas de un estudiante
    @GetMapping("/estudiante/{id}")
    public ResponseEntity<NotasEstudianteResponse> listarPorEstudiante(
            @PathVariable Integer id) {
        return ResponseEntity.ok(notaService.listarNotasPorEstudiante(id));
    }

    // Listar notas de un grupo
    @GetMapping("/grupo/{id}")
    public ResponseEntity<NotasGrupoResponse> listarPorGrupo(
            @PathVariable Integer id) {
        return ResponseEntity.ok(notaService.listarNotasPorGrupo(id));
    }
}
