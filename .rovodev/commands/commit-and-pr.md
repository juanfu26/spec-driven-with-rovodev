# 🔀 Commit and PR

Comando que ejecuta commit inteligente de los cambios implementados y crea automáticamente un Pull Request con descripción completa, contexto técnico y referencias cruzadas con Jira.

## 🎯 Objetivo

Finalizar el ciclo de implementación con commit y PR profesionales:
1. **Analizar** cambios implementados y generar commit messages descriptivos
2. **Ejecutar** commits organizados por categoría de cambios
3. **Crear** Pull Request con descripción técnica completa
4. **Vincular** PR con ticket de Jira automáticamente
5. **Configurar** reviewers y labels apropiados
6. **Actualizar** estado del ticket en Jira

## 🚀 Uso

```bash
# Commit y PR completo
rovodev commit-and-pr PROJ-123

# PR con reviewers específicos
rovodev commit-and-pr PROJ-123 --reviewers=john,mary --team=backend

# Commit por partes organizadas
rovodev commit-and-pr PROJ-123 --organized-commits

# Draft PR para review preliminar
rovodev commit-and-pr PROJ-123 --draft
```

## 📋 Parámetros

- `ticket_id`: ID del ticket de Jira (obligatorio)
- `--reviewers`: Lista de reviewers separados por coma
- `--team`: Equipo de desarrollo (backend/frontend/fullstack)
- `--organized-commits`: Crear commits separados por categoría
- `--draft`: Crear PR como draft
- `--auto-merge`: Configurar auto-merge si reviews pasan
- `--skip-ci`: Saltar CI para draft PRs

## 🔍 Análisis Inteligente de Cambios

### **1. Categorización de Cambios**
```python
def analyze_and_categorize_changes() -> ChangesAnalysis:
    """Analiza cambios y los categoriza para commits organizados"""
    
    changed_files = git_manager.get_changed_files()
    
    categories = {
        'features': [],      # Nuevas funcionalidades
        'bugfixes': [],      # Corrección de bugs
        'refactor': [],      # Refactoring de código
        'tests': [],         # Tests y validación
        'docs': [],          # Documentación
        'config': [],        # Configuración y setup
        'dependencies': []   # Cambios en dependencias
    }
    
    for file_path in changed_files:
        file_analysis = analyze_file_changes(file_path)
        category = classify_change_category(file_analysis)
        categories[category].append({
            'file': file_path,
            'analysis': file_analysis,
            'impact': assess_change_impact(file_analysis)
        })
    
    return ChangesAnalysis(
        categories=categories,
        total_files=len(changed_files),
        complexity_score=calculate_overall_complexity(categories),
        summary=generate_changes_summary(categories)
    )
```

### **2. Generación de Commit Messages**
```python
def generate_commit_messages(analysis: ChangesAnalysis, ticket_info: TicketInfo) -> List[CommitMessage]:
    """Genera commit messages descriptivos siguiendo convenciones"""
    
    commit_messages = []
    
    # Commit principal con feature
    if analysis.categories['features']:
        feature_message = generate_feature_commit_message(
            features=analysis.categories['features'],
            ticket=ticket_info
        )
        commit_messages.append(feature_message)
    
    # Commit de refactoring si aplica
    if analysis.categories['refactor']:
        refactor_message = generate_refactor_commit_message(
            refactors=analysis.categories['refactor'],
            ticket=ticket_info
        )
        commit_messages.append(refactor_message)
    
    # Commit de tests
    if analysis.categories['tests']:
        tests_message = generate_tests_commit_message(
            tests=analysis.categories['tests'],
            coverage_info=get_coverage_info()
        )
        commit_messages.append(tests_message)
    
    # Commit de documentación
    if analysis.categories['docs']:
        docs_message = generate_docs_commit_message(
            docs=analysis.categories['docs'],
            ticket=ticket_info
        )
        commit_messages.append(docs_message)
    
    return commit_messages

def generate_feature_commit_message(features: List[FileChange], ticket: TicketInfo) -> CommitMessage:
    """Genera commit message para features siguiendo conventional commits"""
    
    # Detectar scope principal
    main_scope = detect_main_scope(features)
    
    # Generar título descriptivo
    title = f"feat({main_scope}): {ticket.title_normalized}"
    
    # Generar cuerpo descriptivo
    body_lines = [
        f"Implements {ticket.id}: {ticket.summary}",
        "",
        "Changes made:",
    ]
    
    for feature in features:
        impact_description = describe_change_impact(feature)
        body_lines.append(f"- {impact_description}")
    
    # Añadir información técnica
    body_lines.extend([
        "",
        "Technical details:",
        f"- Files modified: {len(features)}",
        f"- Complexity impact: {calculate_complexity_impact(features)}",
        f"- Performance impact: {assess_performance_impact(features)}"
    ])
    
    # Footer con referencias
    footer_lines = [
        f"Closes {ticket.id}",
        f"Relates-to: {ticket.epic_id}" if ticket.epic_id else "",
    ]
    
    return CommitMessage(
        title=title,
        body="\n".join(body_lines),
        footer="\n".join(filter(None, footer_lines))
    )
```

