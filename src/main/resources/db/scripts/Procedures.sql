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

CREATE OR REPLACE PACKAGE BODY PKG_GRUPO AS

    PROCEDURE CREAR_GRUPO(
        P_NOMBRE           IN  VARCHAR2,
        P_ID_PERIODO       IN  NUMBER,
        P_ID_ASIGNATURA    IN  NUMBER,
        P_ID_GRUPO         OUT NUMBER,
        P_MENSAJE          OUT VARCHAR2
    ) AS
        v_exists_periodo    NUMBER;
        v_exists_asignatura NUMBER;
        v_exists_grupo      NUMBER;
    BEGIN
            P_ID_GRUPO := NULL;
            P_MENSAJE := NULL;

            ------------------------------------------------
            -- VALIDAR EXISTENCIA DEL PERIODO ACADÉMICO
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_periodo
    FROM PERIODO_ACADEMICO
    WHERE id_periodo_academico = P_ID_PERIODO;

    IF v_exists_periodo = 0 THEN
                P_MENSAJE := 'ERROR: El periodo académico no existe';
                RETURN;
    END IF;

            ------------------------------------------------
            -- VALIDAR EXISTENCIA DE LA ASIGNATURA
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_asignatura
    FROM ASIGNATURA
    WHERE id_asignatura = P_ID_ASIGNATURA;

    IF v_exists_asignatura = 0 THEN
                P_MENSAJE := 'ERROR: La asignatura no existe';
                RETURN;
    END IF;

            ------------------------------------------------
            -- VALIDAR DUPLICIDAD DEL GRUPO
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_grupo
    FROM GRUPO
    WHERE nombre = P_NOMBRE
      AND id_periodo_academico = P_ID_PERIODO
      AND id_asignatura = P_ID_ASIGNATURA;

    IF v_exists_grupo > 0 THEN
                P_MENSAJE := 'ERROR: Ya existe un grupo con ese nombre para la asignatura y periodo';
                RETURN;
    END IF;

            ------------------------------------------------
            -- INSERTAR GRUPO (TRIGGER ASIGNA EL ID)
            ------------------------------------------------
    INSERT INTO GRUPO(
        nombre,
        id_periodo_academico,
        id_asignatura
    ) VALUES (
                 P_NOMBRE,
                 P_ID_PERIODO,
                 P_ID_ASIGNATURA
             );

    ------------------------------------------------
    -- OBTENER EL ID GENERADO
    ------------------------------------------------
    SELECT id_grupo INTO P_ID_GRUPO
    FROM (
             SELECT id_grupo
             FROM GRUPO
             ORDER BY id_grupo DESC
         )
    WHERE ROWNUM = 1;

    ------------------------------------------------
    -- ÉXITO
    ------------------------------------------------
    P_MENSAJE := 'Grupo creado correctamente';

    EXCEPTION
            WHEN OTHERS THEN
                P_ID_GRUPO := NULL;
                P_MENSAJE := 'ERROR PL/SQL: ' || SQLERRM;
    END CREAR_GRUPO;

    PROCEDURE ASIGNAR_DOCENTE(
        P_ID_GRUPO   IN NUMBER,
        P_ID_DOCENTE IN NUMBER,
        P_MENSAJE    OUT VARCHAR2
    ) IS
        v_count NUMBER;
    BEGIN
    -- 1. Grupo debe existir

    SELECT COUNT(*) INTO v_count FROM GRUPO WHERE id_grupo = P_ID_GRUPO;
    IF v_count = 0 THEN
                RAISE_APPLICATION_ERROR(-21001, 'El grupo no existe.');
    END IF;


    -- 2. Docente debe existir

    SELECT COUNT(*) INTO v_count FROM DOCENTE WHERE id_docente = P_ID_DOCENTE;
    IF v_count = 0 THEN
                RAISE_APPLICATION_ERROR(-21002, 'El docente no existe.');
    END IF;

    -- 3. Validar si ya dicta el grupo

    SELECT COUNT(*) INTO v_count
    FROM GRUPO_DOCENTE
    WHERE id_grupo = P_ID_GRUPO
      AND id_docente = P_ID_DOCENTE;

    IF v_count > 0 THEN
                RAISE_APPLICATION_ERROR(-21003, 'El docente ya está asignado al grupo.');
    END IF;

    -- 4. VALIDACIÓN DE CRUCE DE HORARIO

    IF EXISTS (
        SELECT 1
        FROM CLASE new_c
        JOIN GRUPO_DOCENTE gd ON gd.id_docente = P_ID_DOCENTE
        JOIN CLASE old_c ON old_c.id_grupo = gd.id_grupo
        WHERE new_c.id_grupo = P_ID_GRUPO
            AND new_c.dia = old_c.dia
            AND new_c.hora_inicio < old_c.hora_fin
            AND new_c.hora_fin > old_c.hora_inicio
    ) THEN
        RAISE_APPLICATION_ERROR(-21004, 'El docente tiene un cruce de horario.');
    END IF;


    -- 5. Insertar relación GRUPO_DOCENTE

    INSERT INTO GRUPO_DOCENTE(id_grupo, id_docente)
    VALUES (P_ID_GRUPO, P_ID_DOCENTE);

    P_MENSAJE := 'Docente asignado correctamente.';

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := SQLERRM;
    END ASIGNAR_DOCENTE;


    PROCEDURE CREAR_CLASE(
        P_ID_GRUPO       IN  NUMBER,
        P_DIA            IN  VARCHAR2,
        P_HORA_INICIO    IN  VARCHAR2,
        P_HORA_FIN       IN  VARCHAR2,
        P_ID_AULA        IN  NUMBER,
        P_ID_CLASE       OUT NUMBER,
        P_MENSAJE        OUT VARCHAR2
    ) AS
        v_exists_grupo   NUMBER;
        v_exists_aula    NUMBER;
        v_inicio         DATE;
        v_fin            DATE;
        v_ocupada        NUMBER;
        v_id_asignatura   NUMBER;
        v_horas_max       NUMBER;
        v_horas_actuales  NUMBER;
        v_horas_nuevas    NUMBER;
    BEGIN
            P_ID_CLASE := NULL;
            P_MENSAJE := NULL;

            ---------------------------------------------------
            -- VALIDAR EXISTENCIA DEL GRUPO
            ---------------------------------------------------
    SELECT COUNT(*) INTO v_exists_grupo
    FROM GRUPO
    WHERE id_grupo = P_ID_GRUPO;

    IF v_exists_grupo = 0 THEN
                P_MENSAJE := 'ERROR: El grupo no existe';
                RETURN;
    END IF;

            ---------------------------------------------------
            -- VALIDAR EXISTENCIA DEL AULA
            ---------------------------------------------------
    SELECT COUNT(*) INTO v_exists_aula
    FROM AULA
    WHERE id_aula = P_ID_AULA;

    IF v_exists_aula = 0 THEN
                P_MENSAJE := 'ERROR: El aula no existe';
                RETURN;
    END IF;

            ---------------------------------------------------
            -- CONVERTIR HORAS A DATE
            ---------------------------------------------------
            v_inicio := TO_DATE(P_HORA_INICIO, 'HH24:MI');
            v_fin    := TO_DATE(P_HORA_FIN, 'HH24:MI');

            IF v_inicio >= v_fin THEN
                P_MENSAJE := 'ERROR: La hora de inicio debe ser menor que la hora fin';
                RETURN;
    END IF;

            ---------------------------------------------------
            -- VALIDAR QUE EL AULA NO ESTÉ OCUPADA
            ---------------------------------------------------
    SELECT COUNT(*) INTO v_ocupada
    FROM CLASE
    WHERE id_aula = P_ID_AULA
      AND dia = P_DIA
      AND (
        (v_inicio BETWEEN hora_inicio AND hora_fin)
            OR (v_fin BETWEEN hora_inicio AND hora_fin)
            OR (hora_inicio BETWEEN v_inicio AND v_fin)
        );

    IF v_ocupada > 0 THEN
                P_MENSAJE := 'ERROR: El aula ya está ocupada en ese horario';
                RETURN;
    END IF;

            ---------------------------------------------------
            -- VALIDAR QUE NO SUPERE LA CANTIDAD DE HORAS SEMANALES DE LA ASIGNATURA
            ---------------------------------------------------

            -- obtener asignatura del grupo
    SELECT id_asignatura INTO v_id_asignatura
    FROM grupo
    WHERE id_grupo = P_ID_GRUPO;

    -- horas máximas permitidas
    SELECT horas_semanales INTO v_horas_max
    FROM asignatura
    WHERE id_asignatura = v_id_asignatura;

    -- horas acumuladas actualmente
    SELECT COALESCE(SUM((hora_fin - hora_inicio) * 24), 0)
    INTO v_horas_actuales
    FROM clase
    WHERE id_grupo = P_ID_GRUPO;

    -- horas nuevas de esta clase
    v_horas_nuevas := (v_fin - v_inicio) * 24;

            -- validar límite
            IF (v_horas_actuales + v_horas_nuevas) > v_horas_max THEN
                P_MENSAJE := 'ERROR: Las horas semanales del grupo (' ||
                             (v_horas_actuales + v_horas_nuevas) ||
                             ') exceden las horas permitidas (' || v_horas_max || ') para la asignatura';
                RETURN;
    END IF;
            ---------------------------------------------------
            -- INSERTAR CLASE (el trigger asigna el ID)
            ---------------------------------------------------
    INSERT INTO CLASE(
        dia,
        hora_inicio,
        hora_fin,
        id_grupo,
        id_aula
    ) VALUES (
                 P_DIA,
                 v_inicio,
                 v_fin,
                 P_ID_GRUPO,
                 P_ID_AULA
             );

    ---------------------------------------------------
    -- OBTENER EL ID GENERADO (último insert)
    ---------------------------------------------------
    SELECT id_clase INTO P_ID_CLASE
    FROM (
             SELECT id_clase
             FROM CLASE
             ORDER BY id_clase DESC
         )
    WHERE ROWNUM = 1;

    ---------------------------------------------------
    -- ÉXITO
    ---------------------------------------------------
    P_MENSAJE := 'Clase creada correctamente';

    EXCEPTION
            WHEN OTHERS THEN
                P_ID_CLASE := NULL;
                P_MENSAJE := 'ERROR PL/SQL: ' || SQLERRM;
    END CREAR_CLASE;

