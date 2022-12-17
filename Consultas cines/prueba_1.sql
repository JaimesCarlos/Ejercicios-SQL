		##### PRIMERA PRUEBA
/* Seleecionar peliculas que se encuentren en cartelera*/

SELECT DISTINCT p.id, p.nombre
FROM pelicula p
LEFT JOIN cartelera c
ON p.id = c.id_pelicula
where c.id_pelicula is not null;

		##### SEGUNDA PRUEBA
/* Dentro de la colukmna clasificacion existen valores nullos, cambiarlos por 0*/

# Parece que su sesión de MySql tiene configurada la opción de actualizaciones seguras 
# Esto significa que no puede actualizar ni eliminar registros sin especificar una clave (por ejemplo, primary key) en la cláusula where.
SET SQL_SAFE_UPDATES = 0; 

UPDATE pelicula
set clasificacion_edad = 0
WHERE clasificacion_edad is null;

		##### TERCERA PRUEBA
/* Se necesita la lista de peliculas en cartelera que tengan clasificacion para todas las edades*/

SELECT DISTINCT  p.id, p.nombre, p.clasificacion_edad
FROM pelicula p
LEFT JOIN cartelera c
ON p.id = c.id_pelicula
where c.id_pelicula is not null and p.clasificacion_edad = 0;

		##### CUARTA PRUEBA
/* Lista de cines disponibles en este momento*/

SELECT DISTINCT c.*
FROM cine c
INNER JOIN cartelera car ON c.id = car.id_cine;

		##### QUINTA PRUEBA
 /* Que peliculas se estan proyectando en cada cine*/
 
 SELECT c.nombre,c.estado,c.pais, p.nombre
 FROM pelicula p
 INNER JOIN cartelera car ON p.id = car.id_pelicula
 INNER JOIN cine c ON c.id = car.id_cine;
 
		##### SEXTA PRUEBA
/* Hay cines que no estan disponibles, eliminar cines que no estan proyectando ninguna pelicula*/

DELETE 
FROM cine
WHERE id IN (
	SELECT id FROM (
	SELECT c.id
	FROM cine c
	LEFT JOIN cartelera car ON c.id = car.id_cine
	WHERE car.id_pelicula IS NULL
    ) AS cine_delete
);

/*hacmos la consulta y ya no figura la lista de cines sin peliculas en cartelera */
SELECT c.id
FROM cine c
LEFT JOIN cartelera car ON c.id = car.id_cine
WHERE car.id_pelicula is NULL;
 
		##### SEPTIMA PRUEBA
 /* Generar una lista de peliculas unicamente de los cines en Dublín, Irlanda */

SELECT car.id_pelicula, p.nombre,c.nombre, c.estado, c.pais
FROM pelicula p 
INNER JOIN cartelera car ON car.id_pelicula = p.id
INNER JOIN cine c ON c.id = car.id_cine
WHERE c.estado = 'Dublín' AND c.pais = 'Irlanda';

		##### OCTAVA PRUEBA 
/* Inluir una tabla 'genero' de las peliculas:
	- id INTEGER AUTOINCREMENTAL AUTO INCREMENTAL
    - nombre VARCHAR(100) con valores :
			1 Accion
            2 Aventura
            3 Ciencia Ficcion
            4 Comedia
            5 Drama
            6 Fantasia
            7 Suspenso
            8 Terror
    */
 
 CREATE TABLE genero (
	id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR (100),
    PRIMARY KEY (id)
 );

INSERT INTO `genero` (`nombre`) VALUES ('Accion');
INSERT INTO `genero` (`nombre`) VALUES ('Aventura');
INSERT INTO `genero` (`nombre`) VALUES ('Ciencia Ficcion');
INSERT INTO `genero` (`nombre`) VALUES ('Comedia');
INSERT INTO `genero` (`nombre`) VALUES ('Drama');
INSERT INTO `genero` (`nombre`) VALUES ('Fantasia');
INSERT INTO `genero` (`nombre`) VALUES ('Suspenso');
INSERT INTO `genero` (`nombre`) VALUES ('Terror');

		##### NOVENA PRUEBA
/* Asociar cada uno de los generos a nuestra tabla de peliculas segun el id de pelicula que tienen
	id_genero: 
		1 - 10	Terror
        11 - 20	Ciencia FIccion
        21 - 45	Comedia
        46 - 55 Suspenso
        Demás 	Accion
*/
	/*Creacion de la columna nueva con valores null y despues de la columna 'clasificacion_edad'*/
ALTER TABLE pelicula 
ADD COLUMN id_genero INT NULL AFTER	clasificacion_edad;

	/*Creacion de llave foranea*/
ALTER TABLE pelicula
ADD CONSTRAINT fk_pelicula_genero
FOREIGN KEY (id_genero)
REFERENCES genero(id);

	/*Actualizar peliculas segun rango*/
UPDATE pelicula
SET id_genero = (SELECT id FROM genero WHERE nombre = 'Terror')
WHERE id BETWEEN 1 AND 10;

UPDATE pelicula
SET id_genero = (SELECT id FROM genero WHERE nombre = 'Ciencia Ficcion')
WHERE id BETWEEN 11 AND 20;

UPDATE pelicula
SET id_genero = (SELECT id FROM genero WHERE nombre = 'Comedia')
WHERE id BETWEEN 21 AND 45;

UPDATE pelicula
SET id_genero = (SELECT id FROM genero WHERE nombre = 'Suspenso')
WHERE id BETWEEN 46 AND 55;

UPDATE pelicula
SET id_genero = (SELECT id FROM genero WHERE nombre = 'Terror')
WHERE id > 55;

		##### DECIMO PROBLEMA
/* Peliculas de suspenso con clasificacion de edad 18, y que esten proyectados en la cuidad de Madrid - España */

SELECT p.nombre, p.clasificacion_edad, c.nombre, c.estado, c.pais, g.nombre
FROM pelicula p
	INNER JOIN genero g ON g.id = p.id_genero
	INNER JOIN cartelera car ON car.id_pelicula = p.id
	INNER JOIN cine c ON c.id = car.id_cine
WHERE p.clasificacion_edad = 18 AND c.estado = 'Madrid' AND c.pais = 'España' AND g.nombre = 'Suspenso';

