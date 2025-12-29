# OpenSpec: Draft

Genera una spec mínima (draft) para un ticket Jira en el repositorio de wiki, siguiendo la metodología de planificación rápida (10–20 min).

## Objetivo
- Crear un borrador pequeño, claro y accionable en `/wiki/openspec/changes/[YYYY-MM-DD]_[JIRA]_[slug].md`.
- Evitar bloquear la ejecución: OpenSpec = intención técnica (no duplicar Confluence).

## Uso
```bash
rovodev openspec-draft SCRUM-123 "titulo-corto"
```
Parámetros:
- ticket_id: ID de Jira (obligatorio)
- slug: identificador corto para el archivo (obligatorio)

Precondiciones:
- `WIKI_ROOT=/wiki` montado (auto-detectado por run-rovodev.sh si el repo hermano `<repo>-wiki` existe).

## Plantilla que se generará
Incluye frontmatter y secciones mínimas:

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

## Objetivo funcional (1–2 frases)

## Cambios esperados
- Modelo de datos central (si aplica):
- Módulos afectados:
- No-go zones (qué NO tocar):

## Impacto por capa
- Backend:
- Frontend (Angular):
- Infra (docker-compose, tooling):

## Riesgos conocidos (si aplica)

## Criterios de aceptación (resumen)

## Pasos
1) Determinar ruta final: `/wiki/openspec/changes/[fecha]_[JIRA]_[slug].md`.
2) Crear el archivo con la plantilla anterior.
3) Rellenar secciones mínimas en 10–20 minutos.

Resultado: Spec mínima (draft) lista para validación.

## CLI OpenSpec (opcional y recomendado)
Ejecutar dentro del repo de wiki (`$WIKI_ROOT` → `/wiki`):

```bash
# Validar plantillas
openspec lint --file openspec/standards/spec-minima.md || true

# Crear el borrador desde plantilla (si tu versión soporta scaffold)
openspec scaffold \
  --template openspec/standards/spec-minima.md \
  --out "openspec/changes/$(date +%F)_${TICKET_ID}_${SLUG}.md" || true

# Actualizar índice
openspec index build --root openspec --out openspec/index.md || true
```