### **3. Ejecución de Commits Organizados**
```python
def execute_organized_commits(commit_messages: List[CommitMessage]) -> CommitResults:
    """Ejecuta commits de manera organizada"""
    
    commit_results = []
    
    for commit_msg in commit_messages:
        # Preparar archivos para este commit específico
        relevant_files = identify_files_for_commit(commit_msg)
        
        # Stage files
        git_manager.stage_files(relevant_files)
        
        # Crear commit
        commit_result = git_manager.commit(
            message=format_full_commit_message(commit_msg),
            verify=True  # Ejecutar pre-commit hooks
        )
        
        commit_results.append(commit_result)
        
        # Validar que commit fue exitoso
        if not commit_result.success:
            raise CommitError(f"Failed to commit: {commit_result.error}")
    
    return CommitResults(
        commits=commit_results,
        total_commits=len(commit_results),
        branch=git_manager.get_current_branch()
    )
```

## 📝 Generación de Pull Request

### **1. Análisis del PR Context**
```python
def generate_pr_context(ticket_info: TicketInfo, implementation: ImplementationSummary) -> PRContext:
    """Genera contexto completo para el PR"""
    
    # Análisis de impacto
    impact_analysis = {
        'breaking_changes': detect_breaking_changes(implementation),
        'database_changes': detect_database_changes(implementation),
        'api_changes': detect_api_changes(implementation),
        'frontend_changes': detect_frontend_changes(implementation),
        'infrastructure_changes': detect_infrastructure_changes(implementation)
    }
    
    # Métricas de calidad
    quality_metrics = {
        'test_coverage': get_test_coverage_summary(),
        'performance_impact': get_performance_summary(),
        'security_scan': get_security_scan_summary(),
        'code_complexity': get_complexity_summary()
    }
    
    # Información de deployment
    deployment_info = {
        'deployment_notes': generate_deployment_notes(implementation),
        'rollback_plan': generate_rollback_plan(implementation),
        'monitoring_points': identify_monitoring_points(implementation)
    }
    
    return PRContext(
        ticket=ticket_info,
        impact=impact_analysis,
        quality=quality_metrics,
        deployment=deployment_info,
        implementation_summary=implementation
    )
```

