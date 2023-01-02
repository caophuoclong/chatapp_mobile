class IDatabase {
  get(Map<String, dynamic> where, {select = "*"}) {}
  getMany(Map<String, dynamic> where, {select = "*"}) {}
  insert(Map<String, dynamic> model) {}
  update(Map<String, dynamic> model) {}
  delete() {}
}
