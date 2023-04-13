<template>

    <div>
        <el-dialog 
            v-model="showBox"  
            :title="`Chi tiết lớp ${this.className}`"
            width="90%"
            fullscreen
            destroy-on-close
            >
    
          <el-input v-model="inputClassName" :placeholder="`${this.inputClassName}`" disabled />

          <div style="margin-top: 20px;">
                Số lượng sinh viên trong lớp: 
                <el-button type="primary" plain disabled >  
                  {{ arrClass.flatMap(cls => cls).filter(cls => cls.IsApproved === true).length}} 
                </el-button> 
          </div>
          

          <div style="margin-top: 20px;">
              <el-badge :value="`${arrClass.flatMap(cls => cls).filter(cls => cls.IsApproved === false).length}`" class="item">
                <el-button plain @click="this.showListNeedApproved = true"> 
                  Đang chờ xét duyệt
                </el-button> 
            </el-badge>

          </div>
            
        
          <el-divider></el-divider>
    
            <!-- Data table -->
          <el-table 
            max-height="400px"
            :data="filterStundentHasApproved" 
            :default-sort="{ prop: 'TopicID', order: 'ascending' }"
            empty-text="Bạn cần phê duyệt để thấy danh sách sinh viên"
          >
    
          <el-table-column label="ID" prop="DetailID"  sortable/>
          <el-table-column label="Họ và tên" prop="Name" />
          <el-table-column label="Giới tính" prop="Gender" />
          <el-table-column align="center">
    
          <template #header>
            <el-input v-model="search" size="large" placeholder="Nhập tên sinh viên" @input="handleSearch"/>
          </template>
    
          <template #default="scope">
            <el-button
              size="large"
              type="danger"
              @click="handleDeleteClass(scope.row.IDCLASS)"
              >Xóa
            </el-button>
          </template>
    
        </el-table-column>
      </el-table>
    
          
        <template #footer>
          <div class="dialog-footer">
            <el-button @click="this.showBox = false">Đóng</el-button>
    
            <el-button type="primary" @click="this.confirmTopic()">
             Xác nhận 
             </el-button>
          </div>
        </template>
    
      </el-dialog>
    
      <!-- Detail class -->
      <template>
        <el-dialog
            v-model="innerVisible"
            title="Chi tiết từ"
            height="50%"
            width="50%"
            append-to-body
            align-center
          >
    
           <el-form
           label-width="130px"
          :label-position="labelPosition">
     
    
          <el-form-item  label="Từ vựng"> 
            <el-input v-model="dataDetailVocab.Word" @input="this.checkChange()" />
          </el-form-item>
    
          <el-form-item label="Nghĩa">
            <el-input v-model="dataDetailVocab.Vietnamese" @input="this.checkChange()" />
          </el-form-item>
    
        
          <el-form-item label="Ví dụ tiếng việt">
            <el-input 
            type="textarea"
            v-model="dataDetailVocab.VN_Example" @input="this.checkChange()" />
          </el-form-item>
        
          <el-form-item label="Vị trí">
            <el-input v-model="dataDetailVocab.Position" @input="this.checkChange()" />
          </el-form-item>
    
           
          <el-form-item label="Lemma">
            <el-input v-model="dataDetailVocab.Lemma" @input="this.checkChange()" />
          </el-form-item>
    
          <el-form-item label="Loại">
            <el-input v-model="dataDetailVocab.Label" @input="this.checkChange()" />
          </el-form-item>
          
          
          <el-form-item label="Phát âm">
            <el-input v-model="dataDetailVocab.IPA" @input="this.checkChange()" />
          </el-form-item>
    
          
          <el-form-item label="Câu ví dụ">
            <el-input type="textarea" v-model="dataDetailVocab.Example" @input="this.checkChange()" />
          </el-form-item>
    
       
          <el-form-item label="Hiển thị">
            <el-switch v-model="dataDetailVocab.Active"  active-text="Hiện" inactive-text="Ẩn" @change="this.checkChange"/>
          </el-form-item>
          
         
          
          <el-form-item label="Cụm từ ">
            <el-input v-model="dataDetailVocab.Cluster" @input="this.checkChange()" />
          </el-form-item>
           
           
          <el-form-item label="Nguồn tham khảo">
            <el-input type="textarea" v-model="dataDetailVocab.Resources" @input="this.checkChange()" />
          </el-form-item>
        </el-form>
    
          <template #footer>
            <div class="dialog-footer">
              <el-button @click="this.innerVisible = false">Đóng</el-button>
    
              <el-button type="primary" @click="this.confirmChange()"> Xác nhận </el-button>
            </div>
          </template>
    
    
        </el-dialog>
    
       
    
      </template>




      <!-- Approved Box -->
      <el-dialog v-model="showListNeedApproved" title="Danh sách sinh viên cần phê duyệt vào lớp" width="70%">

        <el-table 
            max-height="400px"
            :data="filterStundentNotApproved" 
            :default-sort="{ prop: 'DetailID', order: 'ascending' }"
            empty-text="Không có sinh viên cần phê duyệt"
          >
    
          <el-table-column label="ID" prop="DetailID"  sortable/>
          <el-table-column label="Họ và tên" prop="Name" />
          <el-table-column label="Giới tính" prop="Gender" />
          <el-table-column align="center">
    
          <template #header>
            <el-input v-model="search" size="large" placeholder="Nhập tên sinh viên" @input="handleSearch"/>
          </template>
    
          <template #default="scope">
            <el-button type="primary" size="large" @click="approveStudent(scope.row)"
              >Phê duyệt
            </el-button>
          </template>  
        </el-table-column>
      </el-table>

      <template #footer>
        <el-button type="primary" @click="handleVocabChoose(scope.row)">Phê duyệt tất cả</el-button>
        <el-button @click="showListNeedApproved = false">Đóng</el-button>
      </template>

        
      </el-dialog>
    
    
      </div>
    </template>
    
    <script>
