	##### PRIMERA CONSULTA
	/* Genere una lista de todas las bicicletas de tipo monta;a que no pertenezcan a la marca 'Escoza'*/

SELECT p.nombre, m.nombre as marca , p.precio, c.nombre as categoria
FROM categoria c
	INNER JOIN producto p ON p.id_categoria = c.id
	INNER JOIN marca m ON m.id = p.id_marca
WHERE c.nombre = 'Montaña' AND m.nombre != 'Escoza';

	##### SEGUNDA CONSULTA
    /* Genera una lista de bicicletas con rango de precio entre 400 y 600 $ */

SELECT p.nombre, m.nombre as marca , p.precio, c.nombre as categoria
FROM categoria c
	INNER JOIN producto p ON p.id_categoria = c.id
	INNER JOIN marca m ON m.id = p.id_marca
WHERE p.precio BETWEEN 400 AND 600
ORDER BY p.precio;

	##### TERCERA CONSULTA
    /* Descubrir que bicicleta tiene un precio por encima del promedio de las demas */

SELECT *
FROM producto
WHERE precio > (
	SELECT AVG(precio)
	FROM producto
);

	##### CUARTA CONSULTA
    /* Obtener una lista de clientes cuyas facturas hayan tenido un monto total igual o superior a 4500 $ */
    
