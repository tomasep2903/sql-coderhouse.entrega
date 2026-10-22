WITH ventas_por_region AS (
    SELECT 
        r.nombre_region, 
        COALESCE(SUM(v.precio_unitario * v.cantidad), 0) AS total_ventas
    FROM ventas AS v 
    INNER JOIN regiones AS r 
        ON r.id_region = v.id_region
    GROUP BY r.nombre_region
)
SELECT 
    nombre_region,
    total_ventas
FROM ventas_por_region
WHERE total_ventas > (
    SELECT AVG(total_ventas) 
    FROM ventas_por_region
)
ORDER BY total_ventas DESC;
