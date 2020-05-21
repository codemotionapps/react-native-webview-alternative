# react-native-webview-alternative

[![npm version](https://img.shields.io/npm/v/react-native-webview-alternative.svg)](https://www.npmjs.com/package/react-native-webview-alternative)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

Alternative to react-native-webview. Less features. No Windows or macOS support. Not included in Expo.

## Installation

```sh
npm install react-native-webview-alternative
(cd ios && pod install) # for iOS
```

## Usage

```js
import WebView from "react-native-webview-alternative";

<WebView
	source={{ html: '<h1>Hello World</h1>' }}
	style={{ width: 300, height: 300 }}
/>
```

## Props

Extends [`ViewProps`](https://reactnative.dev/docs/view).

### `source`

Load HTML into the WebView.

#### Properties

- `html` (string) - The string to use as the contents of the webpage
- `baseURL` (string or undefined) - A URL used to resolve relative URLs within the document

|Type|Required|Default value|
|----|--------|-------------|
|object|No|`null`|

### `scrollEnabled`

When set to `false` disables scrolling and pinch to zoom. Make sure to add `maximum-scale` to your viewport meta tag in order to prevent automatic scaling when focusing an input with a small font size on iOS.

|Type|Required|Default value|
|----|--------|-------------|
|boolean|No|`true`|

### `onLoad`

Called when page finishes loading.

|Type|Required|
|----|--------|
|function|No|

### `onMessage`

Called when a message is sent from the webview.

#### iOS

Use `webkit.messageHandlers.jsMessageHandler.postMessage(message)` to send your message. Supported types are object, string, number, and boolean. You will receive `message` as a property of `nativeEvent`.

#### Android

Use `JSBridge.postString(string)` to send a string. Use `JSBridge.postNumber(number)` to send a number. Use `JSBridge.postBoolean(boolean)` to send a boolean. Use `JSBridge.postNull()` to send `null`. You will receive your message as a property of `nativeEvent`.

|Type|Required|
|----|--------|
|function|No|

### `keyboardDisplayRequiresUserAction`

When set to `false` allows [`HTMLElement.focus()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLOrForeignElement/focus), and [`autofocus` attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#attr-autofocus) to display the keyboard.

|Type|Required|Default value|Platform|
|----|--------|-------------|--------|
|boolean|No|`true`|iOS|

### `hideKeyboardAccessoryView`

When set to `true` this will hide the default keyboard accessory view.

|Type|Required|Default value|Platform|
|----|--------|-------------|--------|
|boolean|No|`false`|iOS|

## Methods

### `focus()`

#### Android
Calls [`requestFocus`](https://developer.android.com/reference/android/webkit/WebView#requestFocus(int,%20android.graphics.Rect)) and shows the keyboard.

#### iOS
Calls [`HTMLElement.blur()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLOrForeignElement/blur) and [`HTMLElement.focus()`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLOrForeignElement/focus) on [`document.activeElement`](https://developer.mozilla.org/en-US/docs/Web/API/DocumentOrShadowRoot/activeElement). It won't work if [`keyboardDisplayRequiresUserAction`](#keyboardDisplayRequiresUserAction) is `true` or if [`document.activeElement`](https://developer.mozilla.org/en-US/docs/Web/API/DocumentOrShadowRoot/activeElement) is not focusable. It is recommended to just focus your field from JavaScript instead of calling this method, calling blur beforehand may be required.

### `injectJavaScript(string)`

Executes the JavaScript string.

## Requirements

- React Native 0.60 or later

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
