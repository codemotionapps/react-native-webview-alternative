import React, { useRef, useState } from 'react'
import { StyleSheet, Platform, Button, Text, SafeAreaView } from 'react-native'
import WebView, { WebViewRef } from 'react-native-webview-alternative'

const demo1: string = require('./demo1.html')

export default function App() {
	const [message, setMessage] = useState('')
	const ref = useRef<WebViewRef>(null)

	return (
		<SafeAreaView style={styles.container}>
			<Button
				title="Set input text to 'Hello World'"
				onPress={() => {
					ref.current?.injectJavaScript('input.value = "Hello World"')
				}}
			/>
			<Button
				title="Scroll to 4th section"
				onPress={() => {
					ref.current?.scrollTo({ y: 400, animated: false })
				}}
			/>
			<Button
				title="Scroll to top"
				onPress={() => {
					ref.current?.scrollTo({ animated: false })
				}}
			/>
			<Text>{message}</Text>
			<WebView
				ref={ref}
				source={{ html: demo1 }}
				// keyboardDisplayRequiresUserAction={false}
				style={styles.webView}
				// scrollEnabled={false}
				hideKeyboardAccessoryView
				onMessage={({ nativeEvent: { message } }) => (
					setMessage(String(message)), console.log(message, typeof message)
				)}
				onLoad={() => Platform.OS === 'android' && ref.current?.focus()}
			/>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: 'center',
	},
	webView: {
		width: '100%',
		height: 300,
	},
})
