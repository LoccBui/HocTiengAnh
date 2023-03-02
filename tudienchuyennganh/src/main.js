

// Components
import App from './App.vue'



// Composables
import { createApp } from 'vue'

// Plugins
import { registerPlugins } from '@/plugins'




import GAuth from 'vue3-google-oauth2'

const app = createApp(App)

let gAuthClientId = '257245199825-6d2huvrs5vcta8ech2po7kni4dgtlv57.apps.googleusercontent.com'


// Google Authentication
const gAuthOptions = { 
    clientId: gAuthClientId, 
    scope: 'email', 
    prompt: 'consent', 
    plugin_name: 'HocTiengAnh'
}
app.use(GAuth, gAuthOptions)

// app.component('v-otp-input', VOtpInput).mount(#app')// format when use other plugins



registerPlugins(app)

app.mount('#app')

