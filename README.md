#  Proyecto-Macro-TechStore

Proyecto de **Business Intelligence** para TechStore - Solución integral de análisis de datos que integra sistemas SQL y NoSQL.

---

##  Descripción del Proyecto

**TechStore** es una cadena minorista de tecnología en rápido crecimiento que enfrenta el desafío de tener sus datos fragmentados en múltiples sistemas:

- **Información de productos e inventario:** MongoDB (NoSQL) con atributos flexibles
- **Información transaccional:** PostgreSQL (SQL) con integridad ACID

Este proyecto construye un sistema de Business Intelligence que consolida ambas fuentes de datos para proporcionar análisis de negocio en tiempo real.

---

##  Objetivo General

Construir un **Data Mart de Ventas** que integre:

-  **MongoDB (NoSQL)**: Catálogo de productos con especificaciones técnicas flexibles
-  **PostgreSQL (SQL)**: Sistema transaccional de ventas, clientes y sucursales
-  **Proceso ETL**: Extracción, transformación y carga de datos
-  **Dashboard BI**: Visualización de KPIs y métricas de negocio

---

##  Preguntas de Negocio a Resolver

- ¿Cuál es nuestro producto más vendido en cada sucursal?
- ¿Cómo ha sido la tendencia de ventas por categoría en el último trimestre?
- ¿Qué categorías generan mayor rentabilidad?
- ¿Cuál es el perfil de compra de clientes corporativos vs. individuales?
- ¿Qué sucursales tienen mejor desempeño?

---

## 📁 Estructura del Repositorio
```
📦 Proyecto-Macro-TechStore
│
├── 📄 README.md                          # Este archivo
│
└── 📁 AVANCE_UNIDAD_1/
    │
    ├── 📄 INFORME_U1.md                  # Documentación completa Unidad 1
    │
    ├── 📁 SISTEMA_NOSQL/
    │   └── 📄 operaciones_productos.mongodb   # Scripts MongoDB
    │
    └── 📁 SISTEMA_SQL/
        ├── 📄 schema_ventas.sql          # Estructura de tablas PostgreSQL
        └── 📷 modelo_relacional_ventas.png    # Diagrama ER (pendiente)
```

---

##  Tecnologías Utilizadas

| Componente | Tecnología | Versión | Propósito |
|------------|------------|---------|-----------|
| **Base de Datos NoSQL** | MongoDB Atlas | Cloud | Catálogo de productos |
| **Base de Datos SQL** | PostgreSQL | 17 | Sistema transaccional |
| **Administración SQL** | pgAdmin | 4 | Gestión PostgreSQL |
| **Cliente MongoDB** | MongoDB Compass | Latest | GUI MongoDB |
| **Editor de código** | Visual Studio Code | Latest | Desarrollo |
| **Control de versiones** | Git + GitHub | Latest | Repositorio |

---

##  Modelo de Datos

### **Sistema NoSQL (MongoDB)**

**Base de datos:** `techstore_db`

**Colecciones:**
- `categorias` (6 documentos): Smartphones, Laptops, Tablets, Auriculares, Smartwatches, Accesorios
- `productos` (7 documentos): Catálogo con especificaciones técnicas detalladas

**Ventajas:**
- Esquema flexible para diferentes tipos de productos
- Especificaciones técnicas anidadas
- Consultas rápidas sin JOINs
- Escalabilidad horizontal

---

### **Sistema SQL (PostgreSQL)**

**Base de datos:** `techstore_ale`

**Tablas:**
1. `clientes` (20 registros) - Personas y empresas
2. `sucursales` (5 registros) - Ubicaciones físicas
3. `empleados` - Personal de ventas
4. `categorias_ref` (6 registros) - Puente SQL ↔ NoSQL
5. `ventas` (30 registros) - Encabezados de facturas
6. `detalle_ventas` (7 registros) - Líneas de productos vendidos

**Ventajas:**
- Integridad referencial (FOREIGN KEYS)
- Transacciones ACID
- Consistencia de datos
- Auditoría completa

