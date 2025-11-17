package com.datacampus.controller;

import com.datacampus.dto.*;
import com.datacampus.service.ReporteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reportes")
@RequiredArgsConstructor
public class ReportesController {

    private final ReporteService reporteService;

    // 1) Matrícula y carga por periodo
    @GetMapping("/matricula-carga")
    public ResponseEntity<List<ReporteMatriculaCargaRow>> matriculaCarga(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteMatriculaCarga(idPeriodo));
    }

    // 2) Ocupación y top grupos
    @GetMapping("/top-grupos")
    public ResponseEntity<List<ReporteTopGruposRow>> topGrupos(
            @RequestParam Integer idPeriodo,
            @RequestParam(required = false, defaultValue = "10") Integer limite) {
        return ResponseEntity.ok(reporteService.reporteTopGrupos(idPeriodo, limite));
    }

    // 3) Intentos fallidos de matrícula
    @GetMapping("/intentos-fallidos")
    public ResponseEntity<List<ReporteIntentosFallidosRow>> intentosFallidos(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteIntentosFallidos(idPeriodo));
    }

    // 4) Rendimiento por asignatura
    @GetMapping("/rendimiento-asignatura")
    public ResponseEntity<List<ReporteRendimientoAsignaturaRow>> rendimientoAsignatura(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteRendimientoAsignatura(idPeriodo));
    }

    // 5) Distribución de notas
    @GetMapping("/distribucion-notas")
    public ResponseEntity<List<ReporteDistribucionNotasRow>> distribucionNotas(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteDistribucionNotas(idPeriodo));
    }

    // 6) Evolución de promedio por estudiante
    @GetMapping("/evolucion-promedio")
    public ResponseEntity<List<ReporteEvolucionPromedioRow>> evolucionPromedio(
            @RequestParam Integer idEstudiante) {
        return ResponseEntity.ok(reporteService.reporteEvolucionPromedio(idEstudiante));
    }

    // 7) Riesgo académico por periodo
    @GetMapping("/riesgo-periodo")
    public ResponseEntity<List<ReporteRiesgoPeriodoRow>> riesgoPeriodo(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteRiesgoPeriodo(idPeriodo));
    }

    // 8) Intentos por asignatura
    @GetMapping("/intentos-por-asignatura")
    public ResponseEntity<List<ReporteIntentosAsignaturaRow>> intentosPorAsignatura(
            @RequestParam Integer idPeriodo) {
        return ResponseEntity.ok(reporteService.reporteIntentosPorAsignatura(idPeriodo));
    }

    // 9) Trayectoria por cohorte
    @GetMapping("/trayectoria-cohorte")
    public ResponseEntity<List<ReporteTrayectoriaCohorteRow>> trayectoriaCohorte(
            @RequestParam Integer anioCohorte) {
        return ResponseEntity.ok(reporteService.reporteTrayectoriaCohorte(anioCohorte));
    }

    // 10) Mapa de prerrequisitos
    @GetMapping("/mapa-prerrequisitos")
    public ResponseEntity<List<ReporteMapaPrerrequisitosRow>> mapaPrerrequisitos(
            @RequestParam Integer idAsignaturaRaiz) {
        return ResponseEntity.ok(reporteService.reporteMapaPrerrequisitos(idAsignaturaRaiz));
    }
}
