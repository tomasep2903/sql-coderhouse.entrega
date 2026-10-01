# sql-coderhouse.entrega
# Proyecto Retail - SQL

Este proyecto contiene el diseño, creación y manipulación de datos para la base de datos `retail_project` en PostgreSQL.

## Contenido del repositorio
- **retail_project.sql**: Script con las sentencias DDL (creación de base de datos, tablas y restricciones) y DML (inserción, actualización y eliminación de datos mediante transacciones).

## Tablas y Restricciones
- **clientes**: Clave primaria `id_cliente`, email único y restricción `CHECK (edad >= 18)`.
- **productos**: Clave primaria `id_producto`, restricciones `CHECK (precio > 0)` y `CHECK (stock >= 0`
- **ventas**: clave primaria `id_venta`, dos claves foraneas `id_cliente` y `id_producto` y restriccion `CHECK (cantidad > 0)`
