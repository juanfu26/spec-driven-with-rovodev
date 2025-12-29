# 📋 Plan Ticket

Comando que analiza un ticket de Jira y genera un plan detallado de implementación, mejorando el contenido del ticket con análisis técnico y especificaciones de implementación.

## 🎯 Objetivo

Transformar un ticket básico de Jira en un plan de implementación completo:
1. **Analizar** el contenido actual del ticket
2. **Enriquecer** la descripción con detalles técnicos
3. **Generar** plan de implementación detallado
4. **Estimar** esfuerzo y complejidad
5. **Actualizar** el ticket en Jira con la información mejorada

## 🚀 Uso

```bash
# Generar plan para un ticket específico
rovodev plan-ticket PROJ-123

# Plan con contexto específico
rovodev plan-ticket PROJ-123 --type=feature --priority=high

# Solo análisis sin actualizar Jira
rovodev plan-ticket PROJ-123 --local-only

# Plan con análisis profundo
rovodev plan-ticket PROJ-123 --deep-analysis
```

## 📋 Parámetros

- `ticket_id`: ID del ticket de Jira (obligatorio)
- `--type`: Tipo de implementación (feature/bugfix/refactor/tech-debt)
- `--priority`: Prioridad del ticket (low/medium/high/critical)
- `--local-only`: Solo generar plan local sin actualizar Jira
- `--deep-analysis`: Análisis profundo con arquitectura y dependencias
- `--output-file`: Guardar plan en archivo específico

## 🔍 Proceso de Análisis y Planificación

### **1. Extracción de Información del Ticket**
```python
def analyze_jira_ticket(ticket_id: str) -> TicketAnalysis:
    """Analiza ticket existente y extrae información"""
    
    ticket = jira_client.get_ticket(ticket_id)
    
    analysis = {
        'current_description': ticket.description,
        'acceptance_criteria': extract_acceptance_criteria(ticket),
        'labels_and_components': ticket.labels + ticket.components,
        'priority_level': ticket.priority,
        'reporter_context': get_reporter_context(ticket.reporter),
        'project_context': get_project_context(ticket.project)
    }
    
    return TicketAnalysis(
        original_content=analysis,
        technical_gaps=identify_technical_gaps(analysis),
        missing_information=identify_missing_info(analysis),
        implementation_complexity=assess_complexity(analysis)
    )
```

### **2. Enriquecimiento Técnico**
```python
def enrich_ticket_content(analysis: TicketAnalysis) -> EnrichedTicket:
    """Enriquece contenido del ticket con análisis técnico"""
    
    # Análisis técnico usando agentes especializados
    architecture_analysis = architecture_expert.analyze_requirements(analysis)
    technical_specifications = generate_technical_specs(analysis)
    implementation_approach = design_implementation_approach(analysis)
    
    enriched_content = {
        'enhanced_description': generate_enhanced_description(analysis),
        'technical_requirements': architecture_analysis.requirements,
        'implementation_plan': implementation_approach.detailed_plan,
        'acceptance_criteria_enhanced': enhance_acceptance_criteria(analysis),
        'definition_of_done': generate_definition_of_done(analysis),
        'testing_strategy': design_testing_strategy(analysis),
        'documentation_requirements': identify_doc_requirements(analysis)
    }
    
    return EnrichedTicket(
        original=analysis,
        enhanced=enriched_content,
        metadata=generate_metadata(analysis)
    )
```

### **3. Generación del Plan de Implementación**
```python
def generate_implementation_plan(enriched_ticket: EnrichedTicket) -> ImplementationPlan:
    """Genera plan detallado de implementación"""
    
    # Análisis de componentes afectados
    affected_components = identify_affected_components(enriched_ticket)
    
    # Diseño de la implementación
    implementation_design = {
        'architecture_changes': design_architecture_changes(enriched_ticket),
        'code_changes': plan_code_changes(enriched_ticket),
        'database_changes': plan_database_changes(enriched_ticket),
        'api_changes': plan_api_changes(enriched_ticket),
        'frontend_changes': plan_frontend_changes(enriched_ticket),
        'infrastructure_changes': plan_infrastructure_changes(enriched_ticket)
    }
    
    # Secuencia de implementación
    implementation_sequence = {
        'preparation_tasks': generate_preparation_tasks(enriched_ticket),
        'implementation_steps': generate_implementation_steps(implementation_design),
        'testing_phases': generate_testing_phases(enriched_ticket),
        'deployment_steps': generate_deployment_steps(enriched_ticket),
        'validation_steps': generate_validation_steps(enriched_ticket)
    }
    
    return ImplementationPlan(
        design=implementation_design,
        sequence=implementation_sequence,
        effort_estimation=calculate_effort_estimation(implementation_design),
        risk_assessment=assess_implementation_risks(implementation_design)
    )
```

