export const get = (record, path) => {
  let value = record;
  path.split('.').forEach(key => value = value?.[key]);

  return value;
};
