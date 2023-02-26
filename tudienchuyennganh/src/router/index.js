// Composables
import { createRouter, createWebHistory } from 'vue-router'

import PageNotFound from '../components/PageNotFound.vue'

import MainLayout from '../layouts/MainLayout.vue'
import TestComponent from '../layouts/TestComponent.vue'


import Login from '../views/Login.vue'
import Register from '../views/Register.vue'
import Topic from '../views/Topic.vue'
import LearnWords from '../views/LearnWords.vue'
import Searching from '../views/Searching.vue'
import ManageClass from '../views/ManageClass.vue'
import ForgotPassword from '../views/ForgotPassword.vue'

import TopicDetail from '../views/TopicDetail.vue'

const routes = [
  {path: '/',  component: Login},
  {path: '/login',  component: Login},
  {path: '/register',  component: Register},
  {path: '/forgot',  component: ForgotPassword},
  {path: '/test',  component: TestComponent},
  {
    path: '/home',
    component: MainLayout,
    children: [
      {
        path: '/searching',
        component: Searching
      },
      {
        path: '/topic',
        component: Topic
      },
      {
        name: 'LearnTopic',
        path: '/learning/topicid=:id',
        component: LearnWords
      },
      {
        path: '/class',
        component: ManageClass
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
