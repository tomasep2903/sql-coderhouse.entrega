create database retail_project;

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    edad INT CHECK (edad >= 18)
    );

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    fecha_venta DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

begin;
insert into clientes (nombre, email, edad)
values 
('Martin', 'martin@gmail.com', 45),
('Sol', 'sol@hotmail.com', 22),
('Tomas', 'tomas@hotmail.com', 20),
('Marcela', 'marcela@gmail.com', 43),
('Yolanda', 'yolanda@yahoo.com', 70);

insert into productos (nombre, precio, stock)
values 
('Monitor', 110000.00, 10),
('Auriculares', 50000.00, 30),
('MousePad', 30000.00, 20),
('Teclado', 70000.00, 15),
('Gabinete', 60000.00, 5);

insert into ventas (id_cliente, id_producto, cantidad, fecha_venta)
values 
(1, 4, 3, '2026-04-05'),
(2, 1, 1, '2026-01-08'),
(3, 2, 5, '2025-05-20'),
(4, 5, 1, '2025-10-24'),
(5, 3, 2, '2026-05-15');
commit;

begin;
update productos
set precio=precio * 1.10
where nombre='Auriculares';

delete from ventas 
where id_venta=3;

commit;