### **4. Estimación de Esfuerzo**
```python
def calculate_effort_estimation(plan: ImplementationPlan) -> EffortEstimation:
    """Calcula estimación de esfuerzo basada en análisis del código base"""
    
    # Análisis de complejidad histórica
    historical_data = analyze_historical_implementations(plan.affected_components)
    
    # Factores de complejidad
    complexity_factors = {
        'code_complexity': assess_code_complexity(plan),
        'integration_complexity': assess_integration_complexity(plan),
        'testing_complexity': assess_testing_complexity(plan),
        'documentation_complexity': assess_documentation_complexity(plan)
    }
    
    # Estimación base
    base_estimation = calculate_base_estimation(plan, complexity_factors)
    
    # Ajustes por riesgo
    risk_adjustments = calculate_risk_adjustments(plan.risk_assessment)
    
    return EffortEstimation(
        base_hours=base_estimation.hours,
        adjusted_hours=apply_risk_adjustments(base_estimation, risk_adjustments),
        confidence_level=calculate_confidence_level(historical_data),
        breakdown=generate_effort_breakdown(base_estimation, complexity_factors)
    )
```

## 📊 Contenido del Plan Generado

### **Descripción Técnica Mejorada**
```markdown
## 🎯 Descripción Técnica

### Objetivo
[Descripción original mejorada con contexto técnico]

### Contexto Técnico
- **Componentes afectados**: auth-service, user-dashboard, database
- **Arquitectura actual**: Microservicios con API Gateway
- **Tecnologías involucradas**: FastAPI, React, PostgreSQL
- **Dependencias**: user-service (v2.3), notification-service

### Valor de Negocio
- **Impacto**: Mejora experiencia de usuario en 40%
- **Métrica clave**: Tiempo de autenticación < 2s
- **Beneficiarios**: 10,000+ usuarios activos
```

### **Plan de Implementación Detallado**
```markdown
## 🏗️ Plan de Implementación

### Fase 1: Preparación (2 horas)
- [ ] Análisis de código existente en auth-service
- [ ] Setup de branch feature/PROJ-123-auth-improvement
- [ ] Configuración de entorno de testing
- [ ] Review de documentación actual

### Fase 2: Backend (6 horas)
- [ ] Modificar AuthenticationService.login() (2h)
- [ ] Implementar cache de tokens en Redis (2h)
- [ ] Actualizar middleware de validación (1h)
- [ ] Tests unitarios e integración (1h)

### Fase 3: Frontend (4 horas)
- [ ] Actualizar LoginComponent (1.5h)
- [ ] Implementar loading states mejorados (1h)
- [ ] Actualizar AuthService client (1h)
- [ ] Tests de componente (0.5h)

### Fase 4: Testing y Validación (3 horas)
- [ ] Tests end-to-end completos (2h)
- [ ] Validación de performance (0.5h)
- [ ] Review de seguridad (0.5h)

### Fase 5: Deployment (1 hora)
- [ ] Deploy en staging y validación
- [ ] Deploy en producción
- [ ] Monitoring post-deploy
```

### **Criterios de Aceptación Mejorados**
```markdown
## ✅ Criterios de Aceptación

### Funcionales
- [ ] Login completo en < 2 segundos (medido con Performance API)
- [ ] Tokens guardados en cache Redis con TTL de 24h
- [ ] Loading states visibles durante autenticación
- [ ] Fallback graceful si cache no disponible
- [ ] Logout limpia cache correctamente

### Técnicos
- [ ] Test coverage > 85% en código nuevo
- [ ] Performance tests pasan con P95 < 2s
- [ ] Security scan sin vulnerabilidades críticas
- [ ] API backward compatible mantenida
- [ ] Logs estructurados implementados

### Documentación
- [ ] API documentation actualizada
- [ ] README con cambios de configuración
- [ ] Runbook para troubleshooting
```

### **Estimación y Riesgos**
```markdown
## 📊 Estimación de Esfuerzo

### Resumen
- **Tiempo total estimado**: 16 horas (2 días)
- **Confianza**: 85% (basado en 12 implementaciones similares)
- **Complejidad**: Media (6/10)

### Breakdown Detallado
- Backend changes: 6h (38%)
- Frontend changes: 4h (25%)
- Testing: 3h (19%)
- Preparation: 2h (12%)
- Deployment: 1h (6%)

### Riesgos Identificados
- **MEDIO**: Dependencia de Redis - Migración puede requerir tiempo extra
- **BAJO**: Impacto en otros servicios - Cambios en auth pueden afectar integrations
- **BAJO**: Performance en producción - Cache puede no dar speedup esperado

### Mitigaciones
- Implementar feature flag para rollback rápido
- Tests de carga en staging environment
- Monitoreo proactivo post-deploy
```

