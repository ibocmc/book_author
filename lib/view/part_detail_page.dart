import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yazar/view_model/part_detail_page_view_model.dart';
import 'package:yazar/view_model/part_page_view_model.dart';


class PartDetailPage extends StatelessWidget {

  final TextEditingController _controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _buildAppBar(context),
      body: _buildBody(context),

    );
  }

  AppBar _buildAppBar(BuildContext context) {

    PartDetailPageViewModel viewModel = Provider.of<PartDetailPageViewModel>(context);

    return AppBar(
      title: Text(viewModel.part.head),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
            onPressed:(){

              viewModel.saveContent(_controller.text);

    }

        )
      ],
    );

  }

  Widget _buildBody(BuildContext context){

    PartDetailPageViewModel viewModel = Provider.of<PartDetailPageViewModel>(context);

    _controller.text = viewModel.part.content;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        maxLines: 1000,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
      ),
    );
  }


}
