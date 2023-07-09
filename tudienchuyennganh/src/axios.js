import axios from "axios";
import Cookies from 'js-cookie';

// http://35.247.167.65:8090/
const axiosInstance = axios.create({
  baseURL: 'http://localhost:8090/',

  headers: {
    'Content-Type': 'application/json'
  }
});

// Add a request interceptor
axiosInstance.interceptors.request.use(function (config) {

    const token = Cookies.get('access_token');

    if (token) {
      config.headers.Authorization = token ? `Bearer ${token}` : ''; 
    }
    return config;

  },
  function (error) {
    // Do something with request error
    return Promise.reject(error);
  });

// Add a response interceptor
axios.interceptors.response.use(function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    return response;
  }, function (error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error
    return Promise.reject(error);
  });

// This code sets authorization headers for all requests:
// https://blog.logrocket.com/using-axios-set-request-headers/
export default axiosInstance;
