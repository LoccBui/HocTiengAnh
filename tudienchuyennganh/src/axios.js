import axios from "axios";
// axios.defaults.baseURL = 'http://localhost:8000';

const axiosInstance = axios.create({
  baseURL: 'http://localhost:8090/'
});

// Add a request interceptor
axios.interceptors.request.use(function (config) {
    // Do something before request is sent
    config.headers = config.headers || {};
    config.headers['Content-Type'] = 'application/json';
    return config;
  }, function (error) {
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
