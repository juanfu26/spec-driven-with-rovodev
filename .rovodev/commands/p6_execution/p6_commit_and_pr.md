# 🔀 Commit and PR

Comando para: 1) organizar y ejecutar commits profesionales, y 2) generar el contenido de una Pull Request en un archivo markdown listo para copiar/pegar manualmente en Bitbucket (vía web). Este comando NO ejecuta acciones automáticas contra GitHub/Bitbucket/Jira.

## 🎯 Objetivo

- Organizar y realizar commits atómicos y descriptivos (convencional commits) con ayuda del subagente commit-expert.
- Producir un archivo markdown con la PR completa y legible, para copiar/pegar manualmente en Bitbucket.
- Estandarizar la plantilla de PR con secciones claras para facilitar el code review.

## 🚀 Uso

```bash
# Ejecuta commits organizados y genera archivo de PR
rovodev commit-and-pr PROJ-123
```

Parámetros:
- ticket_id: ID del ticket de Jira (obligatorio), por ejemplo "PROJ-123".

## 📂 Ubicación del archivo a generar (PR)

El contenido de la Pull Request se genera SIEMPRE en un archivo local en el repo, que podrás abrir y copiar para pegar en la web de Bitbucket.

- Ruta: `openspec/changes/pr-[TICKET].md`
- Ejemplo: `openspec/changes/pr-PROJ-123.md`

Notas importantes:
- No se crea automáticamente ninguna PR en Bitbucket/GitHub. El objetivo es SOLO generar el texto de la PR para copiar/pegar manualmente.
- Si existe la variable de entorno WIKI_ROOT y está montada en el contenedor, la documentación de specs relacionada puede generarse en `$WIKI_ROOT/openspec/changes` mientras que el contenido de PR se mantiene en el repo de código.
- Si el proyecto usa otra convención de ubicación, ajústala explícitamente aquí antes de ejecutar.

## 🧠 Subagentes involucrados

- Subagente de commits: commit-expert (ver `.rovodev/subagents/commit-expert.md`).
- Subagente de Pull Requests: pullrequest-expert (ver `.rovodev/subagents/pullrequest-expert.md`).

Ambos se usan de forma consultiva para generar estructura, contenido y orden; la ejecución de git y la creación de PR es manual/local.

## 🧩 Flujo del comando

1) Commits organizados
- Analiza los cambios y agrupa por tipo (feat, fix, refactor, test, docs, config, deps) con el commit-expert.
- Crea commits atómicos siguiendo el orden lógico (config/deps → refactor base → features → fixes → tests → docs).
- Usa mensajes de conventional commits con contexto y referencia al ticket.

2) Generación del archivo de PR
- Con ayuda del pullrequest-expert, construye el contenido completo de PR siguiendo la plantilla estandarizada.
- Materializa el contenido en `openspec/changes/pr-[TICKET].md`.
- Abre el archivo y copia/pega manualmente su contenido en la interfaz web de Bitbucket al crear la PR.

## 🛠️ Integración con OpenSpec CLI (opcional)
Si WIKI_ROOT está disponible, puedes validar y actualizar índices de la wiki post-generación de PR:

```bash
cd "$WIKI_ROOT" && \
  openspec lint --path openspec/changes || true && \
  openspec index build --root openspec --out openspec/index.md || true
```

## 🧱 Plantilla de PR (markdown legible)

Al generar la PR, usa exactamente la siguiente estructura y encabezados. Completa cada apartado con la información obtenida de los commits, del código y del contexto del ticket.

---
# [PROJ-123] Título descriptivo de la PR

Enlace a ticket: https://jira.tu-org.tld/browse/PROJ-123

## 1. Objetivo de la tarea
- Qué problema resuelve y por qué era necesario
- Breve resumen del alcance y los criterios de aceptación cubiertos

## 2. Implementación esenciales (requeridos por la tarea)
- Cambios estrictamente necesarios para cumplir el objetivo del ticket
- Puntos técnicos clave (APIs, modelos, migraciones, reglas, flujos)
- Notas sobre decisiones de diseño relevantes

