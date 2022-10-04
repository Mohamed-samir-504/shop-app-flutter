import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, description: "", title: "", imageUrl: "", price: 0);
  var showImage = false;
  var isInit = true;
  var isloading = false;
  var initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": ""
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final id = ModalRoute.of(context)?.settings.arguments;
      if (id != null) {
        editedProduct = Provider.of<Products>(context).findById(id.toString());
        initValues = {
          "title": editedProduct.title,
          "description": editedProduct.description,
          "price": editedProduct.price.toString(),
          "imageUrl": ""
        };
        _imageUrlController.text = editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final valid = _form.currentState?.validate();
    if (!valid!) return;
    _form.currentState?.save();
    setState(() {
      isloading = true;
    });
    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id!, editedProduct);
      setState(() {
        isloading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (error) {
        await showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text("An error has occured!"),
                content: Text("Something went wrong"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text("Close"))
                ],
              );
            });
      } finally {
        setState(() {
          isloading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: initValues["title"],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            isFavorite: editedProduct.isFavorite,
                            description: editedProduct.description,
                            title: value!,
                            imageUrl: editedProduct.imageUrl,
                            price: editedProduct.price);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "please enter a title";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["price"],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            isFavorite: editedProduct.isFavorite,
                            description: editedProduct.description,
                            title: editedProduct.title,
                            imageUrl: editedProduct.imageUrl,
                            price: double.parse(value!));
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "please enter a price";
                        if (double.tryParse(value) == null)
                          return "please enter a valid number";
                        if (double.parse(value) <= 0)
                          return "please enter a number greater than zero";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["description"],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            description: value!,
                            isFavorite: editedProduct.isFavorite,
                            title: editedProduct.title,
                            imageUrl: editedProduct.imageUrl,
                            price: editedProduct.price);
                      },
                      validator: (value) {
                        if (value!.isEmpty) return "please enter a description";
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: !showImage
                              ? Center(child: Text('Enter an URL'))
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onChanged: (_) {
                              setState(() {
                                showImage = true;
                              });
                            },
                            onSaved: (value) {
                              editedProduct = Product(
                                  id: editedProduct.id,
                                  description: editedProduct.description,
                                  isFavorite: editedProduct.isFavorite,
                                  title: editedProduct.title,
                                  imageUrl: value!,
                                  price: editedProduct.price);
                            },
                            validator: (value) {
                              if (value!.isEmpty)
                                return "please enter an image Url";
                              if (!value.startsWith("http") &&
                                  !value.startsWith("https"))
                                return "please enter a valid Url";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
