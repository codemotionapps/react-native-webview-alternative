import React, { useRef } from 'react'
import { StyleSheet, View, Platform } from 'react-native'
import WebView, { WebViewRef } from 'react-native-webview-alternative'

const demo1: string = require('./demo1.html')

export default function App() {
	const ref = useRef<WebViewRef>(null)

	return (
		<View style={styles.container}>
			<WebView
				ref={ref}
				source={{ html: demo1 }}
				keyboardDisplayRequiresUserAction={false}
				style={styles.webView}
				scrollEnabled={false}
				hideKeyboardAccessoryView
				onLoad={() => Platform.OS === 'android' && ref.current?.focus()}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: 'center',
		justifyContent: 'center',
	},
	webView: {
		width: '100%',
		height: 300,
	},
})
