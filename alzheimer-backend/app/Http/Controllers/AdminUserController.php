<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class AdminUserController extends Controller
{
    public function index()
    {
        // Devuelve usuarios no administradores para el widget flutter_slidable
        $users = User::where('role', '!=', 'a')->get();
        return response()->json($users, 200);
    }

    public function toggleActive($id)
    {
        $user = User::findOrFail($id);
        $user->is_active = !$user->is_active;
        $user->save();

        $status = $user->is_active ? 'activada' : 'desactivada';
        return response()->json([
            'message' => "La cuenta de {$user->name} ha sido {$status}.",
            'user' => $user
        ], 200);
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);

        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'email' => 'sometimes|required|email|unique:users,email,'.$user->id,
            'phone' => 'nullable|string',
            'role' => 'sometimes|in:u,p',
        ]);

        $user->update($request->only(['name', 'email', 'phone', 'role']));

        return response()->json([
            'message' => 'Usuario actualizado correctamente.',
            'user' => $user
        ], 200);
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json(['message' => 'Usuario eliminado correctamente.'], 200);
    }
}