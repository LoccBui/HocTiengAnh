<template>
  <div class="container">
    <!-- note:
        Show chủ đề -> lọc theo khoa

        Từ vựng hiển thị trong chủ đề
        
    
    -->

    <v-btn color="error" > Import Excel</v-btn>
    <input v-model="searchString" placeholder="search" class="mb-1">

    <v-table 

theme="dark">
<thead>
  <tr>
    <th class="text-left">
      Name
    </th>
    <th class="text-left">
      Calories
    </th>
    <th class="text-left">
      Action
    </th>
  </tr>
</thead>
<tbody>
  <tr
    v-for="item in desserts"
    :key="item.name"
  >
    <td>{{ item.name }}</td>
    <td>{{ item.calories }}</td>
    <td>
      <v-btn color="red"> Thêm</v-btn>
      <v-btn color="red"> Xóa</v-btn>
    </td>
  </tr>
</tbody>
</v-table>


  </div>
</template>

<script>
export default {
  data () {
      return {
        searchString: "",
        desserts: [
          {
            name: 'Frozen Yogurt',
            calories: 159,
          },
          {
            name: 'Ice cream sandwich',
            calories: 237,
          },
          {
            name: 'Eclair',
            calories: 262,
          },
          {
            name: 'Cupcake',
            calories: 305,
          },
          {
            name: 'Gingerbread',
            calories: 356,
          },
          {
            name: 'Jelly bean',
            calories: 375,
          },
          {
            name: 'Lollipop',
            calories: 392,
          },
          {
            name: 'Honeycomb',
            calories: 408,
          },
          {
            name: 'Donut',
            calories: 452,
          },
          {
            name: 'KitKat',
            calories: 518,
          },
        ],
      }
        
    },
}
</script>

<style>

</style>