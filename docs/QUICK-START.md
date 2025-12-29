# ⚡ Quick Start Guide - RovoDev

> Nota: Este documento se ubica en `docs/` y enlaza a otros recursos internos. Actualizado tras reorganización.

## 🎯 **Desde 0 a Productivo en 15 Minutos**

Esta guía incorpora el resumen de setup inicial (antes en SETUP-COMPLETE.md) para que tengas todo en un solo lugar.

### **Paso 1: Inicializar (2 minutos)**
```bash
# En el directorio de tu proyecto
./run-rovodev.sh
```
**Resultado**: Contenedor Docker con tu proyecto montado y herramientas listas.

### **Paso 2: Configurar Proyecto (10 minutos)**
```bash
# Dentro del contenedor
rovodev initialize-project --project-name="Mi Proyecto" --jira-project=PROJ
```

**🎯 Lo que hace automáticamente:**
```
🔍 Analizando tu código base...
├── Detectado: Python (FastAPI), React, PostgreSQL
├── Generando documentación OpenSpec...
├── Creando code-guardian personalizado...
├── Configurando 6 expertos especializados...
├── Setup integración Jira/Confluence...
└── ✅ Proyecto listo para desarrollo automatizado!
```

### **Paso 3: Primer Ticket (3 minutos)**
```bash
# Usar un ticket real de tu Jira
rovodev plan-ticket PROJ-123
```

**🎯 Resultado inmediato:**
- 📋 Ticket enriquecido con análisis técnico completo
- 💰 Estimación de esfuerzo precisa
- 🏗️ Plan de implementación paso a paso
- 🎯 Criterios de aceptación mejorados

## 🚀 **Tu Primer Desarrollo Automatizado**

### **Implementación Completa (30 minutos)**
```bash
rovodev implement-ticket PROJ-123
```

**Lo verás en tiempo real:**
```
⚙️  Implementando PROJ-123: Agregar autenticación JWT

✅ Preparación (2/2 tareas) - 100%
⏳ Backend (4/6 tareas) - 67%
   ✅ AuthService.login() implementado
   ✅ JWT middleware configurado  
   ✅ Tests unitarios generados
   ⏳ Tests de integración en progreso...
   
📊 Quality Gates:
   ✅ Tests: 23/23 passed (89% coverage)
   ✅ Security: 0 vulnerabilities
   ✅ Performance: P95 < 200ms
   ✅ Linting: Auto-fixed 5 issues
```

### **Finalización Profesional (5 minutos)**
```bash
rovodev commit-and-pr PROJ-123
```

**🎯 Obtienes automáticamente:**
- 📝 3 commits organizados con mensajes descriptivos
- 🔀 Pull Request con descripción técnica completa
- 👥 Reviewers asignados automáticamente por área
- 🔗 Jira actualizado con links y estado
- 📊 Métricas de calidad documentadas

## 📈 **Resultados del Primer Uso**

### **✅ Implementación Completa Lista:**
- 💻 **8 archivos** modificados con código de calidad
- 🧪 **23 tests** generados automáticamente
- 📚 **4 documentos** actualizados (API, README, OpenSpec)
- 🔒 **0 vulnerabilidades** de seguridad
- ⚡ **Performance** validada contra benchmarks
- 🎯 **100% adherencia** a estándares del proyecto

### **📊 Comparación con Desarrollo Manual:**

| Aspecto | Manual Tradicional | RovoDev Automático |
|---------|-------------------|-------------------|
| **Tiempo total** | 2-3 días | 1 hora |
| **Test coverage** | 60-70% | 89%+ |
| **Vulnerabilidades** | 3-5 encontradas después | 0 desde el inicio |
| **Documentación** | 50% actualizada | 100% sincronizada |
| **Code review** | 2 horas de review | 20 min (contexto completo) |
| **Consistency** | Varía por developer | 100% estándares |

## 🎯 **Próximos Pasos Recomendados**

### **1. Explorar Capacidades (15 minutos)**
```bash
# Ver todos los comandos disponibles
rovodev --help

# Analizar las recomendaciones de los expertos
rovodev plan-ticket PROJ-124 --deep-analysis
```

### **2. Personalizar Standards (10 minutos)**
```bash
# Regenerar guardián con nuevos patterns
rovodev generate-code-guardian --update

# Ver configuración generada
cat .rovodev/subagents/code-guardian.md
```

### **3. Integrar con tu Workflow (20 minutos)**
- ✅ **Configurar reviewers** automáticos en settings
- ✅ **Personalizar templates** de commit y PR si necesario  
- ✅ **Configurar notifications** de Jira/Confluence
- ✅ **Training del equipo** en comandos básicos

### **4. Usar en Producción**
```bash
# Para tickets complejos
rovodev implement-from-jira COMPLEX-456

# Para mantenimiento regular  
rovodev evolve-project --maintain

# Para actualizaciones de docs
rovodev update-docs
```

## 🤖 **Conoce a tus 6 Expertos**

### **🏗️ Architecture Expert**
```bash
# Consulta decisiones arquitectónicas
"¿Debo usar microservicios o monolito?"
"¿Qué patrón de base de datos es mejor?"
```

### **🛡️ Code Guardian**
```bash
# Valida calidad específica de tu proyecto
"¿Este código sigue nuestros estándares?"
"¿Qué mejoras de calidad recomiendas?"
```

### **🧪 Testing Expert**
```bash
# Estrategias de testing inteligentes
"¿Qué tests necesito para este endpoint?"
"¿Cómo optimizo el time de ejecución?"
```

### **⚡ Performance Expert**
```bash
# Optimización proactiva
"¿Hay bottlenecks en este código?"
"¿Cómo mejorar el startup time?"
```

### **🔒 Security Expert**
```bash
# Seguridad automática
"¿Este cambio introduce vulnerabilidades?"
"¿Cumple con OWASP guidelines?"
```

### **🚀 DevOps Expert**
```bash
# Deployment inteligente
"¿Cuál es la mejor estrategia de deploy?"
"¿Cómo configurar monitoring?"
```

## 💡 **Tips para Máximo Aprovechamiento**

### **🎯 Escribe Buenos Tickets de Jira**
```
❌ Malo: "Arreglar login"
✅ Bueno: "Implementar autenticación JWT con refresh tokens
          - Login endpoint con validación
          - Middleware de autenticación  
          - Tests de security
          - Documentación API"
```

### **📊 Aprovecha el Análisis**
```bash
# Siempre revisar el plan antes de implementar
rovodev plan-ticket PROJ-123 --analyze-only
# Leer las recomendaciones de los expertos
# Luego implementar con confianza
rovodev implement-ticket PROJ-123
```

### **🔄 Mantén el Sistema Actualizado**
```bash
# Mensualmente, evoluciona tu setup
rovodev evolve-project --maintain
rovodev generate-code-guardian --update
```

## 🎉 **¡Estás Listo!**

Con estos comandos básicos puedes:
- ✅ **Configurar** cualquier proyecto en minutos
- ✅ **Desarrollar** features 10x más rápido
- ✅ **Garantizar** calidad enterprise automática
- ✅ **Mantener** consistencia en el equipo
- ✅ **Escalar** el proceso a cualquier tamaño

### **Tu próximo comando:**
```bash
rovodev plan-ticket PROJ-125
```

**¡Desarrolla a la velocidad del pensamiento!** ⚡