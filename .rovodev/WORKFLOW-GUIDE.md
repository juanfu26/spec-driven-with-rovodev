# 🚀 Guía Completa de Workflow RovoDev

## 🎯 Resumen del Workflow

Esta guía describe el uso completo del agente RovoDev desde la inicialización hasta la implementación automatizada de tickets de Jira.

## 📋 Setup Inicial (Una sola vez)

### **Paso 1: Inicializar Contenedor**
```bash
# Desde el directorio de tu repositorio
./run-rovodev.sh
```
**Resultado**: Contenedor Docker levantado con tu repositorio en `/workspace` y conexión a Jira/Confluence configurada.

### **Paso 2: Configurar Proyecto para RovoDev**
```bash
# Dentro del contenedor
rovodev initialize-project --project-name="Mi Proyecto" --jira-project=PROJ
```

**Lo que hace automáticamente:**
- 🔍 **Analiza tu código base** y extrae patrones específicos
- 📚 **Genera documentación OpenSpec** con estándares del proyecto
- 📖 **Crea especificaciones** técnicas en `openspec/specs/`
- 🛡️ **Configura code-guardian** personalizado para tu stack
- 🔗 **Setup integración** Jira/Confluence
- ⚙️ **Prepara templates** optimizados para tu proyecto

**Estructura generada:**
```
openspec/
├── standards/
│   ├── base.mdc                    # Estándares base específicos
│   ├── backend.mdc                 # Patrones backend detectados
│   ├── frontend.mdc                # Patrones frontend detectados
│   └── development-guide.mdc       # Guía personalizada
├── specs/
│   ├── architecture-overview.md    # Arquitectura actual
│   ├── api-specifications.md       # APIs documentadas
│   ├── data-models.md             # Modelos de datos
│   └── deployment-guide.md        # Estrategia de deployment
└── changes/
    └── .keep                      # Tracking de cambios futuros

.rovodev/
├── project-config.yml             # Config específica del proyecto
├── subagents/
│   ├── code-guardian.md           # Guardián personalizado
│   ├── architecture-expert.md     # Configurado con contexto
│   └── devops-automation.md       # Con herramientas detectadas
└── templates/
    ├── commit-template.md         # Templates personalizados
    └── pr-template.md
```

## 🔄 Workflow Diario (Para cada ticket)

### **Paso 3: Planificar Ticket**
```bash
# Generar plan de implementación detallado
rovodev plan-ticket PROJ-123
```

**Lo que hace:**
- 📖 **Lee el ticket** de Jira y analiza contenido
- 🧠 **Enriquece la descripción** con análisis técnico
- 📋 **Genera plan detallado** de implementación
- 💰 **Estima esfuerzo** basado en análisis del código
- 🎯 **Mejora criterios** de aceptación
- ✏️ **Actualiza ticket** en Jira con información mejorada

**Resultado**: Ticket de Jira transformado con plan técnico completo y estimaciones precisas.

### **Paso 4: Implementar Ticket**
```bash
# Implementación automática completa
rovodev implement-ticket PROJ-123
```

**Lo que hace:**
- 💻 **Genera código** siguiendo patrones específicos del proyecto
- 🧪 **Crea tests** automáticos (unit, integration, E2E)
- 📚 **Actualiza documentación** (API, técnica, OpenSpec)
- ✅ **Ejecuta quality gates** personalizados
- 🔒 **Valida security** sin vulnerabilidades
- ⚡ **Optimiza performance** según benchmarks
- 🎯 **Valida implementación** contra criterios de aceptación

**Resultado**: Implementación completa lista para review con 85%+ test coverage y quality gates pasados.

### **Paso 5: Commit y Pull Request**
```bash
# Commit organizado y PR automático
rovodev commit-and-pr PROJ-123
```

**Lo que hace:**
- 📝 **Analiza cambios** y categoriza por tipo
- 💾 **Crea commits** organizados con mensajes descriptivos
- 🔀 **Genera Pull Request** con descripción técnica completa
- 👥 **Asigna reviewers** automáticamente por área
- 🏷️ **Aplica labels** apropiados
- 🔗 **Actualiza Jira** con links y estado
- 📊 **Documenta métricas** de calidad en PR

**Resultado**: PR profesional listo para review con toda la información necesaria.

## 📊 Ejemplo de Flujo Completo

### **Ticket Inicial (antes)**
```
PROJ-123: Mejorar login
Descripción: Los usuarios se quejan que el login es lento
```

