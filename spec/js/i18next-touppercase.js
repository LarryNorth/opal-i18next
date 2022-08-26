export default {
  name: 'touppercase',
  type: 'postProcessor',

  process(value, key, options, translator) {
    return value.toUpperCase();
  }
}
