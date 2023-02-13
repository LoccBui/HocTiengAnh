const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
    publicPath: '/hoctienganh/',
    devServer: {
      proxy: {
        // '/api': {
        //   target: 'http://localhost:8000',
        //   changeOrigin: true,
        //   pathRewrite: {
        //     '^/api': ''
        //   }
        // }

        "/api": {
            ws: true,
            changeOrigin: true,
            target: "http://localhost:8000"
        }
     }
    }
    
})