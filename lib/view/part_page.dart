import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/model/parts.dart';
import 'package:yazar/view_model/part_page_view_model.dart';


class PartPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: _buildAddBookFab(context),
    );
  }

  AppBar _buildAppBar(BuildContext context){

    PartPageViewModel viewModel = Provider.of(context);

    return AppBar(
      title: Text(viewModel.book.name),
    );
  }


  Widget _buildBody() {

    return Consumer<PartPageViewModel>(
          builder: (context,viewModel,child) => ListView.builder(
          itemCount: viewModel.allParts.length,
          itemBuilder: (BuildContext context,int index){
            return
            ChangeNotifierProvider.value(
                value: viewModel.allParts[index],
                child: _buildListItem(context, index),
            );
          }),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {

    PartPageViewModel viewModel = Provider.of(context);

    return Consumer<Parts>(
      builder: (context,part,child) => ListTile(

        leading: CircleAvatar(
          child: Text(part.id.toString(),
          ),
        ),
        title: Text(part.head),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: (){
                  viewModel.updatePart(context, index);
                },

                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: (){
                  viewModel.openDeleteWindow(context, index);
                  // _deleteBook(index);
                },

                icon: const Icon(Icons.delete)),
          ],
        ),
        onTap: (){
          viewModel.openPartDetailPage(context, index);
        },
      ),
    );
  }

  Widget _buildAddBookFab(BuildContext context){

    PartPageViewModel viewModel = Provider.of(context);

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: (){
        viewModel.createPart(context);
      },
    );
  }


}
