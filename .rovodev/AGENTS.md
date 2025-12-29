# Proyecto y Alcance
- Propósito: Centralizar la memoria operativa del agente para este repositorio y definir reglas por defecto para decisiones automáticas.
- Alcance: Configuración de estándares de desarrollo, flujo de trabajo, calidad y documentación. Este archivo NO contiene secretos.

# Idioma y Tono
- Responder en: Español
- Tono: Profesional, claro y conciso

# Tech Stack (personalizar)
- Backend: (indicar framework/lenguaje y versiones mínimas)
- Frontend: (indicar framework/lenguaje y versiones mínimas)
- Infra/DevOps: Docker, docker-compose
- Documentación técnica: OpenSpec en `openspec/`

# Estándares de Código (personalizar)
- Formato: Definir herramientas (ej. Prettier, Black, gofmt) y reglas
- Lint: Definir herramientas (ej. ESLint/TSLint, Flake8, golangci-lint)
- Patrones preferidos: Inyección de dependencias, separación de capas, principios SOLID
- Antipatrones prohibidos: Lógica en controladores/UI, código muerto, duplicación intencional

# Commits y Pull Requests
- Convención de commits: Conventional Commits (feat, fix, refactor, test, docs, chore, deps, config)
- Referencias: Incluir ID de ticket cuando aplique
- PRs: Describir objetivos, impacto, instrucciones de test y notas de despliegue.
- Guía de PRs y estructura detallada: ver `.rovodev/subagents/pullrequest-expert.md`
- Comando relacionado:
  - Commits: `.rovodev/commands/README.md` y `.rovodev/commands/pr/commit-and-pr.md`

# Testing y Calidad (personalizar)
- Cobertura mínima: (ej. ≥ 80%)
- Tipos de tests: unit, integration, e2e según corresponda
- Herramientas: (indicar frameworks)
- Estrategia y generación inteligente de tests: ver `.rovodev/subagents/testing-expert.md`

# Seguridad
- Reglas clave: validación de entradas, manejo de secretos vía variables de entorno, principle of least privilege
- Scans/actualizaciones de dependencias: definir frecuencia y herramientas
- Lineamientos ampliados y checklists: ver `.rovodev/subagents/security-expert.md`

# Flujo de Ramas y Releases (personalizar)
- Branching: main (protegida), develop (si aplica), feature/*, fix/*
- Integración: preferir PRs pequeños y atómicos, rebase interactivo cuando sea seguro
- Versionado: SemVer
- PR Guidance: ver `.rovodev/subagents/pullrequest-expert.md`

# Definición de Hecho (DoD)
- [ ] Tests pasan y cobertura ≥ umbral definido
- [ ] Lint/format sin errores
- [ ] Documentación relevante actualizada
- [ ] Análisis de seguridad básico sin findings críticos
- [ ] PR con checklist completo y sin TODOs críticos

# Estructura del Repo y Documentación
- Guía general del agente y capacidades: `docs/README-ROVODEV.md`
- Workflow recomendado end-to-end: `docs/WORKFLOW-GUIDE.md`
- Subagentes (catálogo y responsabilidades): `docs/SUBAGENTS-GUIDE.md`
- Comandos disponibles: `.rovodev/commands/README.md`
- OpenSpec (estándares y specs): `openspec/`
  - Estándares: `openspec/standards/` (ej. `documentation.mdc`, `spec-minima.md`, `spec-modelo-central.md`)
  - Cambios/artefactos: `openspec/changes/`

# Integraciones Externas (no secretos)
- Jira: (URL/base y project key si aplica)
- Confluence: (Space/URL base)
- CI/CD: (herramientas y enlaces)

# Glosario / Decisiones Arquitectónicas
- Mantener definiciones de dominio y decisiones clave (o enlazar ADRs/Confluence)
- Referencias de arquitectura: `.rovodev/subagents/architecture-expert.md`

# Reglas Operativas del Agente
- Jira Safety: el agente NUNCA crea/edita/transiciona/comenta issues sin permiso explícito. Puede leer libremente. Antes de modificar Jira: 1) propone, 2) espera confirmación, 3) ejecuta tras permiso.
- No duplicar documentación extensa: enlazar a:
  - `docs/README-ROVODEV.md` (visión general y comandos)
  - `docs/WORKFLOW-GUIDE.md` (flujo de trabajo)
  - `docs/SUBAGENTS-GUIDE.md` (subagentes)
  - `.rovodev/commands/*` (instrucciones de cada comando)
  - `openspec/standards/*` (estándares de documentación)
- Defaults seguros: si falta una sección, seguir mejores prácticas y estándares del repo.

# Cómo usa esto el agente
- Los comandos como `implement-from-jira`, `evolve-project`, `plan-ticket`, `generate-code-guardian` y `update-docs` leerán estas preferencias y enlazarán a la documentación indicada en lugar de duplicarla.
- El subagente `openspec-expert` guiará la ubicación de artefactos según `openspec/` (ver `.rovodev/subagents/openspec-expert.md`).
- El subagente `commit-expert` aplicará Conventional Commits y organización de historial (ver `.rovodev/subagents/commit-expert.md`).

# TODOs de adaptación inicial (rellenar ahora)
- [ ] Completar Tech Stack y versiones
- [ ] Precisar herramientas de lint/format/test por lenguaje
- [ ] Definir cobertura mínima y matrices de CI
- [ ] Completar URLs de Jira/Confluence/CI
- [ ] Ajustar branching y DoD a prácticas del equipo

---

Notas:
- Mantener este archivo corto y accionable. Detalles extensos se documentan en los archivos enlazados.
- No incluir secretos ni credenciales.
