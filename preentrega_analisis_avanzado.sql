CREATE TABLE categorias(
id_categoria int PRIMARY KEY,
nombre_categoria varchar(100) NOT NULL
);

CREATE TABLE productos(
id_producto int PRIMARY KEY,
id_categoria int,
nombre_producto varchar(100) NOT NULL,
precio decimal(10,2),
stock int,
FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
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

INSERT INTO categorias (id_categoria, nombre_categoria) VALUES
(1, 'Audio y Video'),
(2, 'Computación'),
(3, 'Telefonía y Celulares'),
(4, 'Accesorios y Periféricos'),
(5, 'Gaming');

INSERT INTO productos (id_producto, id_categoria, nombre_producto, precio, stock) VALUES
(101, 1, 'Auriculares Inalámbricos', 50000.00, 30),
(102, 2, 'Notebook i5 16GB', 100000.00, 15),
(103, 3, 'Funda Silicona Celular', 15000.00, 100),
(104, 4, 'Teclado Mecánico', 45000.00, 40),
(105, 5, 'Silla Gamer Ergonómica', 70000.00, 10);

INSERT INTO ventas (id_venta, id_cliente, id_categoria, id_producto, fecha_ventas, precio_unitario, cantidad) VALUES
(1, 1, 2, 105, '2024-03-01', 100000.00, 1),
(2, 2, 1, 102, '2024-03-05', 50000.00, 2),
(3, 1, 4, 101, '2024-03-10', 45000.00, 3),
(4, 3, 5, 105, '2024-03-12', 30000.00, 1),
(5, 2, 2, 104, '2024-03-15', 100000.00, 2);

WITH ventas_mensuales AS (
    -- 1. Primera CTE: Agrupa ventas por año, mes y categoría sumando el total
    SELECT 
        EXTRACT(YEAR FROM fecha_ventas) AS anio,
        EXTRACT(MONTH FROM fecha_ventas) AS mes,
        nombre_categoria,
        SUM(precio_unitario * cantidad) AS total_ventas
    FROM ventas 
    INNER JOIN categorias ON ventas.id_categoria = categorias.id_categoria
    GROUP BY 
        EXTRACT(YEAR FROM fecha_ventas),
        EXTRACT(MONTH FROM fecha_ventas),
        nombre_categoria
),
metricas_ventana AS (
    -- 2. Segunda CTE: Calcula el ranking, el acumulado y el promedio por categoría
    SELECT 
        anio,
        mes,
        nombre_categoria,
        total_ventas,
       
        RANK() OVER (PARTITION BY anio, mes ORDER BY total_ventas DESC) AS ranking_mensual,
        
        SUM(total_ventas) OVER (PARTITION BY nombre_categoria ORDER BY anio, mes) AS ventas_acumuladas,
        
        AVG(total_ventas) OVER (PARTITION BY nombre_categoria) AS promedio_categoria
    FROM ventas_mensuales
)
-- 3. Consulta final (SELECT principal) con el CASE WHEN solicitado
SELECT 
    anio,
    mes,
    nombre_categoria,
    total_ventas,
    ranking_mensual,
    ventas_acumuladas,
    CASE 
        WHEN total_ventas >= promedio_categoria THEN 'Exitoso'
        ELSE 'Bajo el promedio'
    END AS estado_ventas
FROM metricas_ventana
ORDER BY 
    anio, mes, ranking_mensual;