## 3. Cambios auxiliares (no esenciales para la tarea)
- Refactors, mejoras de legibilidad, organización de carpetas
- Ajustes de tooling/configuración que no son parte del objetivo principal
- Tests o documentación adicional no estrictamente requerida

## 4. Resumen de impacto
- Breaking changes (si los hay) y su mitigación
- Impacto en rendimiento, seguridad, confiabilidad
- Cambios en APIs/contratos y compatibilidad hacia atrás
- Impacto en despliegue/infra y feature flags si aplica

## 5. Testing checklist (validación funcional)
- [ ] Casos de uso principales del ticket funcionan según lo esperado
- [ ] Casos borde relevantes verificados
- [ ] Tests automáticos agregados/actualizados y pasando
- [ ] Verificación manual básica del flujo afectado
- [ ] Validación de rendimiento si aplica
- [ ] Validación de seguridad si aplica

## 6. Impactos en otras partes de la aplicación
- Áreas afectadas explícitamente (módulos/servicios/páginas)
- Posibles impactos implícitos o laterales a monitorear
- Riesgos conocidos y plan de rollback si fuera necesario

## Archivos relevantes y cambios por categoría
- feat: lista de archivos y breve propósito
- fix: lista de archivos y breve propósito
- refactor: lista de archivos y breve propósito
- test: lista de archivos y breve propósito
- docs/config/deps: lista de archivos y breve propósito

## Guía para reviewers
- Áreas que requieren atención especial y por qué
- Cómo probar localmente (pasos concisos)
- Criterios para aceptar/rechazar cambios

## Notas de despliegue
- Pre-deployment: migraciones, configuraciones, coordinaciones
- Post-deployment: métricas a observar, alertas, validaciones
- Plan de rollback si es necesario
---

Consejo: Mantén los textos claros, escaneables y accionables. Usa listas y subtítulos.

## 🔍 Pasos detallados

### Paso 1: Commits organizados (commit-expert)
1. Analiza todos los cambios y clasifica por tipo.
2. Propón agrupación atómica por funcionalidad/unidad de trabajo.
3. Define el orden lógico de commits.
4. Genera títulos y cuerpos de commit (conventional commits) con referencia a [TICKET].
5. Ejecuta:
   - `git add <archivos del grupo>`
   - `git commit -m "<type>: <resumen>" -m "<cuerpo>" -m "Refs: [TICKET]"`

Validación:
- Sin archivos pendientes tras el último commit.
- Mensajes consistentes y trazables.

### Paso 2: Contenido del PR (pullrequest-expert)
1. Resume los commits y cambios relevantes para el ticket.
2. Estructura el contenido usando la plantilla anterior.
3. Incluye análisis de impacto, métricas/validaciones y guía de testing.

### Paso 3: Materialización a archivo
1. Determina ruta final: `openspec/changes/pr-[TICKET].md`.
2. Crea el archivo con el contenido completo y el título con [TICKET].
3. Verifica que el archivo se guardó correctamente.

### Paso 4: Creación manual del PR en Bitbucket
1. Abre Bitbucket en tu repositorio y crea una nueva PR.
2. Copia el contenido de `openspec/changes/pr-[TICKET].md` y pégalo como descripción.
3. Ajusta reviewers, labels y target branch manualmente según la política del repo.
4. Publica la PR (puede ser en draft si así lo define el proceso).

## 📌 Consideraciones
- No se realizan cambios en Jira de forma automática. Si deseas actualizar el estado, hazlo manualmente o solicita automatización aparte.
- Si el repositorio usa GitHub o GitLab, el proceso es idéntico: copiar/pegar el archivo en la web de PR/MR.
- Mantén esta plantilla como la única fuente de verdad para la descripción de PR.

## ✅ Resultado esperado
- Commits atómicos y profesionales, con mensajes convencionales y referencia a [TICKET].
- Archivo `openspec/changes/pr-[TICKET].md` con PR completa, clara y lista para copiar/pegar en Bitbucket.
- Revisión técnica facilitada por una estructura legible y accionable.
