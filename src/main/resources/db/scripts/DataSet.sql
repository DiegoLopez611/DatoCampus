INSERT INTO DEPARTAMENTO (nombre) VALUES ('Amazonas');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Antioquia');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Arauca');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Atlántico');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Bolívar');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Boyacá');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Caldas');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Caquetá');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Casanare');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Cauca');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Cesar');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Chocó');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Córdoba');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Cundinamarca');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Guainía');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Guaviare');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Huila');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('La Guajira');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Magdalena');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Meta');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Nariño');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Norte de Santander');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Putumayo');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('San Andrés y Providencia');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Santander');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Sucre');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Tolima');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Valle del Cauca');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Vaupés');
INSERT INTO DEPARTAMENTO (nombre) VALUES ('Vichada');

INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Armenia', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Calarcá', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Circasia', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Montenegro', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('La Tebaida', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Quimbaya', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Filandia', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Salento', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Génova', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Buenavista', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Pijao', 1);
INSERT INTO MUNICIPIO (nombre, id_departamento) VALUES ('Cordobá', 1);

INSERT INTO SEDE (nombre, id_municipio) VALUES ('Principal', 1);

INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ingeniería', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias de la Educación', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias Humanas y Bellas Artes', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias Básicas y Tecnologías', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias Económicas, Administrativas y Contables', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias de la Salud', 1);
INSERT INTO FACULTAD (nombre, id_sede) VALUES ('Facultad de Ciencias Agroindustriales', 1);


INSERT INTO TIPO_PROGRAMA (nombre) VALUES ('Pregrado');
INSERT INTO TIPO_PROGRAMA (nombre) VALUES ('Posgrado');

INSERT INTO PROGRAMA_ACADEMICO (codigo, nombre, numero_creditos, id_tipo_programa,id_facultad)
VALUES ('835','Ingeniería Civil',172, 1, 1);

INSERT INTO PROGRAMA_ACADEMICO (codigo, nombre, numero_creditos, id_tipo_programa,id_facultad)
VALUES ('4241','Ingeniería de Sistemas y Computación',163, 1, 1);

INSERT INTO PROGRAMA_ACADEMICO (codigo, nombre, numero_creditos, id_tipo_programa,id_facultad)
VALUES ('4240','Ingeniería Electrónica',160, 1, 1);

INSERT INTO PROGRAMA_ACADEMICO (codigo, nombre, numero_creditos, id_tipo_programa,id_facultad)
VALUES ('108664','Ingeniería Topográfica y Geomática',160, 1, 1);

INSERT INTO PROGRAMA_ACADEMICO (codigo, nombre, numero_creditos, id_tipo_programa,id_facultad)
VALUES ('103589','Maestría en Ingeniería',42, 2, 1);

/*
    riesgo 1: promedio del último semestre menor a 2,
    riesgo 2: perder dos materias el semestre anterior,
    riesgo 3: perder una misma materia por tercera vez,
    riesgo 4: promedio del semestre anterior menor a 3

    Nivel de riesgo	   Créditos permitidos
    Sin riesgo	       21 créditos
    Riesgo 1	       8 créditos
    Riesgo 2	       12 créditos
    Riesgo 3	       8 créditos
    Riesgo 4	       16 créditos

*/

INSERT INTO NIVEL_RIESGO (nombre, maximo_creditos)
VALUES ('Sin riesgo', 21);

INSERT INTO NIVEL_RIESGO (nombre, maximo_creditos)
VALUES ('Riesgo 1', 8);

INSERT INTO NIVEL_RIESGO (nombre, maximo_creditos)
VALUES ('Riesgo 2', 12);

INSERT INTO NIVEL_RIESGO (nombre, maximo_creditos)
VALUES ('Riesgo 3', 8);

INSERT INTO NIVEL_RIESGO (nombre, maximo_creditos)
VALUES ('Riesgo 4', 16);

INSERT INTO TIPO_ASIGNATURA (nombre)
VALUES ('Básica');

INSERT INTO TIPO_ASIGNATURA (nombre)
VALUES ('Disciplinar');

INSERT INTO TIPO_ASIGNATURA (nombre)
VALUES ('Electiva');

ALTER TABLE AULA
    ADD nombre VARCHAR2(45);


-- Piso 1
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '101');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '102');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '103');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '104');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '105');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '106');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '107');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '108');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '109');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '110');

-- Piso 2
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '201');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '202');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '203');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '204');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '205');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '206');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '207');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '208');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '209');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '210');

-- Piso 3
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '301');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '302');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '303');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '304');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '305');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '306');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '307');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '308');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '309');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '310');

-- Piso 4
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '401');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '402');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '403');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '404');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '405');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '406');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '407');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '408');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '409');
INSERT INTO AULA (capacidad_maxima, id_facultad, nombre) VALUES (20, 1, '410');

-- Semestre 1
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Matemáticas Generales', 'ISC101', 2, 4, 1, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Introducción a la Ingeniería de Sistemas y Computación', 'ISC102', 3, 4, 1, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Unquindianidad', 'ISC103', 2, 3, 1, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Lógica de Programación', 'ISC104', 3, 4, 1, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Lectura y Escritura en Ingeniería', 'ISC105', 2, 4, 1, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Electiva Formación Personal I', 'ISC106', 2, 3, 1, 1, 2);


-- Semestre 2
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Cálculo Diferencial', 'ISC201', 4, 6, 2, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Álgebra Lineal', 'ISC202', 3, 4, 2, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Programación I', 'ISC203', 3, 4, 2, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Pensamiento Sistémico', 'ISC204', 3, 4, 2, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Fundamentos de Electricidad, Electrónica y Comunicaciones', 'ISC205', 3, 4, 2, 1, 2);


