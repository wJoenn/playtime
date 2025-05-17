import dayjs from 'dayjs';
import updateLocale from 'dayjs/plugin/updateLocale';
import utc from 'dayjs/plugin/utc';

dayjs.extend(updateLocale);
dayjs.extend(utc);

dayjs.updateLocale('en', {
  weekStart: 1,
});

export const useDayjs = () => dayjs;
