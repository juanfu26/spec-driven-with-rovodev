# OpenSpec: Finalize

Tras el merge a core funcional, finaliza la spec como documento histórico y referencia técnica.

## Objetivo
- Marcar la spec como `finalized`.
- Añadir referencias a PRs fusionadas y notas finales.

## Uso
```bash
rovodev openspec-finalize SCRUM-123 "2025-12-22_SCRUM-123_titulo-corto.md" --pr "https://bitbucket/.../pull-requests/123"
```
Parámetros:
- ticket_id: ID de Jira (obligatorio)
- filename: nombre del archivo en `/wiki/openspec/changes/` (obligatorio)
- pr: URL de PR final fusionada (opcional)

## Pasos
1) Abrir `/wiki/openspec/changes/<filename>`.
2) status: finalized.
3) links.related_prs: agregar PRs fusionadas.
4) Añadir sección “Resumen de implementación” si aplica.

Resultado: Documento histórico de referencia técnica.

## CLI OpenSpec (opcional y recomendado)
```bash
# Lint final del documento
openspec lint --file "openspec/changes/${FILENAME}" || true

# Actualizar índice principal
openspec index build --root openspec --out openspec/index.md || true
```
