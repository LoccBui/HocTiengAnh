<template>  
    <div class="otp-cover">

        <span class="otp-heading-text  no-hover-pointer">Mã OTP đã được gửi vào email của bạn </span>

        <p :class="{'text-danger': total<=0}" v-if="showTimeRunning">
            <strong class="otp-timer">{{minutes}}</strong>
            <strong class="otp-timer">:</strong>
            <strong class="otp-timer">{{seconds}}</strong>
        </p>

        <div style="display: flex; flex-direction: row; padding: 20px 0px; " v-if="showTimer">
            <v-otp-input 
                ref="otpInput"
                input-classes="otp-input"
                separator="-"
                :num-inputs="6"
                :should-auto-focus="true"
                :is-input-num="true"
                :conditionalClass="['one', 'two', 'three', 'four']"
                :placeholder="['*', '*', '*', '*']"
                @on-change="handleOnChange"
                @on-complete="handleOnComplete"
            />
            <v-btn color="primary" @click="clearInput()"> Xóa </v-btn>
        </div>
    
        <div class="resend-otp-area">
            <span class="no-hover-pointer">Không nhận được mã OTP ? </span>
            <a class="primary-text-color hover-pointer" @click="this.generateOTPForEmail()"> Gửi lại mã </a>
        </div>

        <v-btn color="primary" 
        :disabled="hiddenConfirmOTP"
        block
        @click="confirmOTP()"
        > Xác nhận </v-btn> 

        <br>

        <v-alert v-if="showAlertWrongOTP" color="error" icon="$error" min-width="100%">
            Mã OTP không chính xác, bạn còn a    {{ tryTimes }}  cho lần thử nữa.
        </v-alert>

    </div>
</template>

<script>
import VOtpInput from 'vue3-otp-input';
import { ref } from 'vue';
import axiosInstance from '../axios'
import { ElNotification } from 'element-plus'
import emailjs from '@emailjs/browser';


export default {
    components: { VOtpInput },
    props: {
        time: {
            type: Number,
            default: 0,
            inputOTP: ''
        },
        accountID: {
            type: Number,
            default: 0
        },

        wrongOTP: {
            type: Number,
            default: 0
        }
    },
    watch:{
        wrongOTP: function(){
           this.handleWrongOTP()
        }
    },

    setup() {
        const otpInput = ref(null)


        const showTimeRunning = ref(true)
        const hiddenConfirmOTP = ref(false)
        const showTimer = ref(true)

            const handleOnComplete = (value) => {
                console.log('OTP completed: ', value)
                console.log('OTP completed nef')
            };

            const handleOnChange = (value) => {
                console.log('OTP changed: ', value);
            };

            const clearInput = () => {
                otpInput.value.clearInput()
            }

        return { handleOnComplete, handleOnChange, clearInput, otpInput , showTimer, showTimeRunning, hiddenConfirmOTP};
    },

    data: function () {
        return {
            total: '',
            minutes: '--',
            seconds: '--',
            interval: 0,
            token: '1234',

            tryTimes: 10,
            showAlertWrongOTP: false,

            otpInputCode: [],
        }
    },
    mounted() {
        this.total = parseInt(this.time, 10)
        this.interval = setInterval(() => {
            this.tick()
        }, 1000)
    },
    methods: {
        showNotification(title ,message, type){
            ElNotification({
                title: `${title}`,
                message: `${message}`,
                type: `${type}`,
            })
         },

        str_pad_left: function (string, pad, length) {
            return (new Array(length+1).join(pad)+string).slice(-length)
        },
        tick: function () {

            var minutes = Math.floor(this.total / 60)
            var seconds = this.total - minutes * 60
            this.minutes = this.str_pad_left(minutes, '0', 2)
            this.seconds = this.str_pad_left(seconds, '0', 2)

            if (this.total <= 0) {
                clearInterval(this.interval)
                this.$emit('timer-stop')
                console.log('hết giờ nha')
                this.showTimer = false
            }

            this.total -= 1          
        },

        confirmOTP(){
            var arrOTP= [].concat(this.otpInput.otp).join("")
            this.$emit('confirm-OTP', arrOTP)
        },

        generateOTPForEmail(){
            axiosInstance.get(`generateOTP/${this.accountID}`)

            .then( (result) => {
                console.log(result.data)
                this.showNotification('Thông báo', 'Tạo otp mới thành công', 'success')
                this.$emit('refreshNewOTP')
                this.sendEmailToUser(result.data[0])
            })

            .catch( () => {
                this.showNotification('Thông báo', 'Tạo otp không thành công', 'error')
            })         
        },

        sendEmailToUser(data){
            // Send OTP to email have verified 
            var emailParams = {
                user_name: `${data.Name}`,
                otp_code: `${data.OTPCode}`,
                from_name: "Học từ vựng Tiếng Anh",
                user_email: `${data.Email}`,
            }

            emailjs.send(
            `${import.meta.env.VITE_SERVICE_ID}`,
            `${import.meta.env.VITE_TEMPLATE_ID}`, 
                emailParams, 
            `${import.meta.env.VITE_PUBLIC_KEY_ID}`)

            .then(() => {
                this.showNotification('Thông báo', 'Đã gửi OTP', 'success')
            })

            },

        handleWrongOTP(){
            if(this.wrongOTP != 0){
                this.showNotification('Thông báo', 'Mã otp không chính xác', 'error')
                this.showTimer = this.showTimeRunning = false
                this.hiddenConfirmOTP = true
            }
        }



    },

    
}
</script>

<style>
.otp-cover{
    width: 100%;
    height: auto;
    display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: space-between;
}

.otp-timer{
    font-size: 40px;
}

.btn-otp-clear{
    background-color: var(--main-color);
    padding: 10px;
    border-radius: 10px;
    color: var(--light-blue-90);
}

.otp-input {
  width: 40px;
  height: 40px;
  padding: 5px;
  margin: 0 10px;
  font-size: 20px;
  border-radius: 4px;
  border: 1px solid var(--main-color);
  text-align: center;
}

/* Background colour of an input field with value */
.otp-input.is-complete {
  background-color: #e4e4e4;
}
.otp-input::-webkit-inner-spin-button,
.otp-input::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
input::placeholder {
  font-size: 15px;
  text-align: center;
  font-weight: 600;
}

.otp-sub-text{
    color: var(--gray-text);

}

.resend-otp-area{
    margin: 20px 0px;
}

.otp-heading-text {
    margin-bottom: 20px;
    
}
</style>