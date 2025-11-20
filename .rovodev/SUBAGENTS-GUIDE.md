# 🤖 Guía Completa de Subagentes RovoDev

## 🎯 Filosofía de Subagentes

Los subagentes de RovoDev actúan como **consultores expertos especializados** que otros comandos consultan para tomar decisiones inteligentes. Cada subagente tiene un dominio específico de expertise y proporciona recomendaciones basadas en análisis profundo.

## 🧠 Subagentes Disponibles

### **🏗️ architecture-expert**
**Experto en decisiones arquitectónicas**

- **Cuándo se consulta**: Durante `initialize-project`, `plan-ticket`, `implement-ticket`
- **Expertise**: Patrones arquitectónicos, stack tecnológico, diseño de sistemas
- **Decisiones**: Qué arquitectura usar, cómo estructurar código, patrones de diseño

```python
# Ejemplo de consulta
architecture = architecture_expert.recommend_architecture(
    requirements=ticket_requirements,
    existing_codebase=project_analysis
)
```

### **🛡️ code-guardian** *(Generado Dinámicamente)*
**Guardián de calidad específico del proyecto**

- **Cuándo se consulta**: Durante `implement-ticket`, validación de calidad
- **Expertise**: Estándares específicos del proyecto, quality gates personalizados
- **Decisiones**: Si el código cumple estándares, qué mejoras aplicar

```python
# Ejemplo de consulta
validation = code_guardian.validate_implementation(
    new_code=generated_code,
    project_standards=project_specific_rules
)
```

### **🚀 devops-automation**
**Experto en DevOps y deployment**

- **Cuándo se consulta**: Durante `initialize-project`, `implement-ticket`, `commit-and-pr`
- **Expertise**: CI/CD, containerización, deployment strategies, monitoring
- **Decisiones**: Estrategia de deployment, configuración de pipeline, setup de monitoring

```python
# Ejemplo de consulta
deployment_strategy = devops_automation.recommend_deployment_strategy(
    project_complexity=analysis.complexity,
    hardware_target=project_config.hardware
)
```

### **🧪 testing-expert**
**Especialista en estrategias de testing**

- **Cuándo se consulta**: Durante `plan-ticket`, `implement-ticket`
- **Expertise**: Test pyramid, generación de tests, coverage strategies
- **Decisiones**: Qué tests generar, estrategia de cobertura, frameworks de testing

```python
# Ejemplo de consulta
testing_strategy = testing_expert.recommend_testing_approach(
    change_type=ticket.type,
    risk_level=ticket.risk_assessment,
    existing_coverage=project.test_coverage
)
```

### **⚡ performance-expert**
**Experto en análisis y optimización de performance**

- **Cuándo se consulta**: Durante `plan-ticket`, `implement-ticket`, monitoreo continuo
- **Expertise**: Bottleneck detection, optimization strategies, performance monitoring
- **Decisiones**: Baseline de performance, optimizaciones a aplicar, métricas a trackear

```python
# Ejemplo de consulta
performance_baseline = performance_expert.establish_performance_baseline(
    project_type=analysis.type,
    hardware_constraints=deployment_context
)
```

### **🔒 security-expert**
**Especialista en seguridad y compliance**

- **Cuándo se consulta**: Durante `plan-ticket`, `implement-ticket`, security reviews
- **Expertise**: Threat modeling, vulnerability detection, compliance requirements
- **Decisiones**: Riesgo de seguridad, patrones de seguridad a aplicar, tests de seguridad

```python
# Ejemplo de consulta
security_risk = security_expert.assess_security_risk(
    planned_changes=ticket.changes,
    current_threat_model=project.threat_model
)
```

## 🔄 Flujo de Consultas en el Workflow

### **Durante `initialize-project`**
```python
def initialize_project():
    # 1. Architecture Expert: Analizar y recomendar estructura
    architecture_recommendations = architecture_expert.analyze_project_structure()
    
    # 2. Performance Expert: Establecer baseline
    performance_baseline = performance_expert.setup_performance_monitoring()
    
    # 3. Security Expert: Configurar seguridad
    security_setup = security_expert.setup_project_security()
    
    # 4. DevOps Expert: Configurar CI/CD
    devops_setup = devops_automation.setup_development_environment()
    
    # 5. Generate Code Guardian: Crear guardián específico
    code_guardian = generate_code_guardian_from_analysis()
```

### **Durante `plan-ticket`**
```python
def plan_ticket(ticket_id):
    # 1. Architecture Expert: Evaluar impacto arquitectónico
    architecture_impact = architecture_expert.assess_architecture_impact(ticket)
    
    # 2. Testing Expert: Crear plan de testing
    testing_plan = testing_expert.create_testing_plan(ticket)
    
    # 3. Performance Expert: Evaluar impacto en performance
    performance_impact = performance_expert.assess_performance_impact(ticket)
    
    # 4. Security Expert: Analizar implicaciones de seguridad
    security_implications = security_expert.analyze_security_implications(ticket)
    
    # 5. Combinar todas las recomendaciones
    comprehensive_plan = combine_expert_recommendations(
        architecture_impact, testing_plan, performance_impact, security_implications
    )
```