### **Después del plan-ticket**
```
PROJ-123: Implement improved authentication flow

🎯 Descripción Técnica:
- Objetivo: Reducir tiempo de login de 5s a <2s
- Componentes afectados: auth-service, user-dashboard, database
- Tecnologías: FastAPI, React, PostgreSQL, Redis

🏗️ Plan de Implementación:
- Backend (6h): Cache tokens en Redis, optimizar queries
- Frontend (4h): Loading states, optimización UX
- Testing (3h): Tests completos de performance
- Documentation (2h): API docs y deployment guide

📊 Estimación: 16 horas (confianza 85%)
```

### **Después del implement-ticket**
```
✅ Implementación Completada:
- 8 archivos modificados, 3 nuevos
- 23 tests (unit + integration + E2E)
- 87% test coverage
- 0 vulnerabilidades security
- Performance: P95 < 2s ✅
- Documentación: 4 docs actualizados
```

### **Después del commit-and-pr**
```
🔀 PR Creado: [PROJ-123] Implement improved authentication flow

📋 Contenido:
- 3 commits organizados
- Descripción técnica completa
- Reviewers: @backend-team, @security-reviewer
- Quality gates: todos pasados
- Ready for review

🔗 Jira actualizado: En "Code Review"
```

## 🎯 Casos de Uso Específicos

### **Proyecto Backend Nuevo**
```bash
rovodev initialize-project --project-name="API Service" --jira-project=API
# Detecta: FastAPI, PostgreSQL, Docker
# Genera: API standards, database patterns, testing strategy
```

### **Proyecto Frontend Existente**
```bash
rovodev initialize-project --project-name="Dashboard" --jira-project=DASH  
# Detecta: React, TypeScript, Jest
# Genera: Component patterns, state management, testing strategy
```

### **Proyecto Fullstack Complejo**
```bash
rovodev initialize-project --project-name="Platform" --jira-project=PLT
# Detecta: Angular + FastAPI + PostgreSQL + Docker
# Genera: Arquitectura completa, integration patterns, deployment strategy
```

## 🔧 Comandos de Mantenimiento

### **Actualizar Code Guardian**
```bash
# Cuando el proyecto evoluciona
rovodev generate-code-guardian --update
```

### **Regenerar Documentación**
```bash
# Actualizar OpenSpec con cambios
rovodev update-docs
```

### **Evolucionar Proyecto**
```bash
# Aplicar mejoras incrementales
rovodev evolve-project --maintain
```

## ⚡ Quick Reference

### **Comandos Esenciales**
```bash
# Setup inicial (una vez)
./run-rovodev.sh
rovodev initialize-project --project-name="Mi Proyecto" --jira-project=PROJ

# Desarrollo diario (por cada ticket)
rovodev plan-ticket PROJ-123
rovodev implement-ticket PROJ-123  
rovodev commit-and-pr PROJ-123
```

### **Comandos de Apoyo**
```bash
rovodev generate-code-guardian --update    # Actualizar guardián
rovodev evolve-project --maintain          # Mantenimiento
rovodev update-docs                        # Actualizar documentación
```

## 🏆 Beneficios del Workflow

### **Para Desarrolladores**
- ⚡ **Velocidad**: De 2-3 días a 2-3 horas por feature
- 🎯 **Calidad**: Quality gates automáticos garantizan excelencia
- 📚 **Aprendizaje**: Código generado enseña mejores prácticas
- 🧠 **Focus**: Más tiempo en lógica de negocio, menos en boilerplate

### **Para el Equipo**
- 📈 **Consistencia**: Mismo nivel de calidad en todos los desarrollos
- 🚀 **Onboarding**: Nuevos desarrolladores productivos inmediatamente
- 📋 **Standards**: Adherencia automática sin supervisión manual
- 🔄 **Knowledge Sharing**: Patrones embebidos preservan conocimiento

### **Para el Negocio**
- 💰 **Time to Market**: Desarrollo 5x más rápido
- ✅ **Quality Assurance**: Calidad enterprise garantizada
- 🎯 **Predictability**: Estimaciones precisas y entregas predecibles
- 📊 **Scalability**: Proceso escalable a cualquier tamaño de equipo

---

## 🎉 ¡Comienza Ahora!

```bash
# Tu primer comando
./run-rovodev.sh
```

**El futuro del desarrollo automatizado está aquí. Desarrolla a la velocidad del pensamiento.** ⚡