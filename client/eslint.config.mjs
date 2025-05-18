import vue from '@leexi/shared/eslint/vue';
import withNuxt from './.nuxt/eslint.config.mjs';

export default withNuxt([
  ...vue,
  {
    rules: {
      'vue/no-bare-strings-in-template': 'off',
    },
  },
]);
