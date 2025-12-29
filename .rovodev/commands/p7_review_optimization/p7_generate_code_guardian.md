# 🛡️ Generate Code Guardian

Comando que analiza el proyecto actual y genera un subagente `code-guardian` personalizado que aplica automáticamente los estándares de calidad, patrones arquitectónicos y mejores prácticas identificadas específicamente en tu proyecto.

## 🎯 Objetivo

Crear un guardián de código completamente personalizado que:
- **Aprende** de tu código base existente
- **Identifica** tus patrones y convenciones específicas
- **Aplica** automáticamente tus estándares de calidad
- **Valida** adherencia a tus mejores prácticas
- **Genera** tests siguiendo tu metodología específica

## 🚀 Uso

```bash
# Generar guardián para el proyecto actual
rovodev generate-code-guardian

# Regenerar guardián con análisis actualizado
rovodev generate-code-guardian --update

# Generar para proyecto específico
rovodev generate-code-guardian --project-path=/path/to/project

# Análisis sin generar el guardián
rovodev generate-code-guardian --analyze-only
```

## 📋 Parámetros

- `--project-path`: Ruta del proyecto a analizar (default: directorio actual)
- `--update`: Actualizar guardián existente con nueva información
- `--analyze-only`: Solo mostrar análisis sin generar el archivo
- `--output-path`: Ruta donde guardar el guardián generado

## 🔍 Proceso de Análisis Inteligente

### **1. Detección de Stack Tecnológico**
```python
def analyze_tech_stack(project_path: str) -> TechStackAnalysis:
    """Analiza el stack tecnológico del proyecto"""
    
    detected_technologies = {
        "backend": detect_backend_technologies(project_path),
        "frontend": detect_frontend_technologies(project_path), 
        "database": detect_database_technologies(project_path),
        "infrastructure": detect_infrastructure_tools(project_path),
        "testing": detect_testing_frameworks(project_path),
        "build_tools": detect_build_tools(project_path)
    }
    
    return TechStackAnalysis(
        primary_language=determine_primary_language(project_path),
        frameworks=detected_technologies,
        package_managers=detect_package_managers(project_path),
        development_tools=detect_dev_tools(project_path)
    )
```

### **2. Análisis de Patrones de Código**
```python
def extract_code_patterns(project_path: str) -> CodePatterns:
    """Extrae patrones específicos del código base"""
    
    patterns = {
        "naming_conventions": analyze_naming_patterns(project_path),
        "architectural_patterns": detect_architectural_patterns(project_path),
        "error_handling": analyze_error_handling_patterns(project_path),
        "logging_patterns": extract_logging_patterns(project_path),
        "test_patterns": analyze_testing_patterns(project_path),
        "documentation_style": analyze_documentation_patterns(project_path)
    }
    
    return CodePatterns(
        conventions=patterns,
        consistency_score=calculate_consistency_score(patterns),
        recommendations=generate_pattern_recommendations(patterns)
    )
```

### **3. Identificación de Quality Gates**
```python
def identify_quality_standards(project_path: str) -> QualityStandards:
    """Identifica estándares de calidad del proyecto"""
    
    # Análisis de configuración existente
    existing_configs = {
        "linting": parse_linting_config(project_path),
        "formatting": parse_formatting_config(project_path),
        "testing": analyze_test_coverage_config(project_path),
        "ci_cd": analyze_ci_config(project_path),
        "pre_commit": parse_pre_commit_config(project_path)
    }
    
    # Análisis de métricas actuales
    current_metrics = {
        "test_coverage": calculate_current_coverage(project_path),
        "code_complexity": analyze_complexity_metrics(project_path),
        "dependency_health": analyze_dependency_status(project_path),
        "security_status": run_security_analysis(project_path)
    }
    
    return QualityStandards(
        existing_standards=existing_configs,
        current_metrics=current_metrics,
        recommended_thresholds=calculate_recommended_thresholds(current_metrics)
    )
```

### **4. Detección de Herramientas de Desarrollo**
```python
def detect_development_tools(project_path: str) -> DevelopmentTools:
    """Detecta herramientas y configuraciones específicas del proyecto"""
    
    tools = {
        "package_managers": detect_package_managers(project_path),
        "build_systems": detect_build_systems(project_path),
        "linters": detect_linting_tools(project_path),
        "formatters": detect_formatting_tools(project_path),
        "testing_frameworks": detect_test_frameworks(project_path),
        "ci_cd_platforms": detect_ci_platforms(project_path),
        "containerization": detect_container_tools(project_path)
    }
    
    return DevelopmentTools(
        tools=tools,
        configurations=extract_tool_configurations(tools, project_path),
        custom_scripts=identify_custom_scripts(project_path)
    )
```

## 🛡️ Generación del Code Guardian Personalizado

