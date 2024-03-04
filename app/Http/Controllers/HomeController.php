<?php

namespace App\Http\Controllers;

set_time_limit(0);

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;


class HomeController extends Controller
{
    public function index()
    {
        $totalsize = $this->calculateAndSaveTotalFileSize(__DIR__);

        return view('welcome', [
            'filesize' => $totalsize
        ]);
    }

    public function calculateAndSaveTotalFileSize($directory)
    {
        $totalFileSize = 0;
        $totalFolderSize = 0;

        // Open the directory
        if ($handle = opendir($directory)) {
            while (false !== ($entry = readdir($handle))) {
                // Skip current and parent directories
                if ($entry === '.' || $entry === '..') {
                    continue;
                }

                $fullPath = $directory . '/' . $entry;

                // Check if it's a file
                if (is_file($fullPath)) {
                    $totalFileSize += filesize($fullPath);
                } else if (is_dir($fullPath)) {
                    $subfolderSizes = $this->calculateAndSaveTotalFileSize($fullPath); // Recursive call
                    $totalFolderSize += $subfolderSizes['totalFolderSize'];
                    $totalFileSize += $subfolderSizes['totalFileSize'];
                }
            }
            closedir($handle);

            $fileSizeText = "Total file size (KB): " . number_format($totalFileSize / 1024, 2) . PHP_EOL;

            file_put_contents('filesize.txt', $fileSizeText);
        }

        return number_format($totalFileSize / 1024, 2);
    }
}