## 🔄 Actualización del Ticket en Jira

### **Campos Actualizados Automáticamente**
```python
jira_updates = {
    'description': enhanced_description,
    'story_points': calculated_story_points,
    'original_estimate': estimated_hours,
    'labels': existing_labels + ['tech-analyzed', 'ready-for-dev'],
    'custom_fields': {
        'technical_complexity': complexity_score,
        'architecture_impact': architecture_impact_level,
        'testing_strategy': testing_strategy_summary
    }
}
```

### **Comentarios Añadidos**
```markdown
🤖 **Análisis Técnico Completado por RovoDev**

📋 **Resumen del Plan**:
- Estimación: 16 horas (confianza 85%)
- Complejidad: Media (6/10)
- Componentes afectados: 3
- Riesgos identificados: 2 mitigados

📁 **Documentos Generados**:
- Plan detallado: [Link al archivo local]
- Especificaciones técnicas: openspec/specs/auth-improvement.md
- Tests strategy: Actualizado en testing-strategy.md

🚀 **Listo para Implementación**:
El ticket ha sido enriquecido con análisis técnico completo y está listo para comenzar desarrollo.

Próximo paso: `rovodev implement-ticket PROJ-123`
```

## 📁 Archivos Generados

### **Plan Local**
```
.rovodev/plans/
└── PROJ-123-implementation-plan.md    # Plan completo detallado
```

### **Documentación Actualizada**
```
openspec/specs/
├── feature-auth-improvement.md         # Especificación técnica
└── updated-api-specifications.md       # APIs afectadas actualizadas

openspec/changes/
└── PROJ-123-auth-changes.md           # Tracking de cambios
```

## 🎯 Resultado

Ticket de Jira transformado de descripción básica a plan de implementación enterprise-grade con:
- ✅ **Análisis técnico** completo y contextual
- ✅ **Plan de implementación** paso a paso
- ✅ **Estimaciones** basadas en datos históricos
- ✅ **Riesgos identificados** y mitigados
- ✅ **Documentación** técnica actualizada
- ✅ **Criterios de aceptación** mejorados y técnicos

El ticket está listo para implementación eficiente y sin sorpresas.

## Materialización en OpenSpec (wiki) y ciclo de validación

1) Genera un documento OpenSpec en estado "draft" con la planificación técnica:
   - Ruta sugerida: `$WIKI_ROOT/openspec/changes/[YYYY-MM-DD]_[JIRA]_[slug].md`
   - Frontmatter mínimo:
     ```yaml
     ---
     id: [JIRA-ID]
     title: [Breve título de la spec]
     status: draft
     created_at: [YYYY-MM-DD]
     authors: [tu-usuario]
     domains: [backend, frontend, infra]
     links:
       jira: https://jira.tu-org/browse/[JIRA-ID]
       confluence: [opcional_url]
       related_prs: []
     validation:
       reviewers: [backend_ref, frontend_ref, infra_ref, negocio_ref]
       checkpoints: [alcance, impactos, riesgo]
     ---
     ```
   - Secciones recomendadas:
     - Objetivo funcional (1–2 frases)
     - Cambios esperados (por componentes/capas)
     - Impacto por capa (Backend/Frontend/Infra)
     - Riesgos conocidos
     - Criterios de aceptación (resumen)
     - Definición de Hecho (DoD)
     - Estrategia de testing (unit/integration/e2e)

2) Trazabilidad y evidencia
   - Añade links (jira, related_prs, confluence si aplica)
   - Referencia estándares: `openspec/standards/documentation.mdc` si existe

3) Estado y validación
   - Mantener como draft hasta validación del desarrollador
   - Validación manual usando "OpenSpec Validate" (cambia a `status: validated`)
   - Finalización post-merge con "OpenSpec Finalize" (cambia a `status: finalized`)

4) Herramientas relacionadas (commands)
   - OpenSpec Draft: `commands/p4_implementation_planning/p4_openspec_draft.md`
   - OpenSpec Validate: `commands/p5_documentation/p5_openspec_validate.md`
   - OpenSpec Finalize: `commands/p5_documentation/p5_openspec_finalize.md`
