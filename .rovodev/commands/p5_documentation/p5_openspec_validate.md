# OpenSpec: Validate

Marca una spec como validada (checkpoint humano) y registra reviewers/checkpoints. No valida implementación: sólo alcance, impactos y riesgo.

## Objetivo
- Cambiar `status: draft` → `status: validated` en el frontmatter.
- Completar `validation.reviewers` y `validation.checkpoints`.

## Uso
```bash
rovodev openspec-validate SCRUM-123 "2025-12-22_SCRUM-123_titulo-corto.md" --reviewers "backend_ref,frontend_ref,infra_ref,negocio_ref"
```
Parámetros:
- ticket_id: ID de Jira (obligatorio)
- filename: nombre del archivo en `/wiki/openspec/changes/` (obligatorio)
- reviewers: coma-separado (opcional)

## Pasos
1) Abrir `/wiki/openspec/changes/<filename>`.
2) En el frontmatter: `status: validated`.
3) Añadir reviewers si se proporcionan.
4) Confirmar que secciones mínimas existen.

Resultado: Spec validada. Sin spec validada → no ejecución automática.

## CLI OpenSpec (opcional y recomendado)
```bash
# Lint del archivo validado
openspec lint --file "openspec/changes/${FILENAME}" || true

# Reconstruir índice
openspec index build --root openspec --out openspec/index.md || true
```
