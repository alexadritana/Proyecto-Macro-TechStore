# INFORME UNIDAD 1: Modelado de Sistemas Operacionales (OLTP)
## Proyecto: Solución de Business Intelligence para "TechStore"

---

**Estudiante:** Alexandra Tana  
**Fecha:** Noviembre 2024  
**Asignatura:** Modelado avanzado de Base de Datos  
**Unidad:** 1 - Fundamentos de Almacenamiento de Datos

---

## 📑 TABLA DE CONTENIDOS

1. [Introducción](#1-introducción)
2. [Contexto del Caso de Estudio](#2-contexto-del-caso-de-estudio)
3. [Sistema NoSQL - MongoDB](#3-sistema-nosql---mongodb)
4. [Sistema Relacional - PostgreSQL](#4-sistema-relacional---postgresql)
5. [Justificación del Modelo Dual](#5-justificación-del-modelo-dual)
6. [Vinculación SQL ↔ NoSQL](#6-vinculación-sql--nosql)
7. [Análisis de Calidad de Datos](#7-análisis-de-calidad-de-datos)
8. [Validación y Resultados](#8-validación-y-resultados)
9. [Conclusiones](#9-conclusiones)
10. [Referencias](#10-referencias)

---

## 1. INTRODUCCIÓN

Este informe documenta el primer avance del proyecto de Business Intelligence para **TechStore**, una cadena minorista de tecnología en expansión. El enfoque de esta unidad se centra en el diseño e implementación de los sistemas operacionales (OLTP) que servirán como fuentes de datos para el futuro Data Mart de Ventas.

### 1.1 Objetivos del Avance

- ✅ Implementar un sistema NoSQL (MongoDB) para el catálogo de productos
- ✅ Diseñar e implementar un sistema SQL (PostgreSQL) para transacciones de ventas
- ✅ Establecer la vinculación entre ambos sistemas
- ✅ Validar la integridad y calidad de los datos
- ✅ Documentar decisiones de diseño y arquitectura

### 1.2 Alcance

Este avance cubre únicamente los **sistemas operacionales (OLTP)**. Los procesos de ETL, construcción del Data Warehouse y análisis OLAP serán desarrollados en unidades posteriores.

---

## 2. CONTEXTO DEL CASO DE ESTUDIO

### 2.1 Problemática

**TechStore** enfrenta los siguientes desafíos:

- **Datos en silos:** Información fragmentada entre sistemas dispares
- **Falta de visibilidad:** Imposibilidad de responder preguntas básicas de negocio
- **Decisiones sin datos:** La gerencia no cuenta con información consolidada

### 2.2 Preguntas de Negocio sin Respuesta

- ¿Cuál es nuestro producto más vendido en la sucursal de Quito?
- ¿Cómo ha sido la tendencia de ventas de Smartphones en el último trimestre?
- ¿Qué categorías generan mayor rentabilidad?
- ¿Cuál es el perfil de compra de nuestros clientes corporativos vs. individuales?

### 2.3 Solución Propuesta

Implementar una arquitectura dual que aproveche:
- **NoSQL (MongoDB):** Para gestionar el catálogo de productos con atributos flexibles
- **SQL (PostgreSQL):** Para gestionar transacciones de ventas con integridad ACID

---

## 3. SISTEMA NoSQL - MONGODB

### 3.1 Justificación del Uso de MongoDB

**MongoDB** fue seleccionado para el catálogo de productos por las siguientes razones:

1. **Flexibilidad de esquema:** Permite que diferentes categorías de productos tengan especificaciones técnicas distintas
2. **Documentos anidados:** Las especificaciones técnicas se almacenan como subdocumentos JSON
3. **Escalabilidad horizontal:** Preparado para crecimiento futuro del catálogo
4. **Consultas rápidas:** Índices eficientes para búsquedas por categoría, marca, precio

### 3.2 Arquitectura de Base de Datos

**Plataforma:** MongoDB Atlas (Cloud)  
**Base de datos:** `techstore_db`  
**Colecciones:** 2 (`categorias`, `productos`)

### 3.3 Colección: `categorias`

**Descripción:** Almacena las categorías de productos disponibles en TechStore.

**Estructura del documento:**

```json
{
  "_id": ObjectId("673f5a1b2c4e8f1a2b3c4d5e"),
  "nombre": "Smartphones",
  "descripcion": "Teléfonos inteligentes de última generación",
  "slug": "smartphones",
  "activo": true,
  "fecha_creacion": ISODate("2024-11-03T03:25:55.111Z"),
  "orden": 1,
  "imagen_url": "https://example.com/categorias/smartphones.jpg"
}
```

**Categorías registradas:** 6
- Smartphones
- Laptops
- Tablets
- Auriculares
- Smartwatches
- Accesorios

### 3.4 Colección: `productos`

**Descripción:** Catálogo completo de productos con especificaciones técnicas detalladas.

**Estructura del documento:**

```json
{
  "_id": ObjectId("673f5b1a2c4e8f1a2b3c4d64"),
  "sku": "SM-IPHON-15PRO-256-BLK",
  "nombre": "iPhone 15 Pro",
  "descripcion": "Smartphone premium con chip A17 Pro",
  "categoria_id": ObjectId("673f5a1b2c4e8f1a2b3c4d5e"),
  "categoria_nombre": "Smartphones",
  "marca": "Apple",
  "modelo": "iPhone 15 Pro",
  "precio_base": 1299.99,
  "precio_venta": 1299.99,
  "stock": 45,
  "estado": "ACTIVO",
  "especificaciones": {
    "pantalla": {
      "tamaño": "6.1 pulgadas",
      "tipo": "Super Retina XDR OLED",
      "resolucion": "2556 x 1179 px"
    },
    "procesador": {
      "chip": "Apple A17 Pro",
      "nucleos": "6 núcleos"
    },
    "memoria": {
      "ram": "8GB",
      "almacenamiento": "256GB"
    }
  },
  "colores_disponibles": ["Negro Titanio", "Blanco Titanio"],
  "garantia_meses": 12,
  "proveedor": "Apple Inc.",
  "fecha_ingreso": ISODate("2024-10-05T00:00:00.000Z"),
  "puntuacion_promedio": 4.8,
  "numero_resenas": 234
}
```

**Productos registrados:** 7

| SKU | Producto | Categoría | Precio |
|-----|----------|-----------|--------|
| SM-IPHON-15PRO-256-BLK | iPhone 15 Pro | Smartphones | $1,299.99 |
| SM-SAM-S24-128-BLK | Samsung Galaxy S24 | Smartphones | $849.99 |
| LAP-MBPRO-M3-16-512-SLV | MacBook Pro 14" M3 | Laptops | $2,199.99 |
| LAP-DELL-XPS15-I7-16-512 | Dell XPS 15 | Laptops | $1,799.99 |
| TAB-IPADPRO-M2-11-256-GRAY | iPad Pro 11" M2 | Tablets | $999.99 |
| AUR-SONY-WH1000XM5-BLK | Sony WH-1000XM5 | Auriculares | $379.99 |
| SW-APPLEWATCH-S9-45-ALU-MID | Apple Watch S9 | Smartwatches | $429.99 |

### 3.5 Ventajas del Modelo NoSQL

✅ **Flexibilidad:** Cada categoría puede tener especificaciones únicas  
✅ **Rendimiento:** Consultas rápidas sin JOINs  
✅ **Escalabilidad:** Fácil distribución horizontal  
✅ **Agilidad:** Cambios de esquema sin migraciones complejas

---

## 4. SISTEMA RELACIONAL - POSTGRESQL

### 4.1 Justificación del Uso de PostgreSQL

**PostgreSQL** fue seleccionado para el sistema transaccional por:

1. **Propiedades ACID:** Garantiza consistencia en las transacciones
2. **Integridad referencial:** FOREIGN KEYS aseguran relaciones válidas
3. **Transacciones complejas:** Soporte para rollback y commit
4. **Madurez:** Sistema probado para aplicaciones críticas de negocio
5. **Cumplimiento normativo:** Auditoría y trazabilidad de transacciones

### 4.2 Modelo Entidad-Relación (DER)

**Base de datos:** `techstore_ale`  
**SGBD:** PostgreSQL 17  
**Herramienta:** pgAdmin 4

### 4.3 Tablas del Sistema

#### 4.3.1 Tabla: `clientes`

**Descripción:** Almacena información de clientes personas y empresas.

```sql
CREATE TABLE clientes (
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
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Registros:** 20 (17 personas + 3 empresas)

#### 4.3.2 Tabla: `sucursales`

**Descripción:** Ubicaciones físicas de TechStore.

```sql
CREATE TABLE sucursales (
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
```

**Registros:** 5 sucursales
- TechStore Quito Centro
- TechStore Quito Norte  
- TechStore Cuenca
- TechStore Ambato
- TechStore Guayaquil

#### 4.3.3 Tabla: `empleados`

**Descripción:** Personal asignado a sucursales.

```sql
CREATE TABLE empleados (
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
```

#### 4.3.4 Tabla: `categorias_ref`

**Descripción:** Tabla de referencia que vincula categorías SQL con MongoDB.

```sql
CREATE TABLE categorias_ref (
    id_categoria_ref SERIAL PRIMARY KEY,
    id_categoria_mongo VARCHAR(24) NOT NULL,
    nombre_categoria VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_sincronizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Mapeo SQL ↔ NoSQL:**

| id_categoria_ref | id_categoria_mongo | nombre_categoria |
|------------------|-------------------|------------------|
| 37 | 673f5a1b2c4e8f1a2b3c4d5e | Smartphones |
| 38 | 673f5a1b2c4e8f1a2b3c4d5f | Laptops |
| 39 | 673f5a1b2c4e8f1a2b3c4d60 | Tablets |
| 40 | 673f5a1b2c4e8f1a2b3c4d61 | Auriculares |
| 41 | 673f5a1b2c4e8f1a2b3c4d62 | Smartwatches |
| 42 | 673f5a1b2c4e8f1a2b3c4d63 | Accesorios |

#### 4.3.5 Tabla: `ventas`

**Descripción:** Encabezado de facturas de venta.

```sql
CREATE TABLE ventas (
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
    clave_acceso VARCHAR(49)
);
```

**Registros:** 30 ventas (período Sep-Nov 2024)

#### 4.3.6 Tabla: `detalle_ventas`

**Descripción:** Líneas de detalle de cada venta (vinculación con MongoDB).

```sql
CREATE TABLE detalle_ventas (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INTEGER REFERENCES ventas(id_venta),
    id_producto_mongo VARCHAR(24) NOT NULL,  -- ObjectId de MongoDB
    nombre_producto VARCHAR(300),
    id_categoria_ref INTEGER REFERENCES categorias_ref(id_categoria_ref),
    sku VARCHAR(50),
    cantidad INTEGER NOT NULL,
    precio_unitario NUMERIC(12,2) NOT NULL,
    descuento_linea NUMERIC(12,2) DEFAULT 0,
    subtotal_linea NUMERIC(12,2) NOT NULL,
    impuesto_linea NUMERIC(12,2),
    total_linea NUMERIC(12,2) NOT NULL,
    garantia_meses INTEGER,
    estado_producto VARCHAR(50),
    numero_serie VARCHAR(100)
);
```

**Registros:** 7 líneas de detalle (5 ventas con productos)

---

## 5. JUSTIFICACIÓN DEL MODELO DUAL

### 5.1 ¿Por qué SQL para Ventas?

**PostgreSQL** es ideal para el sistema transaccional por:

| Característica | Beneficio para Ventas |
|----------------|----------------------|
| **ACID Compliance** | Garantiza que cada venta se registre completamente o no se registre (atomicidad) |
| **Integridad Referencial** | Asegura que cada venta tenga un cliente, sucursal y empleado válidos |
| **Transacciones** | Permite rollback si hay errores durante el proceso de venta |
| **Consistencia** | Los totales siempre coinciden con los detalles |
| **Auditoría** | Historial completo de cambios y transacciones |
| **Normalización** | Elimina redundancia de datos (DRY - Don't Repeat Yourself) |

**Ejemplo práctico:**

```sql
-- Si falla la inserción del detalle, toda la venta se revierte
BEGIN TRANSACTION;
    INSERT INTO ventas (...) VALUES (...);
    INSERT INTO detalle_ventas (...) VALUES (...);
COMMIT;
```

### 5.2 ¿Por qué NoSQL para Productos?

**MongoDB** es ideal para el catálogo de productos por:

| Característica | Beneficio para Productos |
|----------------|-------------------------|
| **Esquema Flexible** | Cada categoría tiene especificaciones distintas (smartphone ≠ laptop) |
| **Documentos Anidados** | Especificaciones técnicas organizadas jerárquicamente |
| **Sin JOINs** | Consultas rápidas: un solo documento contiene toda la info del producto |
| **Evolución rápida** | Agregar nuevos atributos sin migraciones SQL |
| **Arrays nativos** | Colores, imágenes, tags se almacenan naturalmente |

**Ejemplo práctico:**

Un **Smartphone** tiene especificaciones como:
- Pantalla (tamaño, tipo, resolución, tasa de refresco)
- Procesador (chip, núcleos, arquitectura)
- Cámaras (principal, ultra angular, telefoto, frontal)
- Batería (capacidad, carga rápida, autonomía)

Una **Laptop** tiene especificaciones totalmente diferentes:
- Pantalla (tamaño, tipo, resolución)
- Procesador (generación, núcleos, velocidad)
- Tarjeta gráfica (GPU, VRAM)
- Puertos (Thunderbolt, USB-C, HDMI)

En SQL, esto requeriría múltiples tablas y JOINs complejos. En MongoDB, cada producto es un documento autocontenido.

### 5.3 Comparativa de Enfoques

| Aspecto | SQL (Ventas) | NoSQL (Productos) |
|---------|--------------|-------------------|
| **Estructura** | Rígida, predefinida | Flexible, adaptable |
| **Relaciones** | FOREIGN KEYS obligatorias | Referencias opcionales |
| **Consultas** | JOINs complejos | Documentos completos |
| **Transacciones** | ACID nativo | Eventual consistency |
| **Escalabilidad** | Vertical (más potente) | Horizontal (más nodos) |
| **Cambios de esquema** | Migraciones complejas | Instantáneos |
| **Uso ideal** | Transacciones críticas | Datos semi-estructurados |

---

## 6. VINCULACIÓN SQL ↔ NoSQL

### 6.1 Estrategia de Integración

La vinculación entre ambos sistemas se logra mediante **claves de referencia**:

```
PostgreSQL (detalle_ventas)          MongoDB (productos)
┌───────────────────────────┐        ┌──────────────────────┐
│ id_producto_mongo         │───────>│ _id (ObjectId)       │
│ "673f5b1a2c4e8f1a2b3c4d64"│        │ ObjectId("673f...")  │
│ sku: "SM-IPHON-15PRO..."  │        │ sku: "SM-IPHON..."   │
└───────────────────────────┘        └──────────────────────┘
```

### 6.2 Campos de Vinculación

En la tabla `detalle_ventas`:

- **`id_producto_mongo`** (VARCHAR(24)): Almacena el ObjectId de MongoDB
- **`sku`** (VARCHAR(50)): Clave alternativa para búsquedas
- **`id_categoria_ref`** (INTEGER): FK a tabla puente `categorias_ref`

### 6.3 Flujo de Consulta Integrada

Para obtener información completa de una venta:

1. **SQL:** Consultar `ventas` y `detalle_ventas`
2. **Obtener** `id_producto_mongo` y `sku`
3. **MongoDB:** Buscar producto por `_id` o `sku`
4. **Consolidar:** Combinar datos en la capa de aplicación

**Ejemplo de consulta SQL:**

```sql
SELECT 
    v.numero_factura,
    v.fecha_venta,
    dv.sku,
    dv.nombre_producto,
    dv.id_producto_mongo,
    dv.cantidad,
    dv.precio_unitario,
    dv.total_linea,
    cr.nombre_categoria
FROM ventas v
JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
JOIN categorias_ref cr ON dv.id_categoria_ref = cr.id_categoria_ref
WHERE v.fecha_venta >= '2024-11-01';
```

**Ejemplo de consulta MongoDB:**

```javascript
db.productos.find({
  "_id": ObjectId("673f5b1a2c4e8f1a2b3c4d64")
}, {
  nombre: 1,
  especificaciones: 1,
  garantia_meses: 1,
  proveedor: 1
})
```

### 6.4 Ventajas de esta Arquitectura

✅ **Separación de responsabilidades:** Cada sistema hace lo que mejor sabe hacer  
✅ **Escalabilidad independiente:** SQL y NoSQL pueden escalar por separado  
✅ **Resiliencia:** Si MongoDB falla, las ventas siguen registrándose con SKU  
✅ **Flexibilidad:** Cambios en catálogo no afectan sistema transaccional

---

## 7. ANÁLISIS DE CALIDAD DE DATOS

### 7.1 Problema 1: Inconsistencia de SKU entre SQL y NoSQL

#### **Descripción del Problema**

Un registro en `detalle_ventas` podría contener un `sku` que no existe en la colección `productos` de MongoDB.

**Escenario de error:**
```sql
INSERT INTO detalle_ventas (id_venta, sku, id_producto_mongo, ...)
VALUES (100, 'PROD-INEXISTENTE', '000000000000000000000000', ...);
```

#### **Impacto en el Negocio**

- ❌ **Ventas huérfanas:** Transacciones sin información del producto vendido
- ❌ **Reportes incorrectos:** Análisis de ventas por producto incompleto
- ❌ **Problemas de inventario:** Imposible actualizar stock si el producto no existe
- ❌ **Pérdida de confianza:** Datos inconsistentes en reportes gerenciales

#### **Causas Potenciales**

1. Producto eliminado de MongoDB pero referenciado en ventas antiguas
2. Error manual al ingresar SKU en el sistema de ventas
3. Falta de sincronización entre sistemas
4. Productos descontinuados no marcados correctamente

#### **Soluciones Propuestas**

**Solución 1: Validación antes de insertar (Preventiva)**

```javascript
// En la aplicación, antes de insertar en SQL
const producto = await db.productos.findOne({ sku: skuVenta });
if (!producto) {
    throw new Error(`Producto con SKU ${skuVenta} no existe`);
}
```

**Solución 2: Hacer email obligatorio para nuevos registros**

```sql
-- Modificar la tabla para hacer email NOT NULL
ALTER TABLE clientes 
ALTER COLUMN email SET NOT NULL;

-- Para registros antiguos sin email, crear un proceso de actualización
UPDATE clientes 
SET email = 'noemail+' || id_cliente || '@techstore.ec'
WHERE email IS NULL;
```

**Solución 3: Validación en la capa de aplicación**

```javascript
function validarEmail(email) {
    const regex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$/;
    
    if (!email || email.trim() === '') {
        throw new Error('Email es obligatorio');
    }
    
    if (!regex.test(email)) {
        throw new Error('Formato de email inválido');
    }
    
    return email.toLowerCase().trim();
}

// Uso en formulario
const emailValidado = validarEmail(formData.email);
```

**Solución 4: Proceso de limpieza de datos**

```sql
-- 1. Identificar registros con emails problemáticos
SELECT 
    id_cliente,
    nombre,
    email,
    CASE 
        WHEN email IS NULL THEN 'Email vacío'
        WHEN email NOT LIKE '%@%' THEN 'Sin arroba'
        WHEN email NOT LIKE '%.%' THEN 'Sin dominio'
        ELSE 'Email sospechoso'
    END as problema
FROM clientes
WHERE 
    email IS NULL 
    OR email NOT ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}: Trigger en PostgreSQL (Reactiva)**

```sql
CREATE OR REPLACE FUNCTION validar_producto_existe()
RETURNS TRIGGER AS $$
BEGIN
    -- Aquí se haría una llamada a un servicio externo
    -- que verifique en MongoDB
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_detalle
BEFORE INSERT ON detalle_ventas
FOR EACH ROW EXECUTE FUNCTION validar_producto_existe();
```

**Solución 3: Proceso de reconciliación periódico**

```sql
-- Identificar ventas con productos inexistentes
SELECT 
    dv.id_detalle,
    dv.sku,
    dv.id_producto_mongo,
    v.numero_factura,
    v.fecha_venta
FROM detalle_ventas dv
JOIN ventas v ON dv.id_venta = v.id_venta
WHERE dv.id_producto_mongo NOT IN (
    SELECT DISTINCT id_producto_mongo 
    FROM productos_sync -- Tabla sincronizada desde MongoDB
);
```

**Solución 4: Soft delete en lugar de hard delete**

En MongoDB, en vez de eliminar productos:

```javascript
db.productos.updateOne(
    { _id: ObjectId("...") },
    { 
        $set: { 
            estado: "DESCONTINUADO",
            fecha_descontinuacion: new Date() 
        }
    }
);
```

---

### 7.2 Problema 2: Duplicados de SKU en MongoDB

#### **Descripción del Problema**

Sin un índice único en el campo `sku`, es posible insertar dos productos con el mismo código.

**Escenario de error:**
```javascript
db.productos.insertOne({
    sku: "SM-IPHON-15PRO-256-BLK", // Ya existe
    nombre: "iPhone 15 Pro Duplicado",
    precio_venta: 1299.99
});
// ✅ Se inserta exitosamente (ERROR)
```

#### **Impacto en el Negocio**

- ❌ **Ambigüedad:** ¿Cuál producto se vendió realmente?
- ❌ **Inventario incorrecto:** Stock se descuenta del producto equivocado
- ❌ **Problemas contables:** Precios diferentes para el mismo SKU
- ❌ **Garantías:** No se puede identificar el producto exacto vendido

#### **Causas Potenciales**

1. Falta de índice único en el campo `sku`
2. Carga masiva de datos sin validación
3. Errores manuales al crear productos
4. Falta de validación en la aplicación

#### **Soluciones Propuestas**

**Solución 1: Crear índice único (Preventiva - CRÍTICA)**

```javascript
// En MongoDB Atlas o MongoDB Shell
db.productos.createIndex(
    { sku: 1 }, 
    { 
        unique: true,
        name: "idx_sku_unique"
    }
);
```

Resultado:
```javascript
db.productos.insertOne({
    sku: "SM-IPHON-15PRO-256-BLK", // Ya existe
    nombre: "iPhone 15 Pro Duplicado"
});
// ❌ Error: E11000 duplicate key error
```

**Solución 2: Validación en la aplicación**

```javascript
async function crearProducto(productoData) {
    // Verificar si el SKU ya existe
    const existente = await db.productos.findOne({ 
        sku: productoData.sku 
    });
    
    if (existente) {
        throw new Error(`SKU ${productoData.sku} ya existe`);
    }
    
    return await db.productos.insertOne(productoData);
}
```

**Solución 3: Detección y limpieza de duplicados existentes**

```javascript
// 1. Encontrar SKUs duplicados
db.productos.aggregate([
    {
        $group: {
            _id: "$sku",
            count: { $sum: 1 },
            ids: { $push: "$_id" }
        }
    },
    {
        $match: { count: { $gt: 1 } }
    }
]);

// 2. Eliminar duplicados (manualmente, revisando cuál es el correcto)
db.productos.deleteOne({ 
    _id: ObjectId("id_del_duplicado_incorrecto") 
});
```

**Solución 4: Validación con Schema Validation**

```javascript
db.createCollection("productos", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["sku", "nombre", "precio_venta"],
            properties: {
                sku: {
                    bsonType: "string",
                    pattern: "^[A-Z]{2,3}-[A-Z0-9-]+$",
                    description: "SKU debe seguir formato específico"
                }
            }
        }
    }
});
```

---

### 7.3 Problema 3: Datos Incompletos en Clientes

#### **Descripción del Problema**

El campo `email` en la tabla `clientes` acepta valores NULL o puede contener correos mal formados.

**Escenario de error:**
```sql
INSERT INTO clientes (tipo_cliente, cedula_ruc, nombre, email)
VALUES ('PERSONA', '1234567890', 'Juan Pérez', NULL);
-- O peor aún:
VALUES ('PERSONA', '1234567890', 'Juan Pérez', 'correo-invalido');
```

#### **Impacto en el Negocio**

- ❌ **Campañas de marketing imposibles:** No se puede contactar al cliente
- ❌ **Facturación electrónica:** SRI requiere email válido
- ❌ **Notificaciones de pedidos:** Cliente no recibe confirmaciones
- ❌ **Recuperación de cuentas:** Imposible resetear contraseñas
- ❌ **Cumplimiento legal:** LOPDP requiere datos de contacto válidos

#### **Causas Potenciales**

1. Campo no marcado como `NOT NULL` en el diseño inicial
2. Falta de validación en formularios web
3. Datos migrados de sistemas legacy sin validación
4. Empleados ingresando datos manualmente sin verificar

#### **Soluciones Propuestas**

**Solución 1: Constraint CHECK con validación de formato**

```sql
-- Agregar constraint a tabla existente
ALTER TABLE clientes
ADD CONSTRAINT email_valido 
CHECK (
    email IS NULL OR 
    email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
);

-- Para nuevas tablas
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    email VARCHAR(150) 
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
    ...
);
```

**Solución 2;

-- 2. Marcar clientes para verificación manual
ALTER TABLE clientes ADD COLUMN email_verificado BOOLEAN DEFAULT FALSE;

UPDATE clientes
SET email_verificado = TRUE
WHERE email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}: Trigger en PostgreSQL (Reactiva)**

```sql
CREATE OR REPLACE FUNCTION validar_producto_existe()
RETURNS TRIGGER AS $$
BEGIN
    -- Aquí se haría una llamada a un servicio externo
    -- que verifique en MongoDB
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_detalle
BEFORE INSERT ON detalle_ventas
FOR EACH ROW EXECUTE FUNCTION validar_producto_existe();
```

**Solución 3: Proceso de reconciliación periódico**

```sql
-- Identificar ventas con productos inexistentes
SELECT 
    dv.id_detalle,
    dv.sku,
    dv.id_producto_mongo,
    v.numero_factura,
    v.fecha_venta
FROM detalle_ventas dv
JOIN ventas v ON dv.id_venta = v.id_venta
WHERE dv.id_producto_mongo NOT IN (
    SELECT DISTINCT id_producto_mongo 
    FROM productos_sync -- Tabla sincronizada desde MongoDB
);
```

**Solución 4: Soft delete en lugar de hard delete**

En MongoDB, en vez de eliminar productos:

```javascript
db.productos.updateOne(
    { _id: ObjectId("...") },
    { 
        $set: { 
            estado: "DESCONTINUADO",
            fecha_descontinuacion: new Date() 
        }
    }
);
```

---

### 7.2 Problema 2: Duplicados de SKU en MongoDB

#### **Descripción del Problema**

Sin un índice único en el campo `sku`, es posible insertar dos productos con el mismo código.

**Escenario de error:**
```javascript
db.productos.insertOne({
    sku: "SM-IPHON-15PRO-256-BLK", // Ya existe
    nombre: "iPhone 15 Pro Duplicado",
    precio_venta: 1299.99
});
// ✅ Se inserta exitosamente (ERROR)
```

#### **Impacto en el Negocio**

- ❌ **Ambigüedad:** ¿Cuál producto se vendió realmente?
- ❌ **Inventario incorrecto:** Stock se descuenta del producto equivocado
- ❌ **Problemas contables:** Precios diferentes para el mismo SKU
- ❌ **Garantías:** No se puede identificar el producto exacto vendido

#### **Causas Potenciales**

1. Falta de índice único en el campo `sku`
2. Carga masiva de datos sin validación
3. Errores manuales al crear productos
4. Falta de validación en la aplicación

#### **Soluciones Propuestas**

**Solución 1: Crear índice único (Preventiva - CRÍTICA)**

```javascript
// En MongoDB Atlas o MongoDB Shell
db.productos.createIndex(
    { sku: 1 }, 
    { 
        unique: true,
        name: "idx_sku_unique"
    }
);
```

Resultado:
```javascript
db.productos.insertOne({
    sku: "SM-IPHON-15PRO-256-BLK", // Ya existe
    nombre: "iPhone 15 Pro Duplicado"
});
// ❌ Error: E11000 duplicate key error
```

**Solución 2: Validación en la aplicación**

```javascript
async function crearProducto(productoData) {
    // Verificar si el SKU ya existe
    const existente = await db.productos.findOne({ 
        sku: productoData.sku 
    });
    
    if (existente) {
        throw new Error(`SKU ${productoData.sku} ya existe`);
    }
    
    return await db.productos.insertOne(productoData);
}
```

**Solución 3: Detección y limpieza de duplicados existentes**

```javascript
// 1. Encontrar SKUs duplicados
db.productos.aggregate([
    {
        $group: {
            _id: "$sku",
            count: { $sum: 1 },
            ids: { $push: "$_id" }
        }
    },
    {
        $match: { count: { $gt: 1 } }
    }
]);

// 2. Eliminar duplicados (manualmente, revisando cuál es el correcto)
db.productos.deleteOne({ 
    _id: ObjectId("id_del_duplicado_incorrecto") 
});
```

**Solución 4: Validación con Schema Validation**

```javascript
db.createCollection("productos", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["sku", "nombre", "precio_venta"],
            properties: {
                sku: {
                    bsonType: "string",
                    pattern: "^[A-Z]{2,3}-[A-Z0-9-]+$",
                    description: "SKU debe seguir formato específico"
                }
            }
        }
    }
});
```

---

### 7.3 Problema 3: Datos Incompletos en Clientes

#### **Descripción del Problema**

El campo `email` en la tabla `clientes` acepta valores NULL o puede contener correos mal formados.

**Escenario de error:**
```sql
INSERT INTO clientes (tipo_cliente, cedula_ruc, nombre, email)
VALUES ('PERSONA', '1234567890', 'Juan Pérez', NULL);
-- O peor aún:
VALUES ('PERSONA', '1234567890', 'Juan Pérez', 'correo-invalido');
```

#### **Impacto en el Negocio**

- ❌ **Campañas de marketing imposibles:** No se puede contactar al cliente
- ❌ **Facturación electrónica:** SRI requiere email válido
- ❌ **Notificaciones de pedidos:** Cliente no recibe confirmaciones
- ❌ **Recuperación de cuentas:** Imposible resetear contraseñas
- ❌ **Cumplimiento legal:** LOPDP requiere datos de contacto válidos

#### **Causas Potenciales**

1. Campo no marcado como `NOT NULL` en el diseño inicial
2. Falta de validación en formularios web
3. Datos migrados de sistemas legacy sin validación
4. Empleados ingresando datos manualmente sin verificar

#### **Soluciones Propuestas**

**Solución 1: Constraint CHECK con validación de formato**

```sql
-- Agregar constraint a tabla existente
ALTER TABLE clientes
ADD CONSTRAINT email_valido 
CHECK (
    email IS NULL OR 
    email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'
);

-- Para nuevas tablas
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    email VARCHAR(150) 
        CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
    ...
);
```

**Solución 2;
```

**Solución 5: Sistema de verificación de email**

```sql
-- Tabla para tokens de verificación
CREATE TABLE email_verificaciones (
    id_verificacion SERIAL PRIMARY KEY,
    id_cliente INTEGER REFERENCES clientes(id_cliente),
    token VARCHAR(64) UNIQUE NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_verificacion TIMESTAMP,
    verificado BOOLEAN DEFAULT FALSE
);

-- Trigger para enviar email de verificación al registrar cliente
CREATE OR REPLACE FUNCTION enviar_verificacion_email()
RETURNS TRIGGER AS $
BEGIN
    INSERT INTO email_verificaciones (id_cliente, token)
    VALUES (NEW.id_cliente, md5(random()::text));
    -- Aquí se llamaría a un servicio de email
    RETURN NEW;
END;
$ LANGUAGE plpgsql;
```

---

### 7.4 Resumen de Problemas de Calidad

| Problema | Sistema | Severidad | Solución Principal | Estado |
|----------|---------|-----------|-------------------|--------|
| SKU inconsistente SQL↔NoSQL | Ambos | 🔴 Alta | Validación preventiva | ⚠️ Implementar |
| SKU duplicados | MongoDB | 🔴 Alta | Índice único | ✅ Implementado |
| Email inválido/nulo | PostgreSQL | 🟡 Media | CHECK constraint | ⚠️ Implementar |

---

## 8. VALIDACIÓN Y RESULTADOS

### 8.1 Datos de Prueba Insertados

**Período de prueba:** Septiembre - Noviembre 2024

| Sistema | Entidad | Registros | Estado |
|---------|---------|-----------|--------|
| PostgreSQL | Clientes | 20 | ✅ |
| PostgreSQL | Sucursales | 5 | ✅ |
| PostgreSQL | Empleados | Variable | ✅ |
| PostgreSQL | Categorías Ref | 6 | ✅ |
| PostgreSQL | Ventas | 30 | ✅ |
| PostgreSQL | Detalle Ventas | 7 | ✅ |
| MongoDB | Categorías | 6 | ✅ |
| MongoDB | Productos | 7 | ✅ |

### 8.2 Consultas de Validación Ejecutadas

#### 8.2.1 Verificación de Integridad Referencial

```sql
-- Verificar que todos los detalles tienen ventas válidas
SELECT COUNT(*) as detalles_huerfanos
FROM detalle_ventas dv
LEFT JOIN ventas v ON dv.id_venta = v.id_venta
WHERE v.id_venta IS NULL;
-- Resultado: 0 ✅
```

#### 8.2.2 Validación de Totales

```sql
SELECT 
    v.id_venta,
    v.numero_factura,
    v.total_venta as total_registrado,
    SUM(dv.total_linea) as total_calculado,
    ABS(v.total_venta - SUM(dv.total_linea)) as diferencia
FROM ventas v
JOIN detalle_ventas dv ON v.id_venta = dv.id_venta
GROUP BY v.id_venta, v.numero_factura, v.total_venta
HAVING ABS(v.total_venta - SUM(dv.total_linea)) > 0.01;
-- Resultado: 0 filas (todas las diferencias son 0.00) ✅
```

**Resultados:**

| id_venta | numero_factura | total_registrado | total_calculado | diferencia |
|----------|----------------|------------------|-----------------|------------|
| 207 | FAC-2024-0030 | $425.58 | $425.58 | $0.00 ✅ |
| 206 | FAC-2024-0029 | $2,419.16 | $2,419.16 | $0.00 ✅ |
| 205 | FAC-2024-0028 | $425.58 | $425.58 | $0.00 ✅ |
| 204 | FAC-2024-0027 | $6,775.95 | $6,775.95 | $0.00 ✅ |
| 203 | FAC-2024-0026 | $1,455.98 | $1,455.98 | $0.00 ✅ |

### 8.3 Análisis de Ventas

#### 8.3.1 Productos Más Vendidos

```sql
SELECT 
    dv.nombre_producto,
    dv.sku,
    SUM(dv.cantidad) as unidades_vendidas,
    ROUND(SUM(dv.total_linea), 2) as ingreso_total
FROM detalle_ventas dv
GROUP BY dv.nombre_producto, dv.sku
ORDER BY unidades_vendidas DESC;
```

**Resultados:**

| Producto | SKU | Unidades | Ingresos |
|----------|-----|----------|----------|
| **MacBook Pro 14" M3** | LAP-MBPRO-M3-16-512-SLV | 2 | $4,815.97 🥇 |
| **Dell XPS 15** | LAP-DELL-XPS15-I7-16-512 | 2 | $3,975.96 🥈 |
| **Sony WH-1000XM5** | AUR-SONY-WH1000XM5-BLK | 2 | $828.76 🥉 |
| iPhone 15 Pro | SM-IPHON-15PRO-256-BLK | 1 | $1,455.98 |
| Apple Watch S9 | SW-APPLEWATCH-S9-45-ALU-MID | 1 | $425.58 |

**Total vendido:** 8 unidades por $11,502.25

#### 8.3.2 Ventas por Categoría

```sql
SELECT 
    cr.nombre_categoria,
    COUNT(dv.id_detalle) as lineas_vendidas,
    SUM(dv.cantidad) as unidades_totales,
    ROUND(SUM(dv.total_linea), 2) as ingreso_total,
    ROUND(AVG(dv.precio_unitario), 2) as precio_promedio
FROM detalle_ventas dv
JOIN categorias_ref cr ON dv.id_categoria_ref = cr.id_categoria_ref
GROUP BY cr.nombre_categoria
ORDER BY ingreso_total DESC;
```

**Resultados:**

| Categoría | Líneas | Unidades | Ingresos | Participación |
|-----------|--------|----------|----------|---------------|
| **Laptops** | 3 | 4 | $8,791.93 | 76.4% 🥇 |
| Smartphones | 1 | 1 | $1,455.98 | 12.7% 🥈 |
| Auriculares | 2 | 2 | $828.76 | 7.2% 🥉 |
| Smartwatches | 1 | 1 | $425.58 | 3.7% |

**Insight:** Las laptops representan más del 75% de los ingresos, indicando que son el producto estrella de TechStore.

#### 8.3.3 Ventas por Sucursal

```sql
SELECT 
    s.nombre_sucursal,
    s.ciudad,
    COUNT(DISTINCT v.id_venta) as num_ventas,
    ROUND(SUM(v.total_venta), 2) as total_facturado
FROM ventas v
JOIN sucursales s ON v.id_sucursal = s.id_sucursal
WHERE v.id_venta IN (203, 204, 205, 206, 207)
GROUP BY s.nombre_sucursal, s.ciudad
ORDER BY total_facturado DESC;
```

**Resultados:**

| Sucursal | Ciudad | Ventas | Total Facturado |
|----------|--------|--------|-----------------|
| TechStore Ambato | Ambato | 1 | $6,775.95 🥇 |
| TechStore Cuenca | Cuenca | 1 | $2,419.16 🥈 |
| TechStore Quito Centro | Quito | 2 | $851.16 |
| TechStore Quito Norte | Quito | 1 | $1,455.98 |

**Insight:** La venta corporativa a Innovatech en Ambato (2 MacBook Pro + 1 Dell XPS) representa el 59% del total facturado.

#### 8.3.4 Tipo de Cliente

```sql
SELECT 
    c.tipo_cliente,
    COUNT(DISTINCT v.id_venta) as num_ventas,
    ROUND(SUM(v.total_venta), 2) as total_facturado,
    ROUND(AVG(v.total_venta), 2) as ticket_promedio
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
WHERE v.id_venta IN (203, 204, 205, 206, 207)
GROUP BY c.tipo_cliente;
```

**Resultados:**

| Tipo Cliente | Ventas | Total Facturado | Ticket Promedio |
|--------------|--------|-----------------|-----------------|
| **EMPRESA** | 1 | $6,775.95 | $6,775.95 🏢 |
| PERSONA | 4 | $4,726.30 | $1,181.58 👤 |

**Insight:** Aunque las ventas corporativas son menos frecuentes, generan tickets 5.7x más altos que las ventas individuales.

### 8.4 Verificación de Vinculación SQL ↔ NoSQL

```sql
SELECT 
    v.numero_factura,
    dv.sku,
    dv.nombre_producto,
    dv.id_producto_mongo as objectid_mongodb,
    cr.nombre_categoria,
    cr.id_categoria_mongo as categoria_objectid
FROM detalle_ventas dv
JOIN ventas v ON dv.id_venta = v.id_venta
JOIN categorias_ref cr ON dv.id_categoria_ref = cr.id_categoria_ref
ORDER BY v.fecha_venta DESC;
```

**Resultado:** ✅ Todos los registros tienen `id_producto_mongo` válidos que corresponden a productos existentes en MongoDB.

### 8.5 Métricas de Calidad de Datos

| Métrica | Valor | Estado |
|---------|-------|--------|
| **Ventas con totales correctos** | 5/5 (100%) | ✅ |
| **Detalles con productos válidos** | 7/7 (100%) | ✅ |
| **Clientes con email válido** | 16/20 (80%) | ⚠️ |
| **Productos con SKU único** | 7/7 (100%) | ✅ |
| **Integridad referencial SQL** | 100% | ✅ |
| **Sincronización categorías SQL↔NoSQL** | 6/6 (100%) | ✅ |

---

## 9. CONCLUSIONES

### 9.1 Logros del Avance 1

✅ **Sistema NoSQL implementado exitosamente** con MongoDB Atlas, permitiendo almacenar productos con especificaciones técnicas flexibles y adaptables a diferentes categorías.

✅ **Sistema SQL implementado completamente** con PostgreSQL, garantizando integridad transaccional ACID para el registro de ventas, clientes y sucursales.

✅ **Vinculación SQL ↔ NoSQL establecida** mediante claves de referencia (`id_producto_mongo`, `id_categoria_ref`), permitiendo consultas integradas entre ambos sistemas.

✅ **Datos de prueba realistas** insertados y validados, cubriendo 30 ventas en el período Sep-Nov 2024, con 5 ventas detalladas completamente.

✅ **Integridad de datos verificada** con diferencias de $0.00 entre totales registrados y calculados, confirmando la consistencia del sistema.

✅ **Problemas de calidad identificados** con soluciones técnicas propuestas para prevenir inconsistencias futuras.

### 9.2 Aprendizajes Clave

#### 9.2.1 Técnicos

1. **Complementariedad SQL/NoSQL:** Cada tecnología tiene su lugar; la clave es usarlas donde son más efectivas.

2. **Importancia de constraints:** Los CHECK constraints, FOREIGN KEYS y NOT NULL previenen errores costosos.

3. **Validación en múltiples capas:** La validación debe existir en:
   - Base de datos (constraints)
   - Aplicación (lógica de negocio)
   - Frontend (UX/UI)

4. **Índices únicos críticos:** En NoSQL, la falta de índices únicos puede causar duplicados silenciosos.

#### 9.2.2 De Negocio

1. **Ventas corporativas >> Ventas individuales:** Los clientes B2B generan tickets 5.7x más altos.

2. **Laptops dominan los ingresos:** 76.4% de las ventas provienen de esta categoría.

3. **Concentración geográfica:** Quito concentra el 60% de las sucursales pero no necesariamente las mayores ventas.

### 9.3 Limitaciones Actuales

⚠️ **Limitación 1:** Solo 5 de 30 ventas tienen detalles completos. Las 25 ventas restantes requieren completar sus líneas de detalle.

⚠️ **Limitación 2:** Falta implementar validación automatizada de SKU antes de insertar en `detalle_ventas`.

⚠️ **Limitación 3:** El campo `email` en clientes acepta NULL; 20% de los clientes no tienen email válido.

⚠️ **Limitación 4:** No existe un proceso automatizado de sincronización entre MongoDB y PostgreSQL.

### 9.4 Próximos Pasos (Unidad 2)

**Objetivo:** Construir el Data Warehouse y procesos ETL

1. **Diseñar modelo dimensional:**
   - Dimensión Productos (desde MongoDB)
   - Dimensión Clientes (desde PostgreSQL)
   - Dimensión Tiempo (generada)
   - Dimensión Sucursales (desde PostgreSQL)
   - Tabla de Hechos: Ventas

2. **Implementar procesos ETL:**
   - Extracción desde MongoDB (productos)
   - Extracción desde PostgreSQL (transacciones)
   - Transformación (limpieza, enriquecimiento)
   - Carga al Data Warehouse

3. **Crear consultas OLAP:**
   - Ventas por producto/categoría/sucursal/período
   - Análisis de tendencias temporales
   - Segmentación de clientes
   - KPIs del negocio

4. **Documentar arquitectura completa:**
   - Diagrama de flujo de datos
   - Procesos de sincronización
   - Estrategias de respaldo y recuperación

### 9.5 Recomendaciones Técnicas

#### Para MongoDB:
```javascript
// 1. Crear índices de rendimiento
db.productos.createIndex({ sku: 1 }, { unique: true });
db.productos.createIndex({ categoria_id: 1 });
db.productos.createIndex({ precio_venta: 1 });
db.productos.createIndex({ estado: 1 });

// 2. Implementar Schema Validation
db.runCommand({
  collMod: "productos",
  validator: {
    $jsonSchema: {
      required: ["sku", "nombre", "precio_venta", "stock"],
      properties: {
        sku: { bsonType: "string", minLength: 5 },
        precio_venta: { bsonType: "double", minimum: 0 }
      }
    }
  }
});
```

#### Para PostgreSQL:
```sql
-- 1. Crear índices de rendimiento
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
CREATE INDEX idx_detalle_producto ON detalle_ventas(id_producto_mongo);
CREATE INDEX idx_detalle_sku ON detalle_ventas(sku);

-- 2. Implementar auditoría
CREATE TABLE auditoria_ventas (
    id_auditoria SERIAL PRIMARY KEY,
    tabla VARCHAR(50),
    operacion VARCHAR(10),
    usuario VARCHAR(100),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores JSONB,
    datos_nuevos JSONB
);

-- 3. Trigger de auditoría
CREATE OR REPLACE FUNCTION auditar_ventas()
RETURNS TRIGGER AS $
BEGIN
    INSERT INTO auditoria_ventas (tabla, operacion, datos_nuevos)
    VALUES ('ventas', TG_OP, row_to_json(NEW)::jsonb);
    RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auditoria_ventas
AFTER INSERT OR UPDATE ON ventas
FOR EACH ROW EXECUTE FUNCTION auditar_ventas();
```

### 9.6 Reflexión Final

La implementación de esta arquitectura dual SQL/NoSQL demuestra que **no existe una "bala de plata"** en el almacenamiento de datos. Cada tecnología tiene fortalezas específicas:

- **MongoDB** brilla en flexibilidad y adaptabilidad
- **PostgreSQL** destaca en consistencia e integridad

El verdadero arte del diseño de sistemas consiste en **elegir la herramienta correcta para cada problema** y lograr que ambas trabajen en armonía.

Este avance sienta las bases sólidas para la siguiente fase: transformar estos datos operacionales (OLTP) en información analítica (OLAP) que permita a la gerencia de TechStore tomar decisiones basadas en datos reales.

---

## 10. REFERENCIAS

### 10.1 Documentación Oficial

1. **MongoDB Documentation** (2024). *MongoDB Manual 7.0*. MongoDB Inc. Disponible en: https://www.mongodb.com/docs/manual/

2. **PostgreSQL Global Development Group** (2024). *PostgreSQL 17 Documentation*. Disponible en: https://www.postgresql.org/docs/17/

3. **MongoDB University** (2024). *M001: MongoDB Basics*. Curso en línea.

### 10.2 Libros y Artículos Académicos

4. Sadalage, P. J., & Fowler, M. (2012). *NoSQL Distilled: A Brief Guide to the Emerging World of Polyglot Persistence*. Addison-Wesley Professional.

5. Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling* (3rd ed.). Wiley.

6. Inmon, W. H. (2005). *Building the Data Warehouse* (4th ed.). Wiley.

### 10.3 Recursos en Línea

7. **MongoDB Atlas** - Plataforma cloud utilizada en el proyecto: https://www.mongodb.com/atlas

8. **pgAdmin** - Herramienta de administración PostgreSQL: https://www.pgadmin.org/

9. **Stack Overflow** - Comunidad de desarrollo: https://stackoverflow.com/

### 10.4 Herramientas Utilizadas

| Herramienta | Versión | Propósito |
|-------------|---------|-----------|
| MongoDB Atlas | Cloud | Base de datos NoSQL |
| PostgreSQL | 17 | Base de datos SQL |
| pgAdmin | 4 | Administración PostgreSQL |
| MongoDB Compass | Latest | Cliente GUI MongoDB |
| VS Code | Latest | Editor de código |

---