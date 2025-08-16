-- ==============================================
-- BASE DE DATOS: SISTEMA DE VENTAS
-- Tablas: clientes, productos, compras
-- ==============================================

-- Crear base de datos
CREATE DATABASE sistema_ventas;
USE sistema_ventas;

-- ==============================================
-- TABLA CLIENTES
-- ==============================================
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro DATE NOT NULL,
    ciudad VARCHAR(80),
    pais VARCHAR(50) DEFAULT 'Argentina',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    fecha_nacimiento DATE,
    INDEX idx_email (email),
    INDEX idx_ciudad (ciudad)
);

-- ==============================================
-- TABLA PRODUCTOS
-- ==============================================
CREATE TABLE productos (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    categoria VARCHAR(50),
    marca VARCHAR(80),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('disponible', 'descontinuado', 'agotado') DEFAULT 'disponible',
    peso DECIMAL(8,2), -- en kg
    INDEX idx_categoria (categoria),
    INDEX idx_precio (precio),
    INDEX idx_marca (marca),
    CHECK (precio >= 0),
    CHECK (stock >= 0)
);

-- ==============================================
-- TABLA COMPRAS
-- ==============================================
CREATE TABLE compras (
    compra_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10,2) NOT NULL,
    monto_total DECIMAL(12,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    metodo_pago ENUM('efectivo', 'tarjeta_credito', 'tarjeta_debito', 'transferencia') NOT NULL,
    estado_compra ENUM('pendiente', 'completada', 'cancelada', 'reembolsada') DEFAULT 'completada',
    descuento DECIMAL(5,2) DEFAULT 0.00, -- porcentaje de descuento
    notas TEXT,
    
    -- Claves foráneas
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(producto_id) ON DELETE RESTRICT,
    
    -- Índices
    INDEX idx_cliente_fecha (cliente_id, fecha_compra),
    INDEX idx_producto (producto_id),
    INDEX idx_fecha (fecha_compra),
    INDEX idx_estado (estado_compra),
    
    -- Restricciones
    CHECK (cantidad > 0),
    CHECK (precio_unitario >= 0),
    CHECK (descuento >= 0 AND descuento <= 100)
);

-- ==============================================
-- INSERTAR DATOS DE EJEMPLO
-- ==============================================

-- Clientes
INSERT INTO clientes (nombre, apellido, email, telefono, fecha_registro, ciudad, fecha_nacimiento) VALUES
('Juan', 'Pérez', 'juan.perez@email.com', '+54-362-123456', '2023-01-15', 'Resistencia', '1985-03-20'),
('María', 'González', 'maria.gonzalez@email.com', '+54-362-234567', '2023-02-20', 'Corrientes', '1990-07-12'),
('Carlos', 'López', 'carlos.lopez@email.com', '+54-362-345678', '2023-03-10', 'Resistencia', '1988-11-05'),
('Ana', 'Martínez', 'ana.martinez@email.com', '+54-362-456789', '2023-04-05', 'Formosa', '1992-02-28'),
('Luis', 'Rodríguez', 'luis.rodriguez@email.com', '+54-362-567890', '2023-05-12', 'Resistencia', '1987-09-15'),
('Laura', 'García', 'laura.garcia@email.com', '+54-362-678901', '2023-06-08', 'Corrientes', '1991-12-03'),
('Pedro', 'Silva', 'pedro.silva@email.com', '+54-362-789012', '2023-07-22', 'Resistencia', '1989-04-18'),
('Sofia', 'Torres', 'sofia.torres@email.com', '+54-362-890123', '2023-08-14', 'Formosa', '1993-08-25');

-- Productos
INSERT INTO productos (nombre, descripcion, precio, stock, categoria, marca, peso) VALUES
('Smartphone Samsung Galaxy A54', 'Teléfono inteligente con pantalla AMOLED de 6.4 pulgadas', 89999.00, 25, 'Electrónicos', 'Samsung', 0.2),
('Notebook Lenovo ThinkPad E14', 'Laptop empresarial con procesador Intel i5, 8GB RAM, 256GB SSD', 125000.00, 15, 'Computación', 'Lenovo', 1.6),
('Auriculares Sony WH-1000XM4', 'Auriculares inalámbricos con cancelación de ruido', 45000.00, 30, 'Audio', 'Sony', 0.25),
('Televisor LG 55 Smart TV', 'Smart TV 4K UHD de 55 pulgadas con WebOS', 89000.00, 12, 'Electrónicos', 'LG', 15.2),
('Cafetera Nespresso Essenza Mini', 'Cafetera de cápsulas compacta', 18500.00, 40, 'Hogar', 'Nespresso', 2.3),
('Bicicleta Mountain Bike Rodado 29', 'Bicicleta todo terreno con 21 velocidades', 78000.00, 8, 'Deportes', 'Trek', 14.5),
('Reloj Apple Watch Series 8', 'Smartwatch con GPS y monitoreo de salud', 95000.00, 20, 'Wearables', 'Apple', 0.05),
('Aspiradora Robot Roomba i3+', 'Robot aspirador inteligente con vaciado automático', 125000.00, 10, 'Hogar', 'iRobot', 3.4),
('Cámara Canon EOS M50 Mark II', 'Cámara mirrorless para fotografía y video', 110000.00, 18, 'Fotografía', 'Canon', 0.39),
('Tablet iPad Air 10.9', 'Tablet con chip M1 y pantalla Liquid Retina', 135000.00, 22, 'Electrónicos', 'Apple', 0.46);

