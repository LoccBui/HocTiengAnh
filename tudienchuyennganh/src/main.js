

// Components
import App from './App.vue'



// Composables
import { createApp } from 'vue'

// Plugins
import { registerPlugins } from '@/plugins'

import globalFunc from './GlobalFunction/script'



import 'element-plus/dist/index.css'


const app = createApp(App)

import ElementPlus from 'element-plus'



// app.component('v-otp-input', VOtpInput).mount(#app')// format when use other plugins


app.use(ElementPlus)

app.config.globalProperties.$globalFunc = globalFunc

registerPlugins(app)

app.mount('#app')