-- Semestre 3
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Cálculo Integral', 'ISC301', 4, 5, 3, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Fisica General', 'ISC302', 4, 6, 3, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Matemáticas Discretas', 'ISC303', 3, 4, 3, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Programación II', 'ISC304', 3, 4, 3, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Teoría y Diseño Organizacional', 'ISC305', 3, 4, 3, 1, 2);


-- Semestre 4
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Cálculo Multivariado y Vectorial', 'ISC401', 4, 5, 4, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ecuaciones Diferenciales', 'ISC402', 3, 4, 4, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Segunda Lengua I', 'ISC403', 2, 4, 4, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Programación III', 'ISC404', 3, 4, 4, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Sistemas de Información', 'ISC405', 3, 4, 4, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Fundamentos de Infraestructura Computacional', 'ISC406', 3, 4, 4, 1, 2);


-- Semestre 5
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Estadística y Probabilidad', 'ISC501', 3, 4, 5, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Teoría de Grafos', 'ISC502', 3, 4, 5, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Segunda Lengua II', 'ISC503', 2, 4, 5, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Estructuras de Datos', 'ISC504', 3, 4, 5, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ingeniería de Software I', 'ISC505', 3, 4, 5, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Infraestructura Computacional', 'ISC506', 4, 6, 5, 1, 2);


-- Semestre 6
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Dirección Estratégica de TI', 'ISC601', 3, 4, 6, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Analisis de Algoritmos', 'ISC602', 3, 4, 6, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Programación Avanzada', 'ISC603', 3, 4, 6, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Bases de Datos I', 'ISC604', 3, 4, 6, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ingeniería de Software II', 'ISC605', 3, 4, 6, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Infraestructura de Comuniaciones', 'ISC606', 4, 6, 6, 1, 2);

-- Semestre 7
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ingeniería Económica', 'ISC701', 3, 4, 7, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Fundamentos de HCI', 'ISC702', 3, 4, 7, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Seminario de Investigación', 'ISC703', 3, 4, 7, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Bases de Datos II', 'ISC704', 3, 4, 7, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ingeniería de Software III', 'ISC705', 3, 4, 7, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Administración de Infraestructura de TI', 'ISC706', 3, 4, 7, 1, 2);

-- Semestre 8
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Formulación y Evaluación de Proyectos', 'ISC801', 2, 2, 8, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Teoría de Lenguajes Formales', 'ISC802', 3, 4, 8, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Análisis de Algoritmos', 'ISC803', 3, 4, 8, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Profundización I', 'ISC804', 3, 4, 8, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Profundización II', 'ISC804', 3, 4, 8, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Seminario de Ingeniería', 'ISC806', 2, 4, 8, 1, 2);


-- Semestre 9
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Administración de Proyectos', 'ISC901', 2, 2, 9, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Inteligencia Artificial', 'ISC902', 3, 4, 9, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Legislación Laboral y Propiedad Intelectual', 'ISC903', 2, 2, 9, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Profundización III', 'ISC904', 3, 4, 9, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Profundización IV', 'ISC905', 3, 4, 9, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Administración', 'ISC906', 2, 4, 9, 1, 2);

-- Semestre 10
INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Trabajo de Grado', 'ISC1001', 6, 4, 10, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Electiva Formación Personal II', 'ISC1002', 2, 3, 10, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Electiva Formación Personal III', 'ISC1003', 2, 3, 10, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Ética Profesional', 'ISC1004', 2, 4, 10, 1, 2);

INSERT INTO ASIGNATURA (nombre, codigo, numero_creditos, horas_semanales, semestre, id_tipo_asignatura, id_programa_academico)
VALUES ('Cátedra Multidisciplinar', 'ISC1005', 0, 2, 10, 1, 2);


-- Calculo Diferencial
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (7, 1);

-- Algebra Lineal
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (8, 1);

--Programación I
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (9, 4);

-- Calculo Integral
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (12, 7);
-- Fisica General
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (13, 7);
-- Matematicas Discretas
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (14, 8);
-- Programación II
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (15, 9);
-- TDO
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (16, 10);

-- Vectorial
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (17, 12);
--Ecuaciones
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (18, 12);
-- Programacion III
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (20, 15);
-- SI
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (21, 16);
-- Fundamentos Infra
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (22, 11);

--Estadistica
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (23, 12);
-- Grafos
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (24, 14);
-- Segunda Lengua II
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (25, 19);
-- Estructuras
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (26, 20);
-- Soft I
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (27, 20);
-- Infra Computacional
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (28, 22);

--DETI
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (29, 21);
-- Analisi numerico
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (30, 18);
-- Bases de Datos I
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (32, 23);
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (32, 26);
-- Avanzada
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (31, 26);
-- Soft II
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (33, 27);
-- Infra Comunicaciones
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (34, 28);

--Ing Economica
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (35, 23);
--HCI
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (36, 27);
--Bases II
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (38, 32);
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (38, 29);
--Soft III
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (39, 33);
--Admin TI
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (40, 34);

-- Formulacion
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (41, 35);
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (41, 37);
-- TLF
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (42, 24);
-- Analisis Algoritmos
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (43, 26);

-- Admin de proyectos
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (47, 41);
-- IA
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (48, 17);
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (48, 43);

-- TG
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (53, 50);
INSERT INTO ASIGNATURA_PRERREQUISITO (id_asignatura, id_prerrequisito) VALUES (53, 51);

UPDATE ASIGNATURA
SET nombre = 'Analisis Numerico'
WHERE id_asignatura = 30;