-- Compras (distribuidas a lo largo del tiempo)
INSERT INTO compras (cliente_id, producto_id, fecha_compra, cantidad, precio_unitario, metodo_pago, descuento) VALUES
-- Enero 2024
(1, 1, '2024-01-10 10:30:00', 1, 89999.00, 'tarjeta_credito', 5.00),
(2, 3, '2024-01-15 14:20:00', 2, 45000.00, 'transferencia', 0.00),
(3, 5, '2024-01-20 09:15:00', 1, 18500.00, 'efectivo', 10.00),

-- Febrero 2024
(1, 7, '2024-02-05 16:45:00', 1, 95000.00, 'tarjeta_credito', 0.00),
(4, 2, '2024-02-12 11:30:00', 1, 125000.00, 'transferencia', 8.00),
(2, 6, '2024-02-18 13:20:00', 1, 78000.00, 'tarjeta_debito', 0.00),
(5, 4, '2024-02-25 15:10:00', 1, 89000.00, 'tarjeta_credito', 5.00),

-- Marzo 2024
(3, 9, '2024-03-08 12:00:00', 1, 110000.00, 'transferencia', 0.00),
(6, 1, '2024-03-15 10:45:00', 1, 89999.00, 'tarjeta_credito', 3.00),
(1, 3, '2024-03-22 14:30:00', 1, 45000.00, 'efectivo', 0.00),
(7, 8, '2024-03-28 16:20:00', 1, 125000.00, 'transferencia', 10.00),

-- Abril 2024
(4, 10, '2024-04-05 09:30:00', 1, 135000.00, 'tarjeta_credito', 0.00),
(8, 5, '2024-04-12 11:15:00', 2, 18500.00, 'efectivo', 15.00),
(2, 7, '2024-04-20 13:45:00', 1, 95000.00, 'tarjeta_debito', 0.00),
(5, 9, '2024-04-26 15:30:00', 1, 110000.00, 'transferencia', 5.00),

-- Mayo 2024
(3, 4, '2024-05-10 10:20:00', 1, 89000.00, 'tarjeta_credito', 0.00),
(6, 6, '2024-05-18 14:10:00', 1, 78000.00, 'efectivo', 8.00),
(1, 2, '2024-05-25 16:40:00', 1, 125000.00, 'transferencia', 12.00),

-- Junio 2024
(7, 10, '2024-06-08 12:30:00', 1, 135000.00, 'tarjeta_credito', 0.00),
(8, 3, '2024-06-15 09:45:00', 1, 45000.00, 'tarjeta_debito', 0.00),
(4, 1, '2024-06-22 11:20:00', 1, 89999.00, 'efectivo', 5.00);

-- Mayo 2025
(1, 2, '2025-05-15 14:30:00', 1, 125000.00, 'tarjeta_credito', 8.00),
(3, 7, '2025-05-18 11:20:00', 1, 95000.00, 'transferencia', 0.00),
(5, 4, '2025-05-22 16:45:00', 1, 89000.00, 'efectivo', 5.00),
(2, 9, '2025-05-25 10:15:00', 1, 110000.00, 'tarjeta_debito', 0.00),
(7, 1, '2025-05-28 13:30:00', 1, 89999.00, 'tarjeta_credito', 3.00),

-- Junio 2025
(4, 5, '2025-06-02 09:45:00', 3, 18500.00, 'efectivo', 12.00),
(6, 8, '2025-06-05 15:20:00', 1, 125000.00, 'transferencia', 10.00),
(1, 6, '2025-06-08 12:10:00', 1, 78000.00, 'tarjeta_credito', 0.00),
(8, 3, '2025-06-12 17:30:00', 2, 45000.00, 'tarjeta_debito', 5.00),
(2, 10, '2025-06-15 11:45:00', 1, 135000.00, 'transferencia', 0.00),
(3, 4, '2025-06-18 14:20:00', 1, 89000.00, 'efectivo', 8.00),
(5, 7, '2025-06-22 16:00:00', 1, 95000.00, 'tarjeta_credito', 0.00),
(7, 2, '2025-06-25 10:30:00', 1, 125000.00, 'transferencia', 15.00),
(4, 9, '2025-06-28 13:15:00', 1, 110000.00, 'tarjeta_debito', 0.00),

