<template>
    <div class="container">

      <el-button size="large" color="var(--main-color)" @click="handleOpenCreateNewVocab()"> Thêm bộ từ mới </el-button>
     
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


  <div class="personalVocabDialog">
        <el-dialog
            v-model="showPersonalVocabDialog"
            title="Thêm bộ từ mới"
            width="30%"
            :before-close="() => this.showPersonalVocabDialog = false"
        >

            <el-form  
                ref="ruleFormRef"
                :model="ruleForm"
                :rules="rules"
                status-icon
                label-width="20%" :label-position="'left'" >

                <el-form-item label="Tên bộ từ" prop="personalVocabname" >
                    <el-input prop="inputPersonalVocabName" size="large" 
                    v-model="ruleForm.personalVocabname" placeholder="Nhập tên bộ từ"   />
                </el-form-item>

            </el-form>
            <template #footer>
            <span class="dialog-footer">
                <el-button color="var(--main-color)" size="large" @click="createNewPersonalVocab()">
                    Xác nhận
                </el-button>
            </span>
            </template>
        </el-dialog>
    </div>

  
  
  
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
        @update="updateTable"
    />
  
    </div>
  </template>
  
  <script>
  import { ElNotification } from 'element-plus'
  import DetailPersonalVocab from '../components/DetailPersonalVocab.vue'
  import { requireTokenMixin } from '@/mixin/requireTokenMixin'


  import axiosInstance from '../axios'
  import AskBox from '@/components/AskBox.vue'

    export default {
      components: {AskBox, DetailPersonalVocab},
      mixins:[requireTokenMixin],

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
            dataPersonalVocab: '',
            showPersonalVocabDialog: false,

            ruleForm : {
                inputPersonalVocabName: '',
            },

            rules: {
                personalVocabname: [{ required: true, message: 'Bạn cần nhập tên bộ từ mới', trigger: 'change' }],
            }       
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
        },

        updateTable(){
          this.getPersonalVocab()
        },


        handleOpenCreateNewVocab(){
          this.showPersonalVocabDialog = true
       },

       async createNewPersonalVocab(){

        await  this.$refs.ruleFormRef.validate((valid) => {
            if (valid) {
                try{
                    axiosInstance.post('createPersonalVocab', {
                        "AccountID": this.accountID,
                        "PersonalVocabName": `${this.ruleForm.personalVocabname}`
                    })
                    .then(() => {
                        this.showPersonalVocabDialog = false
                        this.$refs.ruleFormRef.resetFields();
                        this.getPersonalVocab()
                        this.showNotification('Thông báo', 'Thêm thành công', 'success')
                    })

                }
                catch(e){
                    this.showNotification('Thông báo', 'Thêm không thành công', 'error')
                }  

                } else {
                    this.$message.error('Dữ liệu còn thiếu.');
                    return false;
                }
         });
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