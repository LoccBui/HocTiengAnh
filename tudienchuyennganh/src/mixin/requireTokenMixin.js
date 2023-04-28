import Cookies from 'js-cookie';



export const requireTokenMixin = {
  created() {
    const token = Cookies.get('access_token');
    const expires = Cookies.get('access_token')?.expires;

    const expiresAt = new Date(Date.now() + (expires* 1000));

    const tokenExpired = expiresAt.getTime() <= Date.now();

    if (!token || tokenExpired) {
        this.$router.push('/login');
    }
  },
};