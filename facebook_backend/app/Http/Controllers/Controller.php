<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\Route;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function saveImage($image, $path = "public"){
        if(!$image){
            return null;
        }

        $filename = time().".png";

        //Save image file
        \Storage::disk($path)->put($filename, base64_decode($image));

        // Return the path.
        // Url is the base URL exp: localhost:8000
        return "http://192.168.0.200:8000".'/storage/'.$path.'/'.$filename;
    }
}
