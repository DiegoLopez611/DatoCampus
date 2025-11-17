/*
    Se define el paquete de los procedimientos usados en el modulo de Matricula,  al igual que las variables globales,
    parametros de cada procedimiento y retornos.
 */

CREATE OR REPLACE PACKAGE PKG_MATRICULA AS

    -- Tabla para devolver asignaturas automáticas
    TYPE T_VARCHAR_TABLE IS TABLE OF VARCHAR2(200);

    PROCEDURE INICIAR_MATRICULA(
        P_ID_ESTUDIANTE      IN  NUMBER,
        P_ID_PERIODO         IN  NUMBER,
        P_ID_MATRICULA       OUT NUMBER,
        P_ASIGNATURAS_AUTO   OUT T_VARCHAR_TABLE,
        P_MENSAJE            OUT VARCHAR2
    );

    PROCEDURE AGREGAR_GRUPO(
        P_ID_MATRICULA   IN NUMBER,
        P_ID_GRUPO       IN NUMBER,
        P_MENSAJE        OUT VARCHAR2
    );

    PROCEDURE QUITAR_GRUPO(
        P_ID_MATRICULA   IN NUMBER,
        P_ID_GRUPO       IN NUMBER,
        P_MENSAJE        OUT VARCHAR2
    );

    PROCEDURE FINALIZAR_MATRICULA(
        P_ID_MATRICULA  IN NUMBER,
        P_MENSAJE       OUT VARCHAR2
    );

END PKG_MATRICULA;
/

/*
    Se degine el paquete con los procedimientos usados para la gestión de los grupos.
 */

CREATE OR REPLACE PACKAGE PKG_GRUPO AS

    PROCEDURE CREAR_GRUPO(
        P_NOMBRE        IN  VARCHAR2,
        P_ID_PERIODO    IN  NUMBER,
        P_ID_ASIGNATURA IN  NUMBER,
        P_ID_GRUPO      OUT NUMBER,
        P_MENSAJE       OUT VARCHAR2
    );

    PROCEDURE ASIGNAR_DOCENTE(
        P_ID_GRUPO   IN NUMBER,
        P_ID_DOCENTE IN NUMBER,
        P_MENSAJE    OUT VARCHAR2
    );

    PROCEDURE CREAR_CLASE(
    P_ID_GRUPO     IN NUMBER,
    P_DIA          IN VARCHAR2,
    P_HORA_INICIO  IN VARCHAR2,
    P_HORA_FIN     IN VARCHAR2,
    P_ID_AULA      IN NUMBER,
    P_ID_CLASE     OUT NUMBER,
    P_MENSAJE      OUT VARCHAR2
);

END PKG_GRUPO;
/