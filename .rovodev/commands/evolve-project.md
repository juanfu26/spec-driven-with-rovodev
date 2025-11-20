# 🚀 Evolve Project

Comando principal para evolucionar proyectos aplicando patrones consolidados desde tickets de Jira.

## 🎯 Objetivo

Implementar cambios y nuevas funcionalidades en proyectos manteniendo la consistencia arquitectónica y aplicando automáticamente los patrones identificados en 10+ proyectos de referencia.

## 🚀 Uso

```bash
# Evolucionar desde ticket de Jira
rovodev evolve-project --jira=PROJ-123

# Implementar funcionalidad específica
rovodev evolve-project --feature="add-modbus-connector" --project-type=backend

# Mantener proyecto existente
rovodev evolve-project --maintain --project-path=./my-project
```

## 📋 Parámetros

- `--jira`: ID del ticket de Jira a implementar
- `--feature`: Tipo de funcionalidad a implementar
- `--project-type`: Tipo de proyecto (infrastructure, backend, fullstack, microservices)
- `--maintain`: Modo mantenimiento (actualizar dependencias, refactoring, etc.)
- `--project-path`: Ruta del proyecto a evolucionar

## 🧠 Conocimiento Integrado

### **Patrones de Infraestructura**
- **Hardware Detection**: Advantech, Avalue, Shuttle, Dell con configuraciones específicas
- **Docker Multi-Stage**: Optimización según stack (Python, Node, embedded)
- **Bash Defensivo**: Scripts con colores estándar y manejo robusto de errores
- **CI/CD BitBucket**: Pipelines con security scans y multi-arch builds

### **Patrones Backend**
- **FastAPI + PropertiesManager**: Singleton configuration con startup orchestration
- **Domain**: Estructura modular
- **Protocol Connectors**: Modbus, MQTT, OPC UA con Redis coordination
- **Health Checks**: Endpoints estándar con correlation IDs

### **Patrones Fullstack**
- **Microservicios Distribuidos**: 5-6 contenedores con nginx proxy TLS
- **PWA Frontend**: Vanilla JS modular con Bootstrap + FontAwesome
- **Event-Driven**: SSE + WebSockets para comunicación real-time
- **Multi-Environment**: Docker Compose con dev/staging/prod overrides

### **Patrones Enterprise**
- **14 Microservicios**: Event-driven architecture con bounded contexts
- **Angular 19**: Reactive programming con RxJS + OnPush strategy
- **Keycloak Security**: Identity provider con role-based access
- **Testing Pyramid**: 95%+ coverage con pre-commit quality gates

## 🔧 Funcionalidades Automatizadas

### **🎫 Implementación desde Jira**
```yaml
Detección Automática desde Ticket:
- Análisis del título y descripción del ticket
- Identificación del tipo de cambio (feature, bug, refactoring)
- Selección del patrón arquitectónico apropiado
- Generación del código siguiendo estándares detectados
- Creación de tests automáticos
- Actualización de documentación
```

### **🔄 Tipos de Evolución Soportados**

#### **Backend Microservice Evolution**
- **Nuevo Endpoint**: Genera controller + service + schemas con validaciones
- **Protocol Integration**: Añade connectors Modbus/MQTT/OPC UA con Redis
- **Database Schema**: Actualiza modelos con migrations automáticas
- **Background Jobs**: Implementa schedulers con APScheduler patterns

#### **Frontend Enhancement**
- **Nueva Pantalla**: Crea componentes Angular/React con routing y services
- **Real-time Features**: Implementa WebSockets + SSE para live updates
- **Forms Complejos**: Genera formularios con validación y error handling
- **PWA Features**: Añade service workers y manifest para offline support

#### **Infrastructure Updates**
- **Hardware Support**: Añade soporte para nuevos dispositivos industriales
- **CI/CD Enhancement**: Actualiza pipelines con nuevas quality gates
- **Security Hardening**: Aplica security best practices y compliance
- **Performance Optimization**: Optimiza containers y resource allocation

#### **Full-Stack Integration**
- **API + UI**: Genera backend endpoint + frontend interface coordinados
- **Real-time Dashboard**: Crea dashboard con métricas live y alarmas
- **Multi-tenant Features**: Añade soporte multi-instancia industrial
- **Event Sourcing**: Implementa event-driven patterns para trazabilidad

## 🤖 Integración con Subagentes

### **Architecture Expert**
- **Decisiones técnicas** basadas en 10+ proyectos analizados
- **Hardware optimization** según target device
- **Protocol selection** según comunicación requerida
- **Performance tuning** según deployment environment

### **Code Quality Guardian**
- **Enforcement** de patrones
- **Quality gates** automáticos (linting, testing, security)
- **Documentation** generation siguiendo estándares
- **Dependency management** con upgrade strategies