### **2. Template de PR Descriptivo**
```markdown
# 🎯 {{ ticket.title }}

**Ticket**: [{{ ticket.id }}]({{ ticket.url }}) | **Type**: {{ ticket.type }} | **Priority**: {{ ticket.priority }}

## 📋 Summary

{{ ticket.enhanced_description }}

### 🎯 Goals Achieved
{{ #each ticket.acceptance_criteria }}
- [x] {{ this }}
{{ /each }}

## 🏗️ Technical Implementation

### Architecture Changes
{{ #if impact.architecture_changes }}
{{ impact.architecture_changes }}
{{ else }}
No architecture changes in this PR.
{{ /if }}

### API Changes
{{ #if impact.api_changes }}
**⚠️ API Changes Detected:**
{{ #each impact.api_changes }}
- **{{ this.endpoint }}**: {{ this.change_type }} - {{ this.description }}
{{ /each }}

**Backward Compatibility**: {{ impact.backward_compatible }}
{{ else }}
No API changes in this PR.
{{ /if }}

### Database Changes
{{ #if impact.database_changes }}
**⚠️ Database Changes:**
{{ #each impact.database_changes }}
- **{{ this.type }}**: {{ this.description }}
{{ /each }}

**Migration Required**: {{ impact.requires_migration }}
{{ else }}
No database changes in this PR.
{{ /if }}

## 📊 Quality Metrics

### Test Coverage
- **Overall Coverage**: {{ quality.test_coverage.overall }}% ({{ quality.test_coverage.change }})
- **New Code Coverage**: {{ quality.test_coverage.new_code }}%
- **Tests Added**: {{ quality.test_coverage.tests_added }} ({{ quality.test_coverage.test_types }})

### Performance Impact
- **Performance Tests**: {{ quality.performance.status }}
- **Response Time Impact**: {{ quality.performance.response_time_impact }}
- **Memory Usage**: {{ quality.performance.memory_impact }}

### Security
- **Security Scan**: {{ quality.security.status }}
- **Vulnerabilities**: {{ quality.security.vulnerabilities_count }}
- **Security Score**: {{ quality.security.score }}

### Code Quality
- **Complexity Score**: {{ quality.complexity.average }} (target: < {{ quality.complexity.target }})
- **Maintainability**: {{ quality.complexity.maintainability_score }}
- **Technical Debt**: {{ quality.complexity.debt_impact }}

## 🔍 Files Changed

### Core Implementation ({{ implementation.core_files.length }} files)
{{ #each implementation.core_files }}
- `{{ this.path }}` - {{ this.change_description }}
{{ /each }}

### Tests ({{ implementation.test_files.length }} files)
{{ #each implementation.test_files }}
- `{{ this.path }}` - {{ this.coverage_contribution }}
{{ /each }}

### Documentation ({{ implementation.doc_files.length }} files)
{{ #each implementation.doc_files }}
- `{{ this.path }}` - {{ this.update_type }}
{{ /each }}

## 🚀 Deployment Notes

### Pre-deployment Checklist
{{ #each deployment.pre_deployment }}
- [ ] {{ this }}
{{ /each }}

### Post-deployment Monitoring
{{ #each deployment.monitoring_points }}
- **{{ this.metric }}**: {{ this.description }}
{{ /each }}

### Rollback Plan
{{ #if deployment.rollback_required }}
**Rollback Steps**:
{{ #each deployment.rollback_steps }}
1. {{ this }}
{{ /each }}
{{ else }}
No special rollback steps required - standard revert process applies.
{{ /if }}

## 👥 Review Guidelines

### Focus Areas for Reviewers
{{ #each review.focus_areas }}
- **{{ this.area }}**: {{ this.description }}
{{ /each }}

### Testing Instructions
{{ #if review.testing_instructions }}
{{ #each review.testing_instructions }}
1. {{ this }}
{{ /each }}
{{ else }}
Standard testing process applies - run full test suite.
{{ /if }}

## 📎 Related Links

- **Jira Ticket**: [{{ ticket.id }}]({{ ticket.url }})
- **Technical Specs**: [Implementation Spec]({{ specs.implementation_url }})
- **API Documentation**: [Updated API Docs]({{ specs.api_docs_url }})
{{ #if specs.confluence_page }}
- **Confluence**: [Technical Documentation]({{ specs.confluence_page }})
{{ /if }}

---

**Generated by RovoDev** | **Implementation Time**: {{ implementation.time_taken }} | **Complexity**: {{ implementation.complexity_score }}/10
```

### **3. Configuración Automática del PR**
```python
def create_pull_request(pr_context: PRContext, options: PROptions) -> PullRequest:
    """Crea PR con configuración automática completa"""
    
    # Generar descripción del PR
    pr_description = render_pr_template(pr_context)
    
    # Determinar reviewers automáticamente
    reviewers = determine_reviewers(
        changed_files=pr_context.implementation.changed_files,
        team=options.team,
        manual_reviewers=options.reviewers
    )
    
    # Configurar labels automáticos
    labels = generate_automatic_labels(pr_context)
    
    # Crear PR
    pr = git_platform.create_pull_request(
        title=f"[{pr_context.ticket.id}] {pr_context.ticket.title}",
        description=pr_description,
        source_branch=git_manager.get_current_branch(),
        target_branch=determine_target_branch(pr_context),
        reviewers=reviewers,
        labels=labels,
        draft=options.draft,
        auto_merge=options.auto_merge and not pr_context.has_breaking_changes
    )
    
    return pr

def determine_reviewers(changed_files: List[str], team: str, manual_reviewers: List[str]) -> List[str]:
    """Determina reviewers apropiados basado en archivos cambiados"""
    
    auto_reviewers = []
    
    # Reviewers por área de código
    if any('backend' in f or 'api' in f for f in changed_files):
        auto_reviewers.extend(get_backend_reviewers())
    
    if any('frontend' in f or 'ui' in f for f in changed_files):
        auto_reviewers.extend(get_frontend_reviewers())
    
    if any('database' in f or 'migration' in f for f in changed_files):
        auto_reviewers.extend(get_database_reviewers())
    
    # Combinar con reviewers manuales
    all_reviewers = list(set(auto_reviewers + (manual_reviewers or [])))
    
    # Limitar número de reviewers
    return all_reviewers[:4]  # Máximo 4 reviewers
```

