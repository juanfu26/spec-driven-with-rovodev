# OpenSpec: Audit Wiki

Audita una wiki con OpenSpec para verificar consistencia y detectar problemas comunes. No modifica contenido, sólo reporta.

## Objetivo
- Verificar existencia de `openspec/standards` y `openspec/changes`
- Revisar naming y frontmatter mínimo de cada spec
- Sugerir índices (por estado, fecha, ticket)

## Uso
```bash
rovodev openspec-audit-wiki
```
Precondiciones:
- `WIKI_ROOT=/wiki` montado

## Validaciones
- Estructura de carpetas
- Archivos `.keep`
- Nombres `YYYY-MM-DD_[JIRA]_[slug].md`
- Frontmatter mínimo: `id, title, status, created_at, authors, domains, links, validation`
- Estados válidos: `draft|validated|finalized`

## Informe
- Lista de specs OK
- Lista de specs con problemas (naming/frontmatter/estado)
- Recomendaciones de remediación

## CLI OpenSpec (opcional y recomendado)
```bash
# Auditoría / Lint sobre la carpeta de specs
openspec lint --path openspec/changes --format json > openspec/audit-report.json || true

# Regenerar índice después de la auditoría
openspec index build --root openspec --out openspec/index.md || true
```
