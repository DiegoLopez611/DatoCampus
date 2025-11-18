package com.datacampus.service.impl;

import com.datacampus.service.GrupoService;
import com.datacampus.dto.*;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class GrupoServiceImpl implements GrupoService {

    private final JdbcTemplate jdbc;

    @Override
    public GrupoCrearResponse crearGrupo(GrupoCrearRequest request) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_GRUPO")
                    .withProcedureName("CREAR_GRUPO")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_NOMBRE", OracleTypes.VARCHAR),
                            new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_ASIGNATURA", OracleTypes.NUMBER),
                            new SqlOutParameter("P_ID_GRUPO", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> out = call.execute(
                    request.nombre(),
                    request.idPeriodoAcademico(),
                    request.idAsignatura()
            );

            Integer idGrupo = out.get("P_ID_GRUPO") != null
                    ? ((Number) out.get("P_ID_GRUPO")).intValue()
                    : null;

            String mensaje = (String) out.get("P_MENSAJE");

            return new GrupoCrearResponse(idGrupo, mensaje);

        } catch (DataAccessException e) {
            String msg = e.getMostSpecificCause().getMessage();
            return new GrupoCrearResponse(null, "ERROR BD: " + msg);
        }
    }

    @Override
    public GrupoAsignarDocenteResponse asignarDocente(Integer idGrupo, GrupoAsignarDocenteRequest request) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_GRUPO")
                    .withProcedureName("ASIGNAR_DOCENTE")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_ID_GRUPO", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_DOCENTE", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> out = call.execute(
                    idGrupo,
                    request.idDocente()
            );

            String mensaje = (String) out.get("P_MENSAJE");

            return new GrupoAsignarDocenteResponse(
                    idGrupo,
                    request.idDocente(),
                    mensaje
            );

        } catch (DataAccessException e) {
            String msg = e.getMostSpecificCause().getMessage();
            return new GrupoAsignarDocenteResponse(
                    idGrupo,
                    request.idDocente(),
                    "ERROR BD: " + msg
            );
        }
    }

    @Override
    public ClaseCrearResponse crearClase(Integer idGrupo, ClaseCrearRequest request) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_GRUPO")
                    .withProcedureName("CREAR_CLASE")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_ID_GRUPO", OracleTypes.NUMBER),
                            new SqlParameter("P_DIA", OracleTypes.VARCHAR),
                            new SqlParameter("P_HORA_INICIO", OracleTypes.VARCHAR),
                            new SqlParameter("P_HORA_FIN", OracleTypes.VARCHAR),
                            new SqlParameter("P_ID_AULA", OracleTypes.NUMBER),
                            new SqlOutParameter("P_ID_CLASE", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> out = call.execute(
                    idGrupo,
                    request.dia(),
                    request.horaInicio(),
                    request.horaFin(),
                    request.idAula()
            );

            Integer idClase = out.get("P_ID_CLASE") != null
                    ? ((Number) out.get("P_ID_CLASE")).intValue()
                    : null;

            String mensaje = (String) out.get("P_MENSAJE");

            return new ClaseCrearResponse(idGrupo, idClase, mensaje);

        } catch (DataAccessException e) {
            return new ClaseCrearResponse(idGrupo, null, "ERROR BD: " + e.getMostSpecificCause().getMessage());
        }
    }
}
