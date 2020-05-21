import React, { useRef, useState } from 'react'
import { StyleSheet, View, Platform, Button, Text } from 'react-native'
import WebView, { WebViewRef } from 'react-native-webview-alternative'

const demo1: string = require('./demo1.html')

export default function App() {
	const [message, setMessage] = useState('')
	const ref = useRef<WebViewRef>(null)

	return (
		<View style={styles.container}>
			<Button
				title="Set input text to 'Hello World'"
				onPress={() => {
					ref.current?.injectJavaScript('input.value = "Hello World"')
				}}
			/>
			<Text>{message}</Text>
			<WebView
				ref={ref}
				source={{ html: demo1 }}
				keyboardDisplayRequiresUserAction={false}
				style={styles.webView}
				scrollEnabled={false}
				hideKeyboardAccessoryView
				onMessage={({ nativeEvent: { message } }) => (
					setMessage(String(message)), console.log(message, typeof message)
				)}
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
