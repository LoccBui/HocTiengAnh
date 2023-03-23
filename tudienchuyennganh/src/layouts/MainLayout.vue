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
          
          <div v-for="item in menuListItem" :key="item">
            <v-list 
              density="compact"
              nav  
              @click="menuActionClick(item.action)" 
              @click:select="this.selectItemNav(item.value)"
              v-show="item.roles.includes(roleUser)" 
            > 
            {{ activeNav }}
              <v-list-item 
                class="navbar-item"
                :key="`${item.value}`" 
                :prepend-icon="`${item.icon}`" 
                :title="`${item.title}`" 
                :value="`${item.value}`" 
                @click="directTo(`${item.route}`)"
              >
            </v-list-item> 

          </v-list>
        </div>

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

            roleUser: 1,


            menuListItem: [
              {icon: 'mdi-magnify', title: 'Tra từ', value: 1, route: '/searching', roles: [1, 10, 100]},
              {icon: 'mdi-bookshelf', title: 'Học từ', value: 2, route: '/topic', roles: [1, 10, 100]},
              {icon: 'mdi-account', title: 'Cài đặt tài khoản', value: 3, route: '/account/setting', roles: [1, 10, 100]},
              {icon: 'mdi-account-group ', title: 'Quản lý lớp - Admin', value: 4, route: '/manage/class', roles: [100]},
              {icon: 'mdi-account-cog ', title: 'Quản lý tài khoản - Admin', value: 5, route: '/manage/users', roles: [100]},
              {icon: 'mdi-alpha-v-circle ', title: 'Quản lý từ vựng - GV', value: 6, route: '/manage/vocab', roles: [10,100]},

              // maybe more
              {icon: 'mdi-logout  ', title: 'Đăng xuất', value: '5', route: '', action: 'logOut', roles: [1,10,100] }
            ]
        }
    },

    computed:{
      search(){
        console.log(123)
      }
    },

    mounted(){  
      console.log(this.roleUser)

       this.getDataUser()
    },


    methods:{
      menuActionClick(action){
        if(action == 'logOut'){
          this.logOut()
        }
      },

      selectItemNav(index){
        this.activeIndex = index === this.activeIndex ? null : index

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
            this.roleUser = dataUser.Role
            console.log(typeof this.roleUser)
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
.navbar-item{

  &:hover{
    background-color:  var(--main-color) !important;
    color: white !important;
  }

}



</style>
