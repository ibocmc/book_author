import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/tools/constants.dart';
import 'package:yazar/model/books.dart';
import 'package:yazar/view_model/book_page_view_model.dart';


class BookPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildAddBookFab(context),
    );
  }
// char.charStatus == "Alive" ? b1 = true : b1= false;

  AppBar _buildAppBar(BuildContext context){

    BookPageViewModel viewModel = Provider.of(context,listen: true);

    return AppBar(
      title: const Text("Kitaplar Sayfası"),
      actions: [
        if(viewModel.is_Chosen)
          _buildDelete(context)
      ]

    );
  }


  Widget _buildBody(BuildContext context) {
    return Column(
      children: [

        _buildCategoryFilter(),

        Expanded(
          child: Consumer<BookPageViewModel>(builder: (context,viewModel,child) => ListView.builder(
              controller: viewModel.scrollController,
              itemCount: viewModel.AllBooks.length,
              itemBuilder: (context,index){
                return ChangeNotifierProvider.value(
                    value: viewModel.AllBooks[index],
                    child: _buildListItem(context,index),
                );
              }),
          )
        ),
      ],
    );
  }

  Widget _buildDelete(BuildContext context){

    BookPageViewModel viewModel = Provider.of(context,listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Consumer<BookPageViewModel>(builder: (context,value,child) =>
            IconButton(
              onPressed: (){
                viewModel.openDeleteWindow(context);
              },
              icon: const Icon(Icons.delete),
            )
        ),
      ],
    );
  }


  Widget _buildCategoryFilter(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text("Kategori:"),
        Consumer<BookPageViewModel>(builder: (context,viewModel,child) => DropdownButton<int>(
              value: viewModel.choosenCategory,
              items: viewModel.allCategories.map((categoryId){

                return DropdownMenuItem<int>(
                  value: categoryId,
                  child:Text(
                      categoryId == -1 ? "Hepsi" :
                      Constants.categories[categoryId] ?? "") ,

                );

              }).toList(),


              onChanged: (int? newValue){

                if(newValue!=null){
                    viewModel.choosenCategory = newValue;
                    //viewModel.getFirstViewBooks();
                    if (kDebugMode) {
                      print(viewModel.choosenCategory);
                    }

                }
              }),
        ),
      ],
    );
  }


  Widget _buildListItem(BuildContext context , int index) {

    BookPageViewModel viewModel = Provider.of(context,listen: true);

    return Consumer<Books>(

      builder: (context,book,child) => ListTile(

        leading: CircleAvatar(
          child: Text(book.id.toString(),
          ),
        ),
        title: Text(book.name),
        subtitle: Text(Constants.categories[book.category] ?? ""),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

           // if(book.isChosen)

            IconButton(
                onPressed: (){

                  viewModel.updateBook(context, index);

                },

                icon: const Icon(Icons.edit)),
            Checkbox(
                value: book.isChosen,
                onChanged: (bool? newValue){
                  if(newValue!=null){
                    int? bookId = book.id;
                    if(bookId!=null){

                        if(newValue){
                          viewModel.choosenBooksId.add(bookId);
                          viewModel.is_Chosen = true;
                        } else {
                          viewModel.choosenBooksId.remove(bookId);
                          viewModel.is_Chosen = false;
                        }

                        book.choose(newValue);


                        if (kDebugMode) {
                          print("Checkbox oluşturuldu");
                          print("BookId: ${viewModel.choosenBooksId}");
                        }

                    }

                  }
                })
          ],
        ),
        onTap: (){
          viewModel.openPartsPage(context, index);
        },
      ),


    );
  }

  Widget _buildAddBookFab(BuildContext context){

    BookPageViewModel viewModel = Provider.of(context,listen: false);

    return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
         viewModel.createBook(context);
        },
    );
  }


}
