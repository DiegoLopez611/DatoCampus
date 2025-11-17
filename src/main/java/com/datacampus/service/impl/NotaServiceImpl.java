package com.datacampus.service.impl;

import com.datacampus.dto.*;
import com.datacampus.service.NotaService;
import lombok.RequiredArgsConstructor;
import oracle.jdbc.OracleTypes;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class NotaServiceImpl  implements NotaService {

    private final JdbcTemplate jdbc;

    @Override
    public NotaCrearResponse crearNota(NotaCrearRequest req) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_NOTA")
                    .withProcedureName("CREAR_NOTA")
                    .declareParameters(
                            new SqlParameter("P_ID_DETALLE", OracleTypes.NUMBER),
                            new SqlParameter("P_ID_CONFIG", OracleTypes.NUMBER),
                            new SqlParameter("P_VALOR", OracleTypes.NUMBER),
                            new SqlOutParameter("P_ID_NOTA", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(
                    req.idDetalleMatricula(),
                    req.idConfiguracionNota(),
                    req.valor()
            );

            Integer idNota = result.get("P_ID_NOTA") != null
                    ? ((Number) result.get("P_ID_NOTA")).intValue()
                    : null;

            return new NotaCrearResponse(idNota, (String) result.get("P_MENSAJE"));

        } catch (DataAccessException e) {
            return new NotaCrearResponse(null, "ERROR BD: " + e.getMostSpecificCause().getMessage());
        }
    }

    @Override
    public NotaEditarResponse editarNota(Integer idNota, NotaEditarRequest req) {
        try {
            SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                    .withCatalogName("PKG_NOTA")
                    .withProcedureName("EDITAR_NOTA")
                    .declareParameters(
                            new SqlParameter("P_ID_NOTA", OracleTypes.NUMBER),
                            new SqlParameter("P_VALOR", OracleTypes.NUMBER),
                            new SqlOutParameter("P_MENSAJE", OracleTypes.VARCHAR)
                    );

            Map<String, Object> result = call.execute(idNota, req.valor());

            return new NotaEditarResponse(idNota, (String) result.get("P_MENSAJE"));

        } catch (DataAccessException e) {
            return new NotaEditarResponse(idNota, "ERROR BD: " + e.getMostSpecificCause().getMessage());
        }
    }

    @Override
    public NotasEstudianteResponse listarNotasPorEstudiante(Integer idEstudiante) {

        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_NOTA")
                .withProcedureName("LISTAR_NOTAS_ESTUDIANTE")
                .returningResultSet("P_CURSOR", (rs, rowNum) -> mapNota(rs));

        Map<String, Object> out = call.execute(idEstudiante);

        List<NotaDetalle> notas = (List<NotaDetalle>) out.get("P_CURSOR");

        return new NotasEstudianteResponse(idEstudiante, notas);
    }

    @Override
    public NotasGrupoResponse listarNotasPorGrupo(Integer idGrupo) {

        SimpleJdbcCall call = new SimpleJdbcCall(jdbc)
                .withCatalogName("PKG_NOTA")
                .withProcedureName("LISTAR_NOTAS_GRUPO")
                .returningResultSet("P_CURSOR", (rs, rowNum) -> mapNota(rs));

        Map<String, Object> out = call.execute(idGrupo);

        List<NotaDetalle> notas = (List<NotaDetalle>) out.get("P_CURSOR");

        return new NotasGrupoResponse(idGrupo, notas);
    }

    private NotaDetalle mapNota(ResultSet rs) throws SQLException {
        return new NotaDetalle(
                rs.getInt("id_nota"),
                rs.getString("asignatura"),
                rs.getString("tipo_nota"),
                rs.getDouble("valor"),
                rs.getDouble("porcentaje")
        );
    }
}
