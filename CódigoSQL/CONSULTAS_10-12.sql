/* 10. Desplegar el nombre del país en el cual las elecciones han sido más peleadas. 
    Para determinar esto se debe calcular la diferencia de porcentajes de votos entre el partido que obtuvo más votos 
    y el partido que obtuvo menos votos. (La diferencia más pequeña). */
    
    SELECT DISTINCT d.ne, d.ae, d.pais, --c.partido, --c.TotalVotos, c.porcentaje, 
    (d.MAXP - d.MINP) as DIFERENCIA FROM 
         
        ( SELECT DISTINCT c.ne, c.ae, c.pais, --c.partido, --c.TotalVotos, c.porcentaje, 
         MAX(c.porcentaje) over (partition by c.pais) as MAXP, MIN(c.porcentaje) over (partition by c.pais) as MINP FROM 
         
         ( SELECT b.ne, b.ae, b.pais, b.partido, b.TotalVotos, ROUND((b.totalvotos/b.totalpais*100),3) as Porcentaje FROM
         
         ( SELECT a.ne, a.ae, a.pais, a.partido, a.TotalVotos, 
         SUM(a.TotalVotos) over (partition by a.pais) as TotalPais FROM
         
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre AS pais, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, ELECCION e
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido and ep.eleccion = e.idEleccion AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY e.nombre, e.anio, pa.nombre, p.nombre
            ORDER BY p.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por partido y pais 
            
        ORDER BY a.pais, a.partido ) b -- ( B ) SUBCONSULTA 2: Se mantiene y agrega el total de votos por pais  

        ORDER BY b.pais, b.partido ) c -- ( C ) SUBCONSULTA 2: Se mantiene y agrega el porcentaje 
        
        ORDER BY c.pais ) d -- ( C ) SUBCONSULTA 2: Se mantiene y agrega el maximo y minimo porcentaje

    ORDER BY DIFERENCIA ASC
    FETCH NEXT 1 ROWS ONLY
    
    
    
/* 11. Desplegar el total de votos y el porcentaje de votos emitidos por mujeres indígenas alfabetas. */

    SELECT vmia.totalvotos as VOTOS_MUJER_INDIGENA_ALFABETA, ROUND((vmia.totalvotos/totalglobal.totalvotos*100),3) as PorcentajeGlobal FROM
    
        (SELECT SUM(dv.alfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, GENERO g, RAZA ra
        WHERE dv.genero = g.idGenero and g.genero = 'mujeres' and dv.raza = ra.idRaza and ra.raza = 'INDIGENAS' 
        AND dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais ) vmia -- MujeresIndigenasAlfabetas
        ,
        (SELECT SUM(dv.alfabetas + dv.analfabetas) as TotalVotos FROM DETALLEVOTOS dv) totalglobal
    ;


/* 12. Desplegar el nombre del país, el porcentaje de votos de ese país en el que han votado mayor porcentaje de analfabetas. 
    (tip: solo desplegar un nombre de país, el de mayor porcentaje). */

    SELECT DISTINCT votosan.pais, ROUND((votosan.totalvotos/totalpais.totalvotos*100),3) as Porcentaje_Votos_Analfabetas FROM
        
        (SELECT p.nombre AS pais, SUM(dv.analfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
        WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais
        GROUP BY  p.nombre
        ORDER BY p.nombre) votosan
        ,
        (SELECT p.nombre AS pais, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, RAZA ra
        WHERE dv.raza = ra.idRaza and dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais
        GROUP BY  p.nombre
        ORDER BY p.nombre) totalpais
            
    WHERE votosan.pais = totalpais.pais
    ORDER BY Porcentaje_Votos_Analfabetas DESC 
    FETCH NEXT 1 ROWS ONLY
    