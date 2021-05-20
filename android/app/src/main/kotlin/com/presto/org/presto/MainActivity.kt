package com.presto.org.presto
import android.app.Notification
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationBuilderWithBuilderAccessor
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {
    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.presto.org").setMethodCallHandler {
            // Note: this method is invoked on the main thread.
                call, result ->
            println("\n\n\nHello $packageName\n\n\n\n")
            when (call.method) {
                "createNotificationChannel" -> {
                    createNotificationChannel()
                }
                "checkNotificationPermissions" -> {
                    result.success(checkNotificationPermissions())
                }
                "openNotificationSettings" -> {
                    openNotificationSettings(call.arguments.toString())
                }
                "checkAndGetNotificationPermissions" -> {
                    checkAndGetNotificationPermissions()
                }
                "notifyTheUser" -> {
                    notifyTheUser()
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun createNotificationChannel () : Boolean {
        println("Creating notification Channel")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            val mChannel = NotificationChannel("presto_borrowing_channel_test_2", "Presto Custom Notification Test 2", NotificationManager.IMPORTANCE_HIGH)
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

            val soundUri  = Uri.parse("android.resource://"+ applicationContext
                .packageName + "/" + R.raw.ding_dong
            )
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                .build()
            mChannel.setSound(soundUri, audioAttributes)
            mChannel.enableVibration(true)
            mChannel.enableLights(true)
            mChannel.setAllowBubbles(true)
            mChannel.setBypassDnd(true)
            notificationManager.createNotificationChannel(mChannel)
            println("Succeeded")
            return  true
        }

        return  true
    }
    @RequiresApi(Build.VERSION_CODES.N)
    fun checkNotificationPermissions() : String {
        println("Checking permissions 1")
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            println("Checking permissions 2")
            if(!notificationManager.areNotificationsEnabled()){
                println("Checking permissions 3")
                println("Notifications Disabled")
                return  "NOTIFICATIONS_DISABLED"
            }
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                println("Checking permissions 4")
                println(notificationManager.importance)
                if(notificationManager.getNotificationChannel("presto_borrowing_channel_test_2").importance != NotificationManager.IMPORTANCE_HIGH) {
                    println("Notifications not high important")
                    println(notificationManager.importance)
                    return "NOTIFICATIONS_DISABLED"
                }
                else{
                    println("This is the importance")
                    println(notificationManager.getNotificationChannel("presto_borrowing_channel_test_2").importance);
                }

            }
            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                println("Checking permissions 5")
                if(!notificationManager.areBubblesAllowed()){
                    println("Bubbles Disabled")
                    return  "BUBBLES_DISABLED"
                }
            }
        }
        return "ALL_CLEAR"
    }
    @RequiresApi(Build.VERSION_CODES.N)
    private fun checkAndGetNotificationPermissions() {
        println("Checking permissions")
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if(!notificationManager.areNotificationsEnabled()){
                openNotificationSettings("NOTIFICATIONS_DISABLED")
            }
            if(notificationManager.importance != NotificationManager.IMPORTANCE_HIGH) {
                openNotificationSettings("NOTIFICATIONS_DISABLED")
            }

            if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                if(!notificationManager.areBubblesAllowed()){
                    openNotificationSettings("BUBBLES_DISABLED")
                }
            }
    }

    private fun openNotificationSettings(case : String) {
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        println("Opening notifications settings")
        when (case) {
            "NOTIFICATIONS_DISABLED" -> {

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    intent.putExtra(Settings.EXTRA_APP_PACKAGE , packageName)
                    startActivity(intent)
                }else{
                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                    intent.data = Uri.parse(("package:$packageName"))
                    startActivity(intent)
                }
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    if(!notificationManager.areBubblesAllowed()){
                        val intent2 = Intent(Settings.ACTION_APP_NOTIFICATION_BUBBLE_SETTINGS)
                        intent2.putExtra(Settings.EXTRA_APP_PACKAGE , packageName)
                        startActivity(intent2)
                    }
                }
            }
            "BUBBLES_DISABLED" -> {
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    val intent = Intent(Settings.ACTION_APP_NOTIFICATION_BUBBLE_SETTINGS)
                    intent.putExtra(Settings.EXTRA_APP_PACKAGE , packageName)
                    startActivity(intent)
                }
            }

        }

    }

    private fun notifyTheUser() {
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        println("Running noise")
        try {
            val notification: Uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            val r: Ringtone = RingtoneManager.getRingtone(getApplicationContext(), notification)
            r.play()
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }
//
}