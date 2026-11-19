# WeRememberYou: trabajo en equipo

WeRememberYou es una aplicación para apoyar a personas con Alzheimer y a quienes las cuidan. Este documento explica dónde está el código, cómo organizamos el trabajo y dónde consultar la API.

## Repositorio y ramas

Usamos [un repositorio](https://github.com/ACuevaAc/WeRememberYou) para la app Flutter y la API Laravel:

```text
WeRememberYou/
├── wry_frontend/         # Flutter
├── wry_backend/          # API Laravel
└── docs/                 # Documentación del proyecto
```

La propuesta de la actividad habla de repositorios separados para Flutter, Spring y documentación. Elegimos un solo repositorio porque el equipo es pequeño y un cambio de API puede revisarse junto con el cambio de Flutter. El backend actual usa Laravel, ya que hemos decidido desarrollarlo así por ahora, aunque se deba cambiar más adelante. La documentación del proyecto se guarda en `docs/` dentro del mismo repositorio.

`main` guarda la versión entregable y `develop` reúne el trabajo en curso. Para cada tarea se crea una rama desde `develop` con uno de estos nombres:

| Tipo de trabajo | Nombre de rama | Ejemplo |
| --- | --- | --- |
| Función nueva | `feature/<area>-<descripcion>` | `feature/ui-auth-login` |
| Corrección | `fix/<area>-<descripcion>` | `fix/api-login-403` |
| Documentación | `docs/<descripcion>` | `docs/api` |
| Corrección urgente de la versión entregable | `hotfix/<descripcion>` | `hotfix/login` |

Al terminar, se abre un pull request hacia `develop`, se enlaza la tarjeta de Trello y otra persona revisa el cambio. Si afecta a la API, también lo revisa quien trabaja en Flutter. Para preparar una entrega, se revisa y fusiona `develop` en `main`. Una corrección urgente sale de `main` y, después, se incorpora también a `develop`.

## Trabajo en Trello

El [tablero WeRememberYou](https://trello.com/b/5uM2w9K9/werememberyou) tiene estas listas: **TAREAS → EN PROCESO → EN REVISION → REALIZADA**. Cada tarea, fallo o decisión que afecte al equipo se registra en una tarjeta. La tarjeta incluye una descripción breve, la persona responsable y, cuando existe código, el enlace a la rama o al pull request. Las tarjetas actuales ya usan nombres como `US-01` y enlaces al repositorio.

Para una **tarea**, anotamos qué hay que hacer y cómo sabremos que está terminada. Para una **incidencia**, añadimos los pasos para reproducirla, qué esperábamos, qué ocurrió y la pantalla o ruta afectada. Para una **decisión**, escribimos las opciones consideradas, la opción elegida, el motivo y la fecha. La conversación puede quedar en los comentarios de la tarjeta; si la decisión cambia el funcionamiento del proyecto, también se resume en `docs/` o en el README correspondiente.

La tarjeta pasa de `TAREAS` a `EN PROCESO` al empezar. Pasa a `EN REVISION` cuando el trabajo está listo para revisar y a `REALIZADA` tras la revisión. Así Trello muestra el estado del trabajo y el repositorio guarda el resultado.

## Documentación de la API

Los endpoints disponibles, las peticiones y respuestas JSON, los errores y el historial de cambios están en [`docs/api_version.md`](docs/api_version.md). Es la referencia para integrar Flutter con la API. Cada cambio se registra allí y se relaciona con su tarjeta de Trello y su pull request. El mismo documento explica cómo avisar al equipo cuando cambia el contrato de la API.
