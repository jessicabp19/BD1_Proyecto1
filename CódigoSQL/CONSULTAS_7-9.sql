/* 7. Desplegar el nombre del municipio y el nombre de los dos partidos políticos con más votos en el municipio, ordenados por país. */

    SELECT c.nom_e, c.anio_e, c.pais, c.depto, c.muni, b.partido as PartidoMasVotado, b.totalvotos, c.partido as Segundo, c.TotalVotos FROM  
    
    ( SELECT b.ne as nom_e, b.ae as anio_e, b.pais, b.depto, b.muni, b.partido, b.TotalVotos, b.max1, 
         MAX(b.TotalVotos) over (partition by b.muni) MAX2 FROM    
        ( SELECT a.ne, a.ae, a.pais, a.depto, a.muni, a.partido, a.TotalVotos, 
         MAX(a.TotalVotos) over (partition by a.muni) MAX1 FROM        
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre AS pais, d.nombre as depto, m.nombre as muni, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, ELECCION e
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido and ep.eleccion = e.idEleccion AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY e.nombre, e.anio, pa.nombre, d.nombre, m.nombre, p.nombre
            ORDER BY p.nombre, d.nombre, m.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por partido/municipio, departamento y pais        
        ORDER BY a.pais, a.depto, a.muni, a.partido ) b -- ( B ) SUBCONSULTA 2: Se mantiene y agrega el total de votos por pais    
    WHERE b.totalvotos != b.max1
    ORDER BY b.pais, b.depto, b.muni, b.partido ) c -- ( C ) SUBCONSULTA 3: Se mantiene y se busca al partido con mayor cantidad de votos
    ,
    ( SELECT a.ne, a.ae, a.pais, a.depto, a.muni, a.partido, a.TotalVotos, 
         MAX(a.TotalVotos) over (partition by a.muni) MAX1 FROM       
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre AS pais, d.nombre as depto, m.nombre as muni, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, ELECCION e
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido and ep.eleccion = e.idEleccion AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY e.nombre, e.anio, pa.nombre, d.nombre, m.nombre, p.nombre
            ORDER BY p.nombre, d.nombre, m.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por partido/municipio, departamento y pais        
        ORDER BY a.pais, a.depto, a.muni, a.partido 
    ) b
    WHERE c.pais = b.pais and c.depto = b.depto and c.muni = b.muni
    AND b.TotalVotos = b.max1 and c.TotalVotos = c.max2
    ORDER BY c.pais, c.depto, c.muni, c.partido;  -- Se muesta el mayor y se calcula el porcentaje c:


/* 8. Desplegar el total de votos de cada nivel de escolaridad (primario, medio, universitario) por país, sin importar raza o sexo. */

    SELECT e.nombre, e.anio, p.nombre AS pais, SUM(dv.primaria) as PRIMARIA, SUM(dv.medio) as NIVEL_MEDIO, SUM(dv.universitario) as UNIVERSITARIO
    FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, ELECCION e
    WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido and ep.eleccion = e.idEleccion AND dv.municipio = m.idMunicipio 
    AND m.departamento = d.idDepartamento 
    AND d.region = r.idRegion AND r.pais = p.idPais
    GROUP BY e.nombre, e.anio, p.nombre
    ORDER BY p.nombre;
        

/* 9. Desplegar el nombre del país y el porcentaje de votos por raza. */

    SELECT DISTINCT votosraza.pais, votosraza.raza, ROUND((votosraza.totalvotos/totalpais.totalvotos*100),3) as PorcentajeRaza FROM
    
            (SELECT p.nombre AS pais, ra.raza, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, RAZA ra
            WHERE dv.raza = ra.idRaza and dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  ra.raza, p.nombre
            ORDER BY p.nombre, ra.raza) votosraza
            ,
            (SELECT p.nombre AS pais, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, RAZA ra
            WHERE dv.raza = ra.idRaza and dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  p.nombre
            ORDER BY p.nombre) totalpais
            
    WHERE votosraza.pais = totalpais.pais
    ORDER BY votosraza.pais;