### **Template Base del Guardian**
```python
def generate_guardian_template(analysis: ProjectAnalysis) -> GuardianTemplate:
    """Genera template personalizado del code guardian"""
    
    template = f"""
# 🛡️ {analysis.project_name} Code Guardian

Subagente especializado en garantizar la calidad, seguridad y consistencia del código siguiendo los estándares específicos identificados en {analysis.project_name}.

## 🎯 Mission

Asegurar que todo el código generado y mantenido siga los patrones de calidad específicos de {analysis.project_name}, aplicando automáticamente quality gates, security checks y standards compliance personalizados.

## 🔍 Project-Specific Quality Standards

### **{analysis.primary_language} Standards**
{generate_language_standards(analysis)}

### **Architecture Patterns**
{generate_architecture_patterns(analysis)}

### **Quality Gates Configuration**
{generate_quality_gates(analysis)}

### **Security Standards**
{generate_security_standards(analysis)}

### **Testing Requirements**
{generate_testing_standards(analysis)}

### **Documentation Standards**
{generate_documentation_standards(analysis)}
"""
    
    return GuardianTemplate(
        content=template,
        validations=generate_validation_functions(analysis),
        enforcement_rules=generate_enforcement_rules(analysis)
    )
```

### **Estándares Específicos por Lenguaje**
```python
def generate_language_standards(analysis: ProjectAnalysis) -> str:
    """Genera estándares específicos según el lenguaje principal"""
    
    if analysis.primary_language == "python":
        return generate_python_standards(analysis)
    elif analysis.primary_language == "javascript" or analysis.primary_language == "typescript":
        return generate_js_ts_standards(analysis)
    elif analysis.primary_language == "java":
        return generate_java_standards(analysis)
    elif analysis.primary_language == "go":
        return generate_go_standards(analysis)
    else:
        return generate_generic_standards(analysis)

def generate_python_standards(analysis: ProjectAnalysis) -> str:
    return f"""
```python
PYTHON_STANDARDS = {{
    "structure": {{
        "app_pattern": "{analysis.detected_patterns.app_structure}",
        "config_pattern": "{analysis.detected_patterns.config_pattern}",
        "testing_pattern": "{analysis.detected_patterns.test_structure}"
    }},
    "dependencies": {analysis.dependencies.to_dict()},
    "naming_conventions": {{
        "functions": "{analysis.patterns.function_naming}",
        "classes": "{analysis.patterns.class_naming}",
        "variables": "{analysis.patterns.variable_naming}",
        "files": "{analysis.patterns.file_naming}"
    }},
    "quality_gates": {{
        "test_coverage": {analysis.quality_standards.min_coverage},
        "complexity_threshold": {analysis.quality_standards.max_complexity},
        "line_length": {analysis.quality_standards.max_line_length}
    }}
}}
```
"""
```

### **Validaciones Personalizadas**
```python
def generate_validation_functions(analysis: ProjectAnalysis) -> List[ValidationFunction]:
    """Genera funciones de validación específicas del proyecto"""
    
    validations = []
    
    # Validación de estructura de proyecto
    if analysis.has_specific_structure:
        validations.append(f"""
def validate_project_structure(code: CodeBase) -> ValidationResult:
    \"\"\"Valida estructura específica de {analysis.project_name}\"\"\"
    
    required_structure = {analysis.required_structure}
    violations = []
    
    for path, requirements in required_structure.items():
        if not validate_path_requirements(code, path, requirements):
            violations.append(f"Structure violation in {{path}}")
    
    return ValidationResult(
        passed=len(violations) == 0,
        violations=violations,
        recommendations=generate_structure_fixes(violations)
    )
""")
    
    # Validación de patrones de naming específicos
    if analysis.has_naming_patterns:
        validations.append(f"""
def validate_naming_conventions(code: CodeBase) -> ValidationResult:
    \"\"\"Valida convenciones de naming específicas de {analysis.project_name}\"\"\"
    
    naming_rules = {analysis.naming_patterns}
    violations = check_naming_compliance(code, naming_rules)
    
    return ValidationResult(
        passed=len(violations) == 0,
        violations=violations,
        recommendations=generate_naming_fixes(violations)
    )
""")
    
    # Validaciones específicas del dominio
    for domain_validation in analysis.domain_specific_validations:
        validations.append(generate_domain_validation(domain_validation))
    
    return validations
```

### **Quality Gates Personalizados**
```python
def generate_quality_gates(analysis: ProjectAnalysis) -> str:
    """Genera quality gates basados en métricas actuales del proyecto"""
    
    current_metrics = analysis.current_quality_metrics
    recommended_thresholds = calculate_optimal_thresholds(current_metrics)
    
    return f"""
QUALITY_GATES = {{
    "test_coverage": {{
        "minimum": {recommended_thresholds.min_coverage},
        "target": {recommended_thresholds.target_coverage},
        "exclude_patterns": {analysis.coverage_exclusions}
    }},
    "code_complexity": {{
        "max_cyclomatic": {recommended_thresholds.max_complexity},
        "max_cognitive": {recommended_thresholds.max_cognitive_complexity}
    }},
    "security": {{
        "max_vulnerabilities": 0,
        "allowed_severity": "medium",
        "scan_tools": {analysis.security_tools}
    }},
    "performance": {{
        "max_response_time": "{recommended_thresholds.max_response_time}",
        "max_startup_time": "{recommended_thresholds.max_startup_time}",
        "memory_limit": "{recommended_thresholds.memory_limit}"
    }},
    "dependency_management": {{
        "outdated_tolerance": "{recommended_thresholds.outdated_tolerance}",
        "security_audit": true,
        "license_compliance": {analysis.license_requirements}
    }}
}}
"""
```

