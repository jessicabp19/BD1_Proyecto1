/*  1. Desplegar para cada elección el país y el partido político que obtuvo mayor porcentaje de votos en su país. 
    Debe desplegar el nombre de la elección, el año de la elección, el país, el nombre del partido político
    y el porcentaje que obtuvo de votos en su país. */
    
    SELECT c.nom_e as NombreE, c.anio_e as AnioE, c.pais, c.partido, (c.TotalVotos/c.TotalPais*100) as Porcentaje FROM
    
    ( SELECT b.nom_e, b.anio_e, b.pais, b.partido, b.TotalVotos, b.TotalPais, MAX(b.TotalVotos) over (partition by b.pais) Mayor FROM  
    
        ( SELECT a.ne as nom_e, a.ae as anio_e, a.pais, a.partido, a.TotalVotos, 
         SUM(a.TotalVotos) over (partition by a.pais) TotalPais FROM
        
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre AS pais, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep, ELECCION e
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido and ep.eleccion = e.idEleccion AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY e.nombre, e.anio, pa.nombre, p.nombre
            ORDER BY p.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por partido y pais
        
        ORDER BY a.pais, a.partido ) b -- ( B ) SUBCONSULTA 2: Se mantiene y agrega el total de votos por pais
    
    ORDER BY b.pais, b.partido ) c -- ( C ) SUBCONSULTA 3: Se mantiene y se busca al partido con mayor cantidad de votos
       
    WHERE c.TotalVotos = c.mayor;  -- Se muesta el mayor y se calcula el porcentaje c:
    
    --SELECT DISTINCT anio_eleccion, pais FROM TEMPORAL;
    
    
/*  2. Desplegar total de votos y porcentaje de votos de mujeres por departamento y país. 
    El ciento por ciento es el total de votos de mujeres por país. (Tip: Todos los porcentajes por departamento de un país deben sumar el 100%) */
 
    SELECT b.nom_e as NombreE, b.anio_e as AnioE, b.pais, b.depto, (b.TotalVotos/b.TotalPais*100) as Porcentaje FROM
    
        ( SELECT a.ne as nom_e, a.ae as anio_e, a.pais, a.depto, a.TotalVotos, 
         SUM(a.TotalVotos) over (partition by a.pais) TotalPais FROM
        
            ( SELECT e.nombre as ne, e.anio as ae, p.nombre as pais, d.nombre as depto, SUM(dv.alfabetas + dv.analfabetas) as TotalVotos 
            FROM ELECCION e, PAIS p, DEPARTAMENTO d, DETALLEVOTOS dv, GENERO g, ELECCIONPARTIDO ep, MUNICIPIO m, REGION r
            WHERE dv.genero = g.idGenero and g.genero = 'mujeres' and dv.eleccionpartido = ep.idEP and ep.eleccion = e.idEleccion
            and dv.municipio = m.idMunicipio and m.departamento = d.idDepartamento and d.region = r.idRegion and r.pais = p.idPais
            GROUP BY d.nombre, p.nombre, e.anio, e.nombre 
            ORDER BY e.anio, p.nombre, d.nombre ) a -- ( A ) SUBCONSULTA 1: Total de votos por deepartamento y pais
        
        ORDER BY a.pais, a.depto ) b -- ( B ) SUBCONSULTA 2: Se mantiene y agrega el total de votos por pais
        
    ;


/*  3. Desplegar el nombre del país, nombre del partido político y número de alcaldías de los partidos políticos que ganaron más alcaldías por país. */
    
    SELECT d.pais, d.partido, d.Noalcaldias FROM
    
    ( SELECT c.pais, c.partido, c.Noalcaldias, MAX(NoAlcaldias) over (partition by c.pais) Maximo FROM
    
    ( SELECT b.pais, b.partido, COUNT(b.ganador) as NoAlcaldias FROM
    
        ( SELECT a.pais, a.departamento, a.municipio, a.partido, a.TotalVotos, 
        MAX(a.TotalVotos) over (partition by a.municipio,a.departamento) ganador FROM
        
            ( SELECT p.nombre AS pais, d.nombre as departamento, m.nombre as municipio, pa.nombre as partido, SUM(dv.alfabetas + dv.analfabetas) AS TotalVotos
            FROM PARTIDO pa, DETALLEVOTOS dv, MUNICIPIO m, DEPARTAMENTO d, REGION r, PAIS p, ELECCIONPARTIDO ep
            WHERE dv.eleccionpartido = ep.idEP and ep.partido = pa.idPartido AND dv.municipio = m.idMunicipio 
            AND m.departamento = d.idDepartamento 
            AND d.region = r.idRegion AND r.pais = p.idPais
            GROUP BY  pa.nombre, m.nombre, d.nombre, p.nombre
            ORDER BY p.nombre, d.nombre, m.nombre, pa.nombre ) a -- ( A ) SUBCONSULTA 1:Total de votos por partido/municipio/departamento/pais
        
        ORDER BY a.pais, a.departamento, a.municipio, a.partido ) b -- ( B ) SUBCONSULTA 2
    
    WHERE b.totalVotos = b.ganador
    GROUP BY b.partido, b.pais
    ORDER BY b.pais, b.partido
    ) c
    
    ) d
    
    WHERE d.noalcaldias = d.maximo;