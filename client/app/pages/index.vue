<template>
  <div>
    <button @click="start_date = start_date.subtract(7, 'days')">
      Previous week
    </button>
    <button @click="start_date = start_date.add(7, 'days')">
      Next week
    </button>

    <template v-if="sessions">
      <p>Playtime this perdiod: {{ playtime }}</p>

      <BarChart
        v-if="sessions"
        :datasets
        :labels
      />
    </template>
  </div>
</template>

<script setup lang="ts">
import type { Session } from '~/types';

const colors = ['#0000FF', '#008000', '#FF0000', '#FFC0CB', '#FFA500', '#808080', '#FFFF00', '#000000', '#40E0D0', '#A52A2A'];

const dayjs = useDayjs();

const start_date = ref(dayjs.utc().startOf('week'));

const end_date = computed(() => start_date.value.add(6, 'days'));
const playtime = computed(() => dayjs.duration(sumBy(sessions.value, 'duration') * 1000).format('HH[h]mm'));

const { data: sessions } = useFetch<Session[]>('http://localhost:8080/sessions', {
  query: { start_date, end_date },
});

const datasets = computed(() => {
  const games: Record<string, Session[]> = groupBy(sessions.value, 'game.name');

  const sets = Object.entries(games).map(([label, data], index) => ({
    backgroundColor: colors[index],
    data: labels.value.map(datestring => {
      const date = dayjs.utc(datestring);
      const session = data.find(({ played_at }) => dayjs.utc(played_at).isSame(date, 'day'));

      return session?.duration || 0;
    }),
    label,
  }));

  return sortBy(sets, ({ data }: (typeof sets)[number]) => -sum(data));
});

const labels = computed(() => {
  const length = end_date.value.diff(start_date.value, 'days') + 1;
  return Array.from({ length }, (_, index) => start_date.value.add(index, 'day').format('YYYY-MM-DD'));
});
</script>
