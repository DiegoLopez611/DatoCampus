package com.datacampus.service.impl;

import com.datacampus.dto.*;
import com.datacampus.service.MatriculaService;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.sql.Array;
import java.sql.SQLException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class MatriculaServiceImpl implements MatriculaService {

    private final JdbcTemplate jdbc;

    @Override
    public MatriculaIniciarResponse iniciarMatricula(MatriculaIniciarRequest req) {

        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_MATRICULA")
                    .withProcedureName("INICIAR_MATRICULA")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_ID_ESTUDIANTE", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_PERIODO", OracleTypes.NUMBER),
                            new SqlOutParameter("P_ID_MATRICULA", OracleTypes.NUMBER),
                            new SqlOutParameter("P_ASIGNATURAS_AUTO", OracleTypes.ARRAY, "VARCHAR2_TABLE_TYPE"),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(
                    req.idEstudiante(),
                    req.idPeriodo()
            );

            Integer idMatricula = result.get("P_ID_MATRICULA") != null
                    ? ((Number) result.get("P_ID_MATRICULA")).intValue()
                    : null;

            List<String> asignaturasAuto = new ArrayList<>();
            Array arr = (Array) result.get("P_ASIGNATURAS_AUTO");
            if (arr != null) {
                asignaturasAuto = Arrays.asList((String[]) arr.getArray());
            }

            return new MatriculaIniciarResponse(
                    idMatricula,
                    asignaturasAuto,
                    (String) result.get("P_MENSAJE")
            );

        } catch (DataAccessException e) {
            String msg = e.getMostSpecificCause().getMessage();

            return new MatriculaIniciarResponse(
                    null,
                    List.of(),
                    "ERROR BD: " + msg
            );

        } catch (SQLException e) {
            return new MatriculaIniciarResponse(
                    null,
                    List.of(),
                    "ERROR SQL: " + e.getMessage()
            );
        }
    }

    @Override
    public MatriculaAgregarGrupoResponse agregarGrupo(Integer idMatricula, MatriculaAgregarGrupoRequest req) {
        try {

            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_MATRICULA")
                    .withProcedureName("AGREGAR_GRUPO")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_ID_MATRICULA", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_GRUPO", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(idMatricula, req.idGrupo());

            return new MatriculaAgregarGrupoResponse(
                    idMatricula,
                    req.idGrupo(),
                    (String) result.get("P_MENSAJE")
            );

        } catch (DataAccessException e) {
            return new MatriculaAgregarGrupoResponse(
                    idMatricula,
                    req.idGrupo(),
                    "ERROR: " + e.getMostSpecificCause().getMessage()
            );
        }
    }

    @Override
    public MatriculaQuitarGrupoResponse quitarGrupo(Integer idMatricula, Integer idGrupo) {
        try {

            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_MATRICULA")
                    .withProcedureName("QUITAR_GRUPO")
                    .withoutProcedureColumnMetaDataAccess()
                    .declareParameters(
                            new SqlParameter("P_ID_MATRICULA", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_GRUPO", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(idMatricula, idGrupo);

            return new MatriculaQuitarGrupoResponse(
                    idMatricula,
                    idGrupo,
                    (String) result.get("P_MENSAJE")
            );

        } catch (DataAccessException e) {
            return new MatriculaQuitarGrupoResponse(
                    idMatricula,
                    idGrupo,
                    "ERROR: " + e.getMostSpecificCause().getMessage()
            );
        }
    }

    @Override
    public MatriculaFinalizarResponse finalizarMatricula(Integer idMatricula) {
        try {

            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_MATRICULA")
                    .withProcedureName("FINALIZAR_MATRICULA")
                    .declareParameters(
                            new SqlParameter("P_ID_MATRICULA", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(idMatricula);

            return new MatriculaFinalizarResponse(
                    idMatricula,
                    (String) result.get("P_MENSAJE")
            );

        } catch (DataAccessException e) {
            return new MatriculaFinalizarResponse(
                    idMatricula,
                    "ERROR: " + e.getMostSpecificCause().getMessage()
            );
        }
    }


}
