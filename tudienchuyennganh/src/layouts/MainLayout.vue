<template>
    <v-layout style="navbar-mobile">



      <div class="nav-bar">

      <v-navigation-drawer 
        v-model="drawer"
        style="height: auto;"
        location="left"
        class="nav-bar"
        :rail="rail"
        @click="rail = false"
        :persistent="false" 
      >
        <v-list>
          <v-list-item
            :title="nameUser"
            :subtitle="emailUser"             
          ></v-list-item>
        </v-list>

        
        <v-divider></v-divider>
        
        <div v-for="item in menuListItem" :key="item.value">
          <v-list 
            v-show="item.roles.includes(roleUser)" 
            density="compact"
            nav  
            @click="this.selectItem(item.value)" 
          > 

            <v-list-item 
              rounded="xl"
              class="navbar-item"
              :prepend-icon="`${item.icon}`" 
              :title="`${item.title}`" 
              @click="directTo(`${item.route}`)"
              :active="selectedItems.includes(item.value)"
              active-class="bg-active"
            >
          </v-list-item> 
        </v-list>

        
        
      </div>

      <v-divider></v-divider>

      <div style="padding: 8px;">
        <el-button 
          style="width: 100%;"
          type="danger"
          round>
          <v-icon>mdi-logout</v-icon>
       </el-button>
      </div>
      </v-navigation-drawer>  


      <v-app-bar app>
        <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
        <v-toolbar-title>Học từ vựng</v-toolbar-title>
      </v-app-bar>
    </div>

      <div class="menu-bar" v-if="menuVisible" @mouseleave="menuVisible = false">

        <div class="menu-wrapper">
          
          <div v-for="item in menuListItem" :key="item.value">

              <v-tooltip :text="`${item.title}`" location="top">
              <template v-slot:activator="{ props }">
                <v-list 
                  v-bind="props"
                  v-show="item.roles.includes(roleUser)" 
                  density="compact"
                  @click="this.selectItem(item.value)" 
                > 

                  <el-button 
                    round
                    plain
                    v-bind="props" 
                    size="large" 
                    color="#0038FF" 
                    @click="()=>  this.$router.push(`${item.route}`)">
                    <v-icon>{{ item.icon }}</v-icon>
                  </el-button>

                  
                  
                </v-list>
                
                
              </template>
            </v-tooltip>       
          </div>
          
          <div class="logOut" >
            <v-tooltip text="Đăng xuất" location="top">
              <template v-slot:activator="{ props }">
                <el-button  type="danger" v-bind="props" @click="logOut()">
                  <v-icon>mdi-logout </v-icon>
                </el-button>
              </template>
            </v-tooltip>
          </div>
          
        </div>
      </div>



      <v-main class="main">

          <div class="header">
            <el-header>

              <div class="user-app">
                <el-avatar
                  :src="`../../assets/img/${this.gender}.png`"
                />
                <span class="text-large font-600 mr-3"> {{ nameUser }} </span>
                <span class="text-sm mr-2" style="color: var(--el-text-color-regular)">
                  {{ emailUser }}
                </span>

              </div>

              <div></div>
              <div></div>

            </el-header>
          </div>
          
          

          <div class="content">
            <router-view></router-view>
          </div>

          <div class="footer">

            <el-button class="showNav" @mouseover="menuVisible = true"  >
            <v-icon>mdi-arrow-up-bold</v-icon>
          </el-button>

          </div>

      </v-main>

      

    </v-layout>

</template>


<script>
import axiosInstance from '../axios'


export default {
  data(){     
      return {
        drawer: true,
        rail: true,
          emailUser: '',
          nameUser: '',
          accountID: '',
          checkStorage: [],

          roleUser: 1,
          selectedItems: [],

          menuVisible: false,
          gender: 'male',

          menuListItem: [
            {icon: 'mdi-magnify', title: 'Tra từ', value: 1, route: '/searching', roles: [1, 10, 100]},
            {icon: 'mdi-bookshelf', title: 'Học từ', value: 2, route: '/topic', roles: [1, 10, 100]},
            {icon: 'mdi-account', title: 'Cài đặt tài khoản', value: 3, route: '/account/setting', roles: [1, 10, 100]},
            {icon: 'mdi-account-group ', title: 'Quản lý lớp - Admin', value: 4, route: '/manage/class', roles: [100]},
            {icon: 'mdi-account-cog ', title: 'Quản lý tài khoản - Admin', value: 5, route: '/manage/users', roles: [100]},
            {icon: 'mdi-alpha-v-circle ', title: 'Quản lý từ vựng - GV', value: 6, route: '/manage/vocab', roles: [10,100]},

          ]
      }
  },


  mounted(){  
     this.getDataUser()
  },


  methods:{
  

    selectItem(valueNav){
      this.selectedItems.length = 0
      this.selectedItems.push(valueNav) 
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


.main{
  padding: 0;
  width: 100%;
  height: 100vh;
}

.header{
  padding: 10px 0;
  box-shadow: rgba(0, 0, 0, 0.12) 0px 1px 3px, rgba(0, 0, 0, 0.24) 0px 1px 2px;
  border: 1px solid var(--light-blue-90);
  display: flex;
  align-items: center;
  justify-content: start;
  width: 100%;
  position: absolute;
  top: 0;
  min-height: 60px;
  max-height: 60px;
  background-color: white;
  z-index: 100;

  .el-header{
    height: unset;
  }
  
  .user-app{
    display: flex;
    align-items: center;
  }
}

.content{
  margin-top: 60px;
  height: auto;
}

.footer{
  position: absolute;
  width: 100%;
  height: auto;
  z-index: 10;
  bottom: 0;
}

.navbar-item{
  border: 2px solid var(--light-blue-90);
  

&:hover{
  background-color:  var(--main-color) !important;
  color: white !important;
  font-size: 30px;
  transition: all 500ms;  
}

}

.bg-active {
  background-color: var(--main-color);
  color : white !important;
}


.menu-bar{
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  left: 50%;
  bottom: 0;
  transform: translate(-50%, -30%);
  z-index: 10;
  animation: showBox .3s ease-in-out;

}

@keyframes showBox {
  from{
    opacity: 0;
    scale: 0;
  }
  to{
    opacity: 1;
    scale: 1;


  }
}


.menu-wrapper{
  padding: 10px;
  width: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 10;

  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);

  border: 1px solid var(--light-blue-90);
  background: rgba(0, 0, 0, 0.4);
  border-radius: 20px;
  width: auto;

  background-color: rgba(255, 255, 255, 0.5);
  box-shadow: rgba(60, 64, 67, 0.3) 0px 1px 2px 0px, rgba(60, 64, 67, 0.15) 0px 2px 6px 2px;

  background-color: white;

  .v-list{
    background-color: transparent;
    padding: 10px;

    .el-button{
        &:hover{
          background-color:  var(--main-color) !important;
          color: white !important;
          font-size: 20px;
          transition: all 500ms;  
       }
    }
   
    .el-icon{
      padding: 10px;
      
    }
  }

}

.logOut{
  
  .el-button{
    border-radius: 20px;
    width: 100%;
    height: 100%;

  }
}

.nav-bar{
  display: none !important;
}


.showNav{
  color: #0038FF;
  width: inherit;
}


@media screen and (max-width: 768px){

  .showNav{
    display: none;
  }

  .navbar-mobile{
    display: block;
  }

  .nav-bar{
    display:  block !important;
  }

  .header{
    display: none;
  }
}





</style>
