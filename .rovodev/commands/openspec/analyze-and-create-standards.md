# Analyze and Create Standards

Este comando analiza completamente el código base del proyecto y genera documentos estructurados de estándares, convenciones y mejores prácticas específicos para el tipo de proyecto detectado.

## Objetivo

Generar documentación completa de estándares de desarrollo que incluye convenciones de código, patrones de arquitectura, lineamientos de testing, configuración de herramientas, prácticas de rendimiento, workflow de desarrollo y recomendaciones de modernización.

## Proceso

### 1. Inspección Completa del Proyecto

- **Detectar tipo de proyecto**: Determinar si es frontend (React, Vue, Angular), backend (Node.js, Python, Java, etc.), fullstack, o mobile
- **Analizar estructura**: Examinar la organización de carpetas, archivos y módulos
- **Identificar tecnologías**: Catalogar el stack tecnológico completo (frameworks, librerías, herramientas)
- **Reconocer patrones**: Identificar patrones de diseño utilizados y arquitectura actual
- **Examinar configuraciones**: Analizar archivos de configuración (package.json, requirements.txt, pom.xml, etc.)
- **Evaluar estilos de código**: Identificar convenciones de nomenclatura, estructura y formateo
- **Analizar testing**: Revisar estrategias de pruebas existentes
- **Inspeccionar CI/CD**: Examinar pipelines y procesos de despliegue

### 2. Análisis de Calidad y Consistencia

- **Detectar inconsistencias**: Identificar variaciones en patrones de código
- **Evaluar malas prácticas**: Reconocer antipatrones y código problemático
- **Analizar deuda técnica**: Identificar áreas que requieren modernización
- **Revisar documentación**: Evaluar la calidad y completitud de la documentación existente
- **Validar contra estándares**: Comparar con mejores prácticas de la industria

### 3. Generación de Documentos de Estándares

El comando generará documentos específicos según el tipo de proyecto detectado:

#### 3.1 Para Proyectos Frontend
**Archivo**: `openspec/specs/standards/frontend.mdc`

Secciones incluidas:
- Overview del proyecto y arquitectura
- Stack tecnológico y dependencias
- Estándares de código y nomenclatura
- Estructura del proyecto y organización
- Patrones de componentes y estado
- UI/UX y lineamientos de diseño
- Gestión de estilos y assets
- Testing y organización de pruebas
- Configuración de herramientas (ESLint, TypeScript, bundlers)
- Optimización y performance
- Flujo de desarrollo y Git workflow
- Recomendaciones de modernización

#### 3.2 Para Proyectos Backend
**Archivo**: `openspec/specs/standards/backend.mdc`

Secciones incluidas:
- Introducción y propósito del proyecto
- Tecnologías y componentes del stack
- Arquitectura del sistema (capas, servicios, responsabilidades)
- Principios de diseño y patrones
- Estándares de codificación y nomenclatura
- Diseño de APIs y interfaces
- Gestión de datos y patrones de acceso
- Testing y estrategias de pruebas
- Prácticas de rendimiento y optimización
- Seguridad y validaciones
- Flujo de desarrollo y CI/CD
- Configuración de despliegue

#### 3.3 Para Proyectos Fullstack
**Archivos**: Ambos `frontend.mdc` y `backend.mdc` + `integration.mdc`

Incluye estándares específicos para la integración entre frontend y backend.

#### 3.4 Actualización de Base Standards
**Archivo**: `openspec/specs/standards/base.mdc`

Se actualizará para reflejar:
- Referencias correctas a los estándares específicos creados
- Principios generales identificados en el proyecto
- Convenciones globales detectadas

### 4. Características de los Documentos Generados

- **Basados en análisis real**: Derivados del código existente, no plantillas genéricas
- **Estructura clara**: Organización jerárquica con índices y navegación
- **Ejemplos específicos**: Fragmentos de código reales del proyecto
- **Referencias precisas**: Links a archivos específicos del proyecto
- **Formato MDC**: Compatible con el sistema OpenSpec
- **Prácticas identificadas**: Documentación de patrones encontrados
- **Recomendaciones de mejora**: Sugerencias para inconsistencias o malas prácticas
- **Versionado**: Control de cambios y evolución de estándares

### 5. Proceso de Validación

- **Verificar completitud**: Asegurar que todos los aspectos del proyecto estén cubiertos
- **Validar consistencia**: Verificar que los estándares no se contradigan entre sí
- **Revisar aplicabilidad**: Confirmar que los estándares sean prácticos y aplicables
- **Comprobar actualidad**: Asegurar que los estándares reflejen el estado actual del proyecto

## Instrucciones de Uso

1. Ejecutar desde la raíz del proyecto
2. El comando detectará automáticamente el tipo de proyecto
3. Analizará toda la estructura de código y configuraciones
4. Generará los documentos de estándares apropiados en `openspec/specs/standards/`
5. Actualizará las referencias en `base.mdc` si es necesario

## Resultado Esperado

Documentación completa y específica de estándares que incluye:

- **Estándares técnicos**: Basados en el análisis real del código
- **Guías prácticas**: Con ejemplos específicos del proyecto
- **Recomendaciones**: Para mejorar consistencia y calidad
- **Referencias**: A archivos y configuraciones específicas
- **Roadmap de mejora**: Plan para modernización y optimización

Los documentos generados servirán como guía autoritativa para el desarrollo futuro del proyecto, asegurando consistencia, calidad y mantenibilidad del código.