## 🔄 Casos de Uso Específicos

### **Proyecto Python Backend**
```python
# Detectará automáticamente:
# - FastAPI/Flask/Django patterns
# - SQLAlchemy/Django ORM usage
# - Pytest/unittest configuration
# - Pre-commit hooks
# - Docker configuration
# - CI/CD pipelines (GitHub Actions/GitLab CI)

# Generará validaciones para:
# - API endpoint patterns
# - Database model conventions
# - Test structure and naming
# - Error handling patterns
# - Logging configuration
```

### **Proyecto React/Angular Frontend**
```javascript
// Detectará automáticamente:
// - Component patterns (functional/class)
// - State management (Redux/Context/Zustand)
// - Testing setup (Jest/Vitest/Cypress)
// - Build configuration (Webpack/Vite)
// - Styling approach (CSS Modules/Styled Components)

// Generará validaciones para:
// - Component naming conventions
// - Hook usage patterns
// - State management compliance
// - Performance optimization
// - Accessibility standards
```

### **Proyecto Fullstack**
```yaml
# Detectará automáticamente:
# - Monorepo vs multi-repo structure
# - API communication patterns
# - Shared type definitions
# - E2E testing setup
# - Deployment configuration

# Generará validaciones para:
# - Frontend/backend integration
# - API contract compliance
# - Shared code organization
# - Cross-cutting concerns
# - Deployment pipeline coordination
```

## 📊 Output del Comando

### **Análisis Detallado**
```
🔍 Análisis del Proyecto: my-awesome-project

📋 Stack Tecnológico Detectado:
├── Backend: Python (FastAPI + SQLAlchemy)
├── Frontend: React (TypeScript + Zustand)
├── Database: PostgreSQL
├── Testing: Pytest + Jest + Cypress
├── Infrastructure: Docker + GitHub Actions
└── Tools: ESLint + Prettier + Black + isort

🏗️ Patrones Arquitectónicos:
├── API Layer: RESTful with OpenAPI docs
├── Data Layer: Repository pattern with SQLAlchemy
├── Frontend: Component-based with custom hooks
├── State: Zustand with persistent stores
└── Testing: Pyramid with 80%+ coverage

📊 Métricas Actuales:
├── Test Coverage: 87% (Target: 85%+)
├── Code Complexity: 6.2 avg (Target: <8)
├── Security Score: A+ (No vulnerabilities)
├── Performance: Good (API <200ms, UI <3s)
└── Dependencies: 3 outdated, 0 vulnerable

🛡️ Code Guardian Generado:
├── 15 validation rules específicas
├── 8 quality gates personalizados
├── 12 naming convention checks
├── 6 architecture pattern validators
└── 4 security compliance checks
```

### **Guardian Personalizado Generado**
Se creará automáticamente en `.rovodev/subagents/code-guardian.md` con:

1. **Standards específicos** de tu stack tecnológico
2. **Quality gates** calibrados a tu proyecto
3. **Validaciones personalizadas** para tus patrones
4. **Security checks** según tu configuración
5. **Performance benchmarks** basados en tu aplicación
6. **Documentation standards** siguiendo tu estilo

## 🎯 Beneficios

### **Completamente Personalizado**
- ✅ **0% genérico** - Todo específico a tu proyecto
- ✅ **100% relevante** - Solo validaciones que aplican
- ✅ **Evolutivo** - Se actualiza con tu código base
- ✅ **Inteligente** - Aprende de tus decisiones

### **Immediately Actionable**
- ✅ **Quality gates realistas** basados en tu baseline
- ✅ **Validaciones enforceables** que tu equipo puede seguir
- ✅ **Recommendations factibles** para mejora incremental
- ✅ **Standards documentados** específicos a tu dominio

### **Zero Maintenance**
- ✅ **Auto-regeneración** cuando el proyecto evoluciona
- ✅ **Self-updating** conforme cambias patrones
- ✅ **No false positives** porque conoce tu contexto
- ✅ **No configuration needed** - todo automático

## 🚀 Resultado

Un code guardian completamente personalizado que conoce intimamente tu proyecto y puede aplicar automáticamente TUS estándares, TUS patrones y TUS mejores prácticas - no genéricas, sino específicamente extraídas de TU código base.