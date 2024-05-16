use Clinic;

# 1. Obtén la lista de todas las criaturas que han recibido algún tratamiento en algún momento.
select Criatura.id_criatura, nombre_criatura, sexo, especie
from cita
	inner join Criatura on Criatura.id_criatura = cita.id_criatura
group by Criatura.id_criatura;

# 2. Contar el número total de tratamientos disponibles.

select count(*)
	from Tratamiento;
    
# 3.Listar el nombre y la especialidad de todo el personal que tiene asignada al menos una criatura.
select nombre_personal, especialidad
from cita
	inner join Personal on Personal.id_personal = cita.id_personal
group by nombre_personal, especialidad, ssexo, rol_personal;


# 4. Listar todas las citas disponibles entre el uno de enero de 9999 y el 30 de enero de 9999 (ambos incluidos).
SELECT fecha_y_hora,nombre_criatura,especie,sexo,nombre_personal,ssexo,especialidad,rol_personal
FROM cita
	INNER JOIN Criatura ON Criatura.id_criatura = cita.id_criatura
	INNER JOIN Personal ON Personal.id_personal = cita.id_personal
WHERE fecha_y_hora BETWEEN '9999-01-01 00:00:00' AND '9999-01-30 23:59:59';

# 5. Mostrar todos los tratamientos con sus respectivos ingredientes ordenados por nombre.

SELECT
Tratamiento.nombre_tratamiento,
GROUP_CONCAT(Ingrediente.nombre_ingrediente ORDER BY Ingrediente.nombre_ingrediente SEPARATOR ', ') AS ingredientes
FROM Tratamiento
	INNER JOIN necesita ON Tratamiento.id_tratamiento = necesita.id_tratamiento
	INNER JOIN Ingrediente ON Ingrediente.id_ingrediente = necesita.id_ingrediente
GROUP BY Tratamiento.nombre_tratamiento
ORDER BY Tratamiento.nombre_tratamiento;



# 6. Listar todas las citas, incluyendo la información de la criatura y el tratamiento aplicado, ordenadas por fecha y hora.
select fecha_y_hora, nombre_criatura, sexo, especie, nombre_tratamiento, descripcion_tratamiento
from cita
	inner join Criatura on Criatura.id_criatura = cita.id_criatura
    inner join Tratamiento on Tratamiento.id_enfermedad = cita.id_tratamiento
order by fecha_y_hora;


# 7. Encontrar el tratamiento más caro (aquel donde sumando todos los ingredientes que lo componen suma más) y listar todas las criaturas que lo han recibido.
# Usamos Common Table Expression que nos da un resultado temporal lo cual nos facilita la query

# Creamos una tabla llamada CosteTratamiento que guarda el coste de cada tratamiento y con MaxCoste sacamos el más costoso de ellos
WITH CosteTratamiento AS (
	SELECT t.id_tratamiento, SUM(i.precio) AS coste_total
	FROM necesita n
		INNER JOIN Tratamiento t ON t.id_tratamiento = n.id_tratamiento
		INNER JOIN Ingrediente i ON i.id_ingrediente = n.id_ingrediente
	GROUP BY t.id_tratamiento
),
MaxCoste AS (
	SELECT MAX(coste_total) AS max_coste
	FROM CosteTratamiento
)
SELECT DISTINCT c.*, T.nombre_tratamiento
FROM cita ci
	INNER JOIN Criatura c ON c.id_criatura = ci.id_criatura
    INNER JOIN Tratamiento T ON ci.id_tratamiento = T.id_tratamiento
    INNER JOIN CosteTratamiento CT ON ci.id_tratamiento = CT.id_tratamiento
WHERE CT.coste_total >= (SELECT max_coste FROM MaxCoste);


# 8. Listar el personal que ha atendido a criaturas de más de tres especies diferentes.
SELECT Personal.*
FROM cita
	INNER JOIN Personal ON Personal.id_personal = cita.id_personal
	INNER JOIN Criatura ON cita.id_criatura = Criatura.id_criatura
GROUP BY Personal.id_personal
HAVING COUNT(DISTINCT Criatura.especie) > 3;

# 9. Encontrar qué criatura tiene el mayor número de citas programadas.
SELECT Criatura.*, count(*) as numero_citas
FROM Criatura
	inner join cita on cita.id_criatura = Criatura.id_criatura
group by id_criatura
having numero_citas >= all(select count(*)
							from Criatura
								inner join cita on cita.id_criatura = Criatura.id_criatura
                                group by Criatura.id_criatura);


# 10. Identificar los tratamientos que nunca se han aplicado a un dragón pero sí a cualquier otra criatura.

SELECT *
FROM Tratamiento
WHERE id_tratamiento NOT IN (
								SELECT id_tratamiento
								FROM cita
									INNER JOIN Criatura ON cita.id_criatura = Criatura.id_criatura
								WHERE Criatura.especie = 'dragón'
								);




# 11. Calcular los tratamientos que incluyen el ingrediente "baba de caracol mágico".
SELECT *
FROM Tratamiento
WHERE id_tratamiento IN (
						SELECT id_tratamiento
							FROM necesita
						INNER JOIN Ingrediente ON necesita.id_ingrediente = Ingrediente.id_ingrediente
						WHERE nombre_ingrediente = 'baba de caracol mágico'
						);
# 12. Personal que ha utilizado en sus tratamientos el ingrediente "lágrimas de unicornio" pero no el ingrediente "plumas de fénix".alter


