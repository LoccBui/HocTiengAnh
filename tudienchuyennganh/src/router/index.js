// Composables
import { createRouter, createWebHistory } from 'vue-router'

import PageNotFound from '../components/PageNotFound.vue'

import MainLayout from '../layouts/MainLayout.vue'
import TestComponent from '../layouts/TestComponent.vue'


const Login = () => import('../views/Login.vue')
const Register = () => import('../views/Register.vue')
const Topic = () => import('../views/Topic.vue')
const LearnWords = () => import('../views/LearnWords.vue')
const Searching = () => import('../views/Searching.vue')
const ManageClass = () => import('../views/ManageClass.vue')
const ManageVocab = () => import('../views/ManageVocab.vue')
const ManageUsers = () => import('../views/ManageUsers.vue')
const ForgotPassword = () => import('../views/ForgotPassword.vue')
const SettingAccount = () => import('../views/SettingAccount.vue')
const AnalystLearning = () => import( '../views/AnalystLearning.vue')
const ManagePersonalVocab = () => import('../views/ManagePersonalVocab.vue')


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
        path: '/topic',
        component: Topic
      },
      {
        path: '/account/setting',
        component: SettingAccount
      },
      {
        name: 'LearnTopic',
        path: '/learning/topicid=:id',
        component: LearnWords
      },
      {
        path: '/manage/class',
        component: ManageClass
      },
      {
        path: '/manage/vocab',
        component: ManageVocab
      },
      {
        path: '/manage/users',
        component: ManageUsers
      },
      {
        path: '/analyst',
        component: AnalystLearning
      },
      {
        path: '/manage/personal/:id',
        component: ManagePersonalVocab
      },

      
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