---

##  Vinculación SQL ↔ NoSQL

La integración entre sistemas se logra mediante:
```
detalle_ventas.id_producto_mongo → productos._id (MongoDB)
detalle_ventas.id_categoria_ref → categorias_ref → categorias._id (MongoDB)
```

**Campos de vinculación:**
- `id_producto_mongo` (VARCHAR): Almacena ObjectId de MongoDB
- `sku` (VARCHAR): Clave alternativa para búsquedas
- `id_categoria_ref` (INTEGER): FK a tabla puente

---

##  Datos de Prueba

**Período:** Septiembre - Noviembre 2024

| Métrica | Valor |
|---------|-------|
| **Total de ventas** | 30 facturas |
| **Ventas con detalle** | 5 facturas |
| **Productos vendidos** | 8 unidades |
| **Ingreso total (detallado)** | $11,502.25 |
| **Ticket promedio individual** | $1,181.58 |
| **Ticket promedio corporativo** | $6,775.95 |

**Productos más vendidos:**
1.  MacBook Pro 14" M3 (2 unidades)
2.  Dell XPS 15 (2 unidades)
3.  Sony WH-1000XM5 (2 unidades)

**Categoría más rentable:**
- 💻 **Laptops**: $8,791.93 (76.4% del total)

---

##  Autora

**Alexandra Tana**  
Proyecto ESPE - Business Intelligence Techstore

---

## 📝 Estado del Proyecto

### ✅ **Unidad 1: COMPLETADO** - Modelado de Sistemas Operacionales (OLTP)

**Entregables:**
- ✅ Sistema NoSQL (MongoDB) implementado
- ✅ Sistema SQL (PostgreSQL) implementado
- ✅ Vinculación SQL ↔ NoSQL establecida
- ✅ Datos de prueba insertados y validados
- ✅ Informe técnico completo

---

### ⏳ **Unidad 2: PENDIENTE** - ETL y Data Warehouse

**Por desarrollar:**
-  Diseño del modelo dimensional (estrella/copo de nieve)
-  Creación de dimensiones (dim_productos, dim_clientes, dim_tiempo, dim_sucursales)
-  Creación de tabla de hechos (fact_ventas)
-  Implementación de procesos ETL
-  Consultas OLAP

---

### ⏳ **Unidad 3: PENDIENTE** - Visualización y Análisis

**Por desarrollar:**
-  Dashboard interactivo (Power BI / Tableau)
-  KPIs del negocio
-  Análisis de tendencias
-  Segmentación de clientes
-  Reportes gerenciales

---

##  Cómo Usar Este Repositorio

### **Para recrear la Base de Datos NoSQL:**
```bash
# 1. Conéctate a MongoDB Atlas
# 2. Crea una base de datos llamada: techstore_db
# 3. Ejecuta el script:
mongosh < AVANCE_UNIDAD_1/SISTEMA_NOSQL/operaciones_productos.mongodb
```

---

### **Para recrear la Base de Datos SQL:**
```bash
# 1. Abre pgAdmin y conéctate a PostgreSQL
# 2. Crea una base de datos llamada: techstore_ale
# 3. Ejecuta el script:
psql -U postgres -d techstore_ale -f AVANCE_UNIDAD_1/SISTEMA_SQL/schema_ventas.sql
```

---

##  Documentación

-  **[INFORME_U1.md](AVANCE_UNIDAD_1/INFORME_U1.md)** - Documentación completa del Avance 1
  - Justificación del modelo dual SQL/NoSQL
  - Análisis de calidad de datos
  - Consultas de validación
  - Resultados y métricas

---

## 🔗 Enlaces

- [MongoDB Atlas](https://www.mongodb.com/atlas) - Base de datos NoSQL en la nube
- [PostgreSQL](https://www.postgresql.org/) - Base de datos relacional open source
- [pgAdmin](https://www.pgadmin.org/) - Herramienta de administración PostgreSQL
- [MongoDB Compass](https://www.mongodb.com/products/compass) - Cliente GUI para MongoDB

---