## 🔄 Actualización Final de Jira

### **Estado y Links**
```python
def update_jira_with_pr_info(ticket_id: str, pr: PullRequest) -> JiraUpdate:
    """Actualiza ticket de Jira con información del PR"""
    
    jira_updates = {
        'status': 'Code Review',
        'assignee': pr.author,
        'labels': existing_labels + ['in-review', 'has-pr'],
        'development_info': {
            'pull_requests': [pr.url],
            'commits': [commit.sha for commit in pr.commits],
            'branch': pr.source_branch
        },
        'custom_fields': {
            'pr_url': pr.url,
            'implementation_complexity': pr.context.complexity_score,
            'review_focus_areas': pr.review_guidelines.focus_areas
        }
    }
    
    # Comentario de finalización
    completion_comment = f"""
🔀 **Pull Request Creado**

📋 **PR Details**:
- **URL**: {pr.url}
- **Reviewers**: {', '.join(pr.reviewers)}
- **Files Changed**: {len(pr.changed_files)}
- **Complexity**: {pr.context.complexity_score}/10

📊 **Quality Summary**:
- ✅ Tests: {pr.context.quality.test_coverage.overall}% coverage
- ✅ Security: {pr.context.quality.security.status}
- ✅ Performance: {pr.context.quality.performance.status}
- ✅ Documentation: Updated

🚀 **Ready for Review**:
El ticket ha sido implementado completamente y está listo para code review.

**Next Steps**: 
1. Code review por parte del equipo
2. Merge del PR tras aprobación
3. Deploy automático a staging
4. Validación en staging
5. Deploy a producción
"""
    
    jira_client.add_comment(ticket_id, completion_comment)
    jira_client.update_ticket(ticket_id, jira_updates)
    
    return JiraUpdate(success=True, ticket_url=get_ticket_url(ticket_id))
```

## 📊 Resumen Final del Proceso

### **Commit Summary**
```bash
🔀 Commits Creados para PROJ-123

✅ feat(auth): implement improved authentication flow
   📁 8 files changed (+245, -67)
   🎯 Core feature implementation

✅ test(auth): add comprehensive test suite  
   📁 5 files changed (+189, -0)
   🧪 Coverage: 87% (target: 85%)

✅ docs(auth): update API and user documentation
   📁 4 files changed (+156, -23)
   📚 Complete documentation update

Total: 17 files changed, 590 additions, 90 deletions
Branch: feature/PROJ-123-auth-improvement
```

### **PR Creation Confirmation**
```bash
🚀 Pull Request Creado Exitosamente

📋 PR Information:
├── URL: https://github.com/company/project/pull/456
├── Title: [PROJ-123] Implement improved authentication flow
├── Target: main ← feature/PROJ-123-auth-improvement
├── Reviewers: john.doe, mary.smith, tech-lead
├── Labels: enhancement, backend, needs-review
└── Auto-merge: Enabled (after 2 approvals)

📊 Quality Gates: All Passed ✅
├── Tests: 23/23 passed (87% coverage)
├── Security: No vulnerabilities found
├── Performance: P95 < 2s target met
└── Documentation: Complete and updated

🎯 Next Steps:
1. Reviewers will be notified automatically
2. CI/CD pipeline will run validation
3. Auto-merge after approved reviews
4. Automatic staging deployment
```

## 🎯 Resultado

Finalización profesional del ciclo de desarrollo con:
- ✅ **Commits organizados** con mensajes descriptivos siguiendo conventional commits
- ✅ **Pull Request completo** con contexto técnico exhaustivo
- ✅ **Reviewers automáticos** basados en archivos modificados
- ✅ **Quality gates** validados y documentados en PR
- ✅ **Jira integrado** con estado actualizado y links cruzados
- ✅ **Documentation completa** para reviewers y deployment
- ✅ **Monitoring setup** para post-deployment tracking

El desarrollo está completamente finalizado y listo para review profesional.