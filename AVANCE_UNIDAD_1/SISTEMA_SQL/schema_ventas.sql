-- ============================================================
-- TECHSTORE - MODELO RELACIONAL (PostgreSQL)
-- Base de Datos: techstore_ale
-- Descripción: Sistema transaccional de ventas, clientes y sucursales
-- ============================================================

-- ============================================================
-- TABLA: clientes
-- Descripción: Almacena información de clientes (personas y empresas)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.clientes
(
    id_cliente SERIAL PRIMARY KEY,
    tipo_cliente VARCHAR(10) CHECK (tipo_cliente IN ('PERSONA', 'EMPRESA')),
    cedula_ruc VARCHAR(13) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100),
    razon_social VARCHAR(200),
    email VARCHAR(150),
    telefono VARCHAR(20),
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    direccion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE public.clientes 
    IS 'Almacena información de clientes personas y empresas de TechStore';

-- ============================================================
-- TABLA: sucursales
-- Descripción: Ubicaciones físicas de TechStore
-- ============================================================

CREATE TABLE IF NOT EXISTS public.sucursales
(
    id_sucursal SERIAL PRIMARY KEY,
    nombre_sucursal VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    provincia VARCHAR(100),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(150),
    gerente VARCHAR(100),
    fecha_apertura DATE,
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE public.sucursales 
    IS 'Sucursales y ubicaciones físicas de TechStore';

-- ============================================================
-- TABLA: empleados
-- Descripción: Personal de TechStore asignado a sucursales
-- ============================================================

CREATE TABLE IF NOT EXISTS public.empleados
(
    id_empleado SERIAL PRIMARY KEY,
    id_sucursal INTEGER REFERENCES sucursales(id_sucursal),
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    cedula VARCHAR(10) UNIQUE NOT NULL,
    cargo VARCHAR(100),
    email VARCHAR(150),
    telefono VARCHAR(20),
    fecha_ingreso DATE,
    salario NUMERIC(10,2),
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE public.empleados 
    IS 'Empleados de TechStore asignados a sucursales';

-- ============================================================
-- TABLA: categorias_ref
-- Descripción: Tabla de referencia que vincula categorías SQL con MongoDB
-- ============================================================

CREATE TABLE IF NOT EXISTS public.categorias_ref
(
    id_categoria_ref SERIAL PRIMARY KEY,
    id_categoria_mongo VARCHAR(24) NOT NULL,
    nombre_categoria VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_sincronizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT categorias_ref_id_categoria_mongo_key UNIQUE (id_categoria_mongo)
);

COMMENT ON TABLE public.categorias_ref 
    IS 'Referencia sincronizada con categorías de MongoDB';

-- ============================================================
-- TABLA: ventas
-- Descripción: Encabezado de facturas de venta
-- ============================================================

CREATE TABLE IF NOT EXISTS public.ventas
(
    id_venta SERIAL PRIMARY KEY,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    id_sucursal INTEGER REFERENCES sucursales(id_sucursal),
    id_empleado INTEGER REFERENCES empleados(id_empleado),
    fecha_venta TIMESTAMP NOT NULL,
    subtotal NUMERIC(12,2),
    descuento_general NUMERIC(12,2) DEFAULT 0,
    impuesto_iva NUMERIC(12,2),
    total_venta NUMERIC(12,2) NOT NULL,
    metodo_pago VARCHAR(50),
    estado_pago VARCHAR(20) CHECK (estado_pago IN ('PAGADO','PENDIENTE','PARCIAL','ANULADO')),
    estado_venta VARCHAR(20) CHECK (estado_venta IN ('COMPLETADA','PENDIENTE','ENVIADA','ENTREGADA','ANULADA','DEVUELTA')),
    tipo_venta VARCHAR(20) CHECK (tipo_venta IN ('TIENDA','ONLINE','TELEFONICA')),
    es_factura_electronica BOOLEAN DEFAULT TRUE,
    numero_autorizacion_sri VARCHAR(100),
    fecha_autorizacion_sri TIMESTAMP,
    clave_acceso VARCHAR(49),
    observaciones TEXT
);

COMMENT ON TABLE public.ventas 
    IS 'Encabezado de facturas de venta con información transaccional';

-- ============================================================
-- TABLA: detalle_ventas
-- Descripción: Líneas de detalle de cada venta (vinculación con MongoDB)
-- ============================================================

CREATE TABLE IF NOT EXISTS public.detalle_ventas
(
    id_detalle SERIAL PRIMARY KEY,
    id_venta INTEGER REFERENCES ventas(id_venta) ON DELETE CASCADE,
    id_producto_mongo VARCHAR(24) NOT NULL,
    nombre_producto VARCHAR(300),
    id_categoria_ref INTEGER REFERENCES categorias_ref(id_categoria_ref),
    sku VARCHAR(50),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    descuento_linea NUMERIC(12,2) DEFAULT 0 CHECK (descuento_linea >= 0),
    subtotal_linea NUMERIC(12,2) NOT NULL,
    impuesto_linea NUMERIC(12,2),
    total_linea NUMERIC(12,2) NOT NULL,
    garantia_meses INTEGER,
    estado_producto VARCHAR(50),
    numero_serie VARCHAR(100)
);

COMMENT ON TABLE public.detalle_ventas 
    IS 'Detalles de productos vendidos con vinculación a MongoDB';

COMMENT ON COLUMN public.detalle_ventas.id_producto_mongo 
    IS 'ObjectId de MongoDB que referencia la colección productos';

-- ============================================================
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX IF NOT EXISTS idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX IF NOT EXISTS idx_ventas_sucursal ON ventas(id_sucursal);
CREATE INDEX IF NOT EXISTS idx_detalle_venta ON detalle_ventas(id_venta);
CREATE INDEX IF NOT EXISTS idx_detalle_producto_mongo ON detalle_ventas(id_producto_mongo);
CREATE INDEX IF NOT EXISTS idx_detalle_sku ON detalle_ventas(sku);

-- ============================================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================================

-- Ver todas las tablas creadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- Ver estructura de una tabla específica
SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'ventas'
ORDER BY ordinal_position;