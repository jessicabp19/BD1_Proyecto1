/* 4. Desplegar todas las regiones por país en las que predomina la raza indígena. Es decir, hay más votos que las otras razas. */

    SELECT DISTINCT vi.pais, r.nombre FROM REGION r,
    
            ( SELECT p.nombre as pais, r.idRegion as region, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'INDIGENAS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY r.idRegion, p.nombre
            ORDER BY p.nombre, r.idRegion) vi -- INDIGENAS
            ,
            ( SELECT p.nombre as pais, r.idRegion as region, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'LADINOS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY r.idRegion, p.nombre
            ORDER BY p.nombre, r.idRegion) vl -- INDIGENAS
            ,
            ( SELECT p.nombre as pais, r.idRegion as region, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'GARIFUNAS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY r.idRegion, p.nombre
            ORDER BY p.nombre, r.idRegion) vg -- GARIFUNAS
            
            
    WHERE vi.pais = vg.pais and vi.pais = vl.pais and vg.pais = vl.pais 
        AND vi.region = vg.region and vi.region = vl.region and vg.region = vl.region 
        AND vi.totalvotos > vg.totalvotos and vi.totalvotos > vl.Totalvotos
        AND vi.region = r.idRegion;
    
    
/* 5. Desplegar el porcentaje de mujeres universitarias y hombres universitarios que votaron por departamento, 
        donde las mujeres universitarias que votaron fueron más que los hombres universitarios que votaron. */

    SELECT DISTINCT vmu.pais, vmu.departamento, vmu.TotalVotos, vhu.TotalVotos, vd.totalvotos, 
    ROUND((vmu.totalvotos/vd.totalvotos*100),3) as PorcentajeM, ROUND((vhu.totalvotos/vd.totalvotos*100),3) as PorcentajeH FROM --REGION r, PAIS p
    
            (SELECT p.nombre AS pais, d.nombre as departamento, SUM(dv.universitario) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, GENERO g
            WHERE dv.genero = g.idGenero and g.genero = 'mujeres' and dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre) vmu -- MujeresU
            ,
            (SELECT p.nombre AS pais, d.nombre as departamento, SUM(dv.universitario) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, GENERO g
            WHERE dv.genero = g.idGenero and g.genero = 'hombres' and dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre) vhu -- HombresU
             ,
            (SELECT p.nombre AS pais, d.nombre as departamento, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre) vd
            
    WHERE vmu.pais = vhu.pais AND vmu.departamento = vhu.departamento AND vmu.totalvotos > vhu.totalvotos
    and vmu.pais = vd.pais and vhu.pais = vd.pais
    and vmu.departamento = vd.departamento and vhu.departamento = vd.departamento
    ORDER BY vmu.pais;
     
    /* Consulta para verificar la cantidad de votosdemujeresunivesitarias:
    SELECT t.universitario, m.nombre, d.nombre FROM DETALLEVOTOS t, MUNICIPIO m, DEPARTAMENTO d, GENERO g
    WHERE t.genero = g.idGenero and g.genero = 'mujeres'
    and t.municipio = m.idMunicipio and m.nombre = 'Alfaro Ruiz'
    and m.departamento = d.iddepartamento and d.nombre = 'Alajuela';*/


/* 6. Desplegar el nombre del país, la región y el promedio de votos por departamento. Por ejemplo: Si la región tiene tres departamentos, se debe sumar todos los votos de la región y dividirlo dentro de tres (número de departamentos de la región). */

    SELECT DISTINCT a.pais, r.nombre, ROUND(AVG(a.TotalVotos) over (partition by a.region), 2) PromedioPorDepto FROM REGION r,
        
        ( SELECT p.nombre AS pais, r.idRegion as region, d.nombre as departamento, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
        FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
        WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
        AND m.departamento = d.idDepartamento 
        AND d.region = r.idRegion AND r.pais = p.idPais
        GROUP BY  d.nombre, r.idRegion, p.nombre
        ORDER BY p.nombre, r.idRegion, d.nombre ) a -- ( A ) SUBCONSULTA 1:Total de votos por departamento/region/pais
        
    WHERE a.region = r.idRegion
    ORDER BY a.pais, r.nombre
