/*  1. Desplegar para cada elecci�n el pa�s y el partido pol�tico que obtuvo mayor porcentaje de votos en su pa�s. 
    Debe desplegar el nombre de la elecci�n, el a�o de la elecci�n, el pa�s, el nombre del partido pol�tico
    y el porcentaje que obtuvo de votos en su pa�s. */
    
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
    
/*  2. Desplegar total de votos y porcentaje de votos de mujeres por departamento y pa�s. 
    El ciento por ciento es el total de votos de mujeres por pa�s. (Tip: Todos los porcentajes por departamento de un pa�s deben sumar el 100%) */

    SELECT SUM(dv.analfabetos+dv.alfabetas) FROM DETALLEVOTOS dv;

/*  3. Desplegar el nombre del pa�s, nombre del partido pol�tico y n�mero de alcald�as de los partidos pol�ticos 
    que ganaron m�s alcald�as por pa�s. */
    
    
    
/* 4. Desplegar todas las regiones por pa�s en las que predomina la raza ind�gena. Es decir, hay m�s votos que las otras razas. */


/*
5. Desplegar el porcentaje de mujeres universitarias y hombres universitarios que votaron por departamento, donde las mujeres universitarias que votaron fueron m�s que los hombres universitarios que votaron. 
 
6. Desplegar el nombre del pa�s, la regi�n y el promedio de votos por departamento. Por ejemplo: Si la regi�n tiene tres departamentos, se debe sumar todos los votos de la regi�n y dividirlo dentro de tres (n�mero de departamentos de la regi�n). 7. Desplegar el nombre del municipio y el nombre de los dos partidos pol�ticos con m�s votos en el municipio, ordenados por pa�s. 
 
8. Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) por pa�s, sin importar raza o sexo. 
 
9. Desplegar el nombre del pa�s y el porcentaje de votos por raza. 
 
10. Desplegar el nombre del pa�s en el cual las elecciones han sido m�s peleadas. Para determinar esto se debe calcular la diferencia de porcentajes de votos entre el partido que obtuvo m�s votos y el partido que obtuvo menos votos. (La diferencia m�s peque�a). 
 
11. Desplegar el total de votos y el porcentaje de votos emitidos por mujeres ind�genas alfabetas. 
12. Desplegar el nombre del pa�s, el porcentaje de votos de ese pa�s en el que han votado mayor porcentaje de analfabetas. (tip: solo desplegar un nombre de pa�s, el de mayor porcentaje). 
 
13. Desplegar la lista de departamentos de Guatemala y n�mero de votos obtenidos, para los departamentos que obtuvieron m�s votos que el departamento de Guatemala. 
 
14. Desplegar el total de votos de los municipios agrupados por su letra inicial. Es decir, agrupar todos los municipios con letra A y calcular su n�mero de votos, lo mismo para los de letra inicial B, y as� sucesivamente hasta la Z. 
*/