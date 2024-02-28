DROP DATABASE IF EXISTS libroEspress;
CREATE DATABASE libroEspress;

USE libroEspress;

CREATE TABLE clientes(
id_cliente INT PRIMARY KEY,
nombre_cliente VARCHAR(50),
email_cliente VARCHAR(100),
telefono_cliente VARCHAR(10)
);

CREATE TABLE prestamos(
id_prestamo INT PRIMARY KEY,
id_cliente INT,
fecha_inicio DATE,
fecha_devolucion DATE,
estado ENUM ('activo','inactivo')
);

CREATE TABLE detalles_prestamos(
id_detalle_prestamo INT PRIMARY KEY,
id_prestamo INT,
id_libro INT
);

CREATE TABLE libros(
id_libro INT PRIMARY KEY,
titulo_libro VARCHAR(50),
anio_publicacion INT,
id_genero_libro INT,
estado ENUM ('activo','inactivo')
);

CREATE TABLE generos_libros(
id_genero_libro INT PRIMARY KEY,
nombre_genero_libro VARCHAR(50)
);

DELIMITER //

CREATE TRIGGER actualizar_estado_libro
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    UPDATE libros
    SET estado = 'Prestado'
    WHERE id_libro IN (SELECT id_libro FROM detalles_prestamos WHERE id_prestamo = NEW.id_prestamo);
END; //

DELIMITER ;

INSERT INTO clientes (id_cliente, nombre_cliente, email_cliente, telefono_cliente) VALUES
(1, 'Nombre Cliente 1', 'email1@dominio.com', '1234567890'),
(2, 'Nombre Cliente 2', 'email2@dominio.com', '1234567891'),
(15, 'Nombre Cliente 15', 'email15@dominio.com', '12345678914');

INSERT INTO prestamos (id_prestamo, id_cliente, fecha_inicio, fecha_devolucion, estado) VALUES
(1, 1, '2024-01-01', '2024-01-15', 'Devuelto'),
(2, 2, '2024-02-01', '2024-02-15', 'Pendiente'),
(15, 15, '2024-03-01', '2024-03-15', 'Devuelto');

INSERT INTO detalles_prestamos (id_detalle_prestamo, id_prestamo, id_libro) VALUES
(1, 1, 1),
(2, 2, 2),
(15, 15, 15);

INSERT INTO generos_libros (id_genero_libro, nombre_genero_libro) VALUES
(1, 'Genero 1'),
(2, 'Genero 2'),
(15, 'Genero 15');

CREATE PROCEDURE InsertarCliente(IN _id_cliente INT, IN _nombre_cliente VARCHAR(255), IN _email_cliente VARCHAR(255), IN _telefono_cliente VARCHAR(20))
BEGIN
    INSERT INTO clientes (id_cliente, nombre_cliente, email_cliente, telefono_cliente) VALUES (_id_cliente, _nombre_cliente, _email_cliente, _telefono_cliente);
END; //

DELIMITER ;

CALL InsertarCliente(16, 'Nombre Cliente', 'email@cliente.com', '1244567090');
