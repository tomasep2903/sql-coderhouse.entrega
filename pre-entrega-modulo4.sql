CREATE DATABASE pre_entrega_modulo4;

CREATE TABLE clientes(
id_cliente int PRIMARY KEY,
nombre varchar(100) NOT NULL,
apellido varchar(100) NOT NULL,
email varchar(50)
);

CREATE TABLE categorias(
id_categoria int PRIMARY KEY,
nombre_categoria varchar(100) NOT NULL
);

CREATE TABLE ventas(
id_venta int PRIMARY KEY,
id_cliente int,
id_categoria int,
id_producto int,
fecha_ventas date,
precio_unitario decimal(10,2),
cantidad int,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE productos(
id_producto int PRIMARY KEY,
id_categoria int,
nombre_producto varchar(100) NOT NULL,
precio decimal(10,2),
stock int,
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

INSERT INTO clientes (id_cliente, nombre, apellido, email) VALUES
(1, 'Sol', 'Andreo', 'sol@email.com'),
(2, 'Lucas', 'Fernández', 'lucas@email.com'),
(3, 'Yolanda', 'Gomez', 'Yolanda@email.com'),
(4, 'Tomás', 'Pérez', 'tomas@email.com'),
(5, 'Juan', 'Ramirez', 'juan@email.com');

INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
(1, 'Audio y Video'),
(2, 'Computación'),
(3, 'Telefonía y Celulares'),
(4, 'Accesorios y Periféricos'),
(5, 'Gaming');

INSERT INTO ventas (id_venta, id_cliente, id_categoria, fecha_ventas, precio_unitario, cantidad) VALUES
(1, 1, 2, '2024-03-01', 100000.00, 1),
(2, 2, 1, '2024-03-05', 50000.00, 2),
(3, 1, 4, '2024-03-10', 45000.00, 3),
(4, 3, 5, '2024-03-12', 30000.00, 1),
(5, 2, 2, '2024-03-15', 100000.00, 2);

INSERT INTO productos (id_producto, id_categoria, nombre_producto, precio, stock) VALUES
(101, 1, 'Auriculares Inalámbricos', 50000.00, 30),
(102, 2, 'Notebook i5 16GB', 100000.00, 15),
(103, 3, 'Funda Silicona Celular', 15000.00, 100),
(104, 4, 'Teclado Mecánico', 45000.00, 40),
(105, 5, 'Silla Gamer Ergonómica', 70000.00, 10);

-- Consulta 1: Rentabilidad por categoría
-- Problema de negocio: Identificar qué líneas de productos generan mayor facturación 
-- y volumen de ventas para optimizar la asignación de presupuesto, reposición de stock 
-- y priorizar campañas de marketing sobre las categorías que superan el umbral mínimo de ingresos.

SELECT c.nombre_categoria,
 sum(v.cantidad) AS unidades_vendidas,
 sum(v.cantidad * v.precio_unitario) AS ingreso_total
 FROM categorias AS c 
INNER JOIN productos AS p
ON c.id_categoria = p.id_categoria
INNER JOIN ventas AS v 
ON p.id_producto = v.id_producto
GROUP BY c.nombre_categoria
HAVING  sum(v.cantidad * v.precio_unitario) >500;
 

-- Consulta 2: Clientes sin compras registradas
-- Problema de negocio: Detectar usuarios registrados que aún no generaron conversiones
-- para diseñar estrategias de activación (onboarding, cupones de primer pedido o 
-- comunicaciones personalizadas) y reducir la tasa de abandono temprano.

SELECT c.id_cliente,
c.nombre,
c.apellido,
c.email,
COALESCE (count(v.id_venta),0) AS total_compras,
COALESCE (sum(v.cantidad * v.precio_unitario), 0) AS monto_total_gastado 
FROM clientes AS c 
LEFT JOIN ventas AS v 
ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido, c.email
HAVING count(v.id_venta) =0;



-- Consulta 3: Top de compras por cliente y última transacción
-- Problema de negocio: Determinar el producto preferido o de mayor frecuencia de compra 
-- de cada cliente junto con la fecha de su última actividad comercial, permitiendo 
-- segmentar audiencias, personalizar ofertas de fidelización y prevenir la deserción.


SELECT 
    c.nombre,
    c.apellido,
    p.nombre_producto AS producto_mas_comprado,
    SUM(v.cantidad) AS cantidad_comprada,
    MAX(v.fecha_ventas) AS fecha_ultima_transaccion
FROM clientes c
INNER JOIN ventas v ON c.id_cliente = v.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
GROUP BY c.id_cliente, c.nombre, c.apellido, p.id_producto, p.nombre_producto
HAVING SUM(v.cantidad) = (
    SELECT MAX(total_por_prod)
    FROM (
        SELECT v2.id_cliente, v2.id_producto, SUM(v2.cantidad) AS total_por_prod
        FROM ventas v2
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY v2.id_cliente, v2.id_producto
    ) sub
)
ORDER BY c.nombre;


