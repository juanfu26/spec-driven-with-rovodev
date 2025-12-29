# 🔀 Develop trying

Comando que habilita el desarrollo con herramientas para testear en el sistema operativo padre. 

## 🎯 Objetivo

Desarrollar la tarea a base de prueba y error sobre el sistema operativo.
1. **Analizar** los comandos que mejor se van a comportar según la tarea objetivo
2. **Ejecutar** los comandos siempre con la intención de evaluar la respuesta al comando

## Herramientas
Estás trabajando en un contenedor docker y quiero que ejecutes comandos en el servidor que te hostea.
Tienes la opción de ejecutar comandos usando nsenter a través de contenedores docker:
```docker
docker run --rm --privileged --pid=host -v /:/host alpine nsenter -t 1 -m -u -n -p -i [comando]
```