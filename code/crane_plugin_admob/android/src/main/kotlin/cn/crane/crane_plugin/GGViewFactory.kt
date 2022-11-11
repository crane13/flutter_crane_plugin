package cn.crane.crane_plugin

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class GGViewFactory(private val messenger: BinaryMessenger, private val activity: Activity) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    companion object {

        fun registerWith(@NonNull flutterEngine: FlutterEngine, activity: CraneActivity) {
            val key: String = GGView.PLUGIN_VIEW

            flutterEngine.platformViewsController.registry.registerViewFactory(
                key,
                GGViewFactory(flutterEngine.dartExecutor.binaryMessenger, activity)
            );
        }
    }

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as Map<String?, Any>?
        return GGView(activity, messenger, viewId, params)
    }

}