DELIMITER $$
CREATE PROCEDURE info_tratamientos_ingredientes ()
BEGIN
	SELECT
	Tratamiento.nombre_tratamiento,
	GROUP_CONCAT(Ingrediente.nombre_ingrediente, ' (', Ingrediente.precio, ')'  ORDER BY Ingrediente.nombre_ingrediente SEPARATOR ', ') AS ingredientes
	FROM Tratamiento
		INNER JOIN necesita ON Tratamiento.id_tratamiento = necesita.id_tratamiento
		INNER JOIN Ingrediente ON Ingrediente.id_ingrediente = necesita.id_ingrediente
	GROUP BY Tratamiento.nombre_tratamiento
	ORDER BY Tratamiento.nombre_tratamiento;
END$$
DELIMITER ;
CALL info_tratamientos_ingredientes();
