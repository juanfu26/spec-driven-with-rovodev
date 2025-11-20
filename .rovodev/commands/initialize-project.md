# 🚀 Initialize Project

Comando de inicialización completa que prepara un repositorio para usar RovoDev con análisis automático, generación de estándares OpenSpec, especificaciones del proyecto y configuración de agentes personalizados.

## 🎯 Objetivo

Configurar completamente un repositorio para uso con RovoDev:
1. **Analizar el proyecto** existente y extraer patrones
2. **Generar documentación OpenSpec** con estándares específicos del proyecto
3. **Crear especificaciones** técnicas del proyecto en `openspec/specs/`
4. **Configurar agentes personalizados** (code-guardian, etc.)
5. **Preparar workflow** para desarrollo con Jira/Confluence

## 🚀 Uso

```bash
# Inicialización completa del proyecto actual
rovodev initialize-project

# Inicialización con configuración específica
rovodev initialize-project --project-name="Mi Proyecto" --jira-project=PROJ

# Solo generar estándares sin especificaciones
rovodev initialize-project --standards-only

# Regenerar configuración existente
rovodev initialize-project --update
```

## 📋 Parámetros

- `--project-name`: Nombre del proyecto (default: nombre del directorio)
- `--jira-project`: Clave del proyecto en Jira
- `--confluence-space`: Espacio de Confluence para documentación
- `--standards-only`: Solo generar estándares OpenSpec
- `--update`: Actualizar configuración existente
- `--dry-run`: Mostrar qué se haría sin ejecutar

## 🔄 Proceso Completo de Inicialización

### **Fase 1: Análisis del Proyecto**
```yaml
Análisis Automático:
  - Detección de tecnologías utilizadas
  - Identificación de patrones arquitectónicos
  - Extracción de convenciones de código
  - Análisis de estructura de directorios
  - Evaluación de herramientas de desarrollo
  - Métricas de calidad actuales
```

### **Fase 2: Generación de Estándares OpenSpec**
```bash
# Se ejecutan automáticamente estos comandos:
rovodev create-base-standards
rovodev create-backend-standards     # Si se detecta backend
rovodev create-frontend-standards    # Si se detecta frontend
rovodev create-development-guide
```

### **Fase 3: Creación de Especificaciones**
```bash
# Generación automática en openspec/specs/
- architecture-overview.md     # Arquitectura general del sistema
- api-specifications.md        # Especificaciones de APIs
- data-models.md              # Modelos de datos y esquemas
- integration-points.md       # Puntos de integración
- deployment-guide.md         # Guía de despliegue
- testing-strategy.md         # Estrategia de testing
```

### **Fase 4: Configuración de Agentes**
```bash
# Generación de agentes personalizados:
rovodev generate-code-guardian       # Guardián específico del proyecto
# Configuración de architecture-expert con contexto del proyecto
# Configuración de devops-automation con herramientas detectadas
```

### **Fase 5: Setup de Workflow**
```yaml
Configuración de Integración:
  - Variables de entorno para Jira/Confluence
  - Templates de commit y PR
  - Configuración de hooks de calidad
  - Setup de documentación automática
```

## 📊 Estructura Generada

### **OpenSpec Documentation**
```
openspec/
├── standards/
│   ├── base.mdc                    # Estándares base del proyecto
│   ├── backend.mdc                 # Estándares backend específicos
│   ├── frontend.mdc                # Estándares frontend específicos
│   ├── documentation.mdc           # Estándares de documentación
│   └── development-guide.mdc       # Guía de desarrollo completa
├── specs/
│   ├── architecture-overview.md    # Arquitectura del sistema
│   ├── api-specifications.md       # APIs y contratos
│   ├── data-models.md             # Modelos de datos
│   ├── integration-points.md      # Integraciones externas
│   ├── deployment-guide.md        # Estrategia de deployment
│   ├── testing-strategy.md        # Enfoque de testing
│   └── security-requirements.md   # Requerimientos de seguridad
└── changes/
    └── .keep                      # Para tracking de cambios futuros
```

### **RovoDev Configuration**
```
.rovodev/
├── project-config.yml             # Configuración específica del proyecto
├── subagents/
│   ├── code-guardian.md           # Generado específicamente
│   ├── architecture-expert.md     # Configurado con contexto
│   └── devops-automation.md       # Configurado con herramientas
└── templates/
    ├── commit-template.md         # Template de commits
    ├── pr-template.md             # Template de PRs
    └── documentation-template.md  # Template de docs
```

