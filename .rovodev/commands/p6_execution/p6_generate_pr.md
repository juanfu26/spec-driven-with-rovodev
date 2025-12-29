# 🧩 Generate PR (solo PR)

Comando para generar únicamente el contenido de una Pull Request en un archivo markdown listo para copiar/pegar manualmente en Bitbucket (web). Este comando NO crea PRs automáticamente ni modifica JIRA.

## 🎯 Objetivo

- Analizar los cambios de la rama actual respecto a su punto de origen (main/master/develop) usando git.
- Obtener el resumen de commits y archivos modificados relevantes para el ticket actual.
- Generar un archivo `openspec/changes/pr-[TICKET].md` con una plantilla clara y accionable (si existe WIKI_ROOT se puede además generar documentación relacionada en `$WIKI_ROOT/openspec/changes`).
- Facilitar la creación manual de la PR copiando y pegando el contenido.

## 🧠 Subagente utilizado

- Pull Request Expert: `.rovodev/subagents/pullrequest-expert.md`

## 🚀 Uso

```bash
# Genera sólo el archivo de PR a partir de diferencias de la rama actual
rovodev generate-pr PROJ-123
```

Parámetros:
- ticket_id: ID del ticket de Jira (obligatorio)

## 🔍 Detección del punto de origen de la rama

El origen se determina en este orden:
1. Si existe `origin/main`, usar `origin/main`
2. Si no, si existe `origin/master`, usar `origin/master`
3. Si no, si existe `origin/develop`, usar `origin/develop`

Comandos de apoyo (guía):
- `git fetch --all --prune`
- `git rev-parse --abbrev-ref HEAD` → rama actual
- `git branch -r | grep -E "origin/(main|master|develop)"` → ramas base disponibles
- `git merge-base <base> HEAD` → punto común de divergencia
- `git log --oneline <merge_base>..HEAD` → commits a incluir
- `git diff --name-status <merge_base>..HEAD` → archivos cambiados y tipo de cambio

## 🧱 Plantilla de PR (markdown legible)

Usa exactamente la siguiente estructura. Completa con información derivada de commits, diffs y contexto del ticket.

---
# [PROJ-123] Título descriptivo de la PR

Enlace a ticket: https://jira.tu-org.tld/browse/PROJ-123

## 1. Objetivo de la tarea
- Qué problema resuelve y por qué era necesario
- Breve resumen del alcance y los criterios de aceptación cubiertos

## 2. Implementación esenciales (requeridos por la tarea)
- Cambios estrictamente necesarios para cumplir el objetivo del ticket
- Puntos técnicos clave (APIs, modelos, migraciones, reglas, flujos)
- Decisiones de diseño relevantes

## 3. Cambios auxiliares (no esenciales para la tarea)
- Refactors, mejoras de legibilidad/organización
- Ajustes de tooling/configuración no esenciales
- Tests o documentación extra no requeridos

## 4. Resumen de impacto
- Breaking changes y su mitigación
- Impacto en rendimiento, seguridad, confiabilidad
- Cambios en APIs/contratos y compatibilidad hacia atrás
- Impacto en despliegue/infra/feature flags

## 5. Testing checklist (validación funcional)
- [ ] Casos de uso principales funcionan según lo esperado
- [ ] Casos borde relevantes verificados
- [ ] Tests automáticos agregados/actualizados y pasando
- [ ] Verificación manual básica del flujo afectado
- [ ] Validación de rendimiento/seguridad si aplica

## 6. Impactos en otras partes de la aplicación
- Áreas afectadas explícitamente (módulos/servicios/páginas)
- Posibles impactos implícitos o laterales a monitorear
- Riesgos conocidos y plan de rollback

## Archivos relevantes y cambios por categoría (derivados de git)
- feat: lista de archivos y breve propósito
- fix: lista de archivos y breve propósito
- refactor: lista de archivos y breve propósito
- test: lista de archivos y breve propósito
- docs/config/deps: lista de archivos y breve propósito

## Resumen de commits (git log entre merge-base y HEAD)
- <hash corto> type(scope?): descripción
- ...

## Guía para reviewers
- Áreas que requieren atención especial y por qué
- Cómo probar localmente (pasos concisos)
- Criterios para aceptar/rechazar cambios

## Notas de despliegue
- Pre-deployment: migraciones, configuraciones, coordinaciones
- Post-deployment: métricas a observar, alertas, validaciones
- Plan de rollback si es necesario
---

## 🛠️ Integración con OpenSpec CLI (opcional)
Si tienes el repo de wiki montado (WIKI_ROOT) y deseas registrar un resumen vinculado a la spec:

```bash
# Validar y actualizar índice en el repo de wiki
cd "$WIKI_ROOT" && \
  openspec lint --path openspec/changes || true && \
  openspec index build --root openspec --out openspec/index.md || true
```

## 🧭 Proceso paso a paso

1) Identificar rama actual y base
- Detecta `base = origin/main | origin/master | origin/develop` según disponibilidad
- `merge_base = git merge-base base HEAD`

2) Recopilar información con git
- Commits: `git log --oneline ${merge_base}..HEAD`
- Archivos: `git diff --name-status ${merge_base}..HEAD`
- Opcional: extraer scopes/types de mensajes si sigues conventional commits

3) Construir contenido con pullrequest-expert
- Estructura el contenido siguiendo la plantilla exacta anterior
- Completa secciones con los datos de commits/diffs y el contexto del ticket

4) Materializar en archivo
- Crear `openspec/changes/pr-[TICKET].md`
- Título del documento con [TICKET]
- Validar que el archivo se guardó correctamente

5) Crear PR manualmente
- Abre la web de Bitbucket → Nueva Pull Request
- Copia el contenido del archivo y pégalo como descripción
- Ajusta reviewers/labels/target branch según política del repo

## ✅ Resultado esperado
- Archivo `openspec/changes/pr-[TICKET].md` listo para copiar/pegar
- Contenido consistente y legible que acelera el review
- Sin acciones automáticas en remotos ni en Jira
