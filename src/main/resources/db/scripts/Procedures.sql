CREATE OR REPLACE PACKAGE BODY PKG_MATRICULA AS

    PROCEDURE INICIAR_MATRICULA(
        P_ID_ESTUDIANTE    IN NUMBER,
        P_ID_PERIODO       IN NUMBER,
        P_ID_MATRICULA     OUT NUMBER,
        P_ASIGNATURAS_AUTO OUT VARCHAR2_TABLE_TYPE,
        P_MENSAJE          OUT VARCHAR2
    ) AS
        v_tiene_previas    NUMBER;
        v_id_programa      NUMBER;
        v_last_periodo     NUMBER;
        v_count            NUMBER;
        v_grupo            NUMBER;
    BEGIN
            P_MENSAJE := NULL;
            P_ID_MATRICULA := NULL;
            P_ASIGNATURAS_AUTO := VARCHAR2_TABLE_TYPE();

            ---------------------------------------------------------
            -- 1. VALIDAR ESTUDIANTE EXISTE
            ---------------------------------------------------------
    SELECT COUNT(*) INTO v_count
    FROM ESTUDIANTE
    WHERE id_estudiante = P_ID_ESTUDIANTE;

    IF v_count = 0 THEN
                P_MENSAJE := 'ERROR: El estudiante no existe';
                RETURN;
    END IF;

            ---------------------------------------------------------
            -- 2. OBTENER PROGRAMA DEL ESTUDIANTE
            ---------------------------------------------------------
    SELECT id_programa_academico
    INTO v_id_programa
    FROM ESTUDIANTE
    WHERE id_estudiante = P_ID_ESTUDIANTE;

    ---------------------------------------------------------
    -- 3. VALIDAR MATRÍCULAS PREVIAS
    ---------------------------------------------------------
    SELECT COUNT(*) INTO v_tiene_previas
    FROM MATRICULA_ACADEMICA
    WHERE id_estudiante = P_ID_ESTUDIANTE;

    ---------------------------------------------------------
    -- 4. CREAR MATRÍCULA ACTUAL
    ---------------------------------------------------------
    INSERT INTO MATRICULA_ACADEMICA(
        id_estudiante,
        id_periodo_academico
    ) VALUES (
                 P_ID_ESTUDIANTE,
                 P_ID_PERIODO
             )
        RETURNING id_matricula INTO P_ID_MATRICULA;

    ---------------------------------------------------------
    -- CASO 1: SIN MATRÍCULAS PREVIAS (Primer semestre)
    ---------------------------------------------------------
    IF v_tiene_previas = 0 THEN

                FOR rec IN (
                    SELECT id_asignatura, nombre
                    FROM ASIGNATURA
                    WHERE semestre = 1
                      AND id_programa_academico = v_id_programa
                ) LOOP

                    v_grupo := NULL;

    BEGIN
    SELECT id_grupo INTO v_grupo
    FROM GRUPO
    WHERE id_asignatura = rec.id_asignatura
      AND id_periodo_academico = P_ID_PERIODO
      AND ROWNUM = 1;
    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            P_MENSAJE := 'ERROR: No existe grupo para la asignatura '
                                          || rec.nombre || ' en el periodo indicado';
                            RETURN;
    END;

    INSERT INTO DETALLE_MATRICULA(
        id_matricula,
        id_grupo,
        nota_definitiva
    ) VALUES (
                 P_ID_MATRICULA,
                 v_grupo,
                 NULL
             );

    P_ASIGNATURAS_AUTO.EXTEND;
    P_ASIGNATURAS_AUTO(P_ASIGNATURAS_AUTO.LAST) := rec.nombre;
    END LOOP;

                P_MENSAJE := 'Matrícula iniciada. Cargadas asignaturas de primer semestre.';
                RETURN;
    END IF;

            ---------------------------------------------------------
            -- CASO 2: BUSCAR PERIODO ANTERIOR
            ---------------------------------------------------------
    SELECT MAX(id_periodo_academico)
    INTO v_last_periodo
    FROM MATRICULA_ACADEMICA
    WHERE id_estudiante = P_ID_ESTUDIANTE
      AND id_periodo_academico < P_ID_PERIODO;

    ---------------------------------------------------------
    -- CASO 2: ASIGNATURAS REPROBADAS
    ---------------------------------------------------------
    FOR rec IN (
                SELECT A.id_asignatura, A.nombre
                FROM DETALLE_MATRICULA DM
                JOIN MATRICULA_ACADEMICA MA
                  ON DM.id_matricula = MA.id_matricula
                JOIN GRUPO G
                  ON DM.id_grupo = G.id_grupo
                JOIN ASIGNATURA A
                  ON G.id_asignatura = A.id_asignatura
                WHERE MA.id_estudiante = P_ID_ESTUDIANTE
                  AND MA.id_periodo_academico = v_last_periodo
                  AND DM.nota_definitiva < 3
            ) LOOP

                v_grupo := NULL;

    BEGIN
    SELECT id_grupo INTO v_grupo
    FROM GRUPO
    WHERE id_asignatura = rec.id_asignatura
      AND id_periodo_academico = P_ID_PERIODO
      AND ROWNUM = 1;

    EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        P_MENSAJE := 'ERROR: No existe un grupo para la asignatura reprobada '
                                      || rec.nombre || ' en el periodo actual.';
                        RETURN;
    END;

    INSERT INTO DETALLE_MATRICULA(
        id_matricula,
        id_grupo,
        nota_definitiva
    ) VALUES (
                 P_ID_MATRICULA,
                 v_grupo,
                 NULL
             );

    P_ASIGNATURAS_AUTO.EXTEND;
    P_ASIGNATURAS_AUTO(P_ASIGNATURAS_AUTO.LAST) := rec.nombre;
    END LOOP;

            ---------------------------------------------------------
            -- CASO 3: NO HAY AUTOMÁTICAS
            ---------------------------------------------------------
            IF P_ASIGNATURAS_AUTO.COUNT = 0 THEN
                P_MENSAJE := 'Matrícula iniciada. No hay asignaturas automáticas.';
    ELSE
                P_MENSAJE := 'Matrícula iniciada con asignaturas automáticas por pérdida.';
    END IF;

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := 'ERROR PL/SQL: ' || SQLERRM;
    END INICIAR_MATRICULA;

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
    ) AS
        v_exists_grupo   NUMBER;
        v_exists_docente NUMBER;
        v_exists_asig    NUMBER;
        v_conflictos     NUMBER;
    BEGIN
            P_MENSAJE := NULL;

            ------------------------------------------------
            -- VALIDAR QUE EL GRUPO EXISTA
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_grupo
    FROM GRUPO
    WHERE id_grupo = P_ID_GRUPO;

    IF v_exists_grupo = 0 THEN
                P_MENSAJE := 'ERROR: El grupo no existe';
                RETURN;
    END IF;

            ------------------------------------------------
            -- VALIDAR QUE EL DOCENTE EXISTA
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_docente
    FROM DOCENTE
    WHERE id_docente = P_ID_DOCENTE;

    IF v_exists_docente = 0 THEN
                P_MENSAJE := 'ERROR: El docente no existe';
                RETURN;
    END IF;

            ------------------------------------------------
            -- VALIDAR QUE NO ESTÉ YA ASIGNADO
            ------------------------------------------------
    SELECT COUNT(*) INTO v_exists_asig
    FROM GRUPO_DOCENTE
    WHERE id_grupo = P_ID_GRUPO
      AND id_docente = P_ID_DOCENTE;

    IF v_exists_asig > 0 THEN
                P_MENSAJE := 'ERROR: El docente ya está asignado a este grupo';
                RETURN;
    END IF;

            ------------------------------------------------
            -- VALIDAR CHOQUE DE HORARIOS
            ------------------------------------------------

    SELECT COUNT(*) INTO v_conflictos
    FROM CLASE C1
             JOIN GRUPO_DOCENTE GD
                  ON GD.id_docente = P_ID_DOCENTE
             JOIN CLASE C2
                  ON C2.id_grupo = GD.id_grupo
    WHERE C1.id_grupo = P_ID_GRUPO
      AND C2.id_grupo <> P_ID_GRUPO
      AND C1.dia = C2.dia
      AND (
        (C1.hora_inicio BETWEEN C2.hora_inicio AND C2.hora_fin)
            OR (C1.hora_fin BETWEEN C2.hora_inicio AND C2.hora_fin)
            OR (C2.hora_inicio BETWEEN C1.hora_inicio AND C1.hora_fin)
        );

    IF v_conflictos > 0 THEN
                P_MENSAJE := 'ERROR: El docente tiene choque de horario con otro grupo';
                RETURN;
    END IF;

            ------------------------------------------------
            -- INSERTAR ASIGNACIÓN
            ------------------------------------------------
    INSERT INTO GRUPO_DOCENTE (
        id_grupo,
        id_docente
    ) VALUES (
                 P_ID_GRUPO,
                 P_ID_DOCENTE
             );

    P_MENSAJE := 'Docente asignado correctamente';

    EXCEPTION
            WHEN OTHERS THEN
                P_MENSAJE := 'ERROR PL/SQL: ' || SQLERRM;
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




