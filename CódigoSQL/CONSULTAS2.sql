/* 4. Desplegar todas las regiones por país en las que predomina la raza indígena. Es decir, hay más votos que las otras razas. */

SELECT b.nom_e as NombreE, b.anio_e as AnioE, b.pais, b.depto, (b.TotalVotos/b.TotalPais*100) as Porcentaje FROM
    
        ( SELECT a.ne as nom_e, a.ae as anio_e, a.pais, a.region, a.TotalVotos, 
         MAX(a.TotalVotos) over (partition by a.pais) TotalPais FROM
        
            
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre as pais, r.nombre as region, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'INDIGENAS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY r.nombre, p.nombre, e.anio, e.nombre 
            ORDER BY e.anio, p.nombre, r.nombre) a -- ( A ) SUBCONSULTA 1: Total de votos por departamento y pais
            
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre as pais, r.nombre as region, ra.raza, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY ra.raza, r.nombre, p.nombre, e.anio, e.nombre 
            ORDER BY e.anio, p.nombre, r.nombre) a -- ( A ) SUBCONSULTA 1: Total de votos por departamento y pais
        
        
        ORDER BY a.pais, a.region ) b -- ( B ) SUBCONSULTA 2: Se mantiene y agrega el total de votos por pais
        
        WHERE b.totalvotos = b.TotalPais;
        
        
        SELECT a.pais, a.departamento, a.municipio, a.partido, a.TotalVotos, 
        MAX(a.TotalVotos) over (partition by a.municipio,a.departamento) ganador FROM
        
            ( SELECT p.nombre AS pais, d.nombre as departamento, m.nombre as municipio, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  pa.nombre, m.nombre, d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre, m.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1:Total de votos por partido/municipio/departamento/pais
        
        ORDER BY a.pais, a.departamento, a.municipio, a.partido
    
    
    ( SELECT e.nombre as ne, e.anio as ae, p.nombre as pais, d.nombre as depto, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'INDIGENAS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY d.nombre, p.nombre, e.anio, e.nombre 
            ORDER BY e.anio, p.nombre, d.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por departamento y pais
            
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre as pais, r.nombre as region, d.nombre as depto, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, RAZA ra, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.raza = ra.idRaza and ra.raza = 'INDIGENAS' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY d.nombre, r.nombre, p.nombre, e.anio, e.nombre 
            ORDER BY e.anio, p.nombre, r.nombre, d.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por departamento y pais

/* 5. Desplegar el porcentaje de mujeres universitarias y hombres universitarios que votaron por departamento, donde las mujeres universitarias que votaron fueron más que los hombres universitarios que votaron. */



/* 6. Desplegar el nombre del país, la región y el promedio de votos por departamento. Por ejemplo: Si la región tiene tres departamentos, se debe sumar todos los votos de la región y dividirlo dentro de tres (número de departamentos de la región). */
