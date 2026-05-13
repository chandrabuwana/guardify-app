package com.binarnusapersada.guardify

import android.content.Context
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import java.io.File

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        // Clear corrupted SharedPreferences BEFORE Flutter engine starts
        // The shared_preferences plugin stores data in FlutterSharedPreferences.xml
        // If api_logs key grew to 231MB+, it causes OOM when the plugin tries to
        // serialize all data to send back to Dart via platform channels.
        clearCorruptedPrefsIfNeeded()
        super.onCreate(savedInstanceState)
    }

    private fun clearCorruptedPrefsIfNeeded() {
        try {
            val prefsFile = File(applicationInfo.dataDir, "shared_prefs/FlutterSharedPreferences.xml")
            if (prefsFile.exists()) {
                val fileSizeBytes = prefsFile.length()
                val fileSizeMB = fileSizeBytes / (1024 * 1024)
                Log.d("Guardify", "SharedPreferences file size: ${fileSizeMB}MB (${fileSizeBytes} bytes)")

                // If the prefs file is larger than 5MB, it's corrupted — delete it
                if (fileSizeMB > 5) {
                    Log.w("Guardify", "SharedPreferences file is too large (${fileSizeMB}MB), deleting to prevent OOM crash")
                    prefsFile.delete()
                    Log.w("Guardify", "Corrupted SharedPreferences file deleted successfully")
                }
            }
        } catch (e: Exception) {
            Log.e("Guardify", "Error checking SharedPreferences file size: ${e.message}")
        }
    }
}
