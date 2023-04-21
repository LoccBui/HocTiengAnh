<template>
    <div class="container">
     
      <el-table 
        :data="filterPersonalVocab" 
        :default-sort="{ prop: 'PersonalVocabID', order: 'ascending' }"
        empty-text="Không có dữ liệu"
      >
  
      <el-table-column label="ID" prop="PersonalVocabID" width="150" sortable/>
      <el-table-column label="Tên bộ từ" prop="PersonalVocabName" />
      <el-table-column label="Mặc định" prop="IsDefault" >
        <template #default="scope">
            <el-switch v-model="scope.row.IsDefault" active-text="Mặc định" inactive-text="Không" @change="changeDefault(scope.row)"/>
        </template>
      </el-table-column>      

      <el-table-column>
  
        <template #header>
          <el-input v-model="search" size="large" placeholder="Tìm kiếm bộ từ" clearable>
        </el-input>
        </template>
  
        <template #default="scope">
          <el-button color="var(--main-color)" size="large" @click="handleDetail(scope.row)"
            >Chi tiết
          </el-button>
          <el-button
            size="large"
            type="danger"
            @click="handleDeleteVocab(scope.row)"
            >Xóa
          </el-button>
        </template>
  
      </el-table-column>
    </el-table>


    <el-dialog v-model="optionsAdd" title="Chọn hình thức thêm">
      <div class="options-container">
        <div class="option-area">
          <el-button type="success" @click="openWith('excel')">
            <v-icon class="option-icon">mdi-microsoft-excel</v-icon>
            Thêm qua excel
          </el-button>
        </div>

        <div class="option-area">
          <el-button type="primary" @click="openWith('default')">
            <v-icon class="option-icon">mdi-plus-thick</v-icon>
            Thêm thủ công
          </el-button>         
        </div>
      </div>
  </el-dialog>


  <!-- Add By Excel -->
  <template>
    <el-dialog
        v-model="addByExcel"
        width="50%"
        title="Thêm bằng Excel"
        append-to-body
      >

      <el-upload
        class="upload-demo"
        drag
        :auto-upload="false"
        :limit="1"
        :action="''"
        :on-change="handleUpload"
        :before-upload="beforeUpload"
      >
        <v-icon style="font-size: 80px;">mdi-progress-upload</v-icon>

        <div class="el-upload__text">
          Thả file ở đây hoặc <em>chọn file</em>
        </div>

        <template #tip>
          <div class="el-upload__tip">
            Chỉ chọn 1 file (dạng xls)
          </div>
        </template>


      </el-upload>

      
      <el-switch
          v-model="typeUser"
          size="large"
          active-text="Dữ liệu là giáo viên "
          inactive-text="Dữ liệu là sinh viên"
        />

      <el-table :data="tableData" style="width: 100%">
      <el-table-column prop="Account" label="Tài khoản"></el-table-column>
      <el-table-column prop="Email" label="Email"></el-table-column>
      <el-table-column prop="Password" label="Password"></el-table-column>
    </el-table>

     <template #footer>
        <div class="dialog-footer">
          <el-button color="var(--main-color)" size="large" @click="addNewUserByExcel()" > Thêm </el-button>
        </div>
      </template>

    </el-dialog>
  </template>

  <!-- Add By default -->
  <template>
    <el-dialog
        v-model="addByDefault"
        width="50%"
        title="Thêm thủ công"
        append-to-body
      >
     
      <el-input v-model="inputNewUsername" size="large" placeholder="Nhập tài khoản" />
      <el-input v-model="inputNewPassword" size="large" placeholder="Nhập mật khẩu" />
      <el-input v-model="inputNewEmail" size="large" placeholder="Nhập email" />

      
      <div>
        <el-select  v-model="value"  placeholder="Quyền truy cập" size="large" clearable >
        <el-option
          v-for="item in optionsRole"
          :key="item.value"
          :label="item.label"
          :value="item.value"
        />
      </el-select>
      </div>

      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" size="large" @click="addNewUserByDefault()"> Thêm </el-button>
        </div>
      </template>


    </el-dialog>
  </template>
  
  
  
    <AskBox 
        v-if="showAskBox"
        :title="'Bạn có muốn xóa bộ từ này ?'"
        :typeButton="'danger'"
        :btnYes="'Xóa'"
        @confirm="deletePersonalVocab"
        @close="this.showAskBox = false"
    />

    <AskBox 
        v-if="warnDefaultCollection"
        :title="'Bộ từ này là mặc định, hãy thay đổi trước khi tiếp tục !'"
        :typeButton="'primary'"
        :btnYes="'Tôi đã hiểu'"
        @confirm="this.warnDefaultCollection = false"
        @close="this.warnDefaultCollection = false"
    />

    <DetailPersonalVocab v-if="showDetail"
        :dataVocabID="detailPersonalVocabID"
        :dataPersonalVocab="dataPersonalVocab"
        :accountID="accountID"
        @close="()=>this.showDetail = false"
    />
  
    </div>
  </template>
  
  <script>
  import { ElNotification } from 'element-plus'
  import DetailPersonalVocab from '../components/DetailPersonalVocab.vue'


  import axiosInstance from '../axios'
  import AskBox from '@/components/AskBox.vue'
  import * as XLSX from 'xlsx';

    export default {
      components: {AskBox, DetailPersonalVocab},
      data () {
        return {
            accountID: this.$route.params.id,
            dataPersonalVocabAPI: '',
            search: '',
            switchDefault: false,
            dataVocabDelete: '',
            showAskBox: false,
            warnDefaultCollection: false,

            showDetail: false,
            detailPersonalVocabID: '',
            dataPersonalVocab: ''
        }
          
      },

      computed: {
        filterPersonalVocab(){
          if (!this.search) {
              return this.dataPersonalVocabAPI;
            }
            return this.dataPersonalVocabAPI.filter(cls => cls.PersonalVocabName.toLowerCase().includes(this.search.toLowerCase()));
        }
      },    
  
      mounted(){
        this.changeTitle()
        this.getPersonalVocab()
  
      },
  
      methods:{
        changeTitle(){
          document.title = "Quản lý từ vựng cá nhân"
        },

        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
        },
  
        getPersonalVocab(){
            axiosInstance.post('getPersonalVocab', {
                "AccountID": this.accountID
            })
            .then((res) => {
                this.dataPersonalVocabAPI = res.data
            })
        },

        changeDefault(collection){
            console.log(collection)

            try{
                axiosInstance.post('changeDefaultPersonalVocab', {
                "AccountID": this.accountID,
                "PersonalVocabID": collection.PersonalVocabID
                })
                .then(() => {
                    this.getPersonalVocab()
                    this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                })

            }
            catch(e){
                this.showNotification('Thông báo', 'Cập nhật ảnh không thành công', 'error')
            }  
        },


        handleDeleteVocab(dataChoose){
          this.dataVocabDelete = dataChoose

            if(this.dataVocabDelete.IsDefault){
                this.warnDefaultCollection = true
            }
            else{
                this.showAskBox = true
            }

        }, 

        deletePersonalVocab(){    
          try{
              axiosInstance.post('deletePersonalVocab',{
                "AccountID": this.accountID,
                "PersonalVocabID": this.dataVocabDelete.PersonalVocabID
              })

              .then((res) => {
                this.showAskBox = false
                this.showNotification('Thông báo', 'Xóa thành công', 'success')
                this.getPersonalVocab()
              })   

          }
          catch{
            this.showNotification('Thông báo', 'Xóa không thành công', 'error')
          }

        },  


        handleDetail(data){
            this.showDetail = true
            this.dataPersonalVocab = data
            this.detailPersonalVocabID = data.PersonalVocabID
        }

        
      }
    }
  </script>
  
  
  <style lang="scss" scoped>
  .container{
    height: 100vh;
  }
 
  .el-dialog{
  
    .el-input + .el-input{
      margin-top: 20px;
    }
  }

  .options-container{
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100% ;
    height: 200px;
  }

  .option-area{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 50%;
    height: 100%;
    font-size: 50px;


    .el-button{
      width: 100%;
      height: 100%;
    }

    .option-icon{
      font-size: 50px;
     
    }
  }

  .el-select{
    margin-top: 20px;
    width: 100%;
  }

  .dialog-footer{


    .el-button{
      width: 100%;
    }
  }
  
  
  
  
  </style>