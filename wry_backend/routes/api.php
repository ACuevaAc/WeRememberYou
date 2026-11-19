<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AdminUserController;
use App\Http\Controllers\FamilyGroupController;

// Rutas Públicas
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/patient/link', [FamilyGroupController::class, 'linkPatientDevice']); // Login del paciente por QR/PIN

// Rutas Protegidas (Requieren Bearer Token)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    // Rutas de Cuidadores y Grupos Familiares (RGPD)
    Route::post('/groups/create-patient', [FamilyGroupController::class, 'createPatientAndGroup']);
    Route::post('/groups/join', [FamilyGroupController::class, 'joinGroup']);
    Route::get('/groups/my-groups', [FamilyGroupController::class, 'myGroups']);

    // Rutas del Administrador
    Route::prefix('admin/users')->group(function () {
        Route::get('/', [AdminUserController::class, 'index']);
        Route::patch('/{id}/toggle-active', [AdminUserController::class, 'toggleActive']);
        Route::put('/{id}', [AdminUserController::class, 'update']);
        Route::delete('/{id}', [AdminUserController::class, 'destroy']);
    });
});