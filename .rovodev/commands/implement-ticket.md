# ⚙️ Implement Ticket

Comando que ejecuta la implementación completa de un ticket de Jira siguiendo el plan generado, incluyendo código, tests, documentación y validación automática de calidad.

## 🎯 Objetivo

Implementar completamente un ticket de Jira basado en el plan existente:
1. **Ejecutar** el plan de implementación paso a paso
2. **Generar** código siguiendo estándares del proyecto
3. **Crear** tests automáticos completos
4. **Actualizar** documentación técnica
5. **Validar** calidad con quality gates personalizados
6. **Preparar** para commit y PR

## 🚀 Uso

```bash
# Implementar ticket completo
rovodev implement-ticket PROJ-123

# Implementar con validación continua
rovodev implement-ticket PROJ-123 --validate-steps

# Implementar solo hasta testing
rovodev implement-ticket PROJ-123 --stop-at=testing

# Implementar con review manual en cada fase
rovodev implement-ticket PROJ-123 --interactive
```

## 📋 Parámetros

- `ticket_id`: ID del ticket de Jira (obligatorio)
- `--validate-steps`: Validar cada paso antes de continuar
- `--stop-at`: Parar en fase específica (preparation/backend/frontend/testing/validation)
- `--interactive`: Requiere confirmación manual en cada fase
- `--skip-tests`: Saltar generación de tests (no recomendado)
- `--dry-run`: Mostrar qué se haría sin ejecutar cambios

## 🔄 Proceso de Implementación

### **Pre-requisitos Automáticos**
```python
def validate_prerequisites(ticket_id: str) -> PrerequisiteCheck:
    """Valida que el ticket esté listo para implementación"""
    
    checks = {
        'plan_exists': check_plan_exists(ticket_id),
        'branch_ready': check_branch_status(),
        'dependencies_clear': check_dependency_status(),
        'environment_ready': check_development_environment(),
        'quality_gates_configured': check_quality_configuration()
    }
    
    if not all(checks.values()):
        missing = [k for k, v in checks.items() if not v]
        raise PrerequisiteError(f"Missing prerequisites: {missing}")
    
    return PrerequisiteCheck(passed=True, details=checks)
```

### **Fase 1: Preparación del Entorno**
```python
def prepare_implementation_environment(ticket_id: str) -> EnvironmentSetup:
    """Prepara entorno para implementación"""
    
    # Cargar plan de implementación
    plan = load_implementation_plan(ticket_id)
    
    # Crear/validar branch de feature
    branch_name = f"feature/{ticket_id}-{plan.slug}"
    git_manager.create_or_switch_branch(branch_name)
    
    # Setup de configuración temporal para desarrollo
    dev_config = setup_development_configuration(plan)
    
    # Preparar herramientas necesarias
    tools_setup = prepare_development_tools(plan.required_tools)
    
    return EnvironmentSetup(
        branch=branch_name,
        configuration=dev_config,
        tools=tools_setup,
        workspace_ready=True
    )
```

### **Fase 2: Implementación Backend**
```python
def implement_backend_changes(plan: ImplementationPlan) -> BackendImplementation:
    """Implementa cambios de backend según plan"""
    
    backend_changes = []
    
    # Iterar sobre cambios planificados en orden de dependencias
    for change in plan.backend_changes:
        if change.type == "api_endpoint":
            implementation = generate_api_endpoint(change)
        elif change.type == "service_logic":
            implementation = generate_service_logic(change)
        elif change.type == "database_change":
            implementation = generate_database_migration(change)
        elif change.type == "middleware":
            implementation = generate_middleware(change)
        
        # Validar con code-guardian específico del proyecto
        validation = code_guardian.validate_implementation(implementation)
        if not validation.passed:
            implementation = code_guardian.fix_violations(implementation, validation)
        
        # Aplicar implementación
        apply_code_changes(implementation)
        backend_changes.append(implementation)
    
    return BackendImplementation(
        changes=backend_changes,
        tests_generated=generate_backend_tests(backend_changes),
        documentation_updated=update_backend_docs(backend_changes)
    )
```

### **Fase 3: Implementación Frontend**
```python
def implement_frontend_changes(plan: ImplementationPlan) -> FrontendImplementation:
    """Implementa cambios de frontend según plan"""
    
    frontend_changes = []
    
    for change in plan.frontend_changes:
        if change.type == "component":
            implementation = generate_react_component(change)
        elif change.type == "service":
            implementation = generate_frontend_service(change)
        elif change.type == "state_management":
            implementation = generate_state_management(change)
        elif change.type == "routing":
            implementation = update_routing_configuration(change)
        
        # Validar con estándares de frontend
        validation = code_guardian.validate_frontend_code(implementation)
        if not validation.passed:
            implementation = code_guardian.fix_frontend_violations(implementation, validation)
        
        apply_code_changes(implementation)
        frontend_changes.append(implementation)
    
    return FrontendImplementation(
        changes=frontend_changes,
        tests_generated=generate_frontend_tests(frontend_changes),
        documentation_updated=update_frontend_docs(frontend_changes)
    )
```

