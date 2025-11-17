CREATE OR REPLACE PACKAGE BODY PKG_MATRICULA AS

    PROCEDURE INICIAR_MATRICULA(
        P_ID_ESTUDIANTE      IN  NUMBER,
        P_ID_PERIODO         IN  NUMBER,
        P_ID_MATRICULA       OUT NUMBER,
        P_ASIGNATURAS_AUTO   OUT T_VARCHAR_TABLE,
        P_MENSAJE            OUT VARCHAR2
    ) IS
    BEGIN

    INSERT INTO MATRICULA_ACADEMICA(id_matricula_academica, id_estudiante, id_periodo_academico, estado)
    VALUES (SEQ_MATRICULA.NEXTVAL, P_ID_ESTUDIANTE, P_ID_PERIODO, 'ACTIVA')
        RETURNING id_matricula_academica INTO P_ID_MATRICULA;

    P_ASIGNATURAS_AUTO := T_VARCHAR_TABLE();

    FOR r IN (
                SELECT a.nombre, g.id_grupo
                FROM ASIGNATURA a
                JOIN GRUPO_ASIGNATURA g ON g.id_asignatura = a.id_asignatura
                WHERE a.semestre = 1
            ) LOOP

                INSERT INTO DETALLE_MATRICULA(id_detalle_matricula, id_matricula_academica, id_grupo)
                VALUES (SEQ_DETALLE_MAT.NEXTVAL, P_ID_MATRICULA, r.id_grupo);

                P_ASIGNATURAS_AUTO.EXTEND;
                P_ASIGNATURAS_AUTO(P_ASIGNATURAS_AUTO.LAST) := r.nombre;
    END LOOP;
            P_MENSAJE := 'Matrícula iniciada correctamente.';

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := SQLERRM;
    END;

     PROCEDURE AGREGAR_GRUPO(
        P_ID_MATRICULA   IN NUMBER,
        P_ID_GRUPO       IN NUMBER,
        P_MENSAJE        OUT VARCHAR2
    ) IS

        v_id_estudiante      NUMBER;
        v_id_asignatura      NUMBER;
        v_creditos_asig      NUMBER;
        v_creditos_actuales  NUMBER;
        v_riesgo             NUMBER;
        v_max_creditos       NUMBER;
        v_cupo_max           NUMBER;
        v_cupo_actual        NUMBER;
        v_hora_inicio        DATE;
        v_hora_fin           DATE;
        v_dia                VARCHAR2(20);

    BEGIN
    -----------------------------------------------------------------
    -- 0. Obtener datos base
    -----------------------------------------------------------------
    SELECT m.id_estudiante
    INTO v_id_estudiante
    FROM MATRICULA_ACADEMICA m
    WHERE m.id_matricula_academica = P_ID_MATRICULA;

    -----------------------------------------------------------------
    -- 1. Validar que el grupo existe
    -----------------------------------------------------------------
    SELECT g.id_asignatura, g.cupo_maximo, g.hora_inicio, g.hora_fin, g.dia
    INTO v_id_asignatura, v_cupo_max, v_hora_inicio, v_hora_fin, v_dia
    FROM GRUPO_ASIGNATURA g
    WHERE g.id_grupo = P_ID_GRUPO;

    -----------------------------------------------------------------
    -- 2. Validar que no esté ya inscrita la asignatura
    -----------------------------------------------------------------
    IF EXISTS (
            SELECT 1
            FROM DETALLE_MATRICULA d
            JOIN GRUPO_ASIGNATURA g ON g.id_grupo = d.id_grupo
            WHERE d.id_matricula_academica = P_ID_MATRICULA
              AND g.id_asignatura = v_id_asignatura
        ) THEN
            RAISE_APPLICATION_ERROR(-20001, 'La asignatura ya está registrada en la matrícula.');
    END IF;

    -----------------------------------------------------------------
    -- 3. Validar que no haya aprobado ya la asignatura
    -----------------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM HISTORIAL_ACADEMICO
        WHERE id_estudiante = v_id_estudiante
            AND id_asignatura = v_id_asignatura
            AND estado = 'APROBADO'
    ) THEN
        RAISE_APPLICATION_ERROR(-20002, 'El estudiante ya aprobó esta asignatura.');
    END IF;

    -- 4. Validación de prerrequisitos
    IF EXISTS (
        SELECT 1
        FROM PRERREQUISITO p
        WHERE p.id_asignatura = v_id_asignatura
            AND p.id_prerrequisito NOT IN (
                SELECT id_asignatura
                FROM HISTORIAL_ACADEMICO
                WHERE id_estudiante = v_id_estudiante
                    AND estado = 'APROBADO'
            )
        ) THEN
            RAISE_APPLICATION_ERROR(-20003, 'No cumple los prerrequisitos.');
    END IF;

    -- 5. Validación de capacidad del grupo

    SELECT COUNT(*) INTO v_cupo_actual
    FROM DETALLE_MATRICULA
    WHERE id_grupo = P_ID_GRUPO;

    IF v_cupo_actual >= v_cupo_max THEN
            RAISE_APPLICATION_ERROR(-20004, 'El grupo está lleno.');
    END IF;

    -- 6. Validación de choque de horario

    IF EXISTS (
        SELECT 1
        FROM DETALLE_MATRICULA d
        JOIN GRUPO_ASIGNATURA g ON g.id_grupo = d.id_grupo
        WHERE d.id_matricula_academica = P_ID_MATRICULA
            AND g.dia = v_dia
            AND (
                (g.hora_inicio <= v_hora_fin AND g.hora_fin >= v_hora_inicio)
                )
    ) THEN
            AISE_APPLICATION_ERROR(-20005, 'Existe choque de horario.');
    END IF;

    -- 7. Validación de créditos según riesgo

    SELECT riesgo INTO v_riesgo
    FROM ESTUDIANTE
    WHERE id_estudiante = v_id_estudiante;

    CASE v_riesgo
            WHEN 0 THEN v_max_creditos := 21;
    WHEN 1 THEN v_max_creditos := 8;
    WHEN 2 THEN v_max_creditos := 12;
    WHEN 3 THEN v_max_creditos := 8;
    WHEN 4 THEN v_max_creditos := 16;
    END CASE;

    SELECT a.creditos INTO v_creditos_asig
    FROM ASIGNATURA a
    WHERE a.id_asignatura = v_id_asignatura;

    SELECT SUM(a.creditos) INTO v_creditos_actuales
    FROM DETALLE_MATRICULA d
             JOIN GRUPO_ASIGNATURA g ON g.id_grupo = d.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
    WHERE d.id_matricula_academica = P_ID_MATRICULA;

    IF v_creditos_actuales + v_creditos_asig > v_max_creditos THEN
            RAISE_APPLICATION_ERROR(-20006, 'Excede el límite de créditos según riesgo.');
    END IF;

    -- 8. Insertar en detalle

    INSERT INTO DETALLE_MATRICULA(id_detalle_matricula, id_matricula_academica, id_grupo)
    VALUES (SEQ_DETALLE_MAT.NEXTVAL, P_ID_MATRICULA, P_ID_GRUPO);

    P_MENSAJE := 'Grupo agregado correctamente.';

    EXCEPTION
        WHEN OTHERS THEN
            P_MENSAJE := SQLERRM;
    END;

    PROCEDURE QUITAR_GRUPO(
        P_ID_MATRICULA   IN NUMBER,
        P_ID_GRUPO       IN NUMBER,
        P_MENSAJE        OUT VARCHAR2
    ) IS
    BEGIN
    DELETE FROM DETALLE_MATRICULA
    WHERE id_matricula_academica = P_ID_MATRICULA
      AND id_grupo = P_ID_GRUPO;

    IF SQL%ROWCOUNT = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'El grupo no está registrado en esta matrícula.');
    END IF;

            P_MENSAJE := 'Grupo eliminado correctamente.';

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := SQLERRM;
    END;

    PROCEDURE FINALIZAR_MATRICULA(
        P_ID_MATRICULA  IN NUMBER,
        P_MENSAJE       OUT VARCHAR2
    ) IS
    BEGIN
    UPDATE MATRICULA_ACADEMICA
    SET estado = 'FINALIZADA'
    WHERE id_matricula_academica = P_ID_MATRICULA;

    P_MENSAJE := 'Matrícula finalizada correctamente.';

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := SQLERRM;
    END;

END PKG_MATRICULA;
/

