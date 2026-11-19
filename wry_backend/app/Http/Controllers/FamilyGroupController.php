<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\FamilyGroup;
use App\Models\GroupMember;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class FamilyGroupController extends Controller
{
    // 1. El Cuidador Principal crea un Paciente y automáticamente se genera el Grupo Familiar
    public function createPatientAndGroup(Request $request)
    {
        $caregiver = $request->user();

        if ($caregiver->role !== 'u') {
            return response()->json(['message' => 'Solo los cuidadores pueden crear perfiles de pacientes.'], 403);
        }

        $request->validate([
            'patient_name' => 'required|string|max:255',
            'patient_phone' => 'nullable|string|max:20',
            'medical_notes' => 'nullable|string',
        ]);

        // Generar credenciales internas y código único para el Paciente
        $inviteCode = strtoupper(Str::random(6));
        $patientEmail = 'paciente_' . strtolower($inviteCode) . '@werememberyou.local';

        // Crear usuario con rol Paciente ('p')
        $patient = User::create([
            'name' => $request->patient_name,
            'email' => $patientEmail,
            'phone' => $request->patient_phone,
            'password' => Hash::make($inviteCode), // Su PIN es su clave de vinculación
            'role' => 'p',
            'is_active' => true,
        ]);

        // Crear el Grupo Familiar
        $group = FamilyGroup::create([
            'group_name' => 'Grupo de ' . $request->patient_name,
            'patient_id' => $patient->id,
            'invite_code' => $inviteCode,
            'patient_phone' => $request->patient_phone,
            'medical_notes' => $request->medical_notes,
        ]);

        // Vincular al cuidador creador como PROPIETARIO (is_owner = true -> ve datos personales)
        GroupMember::create([
            'family_group_id' => $group->id,
            'user_id' => $caregiver->id,
            'is_owner' => true,
        ]);

        return response()->json([
            'message' => 'Paciente y Grupo Familiar creados con éxito.',
            'invite_code' => $inviteCode, // Código QR / PIN para invitar familiares o vincular tablet del paciente
            'group' => $group,
            'patient' => $patient
        ], 201);
    }

    // 2. Unirse a un Grupo Familiar existente usando el código PIN/QR (Cuidador Invitado)
    public function joinGroup(Request $request)
    {
        $caregiver = $request->user();

        $request->validate([
            'invite_code' => 'required|string|exists:family_groups,invite_code',
        ]);

        $group = FamilyGroup::where('invite_code', strtoupper($request->invite_code))->first();

        // Comprobar si ya pertenece al grupo
        $exists = GroupMember::where('family_group_id', $group->id)
            ->where('user_id', $caregiver->id)
            ->exists();

        if ($exists) {
            return response()->json(['message' => 'Ya perteneces a este grupo familiar.'], 400);
        }

        // Añadir como Cuidador Invitado (is_owner = false -> SIN acceso a datos sensibles RGPD)
        GroupMember::create([
            'family_group_id' => $group->id,
            'user_id' => $caregiver->id,
            'is_owner' => false,
        ]);

        return response()->json([
            'message' => 'Te has unido al grupo familiar correctamente.',
            'group_name' => $group->group_name
        ], 200);
    }

    // 3. Vincular dispositivo del Paciente mediante el PIN/QR (Devuelve Token del Paciente)
    public function linkPatientDevice(Request $request)
    {
        $request->validate([
            'invite_code' => 'required|string|exists:family_groups,invite_code',
        ]);

        $group = FamilyGroup::where('invite_code', strtoupper($request->invite_code))->first();
        $patient = User::findOrFail($group->patient_id);

        $token = $patient->createToken('patient_device_token')->plainTextToken;

        return response()->json([
            'message' => 'Dispositivo vinculado al perfil del paciente.',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $patient
        ], 200);
    }

    // 4. Listar mis grupos y aplicar FILTRO DE PROTECCIÓN DE DATOS (RGPD)
    public function myGroups(Request $request)
    {
        $user = $request->user();
        $memberships = GroupMember::with(['group.patient'])->where('user_id', $user->id)->get();

        $result = $memberships->map(function ($membership) {
            $group = $membership->group;
            $patient = $group->patient;

            // Si es el Cuidador Principal (owner), devolvemos todos los datos personales
            if ($membership->is_owner) {
                return [
                    'group_id' => $group->id,
                    'group_name' => $group->group_name,
                    'invite_code' => $group->invite_code,
                    'role_in_group' => 'Propietario (Acceso Total)',
                    'patient' => [
                        'id' => $patient->id,
                        'name' => $patient->name,
                        'phone' => $group->patient_phone,
                        'medical_notes' => $group->medical_notes,
                    ]
                ];
            }

            // Si es Cuidador Invitado, OCULTAMOS los datos personales sensibles (RGPD)
            return [
                'group_id' => $group->id,
                'group_name' => $group->group_name,
                'role_in_group' => 'Familiar Invitado (Datos protegidos)',
                'patient' => [
                    'id' => $patient->id,
                    'name' => $patient->name, // Solo ve el nombre para identificarlo
                    'phone' => 'Oculto por protección de datos',
                    'medical_notes' => 'Oculto por protección de datos',
                ]
            ];
        });

        return response()->json($result, 200);
    }
}