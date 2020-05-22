package com.reactnativewebviewalternative

import android.R.attr.x
import android.R.attr.y
import android.animation.ObjectAnimator
import android.animation.PropertyValuesHolder
import android.annotation.SuppressLint
import android.content.res.Resources
import android.os.Build
import android.view.MotionEvent
import android.view.inputmethod.InputMethodManager
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.core.content.ContextCompat.getSystemService
import com.facebook.react.bridge.*
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter


class WebViewAlternativeManager(private val reactContext: ReactApplicationContext): SimpleViewManager<WebView>() {
    enum class Command(val commandId: Int) {
        LOAD_HTML_STRING(1),
        FOCUS(2),
        INJECT_JAVASCRIPT(3),
        SCROLL_TO(4),
    }

    companion object {
        const val REACT_CLASS = "WebViewAlternative"
    }

    override fun getName(): String {
        return REACT_CLASS
    }

    override fun createViewInstance(context: ThemedReactContext): WebView {
        val webView = WebView(context)

        webView.webViewClient = object : WebViewClient() {
            override fun onPageFinished(view: WebView, url: String) {
                val reactContext = view.context as ReactContext
                reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(
                        webView.id,
                        "load",
                        null)
            }
        }

        webView.settings.javaScriptEnabled = true
        webView.addJavascriptInterface(object : Object() {
            fun sendMessage(message: WritableMap) {
                reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(
                        webView.id,
                        "message",
                        message)
            }

            @JavascriptInterface
            fun postNull() {
                val writableMap = Arguments.createMap()
                writableMap.putNull("message")
                sendMessage(writableMap)
            }

            @JavascriptInterface
            fun postString(message: String) {
                val writableMap = Arguments.createMap()
                writableMap.putString("message", message)
                sendMessage(writableMap)
            }

            @JavascriptInterface
            fun postBoolean(message: Boolean) {
                val writableMap = Arguments.createMap()
                writableMap.putBoolean("message", message)
                sendMessage(writableMap)
            }

            @JavascriptInterface
            fun postNumber(message: Double) {
                val writableMap = Arguments.createMap()
                writableMap.putDouble("message", message)
                sendMessage(writableMap)
            }
        }, "JSBridge")

        return webView
    }

    @SuppressLint("ClickableViewAccessibility")
    @ReactProp(name = "scrollEnabled", defaultBoolean = false)
    fun scrollEnabled(view: WebView, boolean: Boolean) {
        if (boolean) {
            view.setOnTouchListener(null)
            view.isVerticalScrollBarEnabled = true
            view.isHorizontalScrollBarEnabled = true
        } else {
            view.setOnTouchListener { _, event -> event.action == MotionEvent.ACTION_MOVE }
            view.isVerticalScrollBarEnabled = false
            view.isHorizontalScrollBarEnabled = false
        }
    }

    override fun receiveCommand(root: WebView, commandId: Int, args: ReadableArray?) {
        when(commandId) {
            Command.LOAD_HTML_STRING.commandId -> {
                if (args != null) {
                    root.loadDataWithBaseURL(args.getString(1), args.getString(0), null, null, null)
                }
            }
            Command.FOCUS.commandId -> {
                if (root.requestFocus()) {
                    val imm: InputMethodManager? = getSystemService(reactContext, InputMethodManager::class.java)
                    imm != null && imm.showSoftInput(root, InputMethodManager.SHOW_IMPLICIT)
                }
            }
            Command.INJECT_JAVASCRIPT.commandId -> {
                if (args != null) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        root.evaluateJavascript(args.getString(0), null)
                    }
                }
            }
            Command.SCROLL_TO.commandId -> {
                if (args != null) {
                    val density = Resources.getSystem().displayMetrics.density
                    val x = (args.getDouble(0) * density).toInt()
                    val y = (args.getDouble(1) * density).toInt()
                    if (args.getBoolean(2)) {
                        val scrollX = PropertyValuesHolder.ofInt("scrollX", root.scrollX, x)
                        val scrollY = PropertyValuesHolder.ofInt("scrollY", root.scrollY, y)
                        ObjectAnimator.ofPropertyValuesHolder(root, scrollX, scrollY).start()
                    } else {
                        root.scrollTo(x, y)
                    }
                }
            }
        }
    }

    override fun getCommandsMap(): Map<String, Int> {
        return MapBuilder.of("loadHTMLString", Command.LOAD_HTML_STRING.commandId,
                "focus", Command.FOCUS.commandId,
                "injectJavaScript", Command.INJECT_JAVASCRIPT.commandId,
                "scrollTo", Command.SCROLL_TO.commandId
        )
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Map<String, String>> {
        return MapBuilder.of("load", MapBuilder.of("registrationName", "onLoad"), "message", MapBuilder.of("registrationName", "onMessage"))
    }

//    override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Map<String, Map<String, String>>> {
//        return MapBuilder.of("load", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoad")))
//    }
}