<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use App\Models\Comment;

class CommentController extends Controller
{
    // get all comments.
    public function index($id)
    {
        $post = Post::findOrFail($id);

        if(!$post){
            return response()->json([
                'message' => 'Post not found'
            ], 404);
        }

        return response()->json([
            'comments' => $post->comments()->with('user:id,name,image')->get()
        ], 200);
    }

    //create a comment.
    public function store(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        if(!$post){
            return response()->json([
                'message' => 'Post not found'
            ], 404);
        }

        $this->validate($request, [
            'comment' => 'required|string|max:255',
        ]);

        $comment = new Comment;
        $comment->comment = $request->comment;
        $comment->user_id = auth()->user()->id;
        $comment->post_id = $id;
        $comment->save();

        return response()->json([
            'comment' => $comment,
            'message' =>'Comment added successfully.'
        ], 200);
    }

    //update a comment.
    public function update(Request $request, $id)
    {
        $comment = Comment::findOrFail($id);

        if($comment->user_id != auth()->user()->user_id)
        {
            return response()->json([
                'message' => 'Unauthorized action.'
            ], 401);
        }

        $attrs = $request->validate([
            'comment' => 'required|string|max:255',
        ]);

        $comment->update([
            'comment' => $attrs['comment'],
        ]);

        return response()->json([
            'comment' => $comment,
            'message' =>'Comment updated successfully.'
        ], 200);
    }

    // delete comment.
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);

        if($comment->user_id != auth()->user()->user_id)
        {
            return response()->json([
                'message' => 'Unauthorized action.'
            ], 401);
        }

        $comment->delete();

        return response()->json([
            'message' =>'Comment deleted successfully.'
        ], 200);
    }
}