import axiosInstance from '../axios'
    import { ElNotification } from 'element-plus'
    
    
    export default {
        props: ['showDetailBox','dataClass'],
        data(){
            return {
                showBox: true,
                inputClassName: this.dataClass.ClassName,
                classID: this.dataClass.IDCLASS,
                className: this.dataClass.ClassName,
                filteredClass: [],
                filterPeopleApproved:[],
                innerVisible: false,
    
                detailVocab: '',
                labelPosition: 'left',
    
                arrClass: [],
                search: '',
                class: '',
                isChange: false,

                showListNeedApproved: false,
    
                refreshKey: 0,

    
                dataDetailVocab: {
                  Word: '',
                  Vietnamese: '',
                  VN_Example: '',
                  Position: '',
                  Lemma: '',
                  Label: '',
                  IPA: '',
                  Example: '',
                  Active: '',
                  Cluster: '',
                  Resources:''
                }
            }
        },
    
        watch:{
            showBox: function(){
                this.$emit('close')
            }
        },
    
        computed: {
        // Mảng sản phẩm đã lọc theo giá trị tìm kiếm
            filteredClass() {
              if (!this.search) {
                return this.class;
              }
             return this.class.filter(cls => cls.Name.toLowerCase().includes(this.search.toLowerCase()));
            },

            filterStundentHasApproved(){
              if (!this.search) {
                return this.arrClass.flatMap(cls => cls).filter(cls => cls.IsApproved === true)
              }
             return this.arrClass.flatMap(cls => cls).filter(cls => cls.Name.toLowerCase().includes(this.search.toLowerCase()));
            },

            filterStundentNotApproved(){
              this.refreshKey;
              if (!this.search) {
                return this.arrClass.flatMap(cls => cls).filter(cls => cls.IsApproved === false)
              }
             return this.arrClass.flatMap(cls => cls).filter(cls => cls.Name.toLowerCase().includes(this.search.toLowerCase()));
            }
        },
    
        mounted(){
            this.getDataTableTopic()
        },
    
        methods: {
            async getDataTableTopic(){


                let result = await axiosInstance.post(`DetailClass`, {
                    "IDCLASS": this.classID
                })
                
                if(result.status == 200){
                    this.class = result.data

                    this.arrClass.length = 0
                    this.arrClass.push(result.data)
                  
                }       
            },

            handleIsNotApproved(){
              this.arrClass.map(cls => {
                if(cls.IsApproved == false){
                  console.log(cls)
                }
              });
            },
    

            showNotification(title ,message, type){
                ElNotification({
                    title: `${title}`,
                    message: `${message}`,
                    type: `${type}`,
                })
            },    
    
            handleVocabChoose(dataVocabChoose){
    
              //Tự động gán giá trị data object cùng với data của từ đã chọn
              var keys = Object.keys(dataVocabChoose)
              keys.forEach((data)=>{
                this.dataDetailVocab[data] = dataVocabChoose[data]
              })
    
              this.innerVisible = true
            },
    
            // Nếu có input nào thay đổi thì thay đổi thành có sự thành đổi -> không cần phải post lên api mỗi khi ko có xác nhận
            checkChange(){
              console.log(this.dataDetailVocab.Active)
              this.isChange = true
            },  
    
            async confirmChange(){
              //Đã có sự thay đổi ô input bất kì
              if(this.isChange){
                let result = await axiosInstance.put('updateVocabByTopicID', {
                  "TopicID": parseInt(this.dataDetailVocab.TopicID),
                  "VocabID": parseInt(this.dataDetailVocab.VocabID),
                  "Word": `${this.dataDetailVocab.Word}`,
                  "IPA": `${this.dataDetailVocab.IPA}`,
                  "Label": `${this.dataDetailVocab.Label}`,
                  "Lemma": `${this.dataDetailVocab.Lemma}`,
                  "Vietnamese": `${this.dataDetailVocab.Vietnamese}`,
                  "Cluster": `${this.dataDetailVocab.Cluster}`,
                  "Position": `${this.dataDetailVocab.Position}`,
                  "Example": `${this.dataDetailVocab.Example}`,
                  "VN_Example": `${this.dataDetailVocab.VN_Example}`,
                  "Resources": `${this.dataDetailVocab.Resources}`,
                  "Active": this.dataDetailVocab.Active == true ? 1 : 0
                })
    
                if(result.status == 200){
                  this.showNotification('Thông báo', 'Cập nhật thành công', 'success')
                  this.getDataTableTopic()
                  this.innerVisible = false
                }
                else{
                  this.showNotification('Thông báo', 'Cập nhật không thành công', 'error')
                }
    
    
                this.isChange = false
    
              }
              else{
                this.isChange = false
                console.log('xác nhận chưa thay đổi')
                this.innerVisible = false
              }
            },


            async approveStudent(dataStudent){
              try{

                let result = await axiosInstance.post('updateStudentApproved', {
                  "DetailID": dataStudent.DetailID
                })

                if(result.status == 200){
                  this.showNotification('Thông báo', 'Phê duyệt thành công', 'success')
                  this.getDataTableTopic()
                  this.refreshKey++;

                }



              }
              catch(e){
                this.showNotification('Thông báo', 'Không thể lấy dữ liệu', 'error')
              }

            },
    
            async confirmTopic(){
              if(this.isChange){
                let result = await axiosInstance.put('updateTopic', {
                    "TopicID": this.classID,
                    "TopicName": `${this.inputClassName}`,
                    "TopicDescribe": `${this.inputTopicDescribe}`,
                })
    
                if(result.status == 200){
                    this.showNotification('Thông báo', 'Cập nhật chủ đề thành công', 'success')
                    this.getDataTableTopic()
                    this.showBox = false
                    this.$emit('update-data')
                }
                else{
                  this.showNotification('Thông báo', 'Cập nhật chủ đề không thành công', 'error')
                }
    
                this.isChange = false
              }
              else{
                this.isChange = false
                console.log('xác nhận chưa thay đổi')
                this.showBox = false
              }
        
            }
        }
        
    }
    </script>
    
    <style scoped>
    .dialog-footer button:first-child {
      margin-right: 10px;
    }
    
    
    .addVocab{
      margin-bottom: 20px;
    }
    
    </style>