### **DevOps Automation**
- **CI/CD pipeline** generation y updates
- **Container optimization** multi-arch builds
- **Infrastructure as Code** con Docker Compose
- **Monitoring & Logging** setup automático

## 📊 Flujo de Trabajo

### **1. Análisis del Ticket**
```python
def analyze_jira_ticket(ticket_id: str) -> ProjectEvolution:
    ticket = jira_client.get_ticket(ticket_id)
    
    # Análisis inteligente del contenido
    change_type = classify_change_type(ticket.description)
    project_context = detect_project_context(ticket.project)
    technical_requirements = extract_requirements(ticket.description)
    
    # Selección de patrones apropiados
    patterns = select_patterns(change_type, project_context)
    
    return ProjectEvolution(
        type=change_type,
        patterns=patterns,
        requirements=technical_requirements
    )
```

### **2. Generación de Código**
```python
def generate_implementation(evolution: ProjectEvolution) -> Implementation:
    # Aplicar patrones apropiados
    if evolution.type == "backend_endpoint":
        return generate_fastapi_endpoint(evolution.requirements)
    elif evolution.type == "protocol_connector":
        return generate_protocol_connector(evolution.requirements)
    elif evolution.type == "frontend_component":
        return generate_angular_component(evolution.requirements)
    elif evolution.type == "microservice":
        return generate_microservice_stack(evolution.requirements)
```

### **3. Quality Assurance**
```python
def validate_implementation(implementation: Implementation) -> ValidationResult:
    checks = [
        validate_patterns(implementation),
        run_security_scan(implementation),
        verify_test_coverage(implementation),
        check_documentation(implementation),
        validate_performance(implementation)
    ]
    return ValidationResult(checks)
```

### **4. Integration & Deployment**
```python
def integrate_changes(implementation: Implementation, validation: ValidationResult):
    if validation.passed:
        create_pull_request(implementation)
        update_jira_ticket(implementation.ticket_id, "Ready for Review")
        trigger_ci_pipeline(implementation.branch)
        notify_stakeholders(implementation)
```

## 🎯 Casos de Uso Específicos

### **Mantenimiento del Ecosystem**
```bash
# Añadir nuevo microservicio al ecosystem
rovodev evolve-project --jira=ROS-456 --feature="new-microservice:quality-control"

# Actualizar Angular a nueva versión
rovodev evolve-project --maintain --feature="angular-upgrade"

# Añadir nueva integración de protocolo
rovodev evolve-project --jira=ROS-789 --feature="opcua-integration"
```

### **Evolución de Proyectos Backend**
```bash
# Implementar nueva API según ticket
rovodev evolve-project --jira=MOD-123 --project-type=backend

# Migrar a nueva versión de FastAPI
rovodev evolve-project --maintain --feature="fastapi-upgrade" --project-type=backend
```

### **Evolución de Proyectos Fullstack**
```bash
# Implementar nueva funcionalidad completa
rovodev evolve-project --jira=BBR-789 --project-type=fullstack

# Añadir real-time monitoring
rovodev evolve-project --feature="realtime-dashboard" --protocols=modbus,mqtt

# Actualizar stack tecnológico
rovodev evolve-project --maintain --feature="stack-upgrade"
```

## 📈 Métricas y Validación

### **Quality Gates Automáticos**
- ✅ **Consistency Check**: Código sigue patrones
- ✅ **Test Coverage**: Mínimo 85% coverage automático
- ✅ **Security Scan**: Vulnerabilidades detectadas y reportadas
- ✅ **Performance**: Benchmarks cumplidos según hardware target
- ✅ **Documentation**: Documentación generada automáticamente

### **Success Metrics**
- **Implementation Time**: < 30 min para features estándar
- **Pattern Compliance**: 100% adherencia a estándares
- **Quality Score**: > 90% en quality gates
- **Maintainability**: Código reutilizable y documentado

## 🔄 Integration con Jira

### **Status Updates Automáticos**
```python
# Update automático del ticket según progreso
workflow_updates = {
    "analysis_complete": "Technical analysis completed",
    "implementation_ready": "Code generated following detected patterns", 
    "quality_passed": "All quality gates passed",
    "ready_for_review": "Pull request created for review",
    "deployed": "Changes deployed successfully"
}
```

### **Documentation Links**
```python
# Enlaces automáticos a documentación generada
def update_ticket_documentation(ticket_id: str, implementation: Implementation):
    jira_client.add_comment(ticket_id, f"""
    📚 **Implementation Documentation:**
    - API Docs: {implementation.api_docs_url}
    - Architecture: {implementation.architecture_docs}
    - Test Results: {implementation.test_report_url}
    - Deployment Guide: {implementation.deployment_guide}
    """)
```

## 🎯 Resultado

Sistema completo que permite evolucionar cualquier proyecto directamente desde tickets de Jira, aplicando automáticamente todos los patrones identificados en 10+ proyectos de referencia, garantizando consistencia, calidad y mantenibilidad a nivel enterprise.