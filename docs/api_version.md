## API actual

| Método | Ruta completa | Acceso | Qué hace |
| --- | --- | --- | --- |
| POST | `/api/register` | Público | Registra un usuario y devuelve un token. |
| POST | `/api/login` | Público | Inicia sesión y devuelve un token. |
| POST | `/api/logout` | Token | Borra el token usado en la petición. |
| GET | `/api/admin/users` | Token | Lista usuarios cuyo rol no es `a`. |
| PATCH | `/api/admin/users/{id}/toggle-active` | Token | Invierte `is_active`. |
| PUT | `/api/admin/users/{id}` | Token | Edita un usuario. |
| DELETE | `/api/admin/users/{id}` | Token | Elimina un usuario. |


### Peticiones y respuestas

| Ruta | Cuerpo de la petición | Respuesta correcta | Errores relevantes |
| --- | --- | --- | --- |
| `POST /api/register` | `name`, `email`, `password`, `password_confirmation`; `phone` y `role` opcionales | `201`: `message`, `access_token`, `token_type`, `user` | `422` por datos inválidos. `role` admite `u` o `p`; si falta, se usa `u`. |
| `POST /api/login` | `email`, `password` | `200`: `message`, `access_token`, `token_type`, `user` | `401` por credenciales incorrectas; `403` si la cuenta está desactivada; `422` por datos inválidos. |
| `POST /api/logout` | Sin cuerpo | `200`: `message` | `401` sin token válido. |
| `GET /api/admin/users` | Sin cuerpo | `200`: array de usuarios no administradores | `401` sin token válido. No hay paginación ni filtros. |
| `PATCH /api/admin/users/{id}/toggle-active` | Sin cuerpo | `200`: `message`, `user` | `404` si no existe el usuario. |
| `PUT /api/admin/users/{id}` | Cualquiera de estos campos: `name`, `email`, `phone`, `role` | `200`: `message`, `user` | `404` si no existe; `422` si los datos no son válidos. `role` admite `u` o `p`. |
| `DELETE /api/admin/users/{id}` | Sin cuerpo | `200`: `message` | `404` si no existe el usuario. |

En el registro, `name` y `email` son obligatorios; el email debe ser único. La contraseña debe tener al menos 6 caracteres y coincidir con `password_confirmation`. La respuesta `user` del registro incluye los campos visibles del modelo, como `id`, `name`, `email`, `phone`, `role`, `is_active` y fechas. La respuesta `user` del login es más corta: solo incluye `id`, `name`, `email`, `role` e `is_active`. Ninguna respuesta del modelo muestra `password` ni `remember_token`.

Ejemplo de inicio de sesión:

```http
POST /api/login
Content-Type: application/json
Accept: application/json

{"email":"sema@example.com","password":"123456"}
```

```json
{
  "message": "Inicio de sesión exitoso.",
  "access_token": "<token>",
  "token_type": "Bearer",
  "user": {"id": 2, "name": "Josema", "email": "sema@example.com", "role": "u", "is_active": true}
}
```

Los errores de validación (`422`) devuelven `message` y `errors`.

## Cuándo registrar un cambio

Se añade una entrada al crear, eliminar o modificar una ruta o un método HTTP; al cambiar campos o tipos JSON, validaciones, códigos de respuesta, permisos o comportamiento visible. Los cambios internos que no afectan al cliente no necesitan una entrada.