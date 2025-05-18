// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  ssr: false,

  future: {
    compatibilityVersion: 4,
  },

  imports: {
    dirs: ['utils/**'],
  },

  modules: [
    '@leexi/shared',
    ['@nuxt/eslint', {
      config: {
        standalone: false,
      },
    }],
  ],
});
