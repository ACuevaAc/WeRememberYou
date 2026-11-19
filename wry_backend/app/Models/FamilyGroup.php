<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FamilyGroup extends Model
{
    protected $fillable = [
        'group_name',
        'patient_id',
        'invite_code',
        'patient_phone',
        'medical_notes',
    ];

    public function patient()
    {
        return $this->belongsTo(User::class, 'patient_id');
    }

    public function members()
    {
        return $this->hasMany(GroupMember::class);
    }
}