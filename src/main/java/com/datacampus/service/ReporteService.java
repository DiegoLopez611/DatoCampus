package com.datacampus.service;

import com.datacampus.dto.*;

import java.util.List;

public interface ReporteService {

    List<ReporteMatriculaCargaRow> reporteMatriculaCarga(Integer idPeriodo);

    List<ReporteTopGruposRow> reporteTopGrupos(Integer idPeriodo, Integer limite);

    List<ReporteIntentosFallidosRow> reporteIntentosFallidos(Integer idPeriodo);

    List<ReporteRendimientoAsignaturaRow> reporteRendimientoAsignatura(Integer idPeriodo);

    List<ReporteDistribucionNotasRow> reporteDistribucionNotas(Integer idPeriodo);

    List<ReporteEvolucionPromedioRow> reporteEvolucionPromedio(Integer idEstudiante);

    List<ReporteRiesgoPeriodoRow> reporteRiesgoPeriodo(Integer idPeriodo);

    List<ReporteIntentosAsignaturaRow> reporteIntentosPorAsignatura(Integer idPeriodo);

    List<ReporteTrayectoriaCohorteRow> reporteTrayectoriaCohorte(Integer anioCohorte);

    List<ReporteMapaPrerrequisitosRow> reporteMapaPrerrequisitos(Integer idAsignaturaRaiz);
}
