// Composables
import { createRouter, createWebHistory } from 'vue-router'

import Login from '../components/Login.vue'
import Register from '../components/Register.vue'
import PageNotFound from '../components/PageNotFound.vue'
import ForgotPassword from '../components/ForgotPassword.vue'
import MainLayout from '../layouts/MainLayout.vue'


const routes = [
  {path: '/',  component: Login},
  {path: '/register',  component: Register},
  {path: '/forgot',  component: ForgotPassword},
  {path: '/dashboard',  component: MainLayout},

  // Navigate 404 if not found any path
  {path: '/:pathMatch(.*)*',  component: PageNotFound},
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

export default router
