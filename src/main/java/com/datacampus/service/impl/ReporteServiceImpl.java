package com.datacampus.service.impl;

import com.datacampus.dto.*;
import com.datacampus.service.ReporteService;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ReporteServiceImpl implements ReporteService {

    private final JdbcTemplate jdbc;

    @Override
    public List<ReporteMatriculaCargaRow> reporteMatriculaCarga(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_MATRICULA_CARGA")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapMatriculaCarga(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteMatriculaCargaRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteTopGruposRow> reporteTopGrupos(Integer idPeriodo, Integer limite) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_TOP_GRUPOS")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlParameter("P_LIMITE", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapTopGrupos(rs));

        Map<String, Object> out = call.execute(idPeriodo, limite);
        return (List<ReporteTopGruposRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteIntentosFallidosRow> reporteIntentosFallidos(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_INTENTOS_FALLIDOS")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapIntentosFallidos(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteIntentosFallidosRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteRendimientoAsignaturaRow> reporteRendimientoAsignatura(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_RENDIMIENTO_ASIG")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapRendimientoAsignatura(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteRendimientoAsignaturaRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteDistribucionNotasRow> reporteDistribucionNotas(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_DISTRIB_NOTAS")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapDistribucionNotas(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteDistribucionNotasRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteEvolucionPromedioRow> reporteEvolucionPromedio(Integer idEstudiante) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_EVOLUCION_PROMEDIO")
                .declareParameters(
                        new SqlParameter("P_ID_ESTUDIANTE", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapEvolucionPromedio(rs));

        Map<String, Object> out = call.execute(idEstudiante);
        return (List<ReporteEvolucionPromedioRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteRiesgoPeriodoRow> reporteRiesgoPeriodo(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_RIESGO_PERIODO")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapRiesgoPeriodo(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteRiesgoPeriodoRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteIntentosAsignaturaRow> reporteIntentosPorAsignatura(Integer idPeriodo) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_INTENTOS_ASIG")
                .declareParameters(
                        new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapIntentosAsignatura(rs));

        Map<String, Object> out = call.execute(idPeriodo);
        return (List<ReporteIntentosAsignaturaRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteTrayectoriaCohorteRow> reporteTrayectoriaCohorte(Integer anioCohorte) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_TRAYECTORIA_COHORTE")
                .declareParameters(
                        new SqlParameter("P_ANIO_COHORTE", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapTrayectoriaCohorte(rs));

        Map<String, Object> out = call.execute(anioCohorte);
        return (List<ReporteTrayectoriaCohorteRow>) out.get("P_CURSOR");
    }


    @Override
    public List<ReporteMapaPrerrequisitosRow> reporteMapaPrerrequisitos(Integer idAsignaturaRaiz) {
        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_REPORTES")
                .withProcedureName("REP_MAPA_PRERREQ")
                .declareParameters(
                        new SqlParameter("P_ID_ASIG_RAIZ", OracleTypes.NUMBER),
                        new SqlOutParameter("P_CURSOR", OracleTypes.CURSOR)
                )
                .returningResultSet("P_CURSOR", (rs, rn) -> mapMapaPrerrequisitos(rs));

        Map<String, Object> out = call.execute(idAsignaturaRaiz);
        return (List<ReporteMapaPrerrequisitosRow>) out.get("P_CURSOR");
    }


    private ReporteMatriculaCargaRow mapMatriculaCarga(ResultSet rs) throws SQLException {
        return new ReporteMatriculaCargaRow(
                rs.getString("programa"),
                rs.getString("sede"),
                rs.getString("asignatura"),
                rs.getString("grupo"),
                rs.getInt("inscritos"),
                rs.getInt("creditos"),
                rs.getDouble("porcentaje_ocupacion")
        );
    }

    private ReporteTopGruposRow mapTopGrupos(ResultSet rs) throws SQLException {
        return new ReporteTopGruposRow(
                rs.getString("sede"),
                rs.getString("periodo"),
                rs.getString("asignatura"),
                rs.getString("grupo"),
                rs.getDouble("porcentaje_ocupacion")
        );
    }

    private ReporteIntentosFallidosRow mapIntentosFallidos(ResultSet rs) throws SQLException {
        return new ReporteIntentosFallidosRow(
                rs.getString("asignatura"),
                rs.getString("grupo"),
                rs.getString("motivo"),
                rs.getInt("cantidad")
        );
    }

    private ReporteRendimientoAsignaturaRow mapRendimientoAsignatura(ResultSet rs) throws SQLException {
        return new ReporteRendimientoAsignaturaRow(
                rs.getString("asignatura"),
                rs.getString("periodo"),
                rs.getDouble("promedio"),
                rs.getDouble("nota_minima"),
                rs.getDouble("nota_maxima"),
                rs.getDouble("desviacion")
        );
    }

    private ReporteDistribucionNotasRow mapDistribucionNotas(ResultSet rs) throws SQLException {
        return new ReporteDistribucionNotasRow(
                rs.getString("asignatura"),
                rs.getString("periodo"),
                rs.getString("rango"),
                rs.getInt("cantidad")
        );
    }

    private ReporteEvolucionPromedioRow mapEvolucionPromedio(ResultSet rs) throws SQLException {
        return new ReporteEvolucionPromedioRow(
                rs.getString("periodo"),
                rs.getDouble("promedio"),
                rs.getDouble("variacion")
        );
    }

    private ReporteRiesgoPeriodoRow mapRiesgoPeriodo(ResultSet rs) throws SQLException {
        return new ReporteRiesgoPeriodoRow(
                rs.getString("programa"),
                rs.getString("periodo"),
                rs.getInt("nivel_riesgo"),
                rs.getInt("cantidad_estudiantes")
        );
    }

    private ReporteIntentosAsignaturaRow mapIntentosAsignatura(ResultSet rs) throws SQLException {
        return new ReporteIntentosAsignaturaRow(
                rs.getString("asignatura"),
                rs.getInt("intentos"),
                rs.getDouble("tasa_aprobacion")
        );
    }

    private ReporteTrayectoriaCohorteRow mapTrayectoriaCohorte(ResultSet rs) throws SQLException {
        return new ReporteTrayectoriaCohorteRow(
                rs.getString("cohorte"),
                rs.getString("asignatura"),
                rs.getDouble("porcentaje_oportuno"),
                rs.getDouble("porcentaje_atraso")
        );
    }

    private ReporteMapaPrerrequisitosRow mapMapaPrerrequisitos(ResultSet rs) throws SQLException {
        return new ReporteMapaPrerrequisitosRow(
                rs.getString("asignatura"),
                rs.getInt("nivel"),
                rs.getString("prerrequisito_padre"),
                rs.getString("prerrequisito_hijo")
        );
    }

}
