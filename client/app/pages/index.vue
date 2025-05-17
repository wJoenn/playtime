<template>
  <div>
    <button @click="start_date = start_date.subtract(7, 'days')">
      Previous week
    </button>
    <button @click="start_date = start_date.add(7, 'days')">
      Next week
    </button>
    <Bar
      v-if="sessions"
      :data="{ datasets, labels }"
      :options
    />
  </div>
</template>

<script setup>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from 'chart.js';
import { Bar } from 'vue-chartjs';

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

const dayjs = useDayjs();

const start_date = ref(dayjs.utc().startOf('week'));
const end_date = computed(() => start_date.value.add(6, 'days'));

const options = {
  scales: {
    x: {
      stacked: true,
    },
  },
};

const { data: sessions } = useFetch('http://localhost:8080/sessions', {
  query: { start_date, end_date },
});

const datasets = computed(() => {
  const games = groupBy(sessions.value, 'game.name');
  return Object.entries(games).map(([label, data]) => ({
    data: labels.value.map(datestring => {
      const date = dayjs.utc(datestring);
      const session = data.find(({ played_at }) => dayjs.utc(played_at).isSame(date, 'day'));
      return session?.duration || 0;
    }),
    label,
  }));
});

const labels = computed(() => {
  const length = end_date.value.diff(start_date.value, 'days') + 1;
  return Array.from({ length }, (_, index) => start_date.value.add(index, 'day').format('YYYY-MM-DD'));
});

const get = (record, path) => {
  let value = record;
  path.split('.').forEach(key => value = value?.[key]);
  return value;
};

const groupBy = (records, attr) => records.reduce((groupedRecords, currentRecord) => {
  const key = get(currentRecord, attr);
  groupedRecords[key] ||= [];
  groupedRecords[key].push(currentRecord);

  return groupedRecords;
}, {});
</script>