## 🔧 Configuración del Proyecto

### **project-config.yml Generado**
```yaml
# Configuración específica del proyecto generada automáticamente
project:
  name: "{{ project_name }}"
  type: "{{ project_type }}"  # backend/frontend/fullstack/library
  technologies: {{ detected_technologies }}
  
jira:
  project_key: "{{ jira_project }}"
  base_url: "${JIRA_BASE_URL}"
  
confluence:
  space_key: "{{ confluence_space }}"
  base_url: "${CONFLUENCE_BASE_URL}"

quality_standards:
  test_coverage_minimum: {{ calculated_minimum }}
  complexity_threshold: {{ calculated_threshold }}
  security_scan_required: true
  documentation_required: true

development_workflow:
  branch_strategy: "{{ detected_strategy }}"
  commit_convention: "{{ detected_convention }}"
  pr_requirements: {{ calculated_requirements }}

automation:
  auto_documentation: true
  auto_testing: true
  auto_quality_checks: true
  jira_integration: true
  confluence_sync: true
```

## 📋 Output del Comando

### **Resumen de Inicialización**
```
🚀 Inicialización de Proyecto Completada

📊 Proyecto Analizado:
├── Nombre: mi-awesome-project
├── Tipo: Fullstack Application
├── Tecnologías: Python (FastAPI), React (TypeScript), PostgreSQL
├── Herramientas: Docker, pytest, jest, GitHub Actions
└── Métricas Base: 87% coverage, 6.2 complexity avg

📚 Documentación OpenSpec Generada:
├── ✅ 5 estándares específicos creados
├── ✅ 7 especificaciones técnicas generadas
├── ✅ Guía de desarrollo personalizada
└── ✅ Templates de documentación configurados

🤖 Agentes RovoDev Configurados:
├── ✅ code-guardian personalizado (15 validaciones específicas)
├── ✅ architecture-expert configurado con contexto
├── ✅ devops-automation con herramientas detectadas
└── ✅ Templates de workflow configurados

🔗 Integración Configurada:
├── ✅ Jira: PROJ (mi-awesome-project)
├── ✅ Confluence: TECH-DOCS
├── ✅ Git hooks: calidad automática
└── ✅ CI/CD: pipeline optimizado

🎯 Próximos Pasos:
1. Revisar documentación generada en openspec/
2. Validar configuración de agentes en .rovodev/
3. Probar workflow: rovodev plan-ticket PROJ-123
4. Comenzar desarrollo asistido por IA
```

## 🔄 Comandos Post-Inicialización

Una vez inicializado, estos comandos estarán disponibles optimizados para tu proyecto:

### **Workflow de Desarrollo**
```bash
# 1. Planificar implementación de ticket
rovodev plan-ticket PROJ-123

# 2. Implementar ticket completo
rovodev implement-ticket PROJ-123

# 3. Commit y PR automático
rovodev commit-and-pr PROJ-123
```

### **Mantenimiento y Evolución**
```bash
# Actualizar documentación
rovodev update-docs

# Regenerar agentes con nueva información
rovodev initialize-project --update

# Analizar cambios y actualizar specs
rovodev analyze-changes
```

## ⚡ Quick Start

### **Setup Inicial Típico**
```bash
# 1. Inicializar contenedor RovoDev
./run-rovodev.sh

# 2. Dentro del contenedor, inicializar proyecto
rovodev initialize-project --project-name="Mi Proyecto" --jira-project=PROJ

# 3. Revisar configuración generada
ls -la openspec/
ls -la .rovodev/

# 4. Comenzar desarrollo
rovodev plan-ticket PROJ-123
```

## 🎯 Resultado

Proyecto completamente configurado y listo para desarrollo asistido por IA con:
- ✅ **Documentación OpenSpec** completa y específica
- ✅ **Agentes personalizados** para el proyecto
- ✅ **Workflow optimizado** para Jira/Confluence
- ✅ **Quality gates** calibrados al proyecto
- ✅ **Templates** específicos para commits/PRs/docs
- ✅ **Integración completa** lista para usar

El proyecto está listo para desarrollo de alta velocidad con IA.