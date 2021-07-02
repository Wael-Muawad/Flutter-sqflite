class Student {
  int id;
  int mark;
  String name;
  String major;

  Student(this.id, this.mark, this.name, this.major);

  Map <String, dynamic> objectToMap() {
    return {
      'id': this.id,
      'name': this.name,
      'major': this.major,
      'mark': this.mark,
    };
  }


}