### **Durante `implement-ticket`**
```python
def implement_ticket(ticket_id):
    # 1. Architecture Expert: Guiar implementación
    implementation_guidance = architecture_expert.guide_implementation(plan)
    
    # 2. Code Guardian: Validar calidad en tiempo real
    quality_validation = code_guardian.validate_during_implementation(code)
    
    # 3. Testing Expert: Generar tests automáticamente
    generated_tests = testing_expert.generate_comprehensive_tests(implementation)
    
    # 4. Performance Expert: Validar performance
    performance_validation = performance_expert.validate_performance(implementation)
    
    # 5. Security Expert: Validar seguridad
    security_validation = security_expert.validate_security(implementation)
    
    # 6. DevOps Expert: Preparar deployment
    deployment_preparation = devops_automation.prepare_deployment(implementation)
```

## 🎯 Cuándo Crear un Nuevo Subagente

### **✅ Crea un subagente cuando:**
- **Expertise específico**: Requiere conocimiento especializado en un dominio
- **Decisiones complejas**: Necesita evaluar múltiples factores para decidir
- **Reutilizable**: Múltiples comandos necesitan consultar esta expertise
- **Estado persistente**: Mantiene conocimiento o contexto entre operaciones

### **❌ NO crees un subagente cuando:**
- **Tarea simple**: Solo ejecuta una acción específica sin decisión compleja
- **Uso único**: Solo un comando lo necesita
- **Sin estado**: No mantiene conocimiento entre operaciones
- **Flujo lineal**: Es parte de un workflow específico

## 💡 Subagentes Adicionales Recomendados

### **🔮 Futuros Subagentes Potenciales**

#### **📊 business-intelligence-expert**
**Experto en métricas de negocio y analytics**
- **Expertise**: KPIs, analytics, business metrics, A/B testing
- **Consultas**: Durante implementación de features que afectan métricas de negocio
- **Decisiones**: Qué métricas trackear, cómo medir impacto de features

#### **🎨 ux-expert**
**Especialista en experiencia de usuario**
- **Expertise**: UI/UX patterns, accessibility, user journey optimization
- **Consultas**: Durante implementación de features frontend
- **Decisiones**: Patrones de UI, flujos de usuario, accessibility compliance

#### **📈 scalability-expert**
**Experto en escalabilidad y sistemas distribuidos**
- **Expertise**: Scaling patterns, distributed systems, load balancing
- **Consultas**: Cuando se planea crecimiento o se detectan problemas de escala
- **Decisiones**: Estrategias de scaling, arquitectura distribuida

#### **🔄 migration-expert**
**Especialista en migraciones tecnológicas**
- **Expertise**: Legacy system migration, technology upgrades, data migration
- **Consultas**: Durante modernización de sistemas o upgrades tecnológicos
- **Decisiones**: Estrategia de migración, fases de upgrade, risk mitigation

## 📋 Plantilla para Crear Nuevos Subagentes

```markdown
# 🔮 [Nombre] Expert

Subagente especializado en [dominio]. Consultor experto para decisiones relacionadas con [área específica].

## 🎯 Expertise Domain
- [Lista de áreas de expertise específicas]

## 🧠 Decision Framework
```python
def make_key_decision(context):
    """Método principal de toma de decisiones"""
    pass
```

## 🔧 Integration Points in Workflow
### Durante `command-name`
```python
def consultation_example():
    """Ejemplo de cómo otros comandos consultan este expert"""
    pass
```

## 📊 [Dominio] Patterns por Stack
[Patrones específicos según stack tecnológico]

## 🎯 Expert Recommendations
[Mejores prácticas y recomendaciones del dominio]
```

## 🚀 Evolución de Subagentes

### **Aprendizaje Continuo**
Los subagentes pueden evolucionar aprendiendo de:
- **Decisiones pasadas** y sus resultados
- **Feedback del equipo** sobre recomendaciones
- **Métricas de éxito** de implementaciones
- **Nuevas mejores prácticas** de la industria

### **Personalización por Organización**
Cada subagente puede ser personalizado para:
- **Estándares específicos** de la organización
- **Compliance requirements** particulares
- **Technology preferences** del equipo
- **Risk tolerance** de la empresa

---

## 🎉 Resultado

Un ecosistema de **consultores expertos virtuales** que garantizan que cada decisión técnica sea tomada con el mejor conocimiento disponible, resultando en código de mayor calidad, mejor performance, mayor seguridad y arquitectura más sólida.