<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\LikeController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Public routes (Accessible to everyone and anyone).

Route::post('/register', [AuthController::class, 'register']);

Route::post('/login', [AuthController::class, 'login']);

// Protected routes (Accessible only to users logged in).

Route::group(['middleware' => ['auth:sanctum']], function () {
    // Loging out user.
    Route::post('/logout', [AuthController::class, 'logout']);

    // Get user.
    Route::get('/user', [AuthController::class, 'user']);

    // Update user profile.
    Route::put('/user', [AuthController::class, 'update']);

    // Post.
    Route::apiResource('/posts', PostController::class);

    // Comment.
    Route::get('/posts/{id}/comments', [CommentController::class, 'index']);
    Route::post('/posts/{id}/comments', [CommentController::class, 'store']);
    Route::put('/comments/{id}', [CommentController::class, 'update']);
    Route::delete('/comments/{id}', [CommentController::class, 'destroy']);

    // Like.
    Route::post('/posts/{id}/likes', [LikeController::class, 'likeOrUnlike']);
});
