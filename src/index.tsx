import React, { forwardRef, useImperativeHandle, useRef, ReactNode, Ref, useEffect } from 'react'
import { requireNativeComponent, ViewProps, UIManager, findNodeHandle } from 'react-native'

interface WebViewAlternativePropsIOS {
	keyboardDisplayRequiresUserAction?: boolean
	hideKeyboardAccessoryView?: boolean
}

interface WebViewAlternativeProps extends ViewProps, WebViewAlternativePropsIOS {
	source?: { html: string; baseURL?: string } | null
	children?: ReactNode
	scrollEnabled?: boolean
	onLoad?(): void
}

export interface WebViewAlternativeRef {
	focus(): void
}

export type WebViewRef = WebViewAlternativeRef

const NativeWebViewAlternative = requireNativeComponent<ViewProps>('WebViewAlternative')

type NewReturnType<T> = T extends { new (...args: any): infer R } ? R : never

type NativeWebViewAlternativeBeforeOverwrite = typeof NativeWebViewAlternative
type NativeWebViewAlternative = NewReturnType<NativeWebViewAlternativeBeforeOverwrite>

function WebViewAlternative({ source = null, ...props }: WebViewAlternativeProps, ref: Ref<WebViewAlternativeRef>) {
	const nativeComponentRef = useRef<NativeWebViewAlternative>(null)

	const sourceHashRef = useRef('"null"')
	useEffect(() => {
		const sourceHash = JSON.stringify(source)
		if (sourceHash === sourceHashRef.current) return
		sourceHashRef.current = sourceHash

		if (source === null) return

		UIManager.dispatchViewManagerCommand(
			findNodeHandle(nativeComponentRef.current),
			UIManager.getViewManagerConfig('WebViewAlternative').Commands.loadHTMLString,
			[source.html, source.baseURL],
		)
	}, [source])

	useImperativeHandle(ref, () => ({
		focus() {
			UIManager.dispatchViewManagerCommand(
				findNodeHandle(nativeComponentRef.current),
				UIManager.getViewManagerConfig('WebViewAlternative').Commands.focus,
				undefined,
			)
		},
	}))
	return <NativeWebViewAlternative {...props} ref={nativeComponentRef} />
}

const WebView = forwardRef<WebViewAlternativeRef, WebViewAlternativeProps>(WebViewAlternative)

export default WebView
