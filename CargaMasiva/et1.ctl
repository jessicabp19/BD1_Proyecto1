OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'DatosACargar.csv'
INSERT INTO TABLE TEMPORAL
FIELDS TERMINATED BY ';' TRAILING NULLCOLS
(nombre_eleccion, anio_eleccion, pais, region, depto, municipio, partido, nombre_partido, sexo, raza, analfabetos, alfabetos, sexo_, raza_, primaria, nivel_medio, universitarios )
