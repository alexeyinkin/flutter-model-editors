import 'package:flutter/material.dart';
import 'package:model_editors/model_editors.dart';

enum BookFormat {
  hard,
  paper,
}

class Book {
  final String title;
  final String author;
  final List<BookFormat> formats;

  Book({
    required this.title,
    required this.author,
    required this.formats,
  });
}

class BookEditingController extends ValueNotifier<Book?> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final formatsController = CheckboxGroupEditingController<BookFormat>();

  BookEditingController() : super(null);

  @override
  set value(Book? book) {
    if (book == null) {
      titleController.text = '';
      authorController.text = '';
      formatsController.value = [];
    } else {
      titleController.text = book.title;
      authorController.text = book.author;
      formatsController.value = book.formats;
    }
    notifyListeners();
  }

  @override
  Book? get value {
    final title = titleController.text.trim();
    final author = authorController.text.trim();

    if (title == '' || author == '') return null;

    return Book(
      title: title,
      author: author,
      formats: formatsController.value,
    );
  }

  @override
  void dispose() {
    // If the text controllers get disposed synchronously on delete button
    // event, then on rebuild TextField will break removing listener
    // from such controller. So delay the disposing. Duration.zero does not
    // work either so set some reasonable time.
    // TODO: Find a better way to dispose. Possible solutions are:
    //  - Keep text controllers in a list to dispose after the list controller
    //    is disposed from StatefulWidget's dispose(). But memory may drain
    //    infinitely as we add-remove controllers.
    //  - Subclass TextEditingController so it drops listeners in dispose()
    //    and does not mind a call to removeListener after disposal.
    //  - Ignore the exception of a disposed text controller as it is only
    //    shown in console and not to a user even in debug.
    Future.delayed(const Duration(seconds: 2), _disposeNow);
    super.dispose();
  }

  void _disposeNow() {
    titleController.dispose();
    authorController.dispose();
    formatsController.dispose();
  }
}

class BookListEditingController extends AbstractListEditingController<Book, BookEditingController> {
  BookListEditingController() : super(minLength: 1, maxLength: 3);

  @override
  BookEditingController createItemController() => BookEditingController();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "model_editors Example",
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _listController = BookListEditingController();

  @override
  void initState() {
    super.initState();
    _listController.value = [
      Book(
        title: "Speak, Memory",
        author: "Vladimir Nabokov",
        formats: [BookFormat.hard],
      ),
      Book(
        title: "The Power of Now",
        author: "Eckhart Tolle",
        formats: [BookFormat.paper],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ReorderableListViewEditor<Book, BookEditingController>(
                controller: _listController,
                itemBuilder: (context, itemController) => BookEditor(controller: itemController),
                shrinkWrap: true,
                spacing: 20,
              ),
              ListAddButtonBuilder(
                controller: _listController,
                enabledBuilder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _listController.add(null),
                  );
                },
              ),
              ElevatedButton(
                child: const Text("Save"),
                onPressed: _onSavePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSavePressed() {
    final items = _listController.nonNullValues; // or _listController.value to include nulls.
    print("Got ${items.length} non-empty books.");
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
}

class BookEditor extends StatelessWidget {
  final BookEditingController controller;

  BookEditor({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: "Title"),
          controller: controller.titleController,
        ),
        TextField(
          decoration: const InputDecoration(labelText: "Author"),
          controller: controller.authorController,
        ),
        MaterialCheckboxColumn<BookFormat>(
          controller: controller.formatsController,
          allValues: BookFormat.values,
          labels: const {
            BookFormat.hard: "Hard Cover",
            BookFormat.paper: "Paperback",
          },
        ),
      ],
    );
  }
}