### **Fase 4: Generación de Tests Automáticos**
```python
def generate_comprehensive_tests(implementation: FullImplementation) -> TestSuite:
    """Genera suite completa de tests basada en implementación"""
    
    test_suite = TestSuite()
    
    # Unit tests para backend
    if implementation.backend:
        unit_tests = generate_unit_tests(
            code=implementation.backend.changes,
            coverage_target=code_guardian.get_coverage_target(),
            testing_patterns=code_guardian.get_testing_patterns()
        )
        test_suite.add_unit_tests(unit_tests)
    
    # Integration tests
    if implementation.backend and implementation.frontend:
        integration_tests = generate_integration_tests(
            backend_apis=implementation.backend.new_endpoints,
            frontend_components=implementation.frontend.affected_components
        )
        test_suite.add_integration_tests(integration_tests)
    
    # E2E tests para workflows completos
    if implementation.affects_user_workflows:
        e2e_tests = generate_e2e_tests(
            user_workflows=implementation.affected_workflows,
            acceptance_criteria=implementation.plan.acceptance_criteria
        )
        test_suite.add_e2e_tests(e2e_tests)
    
    # Component tests para frontend
    if implementation.frontend:
        component_tests = generate_component_tests(
            components=implementation.frontend.new_components,
            testing_library=detect_testing_library()
        )
        test_suite.add_component_tests(component_tests)
    
    return test_suite
```

### **Fase 5: Actualización de Documentación**
```python
def update_project_documentation(implementation: FullImplementation) -> DocumentationUpdate:
    """Actualiza toda la documentación afectada"""
    
    doc_updates = []
    
    # API Documentation
    if implementation.backend and implementation.backend.new_endpoints:
        api_docs = update_api_documentation(
            endpoints=implementation.backend.new_endpoints,
            openapi_spec=generate_openapi_updates(implementation.backend)
        )
        doc_updates.append(api_docs)
    
    # OpenSpec Specifications
    if implementation.affects_architecture:
        spec_updates = update_openspec_specs(
            architectural_changes=implementation.architectural_changes,
            specs_path="openspec/specs/"
        )
        doc_updates.append(spec_updates)
    
    # README and setup documentation
    if implementation.affects_setup:
        readme_updates = update_setup_documentation(
            setup_changes=implementation.setup_changes,
            new_dependencies=implementation.new_dependencies
        )
        doc_updates.append(readme_updates)
    
    # User documentation
    if implementation.affects_user_experience:
        user_doc_updates = update_user_documentation(
            ui_changes=implementation.frontend.ui_changes,
            workflow_changes=implementation.workflow_changes
        )
        doc_updates.append(user_doc_updates)
    
    # Technical documentation
    tech_doc_updates = update_technical_documentation(
        implementation_details=implementation,
        decision_records=generate_decision_records(implementation)
    )
    doc_updates.append(tech_doc_updates)
    
    return DocumentationUpdate(
        updates=doc_updates,
        generated_files=extract_generated_files(doc_updates),
        updated_files=extract_updated_files(doc_updates)
    )
```

### **Fase 6: Validación de Calidad Completa**
```python
def run_comprehensive_quality_validation(implementation: FullImplementation) -> QualityReport:
    """Ejecuta validación completa de calidad"""
    
    # Ejecutar todos los tests generados
    test_results = run_test_suite(implementation.test_suite)
    
    # Validación de coverage
    coverage_results = analyze_test_coverage(
        new_code=implementation.all_changes,
        minimum_coverage=code_guardian.get_coverage_requirements()
    )
    
    # Security scanning
    security_results = run_security_scan(
        changed_files=implementation.changed_files,
        scan_tools=code_guardian.get_security_tools()
    )
    
    # Performance validation
    performance_results = run_performance_tests(
        affected_endpoints=implementation.affected_endpoints,
        benchmarks=code_guardian.get_performance_benchmarks()
    )
    
    # Code quality checks
    quality_results = run_quality_checks(
        changed_files=implementation.changed_files,
        quality_gates=code_guardian.get_quality_gates()
    )
    
    # Architecture compliance
    architecture_results = validate_architecture_compliance(
        implementation=implementation,
        architecture_rules=architecture_expert.get_compliance_rules()
    )
    
    return QualityReport(
        tests=test_results,
        coverage=coverage_results,
        security=security_results,
        performance=performance_results,
        quality=quality_results,
        architecture=architecture_results,
        overall_passed=all([
            test_results.passed,
            coverage_results.meets_requirements,
            security_results.passed,
            performance_results.meets_benchmarks,
            quality_results.passed,
            architecture_results.compliant
        ])
    )
```

## 📊 Monitoreo en Tiempo Real

