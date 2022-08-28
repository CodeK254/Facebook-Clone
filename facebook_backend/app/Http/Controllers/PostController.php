<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Post;

class PostController extends Controller
{
    // get all posts.
    public function index()
    {
        return response()->json([
            'posts' => Post::orderBy('created_at', 'desc')->with('user:id,name,image')->withCount('comments', 'likes')
            ->with('likes', function($like) {
                return $like->where('user_id', auth()->user()->id)
                    ->select('id', 'user_id', 'post_id')->get();
            })
            ->get()
        ], 200);
    }

    //get single post
    public function show($id)
    {
        return response()->json([
            'post' => Post::findOrFail($id)->with('user:id,name,image')->withCount('comments', 'likes')->get()
        ], 200);
    }

    //create a post.
    public function store(Request $request)
    {
        $attrs = $request->validate([
            "caption" => "required|string",
            "image" => "required|string"
        ]);

        $image = $this->saveImage($request->image, "posts");

        $post = Post::create([
            "caption" => $attrs["caption"],
            "user_id" => auth()->user()->id,
            "image" => $image
        ]);

        return response()->json([
            'message' =>'Post created successfully.',
            'post' => $post,
        ], 200);
    }

    //update a post.
    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        if($post->user_id != auth()->user()->user_id)
        {
            return response()->json([
                'message' => 'Unauthorized action.'
            ], 401);
        }

        $attrs = $request->validate([
            'caption' => 'required|string|max:255',
        ]);

        $post->update([
            'caption' => $attrs['caption'],
        ]);

        return response()->json([
            'message' =>'Post updated successfully.',
            'post' => $post,
        ], 200);
    }

    // delete post.
    public function destroy($id)
    {
        $post = Post::findOrFail($id);

        if($post->user_id != auth()->user()->user_id)
        {
            return response()->json([
                'message' => 'Unauthorized action.'
            ], 401);
        }

        $post->delete();
        $post->comments()->delete();
        $post->likes()->delete();

        return response()->json([
            'message' =>'Post deleted successfully.',
        ], 200);
    }
}
