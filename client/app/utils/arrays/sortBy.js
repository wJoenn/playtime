export const sortBy = (records, attrsOrCallbacks) => {
  const directions = [];
  if (!Array.isArray(attrsOrCallbacks)) { attrsOrCallbacks = [attrsOrCallbacks]; }

  attrsOrCallbacks = attrsOrCallbacks.map((attrOrCallback, index) => {
    if (typeof attrOrCallback === 'string' && attrOrCallback[0] === '-') {
      directions[index] = -1;
      return attrOrCallback.slice(1);
    } else {
      directions[index] = 1;
      return attrOrCallback;
    }
  });

  const getValue = (record, index) => {
    const attrOrCallback = attrsOrCallbacks[index];
    if (typeof attrOrCallback === 'string') {
      return record[attrOrCallback];
    } else if (typeof attrOrCallback === 'function') {
      return attrOrCallback(record);
    } else {
      return 0;
    }
  };

  return deepDup(records).sort((a, b) => {
    for (let i = 0; i < attrsOrCallbacks.length; i++) {
      const aValue = getValue(a, i);
      const bValue = getValue(b, i);

      if (typeof aValue === 'string' && aValue.localeCompare(bValue) !== 0) {
        return aValue.localeCompare(bValue) > 0 ? directions[i] : -directions[i];
      } else if (typeof aValue === 'number' && aValue !== bValue) {
        return (aValue - bValue) * directions[i];
      } else if (typeof aValue === 'boolean' && aValue !== bValue) {
        return aValue ? directions[i] : -directions[i];
      }
    }

    return 0;
  });
};
