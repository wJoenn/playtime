export const groupBy = (records, attr) => records.reduce((groupedRecords, currentRecord) => {
  const key = get(currentRecord, attr);
  groupedRecords[key] ||= [];
  groupedRecords[key].push(currentRecord);

  return groupedRecords;
}, {});
