<template>
    <v-card>
      <v-layout>
        <v-navigation-drawer
          expand-on-hover
          rail
          permanent 
        >
          <v-list>
            <v-list-item
              :title="nameUser"
              :subtitle="emailUser"             
            ></v-list-item>
          </v-list>
  
          <v-divider></v-divider>
  
          <v-list 
            density="compact"
            nav  
            v-for="item in menuListItem" 
            :key="item"  
            @click="menuActionClick(item.action)"          
          >
              <v-list-item 
                :key="`${item.value}`" 
                :prepend-icon="`${item.icon}`" 
                :title="`${item.title}`" 
                :value="`${item.value}`" 
                @click="directTo(`${item.route}`)"
              >
            </v-list-item> 

          </v-list>

        </v-navigation-drawer>
  

        <v-main style="height: 100vh">
          <div style="width:100%">
            <router-view></router-view>
          </div>
        </v-main>

      </v-layout>
    </v-card>
  </template>
  

<script>
import axiosInstance from '../axios'

export default {
    data(){     
        return {
            emailUser: '',
            nameUser: '',
            accountID: '',

            checkStorage: [],

            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: '1', route: '/searching'},
              {icon: 'mdi-bookshelf', title: 'Học từ', value: '2', route: '/topic'},
              {icon: 'mdi-account', title: 'Cài đặt tài khoản', value: '4', route: '/account/setting'},
              {icon: 'mdi-account-group ', title: 'Quản lý lớp - Admin', value: '5', route: '/manage/class'},
              {icon: 'mdi-account-cog ', title: 'Quản lý tài khoản - Admin', value: '6', route: '/manage/users'},
              {icon: 'mdi-alpha-v-circle ', title: 'Quản lý từ vựng - GV', value: '7', route: '/manage/vocab'},

              // maybe more
              {icon: 'mdi-logout  ', title: 'Đăng xuất', value: '5', route: '', action: 'logOut' }
            ]
        }
    },

    computed:{
      search(){
        console.log(123)
      }
    },

    mounted(){  


       this.getDataUser()
    },


    methods:{
      menuActionClick(action){
        if(action == 'logOut'){
          this.logOut()
        }
      },

      getDataUser(){
          let dataUser = JSON.parse(localStorage.getItem('userInfo'))

          if(!dataUser){
            this.$router.push('/login')
          }
          else{
            this.accountID = dataUser.accountID 
            this.emailUser = dataUser.email 
            this.nameUser = dataUser.name
          }
          
         

      },

      directTo(path){
          this.$router.push(`${path}`)
      },

      logOut(){
        localStorage.removeItem('userInfo')
        window.location.href = '/login'
      },
    }
  
}
</script>

<style lang="scss" scoped>

</style>
