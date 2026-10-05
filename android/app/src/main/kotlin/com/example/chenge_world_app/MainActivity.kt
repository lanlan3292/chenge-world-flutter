package com.chenge.world

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.chenge.world/app_icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAppIcon" -> {
                    val iconName = call.argument<String>("iconName")
                    if (iconName == null) {
                        result.error("INVALID_ARGUMENT", "iconName is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        setAppIcon(iconName)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ICON_ERROR", e.message, null)
                    }
                }
                "getCurrentAppIcon" -> {
                    try {
                        result.success(getCurrentAppIcon())
                    } catch (e: Exception) {
                        result.error("ICON_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun setAppIcon(iconName: String) {
        val pm = packageManager
        val packageName = packageName

        // Disable all aliases first
        val aliases = listOf("MainActivityDefault", "MainActivityNina")
        for (alias in aliases) {
            val component = ComponentName(packageName, "$packageName.$alias")
            pm.setComponentEnabledSetting(
                component,
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP
            )
        }

        // Enable the selected one
        val targetAlias = when (iconName) {
            "nina" -> "MainActivityNina"
            else -> "MainActivityDefault"
        }
        val targetComponent = ComponentName(packageName, "$packageName.$targetAlias")
        pm.setComponentEnabledSetting(
            targetComponent,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    private fun getCurrentAppIcon(): String {
        val pm = packageManager
        val packageName = packageName
        val ninaComponent = ComponentName(packageName, "$packageName.MainActivityNina")
        val state = pm.getComponentEnabledSetting(ninaComponent)
        return if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
            "nina"
        } else {
            "default"
        }
    }
}
