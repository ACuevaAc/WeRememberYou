<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GroupMember extends Model
{
    protected $fillable = [
        'family_group_id',
        'user_id',
        'is_owner',
    ];

    protected function casts(): array
    {
        return [
            'is_owner' => 'boolean',
        ];
    }

    public function group()
    {
        return $this->belongsTo(FamilyGroup::class, 'family_group_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}