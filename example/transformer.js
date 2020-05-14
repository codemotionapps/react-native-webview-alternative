var upstreamTransformer = require('metro-react-native-babel-transformer')

module.exports.transform = function ({ src, filename, options }) {
	if (filename.endsWith('.html')) {
		return upstreamTransformer.transform({
			src: `module.exports = ${JSON.stringify(src)}`,
			filename,
			options,
		})
	} else {
		return upstreamTransformer.transform({ src, filename, options })
	}
}
