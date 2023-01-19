import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/product.dart';
import 'package:shopapp2/providers/product_provider.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = 'EditScreen';

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editProduct =
      new Product(title: '', id: '', price: 0, imageUrl: '', description: '');

  bool _firstRun = false;
  Product _existingProduct;
  Product product;

  @override
  void initState() {
    super.initState();
    _imageFocusNode.addListener(() {
      _updateImage();
    });
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(() => _updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _updateImage() {
    String imageUrl = _imageUrlController.text;
    if (imageUrl.isEmpty ||
        (!imageUrl.endsWith('.jpg') && !imageUrl.endsWith('.png')) ||
        (!imageUrl.startsWith('http') && !imageUrl.startsWith('https'))) {
      return null;
    }
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (!_firstRun) {
      product = ModalRoute.of(context).settings.arguments;
      print('$product');
      if (product != null) {
        _existingProduct = product;
        // set image url
        _existingProduct != null
            ? _imageUrlController.text = _existingProduct.imageUrl
            : _imageUrlController.text = '';
      }
      _firstRun = true;
    }
    super.didChangeDependencies();
  }

  void _submitForm() {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) return;
    _formKey.currentState.save();

    if (_existingProduct != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProductInfo(_existingProduct.id, _existingProduct);
      print(_existingProduct.id);
      print('submit existing product');
    }
    else {
      print('submit edited product');
      print(_editProduct.id);
      Provider.of<ProductsProvider>(context, listen: false)
          .addProducts(_editProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _submitForm();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  initialValue:
                      _existingProduct != null ? _existingProduct.title : '',
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please Enter a Title';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    _editProduct = new Product(
                        title: value,
                        id: _editProduct.id,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl,
                        description: _editProduct.description);

                    if (product != null) {
                      _existingProduct = new Product(
                          title: value,
                          id: product.id,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          description: _editProduct.description);
                    }
                  },
                ),
                TextFormField(
                  initialValue: _existingProduct != null
                      ? _existingProduct.price.toString()
                      : '',
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (!(num.tryParse(value) is num))
                      return 'Please Enter a number';
                    else if (value.isEmpty)
                      return 'Please Enter a Price';
                    else if (double.tryParse(value) <= 0)
                      return 'Please Enter a Valid Price';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    _editProduct = new Product(
                        title: _editProduct.title,
                        id: _editProduct.id,
                        price: double.tryParse(value),
                        imageUrl: _editProduct.imageUrl,
                        description: _editProduct.description);
                    if (product != null) {
                      _existingProduct = new Product(
                          title: _editProduct.title,
                          id: _existingProduct.id,
                          price: double.tryParse(value),
                          imageUrl: _editProduct.imageUrl,
                          description: _editProduct.description);
                    }
                  },
                ),
                TextFormField(
                  initialValue: _existingProduct != null
                      ? _existingProduct.description
                      : '',
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please Enter a Description';
                    else if (value.length < 10)
                      return 'Please Enter at Least 10 Charachters For Description';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    _editProduct = new Product(
                        title: _editProduct.title,
                        id: _editProduct.id,
                        price: _editProduct.price,
                        imageUrl: _editProduct.imageUrl,
                        description: value);
                    if (product != null) {
                      _existingProduct = new Product(
                          title: _editProduct.title,
                          id: _existingProduct.id,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                          description: value);
                    }
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(child: Text('Enter Image Url'))
                          : Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                        onFieldSubmitted: (_) {
                          _submitForm();
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please Enter an Image Url';
                          else if (!value.endsWith('jpg') &&
                              !value.endsWith('png'))
                            return 'Please Enter a Valid Format';
                          else if (!value.startsWith('http') &&
                              !value.startsWith('https'))
                            return 'Please Enter a Valid Url';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          _editProduct = new Product(
                              title: _editProduct.title,
                              id: _editProduct.id,
                              price: _editProduct.price,
                              imageUrl: value,
                              description: _editProduct.description);
                          if (product != null) {
                            _existingProduct = new Product(
                                title: _editProduct.title,
                                id: _existingProduct.id,
                                price: _editProduct.price,
                                imageUrl: value,
                                description: _editProduct.description);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
