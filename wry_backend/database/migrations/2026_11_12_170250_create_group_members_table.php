<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
{
    Schema::create('group_members', function (Blueprint $table) {
        $table->id();
        $table->foreignId('family_group_id')->constrained('family_groups')->onDelete('cascade');
        $table->foreignId('user_id')->constrained('users')->onDelete('cascade'); // Cuidador con rol 'u'
        $table->boolean('is_owner')->default(false); // true = Creador (ve datos personales), false = Invitado (RGPD)
        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('group_members');
    }
};