END PKG_GRUPO;
/


CREATE OR REPLACE PACKAGE BODY PKG_NOTA AS

    PROCEDURE CREAR_NOTA(
        P_ID_DETALLE   IN NUMBER,
        P_ID_CONFIG    IN NUMBER,
        P_VALOR        IN NUMBER,
        P_ID_NOTA      OUT NUMBER,
        P_MENSAJE      OUT VARCHAR2
    ) IS
    BEGIN
    INSERT INTO NOTA(id_detalle_matricula, id_configuracion_nota, valor, fecha)
    VALUES (P_ID_DETALLE, P_ID_CONFIG, P_VALOR, SYSDATE)
        RETURNING id_nota INTO P_ID_NOTA;

    P_MENSAJE := 'Nota registrada correctamente.';

    EXCEPTION
        WHEN OTHERS THEN
            P_MENSAJE := SQLERRM;
    END CREAR_NOTA;

    PROCEDURE EDITAR_NOTA(
        P_ID_NOTA   IN NUMBER,
        P_VALOR     IN NUMBER,
        P_MENSAJE   OUT VARCHAR2
    ) IS
    BEGIN
    UPDATE NOTA
    SET valor = P_VALOR,
        fecha = SYSDATE
    WHERE id_nota = P_ID_NOTA;

    IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-30001, 'La nota no existe.');
    END IF;

        P_MENSAJE := 'Nota modificada correctamente.';

    EXCEPTION
        WHEN OTHERS THEN
            P_MENSAJE := SQLERRM;
    END EDITAR_NOTA;

    PROCEDURE LISTAR_NOTAS_ESTUDIANTE(
        P_ID_ESTUDIANTE IN NUMBER,
        P_CURSOR        OUT SYS_REFCURSOR
    ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT n.id_nota,
           a.nombre AS asignatura,
           t.nombre AS tipo_nota,
           n.valor,
           c.porcentaje
    FROM NOTA n
             JOIN DETALLE_MATRICULA d ON d.id_detalle_matricula = n.id_detalle_matricula
             JOIN GRUPO g ON g.id_grupo = d.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
             JOIN CONFIGURACION_NOTA_GRUPO c ON c.id_configuracion_nota = n.id_configuracion_nota
             JOIN TIPO_NOTA t ON t.id_tipo_nota = c.id_tipo_nota
             JOIN MATRICULA_ACADEMICA m ON m.id_matricula_academica = d.id_matricula_academica
    WHERE m.id_estudiante = P_ID_ESTUDIANTE;

    END LISTAR_NOTAS_ESTUDIANTE;

    PROCEDURE LISTAR_NOTAS_GRUPO(
        P_ID_GRUPO IN NUMBER,
        P_CURSOR   OUT SYS_REFCURSOR
    ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT n.id_nota,
           a.nombre AS asignatura,
           t.nombre AS tipo_nota,
           n.valor,
           c.porcentaje
    FROM NOTA n
             JOIN DETALLE_MATRICULA d ON d.id_detalle_matricula = n.id_detalle_matricula
             JOIN CONFIGURACION_NOTA_GRUPO c ON c.id_configuracion_nota = n.id_configuracion_nota
             JOIN TIPO_NOTA t ON t.id_tipo_nota = c.id_tipo_nota
             JOIN GRUPO g ON g.id_grupo = d.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
    WHERE g.id_grupo = P_ID_GRUPO;
    END LISTAR_NOTAS_GRUPO;

END PKG_NOTA;
/

CREATE OR REPLACE PACKAGE BODY PKG_REPORTES AS

    -- 1) Matrícula y carga por periodo
    PROCEDURE REP_MATRICULA_CARGA(
        P_ID_PERIODO IN NUMBER,
        P_CURSOR     OUT SYS_REFCURSOR
    ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT p.nombre AS programa,
           s.nombre AS sede,
           a.nombre AS asignatura,
           g.nombre AS grupo,
           COUNT(dm.id_detalle_matricula) AS inscritos,
           a.numero_creditos AS creditos,
           ROUND( (COUNT(dm.id_detalle_matricula) / aul.capacidad_maxima) * 100, 2) AS porcentaje_ocupacion
    FROM MATRICULA_ACADEMICA m
             JOIN DETALLE_MATRICULA dm ON dm.id_matricula_academica = m.id_matricula_academica
             JOIN GRUPO g ON g.id_grupo = dm.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
             JOIN PROGRAMA_ACADEMICO p ON p.id_programa_academico = a.id_programa_academico
             JOIN SEDE s ON s.id_sede = p.id_sede
             JOIN CLASE c ON c.id_grupo = g.id_grupo
             JOIN AULA aul ON aul.id_aula = c.id_aula
    WHERE m.id_periodo_academico = P_ID_PERIODO
    GROUP BY p.nombre, s.nombre, a.nombre, g.nombre, a.numero_creditos, aul.capacidad_maxima;
    END REP_MATRICULA_CARGA;

        -- 2) Top grupos por ocupación
        PROCEDURE REP_TOP_GRUPOS(
            P_ID_PERIODO IN NUMBER,
            P_LIMITE     IN NUMBER,
            P_CURSOR     OUT SYS_REFCURSOR
        ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT *
    FROM (
             SELECT s.nombre AS sede,
                    CONCAT(pa.anio, '-', pa.semestre) AS periodo,
                    a.nombre AS asignatura,
                    g.nombre AS grupo,
                    ROUND( (COUNT(dm.id_detalle_matricula) / aul.capacidad_maxima) * 100, 2) AS porcentaje_ocupacion
             FROM MATRICULA_ACADEMICA m
                      JOIN PERIODO_ACADEMICO pa ON pa.id_periodo_academico = m.id_periodo_academico
                      JOIN DETALLE_MATRICULA dm ON dm.id_matricula_academica = m.id_matricula_academica
                      JOIN GRUPO g ON g.id_grupo = dm.id_grupo
                      JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
                      JOIN PROGRAMA_ACADEMICO p ON p.id_programa_academico = a.id_programa_academico
                      JOIN SEDE s ON s.id_sede = p.id_sede
                      JOIN CLASE c ON c.id_grupo = g.id_grupo
                      JOIN AULA aul ON aul.id_aula = c.id_aula
             WHERE m.id_periodo_academico = P_ID_PERIODO
             GROUP BY s.nombre, pa.anio, pa.semestre, a.nombre, g.nombre, aul.capacidad_maxima
             ORDER BY porcentaje_ocupacion DESC
         )
    WHERE ROWNUM <= P_LIMITE;
    END REP_TOP_GRUPOS;

        -- 3) Intentos fallidos (asumo tabla INTENTO_MATRICULA para la entrega)
        PROCEDURE REP_INTENTOS_FALLIDOS(
            P_ID_PERIODO IN NUMBER,
            P_CURSOR     OUT SYS_REFCURSOR
        ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT a.nombre AS asignatura,
           g.nombre AS grupo,
           im.motivo,
           COUNT(*) AS cantidad
    FROM INTENTO_MATRICULA im
             JOIN GRUPO g ON g.id_grupo = im.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
    WHERE im.id_periodo_academico = P_ID_PERIODO
    GROUP BY a.nombre, g.nombre, im.motivo;
    END REP_INTENTOS_FALLIDOS;

        -- 4) Rendimiento por asignatura
        PROCEDURE REP_RENDIMIENTO_ASIG(
            P_ID_PERIODO IN NUMBER,
            P_CURSOR     OUT SYS_REFCURSOR
        ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT a.nombre AS asignatura,
           CONCAT(pa.anio, '-', pa.semestre) AS periodo,
           AVG(n.valor) AS promedio,
           MIN(n.valor) AS nota_minima,
           MAX(n.valor) AS nota_maxima,
           STDDEV(n.valor) AS desviacion
    FROM NOTA n
             JOIN CONFIGURACION_NOTA_GRUPO c ON c.id_configuracion_nota_grupo = n.id_configuracion_nota_grupo
             JOIN DETALLE_MATRICULA dm ON dm.id_detalle_matricula = n.id_detalle_matricula
             JOIN MATRICULA_ACADEMICA m ON m.id_matricula_academica = dm.id_matricula_academica
             JOIN PERIODO_ACADEMICO pa ON pa.id_periodo_academico = m.id_periodo_academico
             JOIN GRUPO g ON g.id_grupo = c.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
    WHERE m.id_periodo_academico = P_ID_PERIODO
    GROUP BY a.nombre, pa.anio, pa.semestre;
    END REP_RENDIMIENTO_ASIG;

        -- 5) Distribución de notas (rangos fijos)
        PROCEDURE REP_DISTRIB_NOTAS(
            P_ID_PERIODO IN NUMBER,
            P_CURSOR     OUT SYS_REFCURSOR
        ) IS
    BEGIN
    OPEN P_CURSOR FOR
    SELECT a.nombre AS asignatura,
           CONCAT(pa.anio, '-', pa.semestre) AS periodo,
           CASE
               WHEN n.valor < 3 THEN '0-2.9'
               WHEN n.valor < 4 THEN '3.0-3.9'
               ELSE '4.0-5.0'
               END AS rango,
           COUNT(*) AS cantidad
    FROM NOTA n
             JOIN CONFIGURACION_NOTA_GRUPO c ON c.id_configuracion_nota_grupo = n.id_configuracion_nota_grupo
             JOIN DETALLE_MATRICULA dm ON dm.id_detalle_matricula = n.id_detalle_matricula
             JOIN MATRICULA_ACADEMICA m ON m.id_matricula_academica = dm.id_matricula_academica
             JOIN PERIODO_ACADEMICO pa ON pa.id_periodo_academico = m.id_periodo_academico
             JOIN GRUPO g ON g.id_grupo = c.id_grupo
             JOIN ASIGNATURA a ON a.id_asignatura = g.id_asignatura
    WHERE m.id_periodo_academico = P_ID_PERIODO
    GROUP BY a.nombre, pa.anio, pa.semestre,
             CASE
                 WHEN n.valor < 3 THEN '0-2.9'
                 WHEN n.valor < 4 THEN '3.0-3.9'
                 ELSE '4.0-5.0'
                 END;
    END REP_DISTRIB_NOTAS;
END PKG_REPORTES;
/