### **Progress Tracking**
```bash
🚀 Implementando PROJ-123: Mejora de Autenticación

✅ Preparación (2/2 tareas completadas) - 100%
⏳ Backend (3/6 tareas completadas) - 50%
   ✅ AuthenticationService.login() modificado
   ✅ Cache Redis implementado
   ✅ Middleware actualizado
   ⏳ Tests unitarios en progreso...
   ⏸️  Tests de integración - pendiente
   ⏸️  Validación de rendimiento - pendiente

⏸️  Frontend - pendiente
⏸️  Documentation - pendiente
⏸️  Quality Validation - pendiente

Tiempo transcurrido: 2h 15min
Tiempo estimado restante: 4h 30min
```

### **Validación Continua**
```bash
🔍 Quality Gates - Validación Continua

✅ Lint: Passed (0 issues)
✅ Format: Passed (auto-fixed 3 files)
✅ Security: Passed (0 vulnerabilities)
⚠️  Coverage: 83% (target: 85%) - 2% below target
✅ Complexity: 6.1 avg (target: <8)
⏳ Performance: Running tests...

🤖 Auto-fix aplicado: Coverage aumentada a 86% con tests adicionales
```

## 📁 Archivos y Cambios Generados

### **Código Implementado**
```
src/
├── auth/
│   ├── AuthenticationService.py        # Modificado
│   ├── middleware/AuthMiddleware.py    # Modificado
│   └── cache/TokenCache.py            # Nuevo
├── frontend/
│   ├── components/LoginComponent.tsx   # Modificado
│   ├── services/AuthService.ts        # Modificado
│   └── hooks/useAuth.ts               # Nuevo
tests/
├── unit/
│   ├── test_authentication_service.py # Generado
│   ├── test_token_cache.py            # Generado
│   └── test_login_component.test.tsx  # Generado
├── integration/
│   └── test_auth_flow.py              # Generado
└── e2e/
    └── auth_workflow.spec.ts           # Generado
```

### **Documentación Actualizada**
```
docs/
├── api/
│   └── authentication.md              # Actualizado
openspec/
├── specs/
│   ├── api-specifications.md          # Actualizado
│   └── auth-improvement.md            # Nuevo
└── changes/
    └── PROJ-123-auth-changes.md       # Tracking
README.md                              # Actualizado
```

## 🔄 Actualización de Jira

### **Estado del Ticket Actualizado**
```python
jira_updates = {
    'status': 'In Review',
    'assignee': current_developer,
    'progress': 100,
    'remaining_estimate': '0h',
    'resolution_date': datetime.now(),
    'labels': existing_labels + ['implemented', 'ready-for-review']
}
```

### **Comentario de Implementación**
```markdown
🤖 **Implementación Completada por RovoDev**

✅ **Resumen de Implementación**:
- Código: 8 archivos modificados, 3 archivos nuevos
- Tests: 15 tests unitarios, 5 tests de integración, 3 tests E2E
- Coverage: 87% (objetivo: 85% ✅)
- Documentación: 4 documentos actualizados

📊 **Quality Gates**:
- ✅ Tests: 23/23 passed
- ✅ Security: 0 vulnerabilities
- ✅ Performance: P95 < 2s ✅
- ✅ Coverage: 87% ✅
- ✅ Complexity: 6.1 avg ✅

📁 **Archivos Listos para Review**:
- Branch: feature/PROJ-123-auth-improvement
- Commits: 4 commits con mensajes descriptivos
- Documentation: Completamente actualizada

🚀 **Próximo Paso**: 
`rovodev commit-and-pr PROJ-123` para crear Pull Request automáticamente
```

## ⚡ Auto-fixes y Optimizaciones

### **Correcciones Automáticas**
- ✅ **Formateo**: Aplicado automáticamente durante implementación
- ✅ **Import sorting**: Organización automática de imports
- ✅ **Type hints**: Añadidos donde faltaban
- ✅ **Documentation strings**: Generados para funciones nuevas
- ✅ **Test coverage gaps**: Tests adicionales generados automáticamente

### **Optimizaciones Aplicadas**
- ✅ **Performance**: Cache queries optimizadas
- ✅ **Memory usage**: Cleanup automático de recursos
- ✅ **Error handling**: Patrones consistentes aplicados
- ✅ **Logging**: Structured logging añadido

## 🎯 Resultado

Implementación completa y lista para review con:
- ✅ **Código funcional** siguiendo estándares del proyecto
- ✅ **Tests completos** (unit, integration, E2E) con 85%+ coverage
- ✅ **Documentación actualizada** (API, técnica, usuario)
- ✅ **Quality gates** todos pasados automáticamente
- ✅ **Security validated** sin vulnerabilidades
- ✅ **Performance verified** cumple benchmarks
- ✅ **Ready for review** con contexto completo en Jira

El ticket está implementado profesionalmente y listo para el siguiente paso del workflow.