package com.reactnativewebviewalternative

import android.annotation.SuppressLint
import android.content.Context
import android.util.Log
import android.view.MotionEvent
import android.view.inputmethod.InputMethodManager
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.core.content.ContextCompat.getSystemService
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter


class WebViewAlternativeManager(reactContext: ReactApplicationContext): SimpleViewManager<WebView>() {
    val reactContext = reactContext

    enum class Command(val commandId: Int) {
        LOAD_HTML_STRING(1),
        FOCUS(2),
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
        }
    }

    override fun getCommandsMap(): Map<String, Int> {
        return MapBuilder.of("loadHTMLString", Command.LOAD_HTML_STRING.commandId, "focus", Command.FOCUS.commandId)
    }

    override fun getExportedCustomDirectEventTypeConstants(): Map<String, Map<String, String>> {
        return MapBuilder.of("load", MapBuilder.of("registrationName", "onLoad"))
    }

//    override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Map<String, Map<String, String>>> {
//        return MapBuilder.of("load", MapBuilder.of("phasedRegistrationNames", MapBuilder.of("bubbled", "onLoad")))
//    }
}