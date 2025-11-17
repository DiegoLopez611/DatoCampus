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