-- Julio 2025
(6, 1, '2025-07-02 09:20:00', 1, 89999.00, 'efectivo', 7.00),
(1, 5, '2025-07-05 15:40:00', 2, 18500.00, 'tarjeta_credito', 0.00),
(8, 6, '2025-07-08 12:25:00', 1, 78000.00, 'transferencia', 10.00),
(3, 8, '2025-07-12 16:50:00', 1, 125000.00, 'tarjeta_debito', 8.00),
(2, 7, '2025-07-15 11:10:00', 1, 95000.00, 'efectivo', 0.00),
(5, 10, '2025-07-18 14:35:00', 1, 135000.00, 'tarjeta_credito', 5.00),
(7, 3, '2025-07-22 10:45:00', 1, 45000.00, 'transferencia', 0.00),
(4, 1, '2025-07-25 17:20:00', 1, 89999.00, 'tarjeta_debito', 12.00),
(6, 9, '2025-07-28 13:30:00', 1, 110000.00, 'efectivo', 0.00),
(8, 4, '2025-07-30 15:15:00', 1, 89000.00, 'tarjeta_credito', 6.00),

-- Agosto 2025 (hasta hoy 09/08)
(1, 8, '2025-08-02 10:20:00', 1, 125000.00, 'transferencia', 0.00),
(3, 2, '2025-08-04 14:40:00', 1, 125000.00, 'tarjeta_credito', 10.00),
(2, 6, '2025-08-06 11:30:00', 1, 78000.00, 'efectivo', 0.00),
(5, 1, '2025-08-08 16:25:00', 1, 89999.00, 'tarjeta_debito', 4.00),
(7, 5, '2025-08-09 09:45:00', 2, 18500.00, 'transferencia', 8.00);

-- ==============================================
-- CONSULTAS ÚTILES DE EJEMPLO
-- ==============================================

-- 1. Total de ventas por cliente con información personal
SELECT 
    c.cliente_id,
    CONCAT(c.nombre, ' ', c.apellido) AS cliente,
    c.ciudad,
    COUNT(co.compra_id) AS total_compras,
    SUM(co.monto_total) AS total_gastado,
    AVG(co.monto_total) AS promedio_compra,
    MAX(co.fecha_compra) AS ultima_compra
FROM clientes c
LEFT JOIN compras co ON c.cliente_id = co.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido, c.ciudad
ORDER BY total_gastado DESC;

-- 2. Productos más vendidos
SELECT 
    p.producto_id,
    p.nombre,
    p.categoria,
    p.marca,
    COUNT(co.compra_id) AS veces_vendido,
    SUM(co.cantidad) AS unidades_vendidas,
    SUM(co.monto_total) AS ingresos_totales
FROM productos p
LEFT JOIN compras co ON p.producto_id = co.producto_id
GROUP BY p.producto_id, p.nombre, p.categoria, p.marca
ORDER BY unidades_vendidas DESC;

-- 3. Análisis de compras con función de ventana (similar a tu consulta original)
SELECT 
    co.cliente_id,
    CONCAT(cl.nombre, ' ', cl.apellido) AS cliente,
    co.fecha_compra,
    p.nombre AS producto,
    co.monto_total as monto,
    SUM(co.monto_total) OVER (
        PARTITION BY co.cliente_id 
        ORDER BY co.fecha_compra
        ROWS UNBOUNDED PRECEDING
    ) AS total_acumulado,
    LAG(co.fecha_compra) OVER (
        PARTITION BY co.cliente_id 
        ORDER BY co.fecha_compra
    ) AS compra_anterior,
    DATEDIFF(
        co.fecha_compra, 
        LAG(co.fecha_compra) OVER (
            PARTITION BY co.cliente_id 
            ORDER BY co.fecha_compra
        )
    ) AS dias_desde_ultima
FROM compras co
JOIN clientes cl ON co.cliente_id = cl.cliente_id
JOIN productos p ON co.producto_id = p.producto_id
WHERE co.estado_compra = 'completada'
ORDER BY co.cliente_id, co.fecha_compra;

-- 4. Ventas por mes y categoría
SELECT 
    DATE_FORMAT(co.fecha_compra, '%Y-%m') AS mes,
    p.categoria,
    COUNT(co.compra_id) AS total_ventas,
    SUM(co.cantidad) AS unidades_vendidas,
    SUM(co.monto_total) AS ingresos
FROM compras co
JOIN productos p ON co.producto_id = p.producto_id
WHERE co.estado_compra = 'completada'
GROUP BY DATE_FORMAT(co.fecha_compra, '%Y-%m'), p.categoria
ORDER BY mes DESC, ingresos DESC;

-- 5. Clientes por ciudad y su actividad
SELECT 
    cl.ciudad,
    COUNT(DISTINCT cl.cliente_id) AS total_clientes,
    COUNT(co.compra_id) AS total_compras,
    COALESCE(SUM(co.monto_total), 0) AS ingresos_ciudad,
    COALESCE(AVG(co.monto_total), 0) AS promedio_compra_ciudad
FROM clientes cl
LEFT JOIN compras co ON cl.cliente_id = co.cliente_id AND co.estado_compra = 'completada'
GROUP BY cl.ciudad
ORDER BY ingresos_ciudad DESC;