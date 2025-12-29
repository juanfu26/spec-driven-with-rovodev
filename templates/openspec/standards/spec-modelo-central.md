# OpenSpec - Cambio en modelo de datos central (plantilla)

Usar cuando la tarea afecta el dominio de datos central. Requiere impact list obligatoria.

---
id: [JIRA-ID]
title: [Modelo central] - [Breve título]
status: validated
created_at: [YYYY-MM-DD]
authors: [tu-usuario]
domains: [backend, data]
links:
  jira: https://jira.tu-org/browse/[JIRA-ID]
  confluence: [opcional_url]
  related_prs: []
data_model_change: true
---

## Alcance del cambio en el modelo
- Entidades afectadas
- Relaciones nuevas/alteradas
- Reglas de negocio relevantes

## Impact list (obligatoria)
- APIs/servicios afectados
- Migraciones necesarias
- Backfills o scripts de mantenimiento
- Compatibilidad hacia atrás (sí/no) y estrategia
- Performance/índices

## Migraciones
- Plan y orden de migraciones
- Validaciones pre y post
- Rollback plan

## Testing del modelo
- Tests unitarios/contract tests
- Datos de prueba
- Métricas esperadas
