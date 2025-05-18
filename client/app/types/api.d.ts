import type { DateString, Timestamp } from '~/types';

export type Game = {
  appid?: number
  cover_url: string
  created_at: Timestamp
  id: number
  name: string
  updated_at: Timestamp
};

export type Session = {
  active: boolean
  created_at: DateString
  duration: number
  game_id: number
  id: number
  played_at: Timestamp
  updated_at: Timestamp
};
