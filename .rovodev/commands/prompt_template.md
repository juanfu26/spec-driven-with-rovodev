# Prompt Template

## 🎯 Objetivo
Describe claramente el objetivo principal del prompt.
- Qué se busca lograr
- Qué valor aporta
- Alcance y límites

## 🧩 Contexto
Proporciona el contexto mínimo necesario para que el agente trabaje con precisión:
- Proyecto / módulo / dominio
- Dependencias relevantes
- Restricciones (tiempo, entorno, compliance)
- Referencias (paths en wiki/ o docs/ si aplica)

## 📝 Instrucciones
Indica los pasos y el proceso que debe seguir el agente. Sé específico:
1) Rol o perspectiva desde la que debe actuar (p. ej., “como backend senior…”)
2) Proceso de razonamiento (sequential-thinking, validaciones, consultas a subagentes)
3) Herramientas y fuentes a consultar (paths o MCP tools si están habilitados)
4) Criterios de calidad y validación
5) Límites (no modificar Jira/Confluence sin permiso, etc.)

## 🔡 Entradas requeridas
Enumera los parámetros que el usuario debe facilitar:
- input_1: descripción y formato esperado
- input_2: descripción y formato esperado
- flags/opciones: explicación breve

## 📤 Salida esperada
Define la estructura y el formato de la respuesta:
- Secciones o bullets obligatorios
- Campos/artefactos esperados (código, tests, docs, métricas)
- Criterios de aceptación / calidad

## 💡 Tips
- Buenas prácticas para usar el prompt
- Sugerencias para refinar resultados
- Errores comunes a evitar

## 🧪 Ejemplo de uso
Indica un ejemplo mínimo para guiar al usuario:

Input:
```
<coloca aquí un ejemplo de inputs del usuario>
```

Output esperado:
```
<estructura y fragmento de salida esperada>
```

## 🛡️ Notas de cumplimiento
- No crear/editar/transicionar/comentar en Jira sin permiso explícito.
- Publicar en Confluence solo con confirmación.
- Respetar estándares OpenSpec si aplican (p. ej., openspec/standards/documentation.mdc).