SELECT *
FROM Personal
WHERE id_personal IN (
					SELECT id_personal
					FROM cita
						INNER JOIN Tratamiento ON cita.id_tratamiento = Tratamiento.id_tratamiento
						INNER JOIN necesita ON Tratamiento.id_tratamiento = necesita.id_tratamiento
						INNER JOIN Ingrediente ON necesita.id_ingrediente = Ingrediente.id_ingrediente
					WHERE Ingrediente.nombre_ingrediente = 'lágrimas de unicornio'
					)
AND id_personal NOT IN (
SELECT id_personal
FROM cita
	INNER JOIN Tratamiento ON cita.id_tratamiento = Tratamiento.id_tratamiento
	INNER JOIN necesita ON Tratamiento.id_tratamiento = necesita.id_tratamiento
	INNER JOIN Ingrediente ON necesita.id_ingrediente = Ingrediente.id_ingrediente
WHERE Ingrediente.nombre_ingrediente = 'plumas de fénix'
);
# 13. Criaturas que han sido tratadas con el tratamiento "crema de invisibilidad" y posteriormente con el tratamiento "infusión de sueños".
SELECT Criatura.*
FROM Criatura
	JOIN cita ON Criatura.id_criatura = cita.id_criatura
	JOIN Tratamiento AS Tratamiento1 ON cita.id_tratamiento = Tratamiento1.id_tratamiento
	JOIN cita AS cita2 ON Criatura.id_criatura = cita2.id_criatura
	JOIN Tratamiento AS Tratamiento2 ON cita2.id_tratamiento = Tratamiento2.id_tratamiento
WHERE Tratamiento1.nombre_tratamiento = 'crema de invisibilidad'
AND Tratamiento2.nombre_tratamiento = 'infusión de sueños'
AND cita.fecha_y_hora < cita2.fecha_y_hora;

# 14. Calcular el coste promedio de los tratamientos aplicados a cada especie de criatura y encontrar la especie con el coste más alto.


with CostePorTratamiento as (
	select t.id_tratamiento as id_tratamiento, sum(i.precio) as coste_tratamiento
    from necesita n
		inner join Tratamiento t on t.id_tratamiento = n.id_tratamiento
        inner join Ingrediente i on i.id_ingrediente = n.id_ingrediente
	group by t.id_tratamiento
),

CostePromedioPorEspecie AS (
	SELECT c.especie, avg(CT.coste_tratamiento) AS coste_promedio
	FROM cita ci
		INNER JOIN Tratamiento t ON t.id_tratamiento = ci.id_tratamiento
        inner join Criatura c on c.id_criatura = ci.id_criatura
        inner join CostePorTratamiento CT on CT.id_tratamiento = ci.id_tratamiento
	GROUP BY c.especie 
)
select *
from CostePromedioPorEspecie;


with CostePorTratamiento as (
	select t.id_tratamiento as id_tratamiento, sum(i.precio) as coste_tratamiento
    from necesita n
		inner join Tratamiento t on t.id_tratamiento = n.id_tratamiento
        inner join Ingrediente i on i.id_ingrediente = n.id_ingrediente
	group by t.id_tratamiento
),

CostePromedioPorEspecie AS (
	SELECT c.especie, avg(CT.coste_tratamiento) AS coste_promedio
	FROM cita ci
		INNER JOIN Tratamiento t ON t.id_tratamiento = ci.id_tratamiento
        inner join Criatura c on c.id_criatura = ci.id_criatura
        inner join CostePorTratamiento CT on CT.id_tratamiento = ci.id_tratamiento
	GROUP BY c.especie 
),
Maximo_costo_promedio_por_especie AS (
	SELECT MAX(coste_promedio) AS maximo_coste_promedio
	FROM CostePromedioPorEspecie
)


SELECT DISTINCT c.especie, CT.coste_promedio
FROM cita ci
	INNER JOIN Criatura c ON c.id_criatura = ci.id_criatura
    INNER JOIN CostePromedioPorEspecie CT ON c.especie = CT.especie
WHERE CT.coste_promedio >= (SELECT maximo_coste_promedio FROM Maximo_costo_promedio_por_especie);


# 15. Tratamientos que usan todos los ingredientes.
SELECT t.*
FROM Tratamiento t
	inner join necesita n on n.id_tratamiento = t.id_tratamiento
group by t.id_tratamiento 
having count(*) >= (select count(i.id_ingrediente)
							from Ingrediente i);
	

# 16. Criaturas de tipo dragón que han recibido tratamientos que usan todos los ingredientes de precio menor que 55.
# Criaturas que no pertenezcan a las criaturas que han recibido tratamientos con ingredientes de precio mayor que 55
select c.*
from cita ci
	inner join Criatura c on c.id_criatura = ci.id_criatura
where c.id_criatura not in (select c.id_criatura
							from cita ci
								inner join Criatura c on c.id_criatura = ci.id_criatura
							where id_tratamiento in (select n.id_tratamiento
													from necesita n
														inner join Tratamiento t on t.id_tratamiento = n.id_tratamiento
													where n.id_ingrediente in (select i.id_ingrediente
																				from necesita n
																					inner join Ingrediente i on i.id_ingrediente = n.id_ingrediente
																				where precio >= 55
																				group by i.id_ingrediente)
													group by n.id_tratamiento));

