migrate((app) => {
  try {
    app.findAuthRecordByEmail("_superusers", "admin@admin.com");
  } catch (e) {
    const collection = app.findCollectionByNameOrId("_superusers");
    const record = new Record(collection);
    record.set("email", "admin@admin.com");
    record.set("password", "admin123456");
    record.set("passwordConfirm", "admin123456");
    app.save(record);
  }
}, (app) => {
  try {
    const record = app.findAuthRecordByEmail("_superusers", "admin@admin.com");
    app.delete(record);
  } catch (e) {}
});
