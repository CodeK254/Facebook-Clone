<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AuthController extends Controller
{
    // Register User.

    public function register(Request $request) {
        $attrs = $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|max:255|unique:users,email',
            'password' => 'required|min:6|confirmed',
        ]);

        // Create user
        $user = User::create([
            'name' => $attrs['name'],
            'email' => $attrs['email'],
            'password' => bcrypt($attrs['password']),
        ]);

        // Return user data & token
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken,
        ], 200);
    }

    // Login User.
    public function login(Request $request) {
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6',
        ]);

        // Attempt to login.
        if (!Auth::attempt($attrs)) {
            return response([
                'message' => 'Invalid credentials.'
            ], 403);
        }

        // Return user & token in response.
        return response([
            $user = Auth::user(),
            'user' => auth()->user(),
            'token' => auth()->user()->createToken('secret')->plainTextToken,
        ], 200);
    }

    // Logout User.
    public function logout() {
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'Successfully logged out.'
        ], 200);
    }

    // Get User.
    public function user() {
        return response([
            'user' => auth()->user(),
        ], 200);
    }

    // Update User profile.
    public function update(Request $request) {
        $attrs = $request->validate([
            'name' => 'string|max:255',
        ]);

        $image = $this->saveImage($request->image, 'profiles');

        auth()->user()->update([
            'name' => $attrs['name'],
            'image' => $image,
        ]);

        return response([
            'message' => 'Profile updated successfully.',
            'user' => auth()->user(),
        ], 200);
    }
}
