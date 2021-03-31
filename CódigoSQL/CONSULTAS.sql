/*  1. Desplegar para cada elección el país y el partido político que obtuvo mayor porcentaje de votos en su país. 
    Debe desplegar el nombre de la elección, el año de la elección, el país, el nombre del partido político
    y el porcentaje que obtuvo de votos en su país. */
    
    SELECT SUM(a.totalVotos) AS Total, a.nombre, e.nombre AS NombreEleccion, e.anio, c.nombre
FROM ELECCION e, ELECCIONPARTIDO ep, PARTIDO p , PAIS c, DEPARTAMENTO d, MUNICIPIO m, REGION r, 
(
    SELECT (c.analfabetos + c.alfabetos + c.primaria + c.nivelMedio + c.universitario ) AS totalVotos, c.partido , p.idPartido, p.nombre, c.municipio
    FROM CONTEO c, PARTIDO p 
    WHERE c.partido = p.idPartido
    ORDER BY totalVotos ASC
) a 
WHERE a.nombre = p.nombre AND p.idPartido = ep.partido AND ep.Eleccion = e.idEleccion AND a.municipio = m.idMunicipio 
AND m.departamento = d.idDepartamento AND d.region = r.idRegion AND r.pais = c.idPais
GROUP BY a.nombre, e.nombre, e.anio, c.nombre
ORDER BY Total;
    
/*  2. Desplegar total de votos y porcentaje de votos de mujeres por departamento y país. 
    El ciento por ciento es el total de votos de mujeres por país. (Tip: Todos los porcentajes por departamento de un país deben sumar el 100%) */

    SELECT SUM(dv.analfabetos+dv.alfabetas) FROM DETALLEVOTOS dv;

/*  3. Desplegar el nombre del país, nombre del partido político y número de alcaldías de los partidos políticos 
    que ganaron más alcaldías por país. */
    
    
    
/* 4. Desplegar todas las regiones por país en las que predomina la raza indígena. Es decir, hay más votos que las otras razas. */


/*
5. Desplegar el porcentaje de mujeres universitarias y hombres universitarios que votaron por departamento, donde las mujeres universitarias que votaron fueron más que los hombres universitarios que votaron. 
 
6. Desplegar el nombre del país, la región y el promedio de votos por departamento. Por ejemplo: Si la región tiene tres departamentos, se debe sumar todos los votos de la región y dividirlo dentro de tres (número de departamentos de la región). 7. Desplegar el nombre del municipio y el nombre de los dos partidos políticos con más votos en el municipio, ordenados por país. 
 
8. Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) por país, sin importar raza o sexo. 
 
9. Desplegar el nombre del país y el porcentaje de votos por raza. 
 
10. Desplegar el nombre del país en el cual las elecciones han sido más peleadas. Para determinar esto se debe calcular la diferencia de porcentajes de votos entre el partido que obtuvo más votos y el partido que obtuvo menos votos. (La diferencia más pequeña). 
 
11. Desplegar el total de votos y el porcentaje de votos emitidos por mujeres indígenas alfabetas. 
12. Desplegar el nombre del país, el porcentaje de votos de ese país en el que han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre de país, el de mayor porcentaje). 
 
13. Desplegar la lista de departamentos de Guatemala y número de votos obtenidos, para los departamentos que obtuvieron más votos que el departamento de Guatemala. 
 
14. Desplegar el total de votos de los municipios agrupados por su letra inicial. Es decir, agrupar todos los municipios con letra A y calcular su número de votos, lo mismo para los de letra inicial B, y así sucesivamente hasta la Z. 
*/