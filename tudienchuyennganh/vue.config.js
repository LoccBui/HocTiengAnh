const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
    publicPath: '/hoctienganh/',
    devServer: {
      proxy: {

        "/api": {
            ws: true,
            changeOrigin: true,
            target: "http://localhost:8000"
        }
     }
    },

    
})