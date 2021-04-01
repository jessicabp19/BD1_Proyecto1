/* 13. Desplegar la lista de departamentos de Guatemala y número de votos obtenidos, 
    para los departamentos que obtuvieron más votos que el departamento de Guatemala. */

    /*PARA PRUEBAS: SELECT p.nombre, d.nombre FROM DEPARTAMENTO d, REGION r, PAIS p
    WHERE d.region = r.idRegion and r.pais = p.idPais and p.nombre = 'GUATEMALA';*/
    
    SELECT a.departamento, a.TotalVotos FROM
        
        ( SELECT d.nombre as departamento, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
        WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais AND p.nombre = 'GUATEMALA'
        GROUP BY  d.nombre
        ORDER BY d.nombre ) a -- ( A ) SUBCONSULTA 1:Total de votos por departamentos de GUATE
        ,
        ( SELECT d.nombre as departamento, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
        WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais AND p.nombre = 'GUATEMALA' and d.nombre = 'Guatemala'
        GROUP BY  d.nombre
        ORDER BY d.nombre ) b
        
    WHERE a.TotalVotos > b.TotalVotos
    ORDER BY a.TotalVotos asc
    
    

/* 14. Desplegar el total de votos de los municipios agrupados por su letra inicial. 
    Es decir, agrupar todos los municipios con letra A y calcular su número de votos, 
    lo mismo para los de letra inicial B, y así sucesivamente hasta la Z. */
    
    SELECT a.INICIAL, SUM(a.totalvotos) FROM
        
            ( SELECT p.nombre AS pais, d.nombre as departamento, m.nombre as municipio, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos, SUBSTR(m.nombre, 1,1) as INICIAL
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  m.nombre, d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre, m.nombre ) a -- ( A ) SUBCONSULTA 1:Total de votos por partido/municipio/departamento/pais
        
    GROUP BY a.INICIAL
    ORDER BY a.INICIAL