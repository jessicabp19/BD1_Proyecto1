/* PROCEDIMIENTOS PARA MIGRAR DATOS A LAS TABLAS DEL ER */


/******************************** D R O P S **********************************/
DROP PROCEDURE MIGRAR_PAISES;
DROP PROCEDURE MIGRAR_REGIONES;
DROP PROCEDURE MIGRAR_DEPARTAMENTOS;


/****************************** C R E A T E S ********************************/

-- TABLAS DE UBICACION GEOGRAFICA
CREATE OR REPLACE PROCEDURE MIGRAR_PAISES IS
CURSOR c_origen IS
    SELECT DISTINCT pais FROM TEMPORAL;
BEGIN
    FOR R IN c_origen LOOP
        INSERT INTO PAIS(nombre) VALUES (R.pais);
    END LOOP;
end; -- PAISES
CREATE OR REPLACE PROCEDURE MIGRAR_REGIONES IS
CURSOR c_region IS
    SELECT DISTINCT region, idPais FROM TEMPORAL, PAIS 
    WHERE TEMPORAL.pais = PAIS.nombre;
BEGIN
    FOR R IN c_region LOOP
        INSERT INTO REGION(nombre, pais) VALUES (R.region, R.idPais);
    END LOOP;
end; -- REGIONES
CREATE OR REPLACE PROCEDURE MIGRAR_DEPARTAMENTOS IS
CURSOR c_depto IS
    SELECT DISTINCT t.depto, t.region, t.pais, r.idRegion FROM TEMPORAL t, REGION r, PAIS p
    WHERE t.region = r.nombre and r.pais = p.idPais and t.pais = p.nombre;
BEGIN
    FOR R IN c_depto LOOP
        INSERT INTO DEPARTAMENTO(nombre, region) VALUES (R.depto, R.idRegion);
    END LOOP;
end; -- DEPARTAMENTOS
CREATE OR REPLACE PROCEDURE MIGRAR_MUNICIPIOS IS
CURSOR c_muni IS
    SELECT DISTINCT t.municipio, d.idDepartamento FROM TEMPORAL t, DEPARTAMENTO d
    WHERE t.depto = d.nombre;
BEGIN
    FOR R IN c_muni LOOP
        INSERT INTO MUNICIPIO(nombre, departamento) VALUES (R.municipio, R.idDepartamento);
    END LOOP;
end;-- MUNICIPIOS


--TABLAS DE ELECCIONPARTIDO
CREATE OR REPLACE PROCEDURE MIGRAR_ELECCIONES IS
CURSOR c_elec IS
    SELECT DISTINCT nombre_eleccion, anio_eleccion FROM TEMPORAL;
BEGIN
    FOR R IN c_elec LOOP
        INSERT INTO ELECCION(nombre, anio) VALUES (R.nombre_eleccion, R.anio_eleccion);
    END LOOP;
end;-- ELECCION
CREATE OR REPLACE PROCEDURE MIGRAR_PARTIDOS IS
CURSOR c_par IS
    SELECT DISTINCT partido, nombre_partido FROM TEMPORAL;
BEGIN
    FOR R IN c_par LOOP
        INSERT INTO PARTIDO(partido, nombre) VALUES (R.partido, R.nombre_partido);
    END LOOP;
end;--PARTIDOS
CREATE OR REPLACE PROCEDURE MIGRAR_EP IS
CURSOR c_ep IS
    SELECT DISTINCT t.partido, e.idEleccion, p.idPartido FROM TEMPORAL t, ELECCION e, PARTIDO p
    WHERE t.nombre_eleccion = e.nombre and t.anio_eleccion = e.anio and t.partido = p.partido;
BEGIN
    FOR R IN c_ep LOOP
        INSERT INTO ELECCIONPARTIDO(eleccion, partido) VALUES (R.idEleccion, R.idPartido);
    END LOOP;
end;--ELECCIONPARTIDO

--TABLAS DE DETALLEVOTOS
CREATE OR REPLACE PROCEDURE MIGRAR_RAZA IS
CURSOR c_raza IS
    SELECT DISTINCT raza FROM TEMPORAL;
BEGIN 
    FOR R IN c_raza LOOP
        INSERT INTO RAZA(raza) VALUES(R.raza);
    END LOOP;
end;--RAZA
CREATE OR REPLACE PROCEDURE MIGRAR_GENERO IS
CURSOR c_gen IS
    SELECT DISTINCT sexo FROM TEMPORAL;
BEGIN 
    FOR R IN c_gen LOOP
        INSERT INTO GENERO(genero) VALUES(R.sexo);
    END LOOP;
end;--GENERO

CREATE OR REPLACE PROCEDURE MIGRAR_DETALLEVOTOS IS
    CURSOR c_vot IS
        SELECT DISTINCT  analfabetos, alfabetos, primaria, nivel_medio, universitarios, idRaza, idMunicipio, idEP, idGenero
        FROM TEMPORAL t, RAZA, GENERO , PARTIDO, MUNICIPIO, DEPARTAMENTO, ELECCION, ELECCIONPARTIDO
        WHERE t.raza = RAZA.raza AND t.sexo = GENERO.genero  
        AND t.municipio = MUNICIPIO.nombre and t.depto = DEPARTAMENTO.nombre and MUNICIPIO.departamento = DEPARTAMENTO.idDepartamento
        AND t.partido = partido.partido and t.anio_eleccion = ELECCION.anio and ELECCIONPARTIDO.eleccion = ELECCION.idEleccion and ELECCIONPARTIDO.partido = PARTIDO.idPartido;
BEGIN
    FOR v IN c_vot LOOP
        INSERT INTO DETALLEVOTOS (alfabetas,analfabetas,primaria, medio,universitario, raza, municipio, eleccionpartido, genero)
        VALUES(v.alfabetos,v.analfabetos,v.primaria,v.nivel_medio,v.universitarios,v.idRaza,v.idMunicipio,v.idEP,v.idGenero);
    END LOOP;
END;


/****************************** E X E C U T E S ******************************/    
EXECUTE MIGRAR_PAISES;
EXECUTE MIGRAR_REGIONES;
EXECUTE MIGRAR_DEPARTAMENTOS;
EXECUTE MIGRAR_MUNICIPIOS;
EXECUTE MIGRAR_ELECCIONES;
EXECUTE MIGRAR_PARTIDOS;
EXECUTE MIGRAR_EP;
EXECUTE MIGRAR_RAZA;
EXECUTE MIGRAR_GENERO;
EXECUTE MIGRAR_DETALLEVOTOS;

/******************************* S E L E C T S *******************************/    
SELECT * FROM TEMPORAL;
SELECT * FROM PAIS;
SELECT * FROM REGION;
SELECT * FROM DEPARTAMENTO;
SELECT * FROM MUNICIPIO;
SELECT * FROM ELECCION;
SELECT * FROM PARTIDO;
SELECT * FROM ELECCIONPARTIDO;
SELECT * FROM RAZA;
SELECT * FROM GENERO;
SELECT * FROM DETALLEVOTOS;
SELECT count(*) FROM DETALLEVOTOS;