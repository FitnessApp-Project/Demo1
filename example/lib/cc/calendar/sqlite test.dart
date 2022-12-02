import 'package:flutter/material.dart';
import 'TodoDB.dart';
enum extraAction { edit, delete }
class ListWidget extends StatefulWidget {
  @override
  _ListState createState() => _ListState();
}
class _ListState extends State<ListWidget> {
  List<Todo> listArr = [];
  // 查所有list
  void getTodoList() async {
    final list = await TodoDB.getTodos();
    setState(() {
      listArr = list;
    });
  }
  // 打勾
  void onChangeCheckbox(val, todo) async {
    final updateTodo =
    Todo(id: todo.id, name: todo.name, isCompleted: val ? 1 : 0);
    await TodoDB.updateTodo(updateTodo);
    getTodoList();
  }
  // 新增
  void addTodo() async {
    final newTodo = Todo(
      id: new DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'new Todo',
      isCompleted: 0,
    );
    await TodoDB.addTodo(newTodo);
    getTodoList();
  }
  // 選擇編輯 or 刪除
  void editList(type, context, todo) {
    switch (type) {
      case extraAction.edit:
        Navigator.push<void>(
            context,
            MaterialPageRoute(
                builder: (context) => FullScreenDialog(
                    onSave: editTodo, todo: todo, onDelete: deleteTodo),
                fullscreenDialog: true));
        break;
      case extraAction.delete:
        deleteTodo(todo);
        break;
      default:
        print('error!!');
    }
  }
  // 編輯
  void editTodo(name, todo) async {
    final updateTodo =
    Todo(id: todo.id, name: name, isCompleted: todo.isCompleted);
    await TodoDB.updateTodo(updateTodo);
    getTodoList();
    Navigator.pop(context);
  }
  // 刪除
  void deleteTodo(todo) async {
    await TodoDB.deleteTodo(todo.id);
    getTodoList();
  }
  @override
  void initState() {
    super.initState();
    getTodoList();
  }
  void dispose() {
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoList'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                for (int index = 1; index <= listArr.length; index++)
                  ListTile(
                    leading: Checkbox(
                        value: listArr[index - 1].isCompleted == 1,
                        onChanged: (val) {
                          onChangeCheckbox(val, listArr[index - 1]);
                        }),
                    title: Text('${listArr[index - 1].name}',
                        style: TextStyle(
                            color: listArr[index - 1].isCompleted == 1
                                ? Colors.grey.shade400
                                : Theme.of(context).textTheme.bodyText1?.color,
                            decoration: listArr[index - 1].isCompleted == 1
                                ? TextDecoration.lineThrough
                                : null)),
                    trailing: PopupMenuButton<extraAction>(
                      onSelected: (type) {
                        editList(type, context, listArr[index - 1]);
                      },
                      itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<extraAction>>[
                        PopupMenuItem<extraAction>(
                          value: extraAction.edit,
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<extraAction>(
                          value: extraAction.delete,
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          MaterialBanner(
            content: Text(
                '共 ${listArr.length} 個清單，已完成 ${listArr.where((obj) => obj.isCompleted == 1).length} 個'),
            actions: <Widget>[],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: addTodo, child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
class FullScreenDialog extends StatefulWidget {
  FullScreenDialog({required this.onSave,required this.todo,required this.onDelete});
  final Function onSave;
  final Todo todo;
  final Function onDelete;
  @override
  _FullScreenDialogState createState() => _FullScreenDialogState();
}
class _FullScreenDialogState extends State<FullScreenDialog> {
  final itemController = TextEditingController();
  @override
  void initState() {
    super.initState();
    itemController.text = widget.todo.name;
  }
  void dispose() {
    itemController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add a todo'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                widget.onSave(itemController.text, widget.todo);
              },
              child: Text('儲存'))
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            controller: itemController,
            obscureText: false,
            decoration:
            InputDecoration(labelText: 'label', hintText: '請輸入項目名稱'),
          ),
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListWidget();
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  TodoList();

  }
}