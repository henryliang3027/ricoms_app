package com.example.ricoms_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.net.Uri
import android.content.ActivityNotFoundException;
import android.webkit.MimeTypeMap
import java.io.File
import android.os.Build
import androidx.core.content.FileProvider
import android.util.Log

class MainActivity: FlutterActivity() {
      private val CHANNEL = "com.example.ricoms_app/open_file"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "openFile") {
        val isSuccess = openFile(call.argument("filePath"))

        if(isSuccess) {
          result.success("Success")
        }else{
          result.error("Failed", "Open file Failed.", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }

  fun openFile(filePath: String?): Boolean {
      val file = File(filePath)
      val myMime: MimeTypeMap = MimeTypeMap.getSingleton()
      val newIntent = Intent(Intent.ACTION_VIEW)
      val mimeType: String =
          myMime.getMimeTypeFromExtension(file.extension).toString()

      if (Build.VERSION.SDK_INT >= 24) {
          newIntent.setDataAndType(FileProvider.getUriForFile(activity!!.applicationContext, activity.applicationContext.packageName.toString() +
              ".provider", file), mimeType)
      }else{
          newIntent.setDataAndType(Uri.fromFile(file), mimeType)
      }
      newIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      newIntent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
      try {
          activity!!.startActivity(newIntent)
      } catch (e: ActivityNotFoundException) {
        return false
      }
      return true

    }
}
