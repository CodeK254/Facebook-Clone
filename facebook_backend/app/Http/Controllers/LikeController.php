<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use App\Models\Like;

class LikeController extends Controller
{
    // get all likes.
    public function likeOrUnlike($id){
        $post = Post::findOrFail($id);

        if(!$post){
            return response()->json([
                'message' => 'Post not found'
            ], 404);
        }

        $like = $post->likes()->where('user_id', auth()->user()->id)->first();

        // if not liked yet, like it.
        if(!$like){
            Like::create([
                'user_id' => auth()->user()->id,
                'post_id' => $id
            ]);

            return response()->json([
                'message' => 'Liked.'
            ], 200);
        }

        // if already liked, unlike it.
        $like->delete();

        return response()->json([
            'message' => 'Unliked.'
        ], 200);
    }
}
