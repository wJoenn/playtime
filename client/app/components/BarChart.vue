<template>
  <Bar
    :data="{ datasets, labels }"
    :options
  />
</template>

<script setup lang="ts">
import { BarElement, CategoryScale, Chart, Legend, LinearScale, Title, Tooltip } from 'chart.js';
import { Bar } from 'vue-chartjs';

Chart.register(BarElement, CategoryScale, Legend, LinearScale, Title, Tooltip);

const props = defineProps<{
  datasets: { data: number[], label: string }[]
  labels: string[]
}>();

const dayjs = useDayjs();

const formatValue = (value: number) => dayjs.duration(value * 1000).format('HH[h]mm');

const options = {
  plugins: {
    tooltip: {
      callbacks: {
        label: ({ dataset: { label }, formattedValue }) => {
          const value = formatValue(+formattedValue.replaceAll(/[,\s]/g, ''));
          return `${label}: ${value}`;
        },
      },
    },
  },
  scales: {
    x: {
      stacked: true,
    },
    y: {
      stacked: true,
      ticks: {
        callback: formatValue,
      },
    },
  },
};
</script>
