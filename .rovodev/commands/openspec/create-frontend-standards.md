# Analyze and Create Standards

Este comando analiza completamente el código base del proyecto y genera un documento estructurado de estándares, convenciones y mejores prácticas.

## Objetivo

Generar un documento que define estándares de desarrollo frontend, convenciones de componentes, patrones de estado, arquitectura de servicios, lineamientos UI/UX, estructura del proyecto, prácticas de testing, configuración de herramientas, y recomendaciones de rendimiento y workflow.

## Proceso

### 1. Inspección del Código Real del Proyecto

- **Detectar estructura**: Analizar la organización de carpetas, archivos y módulos
- **Identificar patrones**: Reconocer patrones de diseño utilizados y omitidos
- **Tecnologías y frameworks**: Catalogar el stack tecnológico completo
- **Configuraciones**: Examinar archivos de configuración (package.json, tsconfig, eslint, etc.)
- **Estilos de código**: Identificar convenciones de nomenclatura y estructura
- **Patrones de componentes**: Analizar la arquitectura de componentes existente
- **Prácticas existentes**: Derivar prácticas implícitas del código

### 2. Generación del Documento Completo

El documento debe incluir las siguientes secciones:

#### 2.1 Overview del Proyecto
- Descripción general y propósito
- Arquitectura de alto nivel
- Principios de diseño identificados

#### 2.2 Stack Tecnológico
- Frameworks y librerías principales
- Herramientas de desarrollo
- Dependencias críticas
- Versiones y compatibilidad

#### 2.3 Estándares de Código
- Convenciones de nomenclatura (variables, funciones, clases, archivos)
- Patrones de componentes
- Arquitectura de servicios
- Manejo de hooks y estado
- Gestión de errores y logging
- Comentarios y documentación

#### 2.4 Estructura del Proyecto
- Organización de directorios
- Convenciones de archivos
- Separación de responsabilidades
- Modularización

#### 2.5 Patrones de Estado y Arquitectura
- Gestión de estado global vs local
- Patrones de comunicación entre componentes
- Arquitectura de datos
- Flujo de información

#### 2.6 UI/UX y Buenas Prácticas de Interacción
- Principios de diseño de interfaz
- Patrones de interacción
- Accesibilidad
- Responsividad

#### 2.7 Testing y Organización de Pruebas
- Estrategias de testing
- Organización de archivos de prueba
- Convenciones de nomenclatura
- Cobertura esperada
- Tipos de pruebas (unitarias, integración, e2e)

#### 2.8 Lineamientos de Configuración
- TypeScript configuración
- ESLint y reglas de linting
- Variables de entorno
- Configuración de routing
- Build y bundling

#### 2.9 Optimización y Performance
- Técnicas de optimización identificadas
- Lazy loading y code splitting
- Gestión de assets
- Métricas de rendimiento

#### 2.10 Flujo de Desarrollo y Git Workflow
- Estrategia de branching
- Proceso de code review
- CI/CD pipeline
- Versionado y releases

#### 2.11 Recomendaciones de Modernización/Migración
- Identificación de deuda técnica
- Oportunidades de mejora
- Plan de modernización
- Migración de dependencias obsoletas

### 3. Características del Documento Final

- **Estructura clara**: Secciones bien organizadas con índice
- **Ejemplos reales**: Código derivado del análisis real, no inventado
- **Prácticas identificadas**: Basado en patrones encontrados en el código
- **Recomendaciones**: Incluir mejoras para inconsistencias o malas prácticas
- **Formato markdown**: Fácil de leer y mantener
- **Referencias**: Links a archivos específicos del proyecto

### 4. Análisis de Calidad

- Detectar inconsistencias en el código
- Identificar malas prácticas
- Sugerir mejoras específicas
- Proponer estándares donde no existen
- Validar contra mejores prácticas de la industria

## Instrucciones de Uso

1. Ejecutar este comando desde la raíz del proyecto
2. El comando analizará automáticamente toda la estructura
3. Generará un documento en `openspec/specs/standards/[project-type]-standards.mdc`
4. El documento será personalizado según el tipo de proyecto detectado (React, Vue, Angular, etc.)

## Resultado Esperado

Un documento completo y específico que sirva como guía de estándares para el proyecto, basado en análisis real del código y no en plantillas genéricas.