// Composables
import { createRouter, createWebHistory } from 'vue-router'

import Register from '../components/Register.vue'
import PageNotFound from '../components/PageNotFound.vue'
import ForgotPassword from '../components/ForgotPassword.vue'

import MainLayout from '../layouts/MainLayout.vue'
import TestComponent from '../layouts/TestComponent.vue'
import Title from '../layouts/Title.vue'

import LearnWords from '../views/LearnWords.vue'
import Searching from '../views/Searching.vue'

// views
import Login from '../views/Login.vue'

const routes = [
  {path: '/',  component: Login},
  {path: '/login',  component: Login},
  {path: '/register',  component: Register},
  {path: '/forgot',  component: ForgotPassword},
  {
    path: '/home',
    component: MainLayout,
    children: [
      {
        path: '/searching',
        component: Searching
      },
      {
        path: '/title',
        component: Title
      },
      {
        path: '/learning',
        component: LearnWords
      }
  ]
  },

  // Navigate 404 if not found any path
  {path: '/:pathMatch(.*)*',  component: PageNotFound},
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})

export default router
