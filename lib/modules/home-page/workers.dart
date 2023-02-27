class worker {
  String imgpath;
  String workername;
  int age;
  worker({required this.imgpath, required this.workername, required this.age});
}

Map<String,worker> map = {
  "Yousef": worker(imgpath: "assets/Workers/1.jpg", workername: "Yousef", age: 22),
  "Gamal":  worker(imgpath: "assets/Workers/2.jpg", workername: "Gamal", age: 30),
  "Nagy":   worker(imgpath: "assets/Workers/3.jpg", workername: "Nagy", age: 35),
  "Salah":  worker(imgpath: "assets/Workers/4.jpg", workername: "Salah", age: 30),
  "Ziad":   worker(imgpath: "assets/Workers/5.jpg", workername: "Ziad", age: 30),
  "Mousad":  worker(imgpath: "assets/Workers/6.jpg", workername: "Mousad", age: 30),
  "Mustafa":   worker(imgpath: "assets/Workers/7.jpg", workername: "Mustafa", age: 30),
"Abd Allah Fawzy":   worker(imgpath: "assets/Workers/8.jpg", workername: "Abd Allah Fawzy", age: 30),


};
List<worker> Workers = [
  worker(imgpath: "assets/Workers/1.jpg", workername: "Yousef", age: 22),
  worker(imgpath: "assets/Workers/2.jpg", workername: "Gamal", age: 30),
  worker(imgpath: "assets/Workers/3.jpg", workername: "Nagy", age: 35),
  worker(imgpath: "assets/Workers/4.jpg", workername: "Salah", age: 30),
  worker(imgpath: "assets/Workers/5.jpg", workername: "Ziad", age: 30),
  worker(imgpath: "assets/Workers/6.jpg", workername: "Muhammed Nour", age: 30),
  worker(imgpath: "assets/Workers/7.jpg", workername: "Mustafa", age: 30),
  worker(imgpath: "assets/Workers/8.jpg", workername: "Abd Allah Fawzy", age: 30),
];
